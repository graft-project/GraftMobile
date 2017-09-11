#include "productmodelserializator.h"
#include "graftwalletclient.h"
#include "api/graftwalletapi.h"
#include "productmodel.h"
#include "config.h"

GraftWalletClient::GraftWalletClient(QObject *parent)
    : GraftBaseClient(parent)
{
    mApi = new GraftWalletAPI(QUrl(cUrl.arg(cSeedSupernodes.first())), this);
    connect(mApi, &GraftWalletAPI::readyToPayReceived,
            this, &GraftWalletClient::receiveReadyToPay);
    connect(mApi, &GraftWalletAPI::rejectPayReceived, this, &GraftWalletClient::receiveRejectPay);
    connect(mApi, &GraftWalletAPI::payReceived, this, &GraftWalletClient::receivePay);
    connect(mApi, &GraftWalletAPI::getPayStatusReceived,
            this, &GraftWalletClient::receivePayStatus);
    connect(mApi, &GraftWalletAPI::error, this, &GraftWalletClient::errorReceived);

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

void GraftWalletClient::readyToPay(const QString &data)
{
    if (!data.isEmpty())
    {
        QStringList dataList = data.split(';');
        if (dataList.count() == 3)
        {
            mPID = dataList.value(0);
            mPrivateKey = dataList.value(1);
            mTotalCost = dataList.value(2).toDouble();
            mApi->readyToPay(mPID, QString());
        }
    }
}

void GraftWalletClient::rejectPay()
{
    mApi->rejectPay(mPID);
}

void GraftWalletClient::pay()
{
    mApi->pay(mPID, QString(""));
}

void GraftWalletClient::getPayStatus()
{
    mApi->getPayStatus(mPID);
}

void GraftWalletClient::receiveReadyToPay(int result, const QString &transaction)
{
    const bool isStatusOk = (result == 0);
    mPaymentProductModel->clear();
    QByteArray data = QByteArray::fromHex(transaction.toLatin1());
    ProductModelSerializator::deserialize(data, mPaymentProductModel);
    emit readyToPayReceived(isStatusOk);
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
        if (payStatus == GraftWalletAPI::StatusProcessing)
        {
            getPayStatus();
        }
        else if (payStatus == GraftWalletAPI::StatusApproved)
        {
            emit payStatusReceived(true);
        }
        else if (payStatus == GraftWalletAPI::StatusRejected)
        {
            emit payStatusReceived(false);
        }
    }
    else
    {
        emit payStatusReceived(false);
    }
}
