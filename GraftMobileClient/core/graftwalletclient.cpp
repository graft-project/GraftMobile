#include "graftwalletclient.h"
#include "api/graftwalletapi.h"
#include "config.h"

GraftWalletClient::GraftWalletClient(QObject *parent)
    : QObject(parent)
{
    mApi = new GraftWalletAPI(QUrl(cUrl.arg(cSeedSupernodes.value(0))), this);
    connect(mApi, SIGNAL(readyToPayReceived(int,QString)),
            this, SLOT(receiveReadyToPay(int,QString)));
    connect(mApi, SIGNAL(rejectPayReceived(int)), this, SLOT(receiveRejectPay(int)));
    connect(mApi, SIGNAL(payReceived(int)), this, SLOT(receivePay(int)));
    connect(mApi, SIGNAL(getPayStatusReceived(int,int)), this, SLOT(receivePayStatus(int,int)));
}

void GraftWalletClient::readyToPay(const QString &data)
{
    QStringList dataList = data.split(';');
    mPID = dataList.value(0);
    mPrivateKey = dataList.value(1);
    mApi->readyToPay(mPID, QString());
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
    emit readyToPayReceived(result == 0);
}

void GraftWalletClient::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletClient::receivePay(int result)
{
    emit payReceived(result == 0);
    if (result == 0)
    {
        getPayStatus();
    }
}

void GraftWalletClient::receivePayStatus(int result, int payStatus)
{
    if (result == 0)
    {
        if (payStatus == 1)
        {
            getPayStatus();
        }
        else if (payStatus == 0)
        {
            emit payStatusReceived(true);
        }
        else if (payStatus == 2)
        {
            emit payStatusReceived(false);
        }
    }
    else
    {
        emit payStatusReceived(false);
    }
}
