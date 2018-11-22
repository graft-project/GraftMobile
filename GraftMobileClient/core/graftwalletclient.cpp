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

#include <QRegularExpressionMatch>
#include <QRegularExpression>

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

bool GraftWalletClient::isCorrectAddress(const QString &data) const
{
    QRegularExpression walletAddress;
    if (networkType() == GraftClientTools::Mainnet)
    {
        walletAddress.setPattern("^G[0-9A-Za-z]{105}|^G[0-9A-Za-z]{94}");
    }
    else
    {
        walletAddress.setPattern("^F[0-9A-Za-z]{105}|^F[0-9A-Za-z]{94}");
    }
    QRegularExpressionMatch match = walletAddress.match(data, 0, QRegularExpression::PartialPreferFirstMatch);
    return match.hasPartialMatch();
}

bool GraftWalletClient::isSaleQrCodeValid(const QString &data) const
{
    if (!data.isEmpty())
    {
        QStringList dataList = data.split(';');
        return dataList.count() == 4;
    }
    return false;
}

void GraftWalletClient::saleDetails(const QString &data)
{
    if (isSaleQrCodeValid(data))
    {
        QStringList dataList = data.split(';');
        mPID = dataList.value(0);
        mPrivateKey = dataList.value(1);
        mTotalCost = dataList.value(2).toDouble();
        mBlockNumber = dataList.value(3).toInt();
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
