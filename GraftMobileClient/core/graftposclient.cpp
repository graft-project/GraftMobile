#include "graftposclient.h"
#include "api/graftposapi.h"
#include "config.h"

GraftPOSClient::GraftPOSClient(QObject *parent)
    : QObject(parent)
{

    mApi = new GraftPOSAPI(QUrl(cUrl.arg(cSeedSupernodes.value(0))), this);
    connect(mApi, SIGNAL(saleResponseReceived(int)), this, SLOT(receiveSale(int)));
    connect(mApi, SIGNAL(getSaleStatusResponseReceived(int,int)),
            this, SLOT(receiveSaleStatus(int,int)));
}

void GraftPOSClient::sale()
{
    mPID = "";
    mApi->sale(mPID, QString());
}

void GraftPOSClient::getSaleStatus()
{
    mApi->getSaleStatus(mPID);
}

void GraftPOSClient::receiveSale(int result)
{
    emit saleReceived(result == 0);
    if (result == 0)
    {
        getSaleStatus();
    }
}

void GraftPOSClient::receiveSaleStatus(int result, int saleStatus)
{
    if (result == 0)
    {
        if (saleStatus == 1)
        {
            getSaleStatus();
        }
        else if (saleStatus == 0)
        {
            emit saleStatusReceived(true);
        }
        else if (saleStatus == 2)
        {
            emit saleStatusReceived(false);
        }
    }
    else
    {
        emit saleStatusReceived(false);
    }
}
