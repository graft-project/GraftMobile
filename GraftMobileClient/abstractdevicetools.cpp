#include "abstractdevicetools.h"

AbstractDeviceTools::AbstractDeviceTools(QObject *parent) : QObject(parent)
{
}

AbstractDeviceTools::~AbstractDeviceTools()
{
}

void AbstractDeviceTools::setNetworkManager(QNetworkAccessManager *networkManager)
{
    if (networkManager && mNetworkManager != networkManager)
    {
        mNetworkManager = networkManager;
    }
}
