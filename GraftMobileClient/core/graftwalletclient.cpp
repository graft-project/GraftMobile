#include "productmodelserializator.h"
#include "api/graftwalletapi.h"
#include "graftwalletclient.h"
#include "accountmanager.h"
#include "productmodel.h"
#include "keygenerator.h"
#include "config.h"

GraftWalletClient::GraftWalletClient(QObject *parent)
    : GraftBaseClient(parent)
{
    mBlockNum = 0;
    mApi = new GraftWalletAPI(getServiceUrl(), this);
    connect(mApi, &GraftWalletAPI::getPOSDataReceived,
            this, &GraftWalletClient::receiveGetPOSData);
    connect(mApi, &GraftWalletAPI::rejectPayReceived, this, &GraftWalletClient::receiveRejectPay);
    connect(mApi, &GraftWalletAPI::payReceived, this, &GraftWalletClient::receivePay);
    connect(mApi, &GraftWalletAPI::getPayStatusReceived,
            this, &GraftWalletClient::receivePayStatus);
    connect(mApi, &GraftWalletAPI::error, this, &GraftWalletClient::errorReceived);

    mPaymentProductModel = new ProductModel(this);
    if (isAccountExists())
    {
        mApi->setAccountData(mAccountManager->account(), mAccountManager->passsword());
    }
    else
    {
        requestAccount(mApi, KeyGenerator::generateUUID(8));
    }
    registerBalanceTimer(mApi);
}

double GraftWalletClient::totalCost() const
{
    return mTotalCost;
}

ProductModel *GraftWalletClient::paymentProductModel() const
{
    return mPaymentProductModel;
}

bool GraftWalletClient::resetUrl(const QString &ip, const QString &port)
{
    if (GraftBaseClient::resetUrl(ip, port))
    {
        mApi->setUrl(QUrl(cUrl.arg(QString("%1:%2").arg(ip).arg(port))));
        return true;
    }
    return false;
}

void GraftWalletClient::createAccount(const QString &password)
{
    GraftBaseClient::requestAccount(mApi, password);
}

void GraftWalletClient::restoreAccount(const QString &seed, const QString &password)
{
    GraftBaseClient::requestRestoreAccount(mApi, seed, password);
}

void GraftWalletClient::getPOSData(const QString &data)
{
    if (!data.isEmpty())
    {
        QStringList dataList = data.split(';');
        if (dataList.count() == 4)
        {
            mPID = dataList.value(0);
            mPrivateKey = dataList.value(1);
            mTotalCost = dataList.value(2).toDouble();
            mBlockNum = dataList.value(3).toInt();
            updateQuickExchange(mTotalCost);
            mApi->getPOSData(mPID, mBlockNum);
        }
        else
        {
            emit getPOSDataReceived(false);
        }
    }
}

void GraftWalletClient::rejectPay()
{
    mApi->rejectPay(mPID, mBlockNum);
}

void GraftWalletClient::pay()
{
    mApi->pay(mPID, mPrivateKey, mTotalCost, mBlockNum);
}

void GraftWalletClient::getPayStatus()
{
    mApi->getPayStatus(mPID);
}

void GraftWalletClient::receiveGetPOSData(int result, const QString &payDetails)
{
    const bool isStatusOk = (result == 0);
    mPaymentProductModel->clear();
    QByteArray data = QByteArray::fromHex(payDetails.toLatin1());
    ProductModelSerializator::deserialize(data, mPaymentProductModel);
    emit getPOSDataReceived(isStatusOk);
}

void GraftWalletClient::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletClient::receivePay(int result)
{
    const bool isStatusOk = (result == 0);
    emit payReceived(isStatusOk);
    if (isStatusOk)
    {
        getPayStatus();
    }
}

void GraftWalletClient::receivePayStatus(int result, int payStatus)
{
    if (result == 0)
    {
        switch (payStatus) {
        case GraftWalletAPI::StatusProcessing:
            getPayStatus();
            break;
        case GraftWalletAPI::StatusApproved:
            emit payStatusReceived(true);
            break;
        case GraftWalletAPI::StatusNone:
        case GraftWalletAPI::StatusFailed:
        case GraftWalletAPI::StatusPOSRejected:
        case GraftWalletAPI::StatusWalletRejected:
        default:
            emit payStatusReceived(false);
            break;
        }
    }
    else
    {
        emit payStatusReceived(false);
    }
}

void GraftWalletClient::updateBalance()
{
    mApi->getBalance();
}
