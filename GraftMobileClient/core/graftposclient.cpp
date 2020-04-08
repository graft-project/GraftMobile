#include "selectedproductproxymodel.h"
#include "productmodelserializator.h"
#include "graftclienttools.h"
#include "qrcodegenerator.h"
#include "graftposclient.h"
#include "accountmanager.h"
#include "keygenerator.h"
#include "productmodel.h"
#include "api/v3/graftposhandlerv3.h"
#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
#include "api/v2/graftposhandlerv2.h"
#endif
#include "api/graftposhandler.h"
#include "config.h"

#include <QStandardPaths>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>




static const QString scProductModelDataFile("productList.dat");

GraftPOSClient::GraftPOSClient(QObject *parent)
    : GraftBaseClient(parent)
    ,mClientHandler(nullptr)
{
    changeGraftHandler();
    initProductModels();
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
        mClientHandler->sale(mAccountManager->address(), 
                             mProductModel->totalCost(), selectedProducts.toHex()
                             );
    }
    else
    {
        emit saleReceived(false);
    }
}

void GraftPOSClient::rejectSale()
{
    mClientHandler->rejectSale(mPID);
}

void GraftPOSClient::saleStatus()
{
    mClientHandler->saleStatus(mPID, mBlockNumber);
}

void GraftPOSClient::receiveSale(int result, const QString &pid, int blockNumber)
{
    const bool isStatusOk = (result == 0);
    mPID = pid;
    mBlockNumber = blockNumber;
        
    PrivatePaymentDetails paymentRequest = mClientHandler->paymentRequest();
    paymentRequest.posAddress.WalletAddress = mAccountManager->address();
    
//  QString qrText = QString("%1;%2;%3;%4").arg(pid).arg(mAccountManager->address())
//          .arg(mProductModel->totalCost()).arg(blockNumber);
    
    QString qrText = QJsonDocument(paymentRequest.toJson()).toJson();
    
#if 1     // debug
    QFile f("/tmp/rta-qr-code.json");
    f.open(QIODevice::WriteOnly);
    f.write(qrText.toLocal8Bit());
#endif            
        
    setQRCodeImage(QRCodeGenerator::encode(qrText));
    emit saleReceived(isStatusOk);
    if (isStatusOk)
    {
        saleStatus();
    }
}

void GraftPOSClient::initProductModels()
{
    mProductModel = new ProductModel(this);
    ProductModelSerializator::deserialize(loadModel(scProductModelDataFile), mProductModel);
    mSelectedProductModel = new SelectedProductProxyModel(this);
    mSelectedProductModel->setSourceModel(mProductModel);
}

void GraftPOSClient::changeGraftHandler()
{
    if (mClientHandler)
    {
        mClientHandler->deleteLater();
    }
    GraftGenericAPIv3::NetType nettype = networkType() == GraftClientTools::Mainnet ? GraftGenericAPIv3::MAINNET : GraftGenericAPIv3::TESTNET;
    
    switch (networkType())
    {
    case GraftClientTools::Mainnet:
    case GraftClientTools::PublicTestnet:
        mClientHandler = new GraftPOSHandlerV3(dapiVersion(), nettype, getServiceAddresses(), this);
        break;
    case GraftClientTools::PublicExperimentalTestnet:
#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
        mClientHandler = new GraftPOSHandlerV2(dapiVersion(), getServiceAddresses(),
                                               getServiceAddresses(true),
                                               networkType() != GraftClientTools::Mainnet, this);
#else
        mClientHandler = new GraftPOSHandlerV3(dapiVersion(), nettype, getServiceAddresses(), this);
#endif
        break;
    }
    mClientHandler->setNetworkManager(mNetworkManager);
    connect(mClientHandler, &GraftPOSHandler::saleReceived, this, &GraftPOSClient::receiveSale);
    connect(mClientHandler, &GraftPOSHandler::rejectSaleReceived,
            this, &GraftPOSClient::rejectSaleReceived);
    connect(mClientHandler, &GraftPOSHandler::saleStatusReceived,
            this, &GraftPOSClient::saleStatusReceived);
    connect(mClientHandler, &GraftPOSHandler::errorReceived,
            this, &GraftPOSClient::errorReceived);
    initAccountSettings();
}

GraftBaseHandler *GraftPOSClient::graftHandler() const
{
    Q_ASSERT_X(mClientHandler, "GraftPOSClient", "GraftPOSHandler not initialized!");
    return mClientHandler;
}
