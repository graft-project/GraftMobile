#include "graftposclient.h"
#include "patrickqrcodeencoder.h"
#include "api/graftposapi.h"
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
}

void GraftPOSClient::sale()
{
    setQRCodeImage(mQRCodeEncoder->encode(""));
    mApi->sale(mPID, QString());
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
