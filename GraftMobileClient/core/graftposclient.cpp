#include "selectedproductproxymodel.h"
#include "productmodelserializator.h"
#include "qrcodegenerator.h"
#include "api/graftposapi.h"
#include "graftposclient.h"
#include "accountmanager.h"
#include "keygenerator.h"
#include "productmodel.h"
#include "config.h"

#include <QStandardPaths>
#include <QSettings>
#include <QFileInfo>

static const QString scProductModelDataFile("productList.dat");

GraftPOSClient::GraftPOSClient(QObject *parent)
    : GraftBaseClient(parent)
{
    mApi = new GraftPOSAPI(getServiceUrl(), cDAPIVersion, this);
    connect(mApi, &GraftPOSAPI::saleResponseReceived, this, &GraftPOSClient::receiveSale);
    connect(mApi, &GraftPOSAPI::rejectSaleResponseReceived,
            this, &GraftPOSClient::receiveRejectSale);
    connect(mApi, &GraftPOSAPI::getSaleStatusResponseReceived,
            this, &GraftPOSClient::receiveSaleStatus);
    connect(mApi, &GraftPOSAPI::error, this, &GraftPOSClient::errorReceived);
    initProductModels();
    if (isAccountExists())
    {
        mApi->setAccountData(mAccountManager->account(), mAccountManager->passsword());
    }
    registerBalanceTimer(mApi);
}

GraftPOSClient::~GraftPOSClient()
{
}

ProductModel *GraftPOSClient::productModel() const
{
    return mProductModel;
}

SelectedProductProxyModel *GraftPOSClient::selectedProductModel() const
{
    return mSelectedProductModel;
}

void GraftPOSClient::registerTypes(QQmlEngine *engine)
{
    GraftBaseClient::registerTypes(engine);
}

bool GraftPOSClient::resetUrl(const QString &ip, const QString &port)
{
    if (GraftBaseClient::resetUrl(ip, port))
    {
        mApi->setUrl(QUrl(cUrl.arg(QString("%1:%2").arg(ip).arg(port))));
        return true;
    }
    return false;
}

void GraftPOSClient::createAccount(const QString &password)
{
    GraftBaseClient::requestAccount(mApi, password);
}

void GraftPOSClient::restoreAccount(const QString &seed, const QString &password)
{
    GraftBaseClient::requestRestoreAccount(mApi, seed, password);
}

void GraftPOSClient::saveProducts() const
{
    saveModel(scProductModelDataFile, ProductModelSerializator::serialize(mProductModel));
}

void GraftPOSClient::sale()
{
    if (mProductModel->totalCost() > 0)
    {
        updateQuickExchange(mProductModel->totalCost());
        QByteArray selectedProducts = ProductModelSerializator::serialize(mProductModel, true);
        mApi->sale(mAccountManager->address(), mAccountManager->viewKey(),
                   mProductModel->totalCost(), selectedProducts.toHex());
    }
    else
    {
        emit saleReceived(false);
    }
}

void GraftPOSClient::rejectSale()
{
    mApi->rejectSale(mPID);
}

void GraftPOSClient::getSaleStatus()
{
    mApi->getSaleStatus(mPID);
}

void GraftPOSClient::receiveSale(int result, const QString &pid, int blockNum)
{
    const bool isStatusOk = (result == 0);
    mPID = pid;
    QString qrText = QString("%1;%2;%3;%4").arg(pid).arg(mAccountManager->address())
            .arg(mProductModel->totalCost()).arg(blockNum);
    setQRCodeImage(mQRCodeEncoder->encode(qrText));
    emit saleReceived(isStatusOk);
    if (isStatusOk)
    {
        getSaleStatus();
    }
}

void GraftPOSClient::receiveRejectSale(int result)
{
    emit rejectSaleReceived(result == 0);
}

void GraftPOSClient::receiveSaleStatus(int result, int saleStatus)
{
    if (result == 0)
    {
        switch (saleStatus) {
        case GraftPOSAPI::StatusProcessing:
            getSaleStatus();
            break;
        case GraftPOSAPI::StatusApproved:
            emit saleStatusReceived(true);
            break;
        case GraftPOSAPI::StatusNone:
        case GraftPOSAPI::StatusFailed:
        case GraftPOSAPI::StatusPOSRejected:
        case GraftPOSAPI::StatusWalletRejected:
        default:
            emit saleStatusReceived(false);
            break;
        }
    }
    else
    {
        emit saleStatusReceived(false);
    }
}

void GraftPOSClient::initProductModels()
{
    mProductModel = new ProductModel(this);
    ProductModelSerializator::deserialize(loadModel(scProductModelDataFile), mProductModel);
    mSelectedProductModel = new SelectedProductProxyModel(this);
    mSelectedProductModel->setSourceModel(mProductModel);
}

void GraftPOSClient::updateBalance()
{
    mApi->getBalance();
}
