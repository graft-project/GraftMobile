#include "productmodelserializator.h"
#include "patrickqrcodeencoder.h"
#include "api/graftposapi.h"
#include "graftposclient.h"
#include "keygenerator.h"
#include "productmodel.h"
#include "config.h"

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
    ProductModelSerializator::deserialize(QByteArray(), mProductModel);
}

GraftPOSClient::~GraftPOSClient()
{
    delete mQRCodeEncoder;
}

ProductModel *GraftPOSClient::productModel() const
{
    return mProductModel;
}

void GraftPOSClient::sale()
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
