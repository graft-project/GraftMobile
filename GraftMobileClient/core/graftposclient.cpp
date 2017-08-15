#include "graftposclient.h"
#include "api/graftposapi.h"
#include "config.h"

GraftPOSClient::GraftPOSClient(QObject *parent)
    : QObject(parent)
{

    mApi = new GraftPOSAPI(QUrl(cUrl.arg(cSeedSupernodes.first())), this);
    connect(mApi, &GraftPOSAPI::saleResponseReceived, this, &GraftPOSClient::receiveSale);
    connect(mApi, &GraftPOSAPI::getSaleStatusResponseReceived,
            this, &GraftPOSClient::receiveSaleStatus);
}

void GraftPOSClient::sale()
{
    mApi->sale(mPID, QString());
}

void GraftPOSClient::getSaleStatus()
{
    mApi->getSaleStatus(mPID);
}

void GraftPOSClient::receiveSale(int result)
{
    const bool isSomeName = (result == 0);
    emit saleReceived(isSomeName);
    if (isSomeName)
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
