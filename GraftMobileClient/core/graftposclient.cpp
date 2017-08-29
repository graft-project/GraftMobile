#include "selectedproductproxymodel.h"
#include "productmodelserializator.h"
#include "patrickqrcodeencoder.h"
#include "api/graftposapi.h"
#include "graftposclient.h"
#include "keygenerator.h"
#include "productmodel.h"
#include "config.h"
#include <QStandardPaths>
#include <QFileInfo>
#include <QFile>
#include <QDir>
#include <QDebug>

static const QString scProductModelDataFile("productList.dat");

GraftPOSClient::GraftPOSClient(QObject *parent)
    : GraftBaseClient(parent)
{
    mQRCodeEncoder = new PatrickQRCodeEncoder();
    mApi = new GraftPOSAPI(QUrl(cUrl.arg(cSeedSupernodes.first())), this);
    connect(mApi, &GraftPOSAPI::saleResponseReceived, this, &GraftPOSClient::receiveSale);
    connect(mApi, &GraftPOSAPI::getSaleStatusResponseReceived,
            this, &GraftPOSClient::receiveSaleStatus);
    connect(mApi, &GraftPOSAPI::error, this, &GraftPOSClient::errorReceived);

    mProductModel = new ProductModel(this);
    QString dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                              scProductModelDataFile);
    if (!dataPath.isEmpty())
    {
        QFile lFile(dataPath);
        if (lFile.open(QFile::ReadOnly))
        {
            ProductModelSerializator::deserialize(lFile.readAll(), mProductModel);
        }
    }
    mSelectedProductModel = new SelectedProductProxyModel(this);
    mSelectedProductModel->setSourceModel(mProductModel);
}

GraftPOSClient::~GraftPOSClient()
{
    delete mQRCodeEncoder;
}

void GraftPOSClient::save() const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!dataPath.isEmpty())
    {
        if (!QFileInfo(dataPath).exists())
        {
            QDir().mkpath(dataPath);
        }
        QDir lDir(dataPath);
        QFile lFile(lDir.filePath(scProductModelDataFile));
        if (lFile.open(QFile::WriteOnly))
        {
            lFile.write(ProductModelSerializator::serialize(mProductModel));
            lFile.close();
        }
    }
}

ProductModel *GraftPOSClient::productModel() const
{
    return mProductModel;
}

SelectedProductProxyModel *GraftPOSClient::selectedProductModel() const
{
    return mSelectedProductModel;
}

void GraftPOSClient::sale()
{
    if (mProductModel->totalCost() > 0)
    {
        mPID = KeyGenerator::generatePID();
        QString address = QString("%1%2").arg(KeyGenerator::generateSpendingKey())
                .arg(KeyGenerator::generateViewKey());
        QString qrText = QString("%1;%2;%3").arg(mPID).arg(address)
                .arg(mProductModel->totalCost());
        setQRCodeImage(mQRCodeEncoder->encode(qrText));
        QByteArray selectedProducts = ProductModelSerializator::serialize(mProductModel, true);
        mApi->sale(mPID, selectedProducts.toHex());
    }
    else
    {
        emit saleStatusReceived(false);
    }
}

void GraftPOSClient::getSaleStatus()
{
    mApi->getSaleStatus(mPID);
}

void GraftPOSClient::receiveSale(int result)
{
    const bool isStatusOk = (result == 0);
    emit saleReceived(isStatusOk);
    if (isStatusOk)
    {
        getSaleStatus();
    }
}

void GraftPOSClient::receiveSaleStatus(int result, int saleStatus)
{
    if (result == 0)
    {
        if (saleStatus == GraftPOSAPI::StatusProcessing)
        {
            getSaleStatus();
        }
        else if (saleStatus == GraftPOSAPI::StatusApproved)
        {
            emit saleStatusReceived(true);
        }
        else if (saleStatus == GraftPOSAPI::StatusRejected)
        {
            emit saleStatusReceived(false);
        }
    }
    else
    {
        emit saleStatusReceived(false);
    }
}
