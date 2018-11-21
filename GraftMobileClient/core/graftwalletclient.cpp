#include "productmodelserializator.h"
#include "api/v1/graftwalletapiv1.h"
#include "api/v1/graftwallethandlerv1.h"
#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
#include "api/v2/graftwallethandlerv2.h"
#endif
#include "graftwalletclient.h"
#include "graftclienttools.h"
#include "accountmanager.h"
#include "productmodel.h"
#include "keygenerator.h"
#include "config.h"

GraftWalletClient::GraftWalletClient(QObject *parent)
    : GraftBaseClient(parent)
    ,mClientHandler(nullptr)
{
    mBlockNumber = 0;
    changeGraftHandler();
    mPaymentProductModel = new ProductModel(this);
}

double GraftWalletClient::totalCost() const
{
    return mTotalCost;
}

ProductModel *GraftWalletClient::paymentProductModel() const
{
    return mPaymentProductModel;
}

bool GraftWalletClient::detectedSalesDetails(const QString &data) const
{
    if (!data.isEmpty())
    {
        return productList(data).count() == 4;
    }
    return false;
}

void GraftWalletClient::saleDetails(const QString &data)
{
    if (productList(data).count() == 4)
    {
        mPID = productList(data).value(0);
        mPrivateKey = productList(data).value(1);
        mTotalCost = productList(data).value(2).toDouble();
        mBlockNumber = productList(data).value(3).toInt();
        updateQuickExchange(mTotalCost);
        mClientHandler->saleDetails(mPID, mBlockNumber);
    }
    else
    {
        emit saleDetailsReceived(false);
    }
}

void GraftWalletClient::rejectPay()
{
    if (mClientHandler)
    {
        mClientHandler->rejectPay(mPID, mBlockNumber);
    }
}

void GraftWalletClient::pay()
{
    if (mClientHandler)
    {
        mClientHandler->pay(mPID, mPrivateKey, mTotalCost, mBlockNumber);
    }
}

void GraftWalletClient::payStatus()
{
    if (mClientHandler)
    {
        mClientHandler->payStatus(mPID, mBlockNumber);
    }
}

void GraftWalletClient::receiveSaleDetails(int result, const QString &payDetails)
{
    const bool isStatusOk = (result == 0);
    mPaymentProductModel->clear();
    QByteArray data = QByteArray::fromHex(payDetails.toLatin1());
    ProductModelSerializator::deserialize(data, mPaymentProductModel);
    emit saleDetailsReceived(isStatusOk);
}

void GraftWalletClient::receivePay(int result)
{
    const bool isStatusOk = (result == 0);
    emit payReceived(isStatusOk);
    if (isStatusOk)
    {
        payStatus();
    }
}

void GraftWalletClient::changeGraftHandler()
{
    if (mClientHandler)
    {
        mClientHandler->deleteLater();
    }
    switch (networkType())
    {
    case GraftClientTools::Mainnet:
    case GraftClientTools::PublicTestnet:
        mClientHandler = new GraftWalletHandlerV1(dapiVersion(), getServiceAddresses(), this);
        break;
    case GraftClientTools::PublicExperimentalTestnet:
#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
        mClientHandler = new GraftWalletHandlerV2(dapiVersion(), getServiceAddresses(),
                                                  getServiceAddresses(true),
                                                  networkType() != GraftClientTools::Mainnet, this);
#else
        mClientHandler = new GraftWalletHandlerV1(dapiVersion(), getServiceAddresses(), this);
#endif
        break;
    }
    connect(mClientHandler, &GraftWalletHandler::saleDetailsReceived,
            this, &GraftWalletClient::receiveSaleDetails);
    connect(mClientHandler, &GraftWalletHandler::payReceived,
            this, &GraftWalletClient::receivePay);
    connect(mClientHandler, &GraftWalletHandler::rejectPayReceived,
            this, &GraftWalletClient::rejectPayReceived);
    connect(mClientHandler, &GraftWalletHandler::payStatusReceived,
            this, &GraftWalletClient::payStatusReceived);
    connect(mClientHandler, &GraftWalletHandler::errorReceived,
            this, &GraftWalletClient::errorReceived);
    initAccountSettings();
}

GraftBaseHandler *GraftWalletClient::graftHandler() const
{
    Q_ASSERT_X(mClientHandler, "GraftWalletClient", "GraftWalletHandler not initialized!");
    return mClientHandler;
}

QStringList GraftWalletClient::productList(const QString &data) const
{
    return QStringList() << data.split(';');
}
