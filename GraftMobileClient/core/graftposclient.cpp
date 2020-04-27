#include "selectedproductproxymodel.h"
#include "productmodelserializator.h"
#include "graftclienttools.h"
#include "qrcodegenerator.h"
#include "graftposclient.h"
#include "accountmanager.h"
#include "keygenerator.h"
#include "productmodel.h"
#include "api/v3/graftposhandlerv3.h"

#include "crypto/crypto.h"
#include "epee/string_tools.h"
#include "utils/cryptmsg.h"
#include "utils/rta_helpers_gui.h"
#include "epee/misc_log_ex.h"

#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
#include "api/v2/graftposhandlerv2.h"
#endif
#include "api/graftposhandler.h"
#include "config.h"

#include <QStandardPaths>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>


#if defined(Q_OS_ANDROID)

#include <android/log.h>

#define ANDROID_LOG_TAG "GRAFT"

class AndroidLogHandler : public el::LogDispatchCallback {
  public:
    static int initialize() {
        el::Helpers::installLogDispatchCallback<AndroidLogHandler>("AndroidLogHandler");
        return 0;
    }

  void handle(const el::LogDispatchData* data) {
    auto level = data->logMessage()->level();
    switch (level) {
      case el::Level::Info:
        __android_log_print(ANDROID_LOG_INFO, ANDROID_LOG_TAG, "%s", data->logMessage()->message().c_str());
        break;
      case el::Level::Error:
        __android_log_print(ANDROID_LOG_ERROR, ANDROID_LOG_TAG, "%s", data->logMessage()->message().c_str());
        break;
      default: // Add other cases if needed...
        break;
    }
  }
};

static int initAndroidLogHandler = AndroidLogHandler::initialize();

#endif



static const QString scProductModelDataFile("productList.dat");

GraftPOSClient::GraftPOSClient(QObject *parent)
    : GraftBaseClient(parent)
    ,mClientHandler(nullptr)
{
    changeGraftHandler();
    initProductModels();
    mlog_configure("", true);
    mlog_set_log("2");
    MERROR("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
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

void GraftPOSClient::test()
{
    
    std::string tx_blob = "5d0f0000c1246ff1fab4e76c2cef23f51ae3d0588de228b0d2d37737841b95cce6cf90f801008d98023a197c1dd76c24795ac69066361d4e4844811743f660261c25486ff91db3228d010000000000000000efd86a192877c95cdf4c05d15b0b74ae8f3f5e3880c6b75a87880be2e819b8de523203779de138361ee402d927ea42f160f309e122dccbd6c4a148faad88232b5edd61fd6fdff35b767a9e5e630797ef3bccfe3054215feab8a65a4dce3cc17c76dd3a9dd5c7b239507fb96b7406008bdf44d94229298b1ee466d8fb04ff9074b4fc9a41e701a92d0edca875d011aaec544e0375dbfb66fed61ac21aa5ddd377fb770ec1fe7f8a19a6dc9ad2c7186b1c9067fff7d5a7466fabbfdbd129fa13b63f3b28f82000ffd9024ebbc1cf09614fdf26f8f330be519c170a8522398fc21226c4a888b7ee3bf972e58a1762ec4ac794189476e857bb47ec2061a74c9fa95c77207433e508b36c2915976fd3a93d2510fedb69affd377341ba45f74550c477992e494e779a96d2bd38f43012e3584ab8e291941457fd0b90f87bd37f9f9266f1aacaa282644417bbe60e1ee19d37795722d38083248055a02562620bf985b21aceacc57877544ee7eda8ea5eaf4ffd83bd4b1907c5d9cb226e0d262058854349554dff14fab317e997a4fee494226c8ebb32cae7d0f85212b49bc9d1a6ecdb275e09ecf10f910cd058140f4b6d037d97a3ef8626c417900eb2a7c1f0dbf91e54c0bebb5379f2ed74a97e0ece75b8f5314947c9a0b2519dc22a2e0dbd3f810ae7382c6f77aa6da3d8ea17807c05b7c1c73811aaa2ab7e45dac16d56e0e8fc8eeaac3393a95427bc0673ec1c0068e3bb647040b3ce45b32bed5b5611c6dd49539ccdecdb3514ed6a3ecd1a56cc7ff72e881ee7c26396e949f423f66a407f23ba1aeac57cf216377f1a52b4ea456b21fa84b13b62815c5ad9f7255ca1f80e0e04bd9a62b2804fe5ddfbb63676cddfc6eecb0fc082bdd626a596d35ab27ea02204b7dda94066caa200e963c61bdde7c708dfd054b5ef018d7dcbc62049ccc745f100d2d670a54ec3c0cb3049e45e3f53d789259958292f8ae64adc358e3127c33b00df6dd12da69c658d8e38a39e644d6d2244a647448e05a4efdc55b8ade5562d1d15cb243e81f18d7cf6f2937cc21aec4a04fdfbf07085162af2939949372414fd92479cf205e6326efe851dc6b8c986ff6033be95ea7b5a612e91074261f02065c7ed7bd6deace3b9245469b52df4e1c3a2aa7743bb0ef530a2c9a301d25a6a5abbd76c29fd463368b16648e02b92f548c8c7c8021fd27592314e1ebbd014f8b8c7364cfb64d5bfd292e82c32df4b38ed5cc343e669d1a781ee0f8231fe613431e0cf5da96604fe4060a2e93875d3703ad606e20c1fb5bbaf012c226185ff1079e891e29bf29c547e981cf755749b2f1f9e07346bc017c643186ed77b9c09e6607ccbf5c2e458e95a81d0345f93f744ebc9ff0d3c45111fbbfbce286aee84f247812bc1220583b23dc9d2a7007223c0cfc9645cd022d56c5cbb01bf11961d629eb217f5925ea04cb04e03cf9bce4d3e8c228f6c1a96eb6d3d0a7ca179b3bf22754dce7b7cd62f557c0fccdbc717931cb1f7ec958179f2b533db068d05732c46d50abf10c89ea45b014522b93ece1f835d2732bc9435ed009f916fdc1041d9ae8d288543fd3abe3711bc8b192dd978c0f8bfbe56202f6bb8661ff8755cd05f38411ef9d649e23cb42286941b2884367d7c6e6a27c9c0728107a39e834e8220c93ecdd0c5224a95a2fc7697dd742b8856abffcc46cc856531a9c00f8bb90e9e3df856f13195ebf2e267218d5e3595eee57700e36d96eee9dcf223f6f77f01066539644e7e6c7033def2a1a4e3ded25fa74bb45d20374e593100ed50e09b72be148c73bbd7797be6edaf3638c71f1d52e32c1c698d187426537aaf41933ee070357502df3f4b527f2c885a784f8505cee1e891740092e9a9727b72bbe96a83ce36c7b5732b53376a331f94b6a0ffb51d258f466b913bf3d5831dba543b035ffff05c53af535f6bf0828c186007d9aa38bce02674030a030bf1e6b4b529a677e50ff2db1ee5c54a7ba92860c7adecc69c634281770abbfcb5462eb06f9ad8b097e225c2a195ddb9a5b1436787d5420f831f18ceb3302cd2d0f4769642a668d52d0a62f739c9cda2e5fc978bf745622a5c1b8308ccce5cecf093e14633770529ee457bbc54cb9715ad7f3ad5fbeede4504ef3e2a9d0fe89da1afcd7c75a1d1e51ee1cc312f14886d5547c2c09501c5f9ca630c67a4bc55d07cf51e38de87f9a3616f0617585c76069b1e16881d6c4d9982d408a032ae4deb8885e39b55dde3f52ddb5c867c5e56da5dbf611dffc95a29ed031b56e4b94221c32260e8ef1588aa29a022ca09368f95c2f723899b10ef99cf84714703fc3d3754c2192e2f9be9fb61e47088f6c8d0b3c9b448ec07558dde6b4bc4384fa78a7f2fbbb395a95ee8e96c7954116bb39833deeb770b443e72c2d0a77d1bf2656204f367a73a70b14f00ebbb58ffb5278d244996352ed95c520c38204d747682498bfe448a739377a066577126dee35f9d3259138ed6b461279dadb73ce8b6dbb636ec54e4b955a6c46639d992974197eb1da809f7fd98918bc066bab523f447753e586a46bf6dff86d0ed0c9bd6fef561428ae54e6937c2da97094d5a6596147e44a22fff9847b7154c5a2725e13ca60ee77fc98dd764f648e35d2933066b4d08388f862ac7d46f0e20d37811a731c9cedadd550e26896c154f86d000caea613b70283eb57890f66d6fbc05077a2f97060be7169adfb8fd4d4b0fbf5d259caa6e72044d862bc7a2d2194027eab6d5c891548bd02a471d6722dc17481572ea16bf2aa0052defb3b7b7bf32068f24be3d59d6d2a15772dc468fa5f54bac94edcf85eeab6040f79afc401b233a0f142814a9460996d342bba24d44b30f92b51e565ac7cdb59e830641bcf10661ddcef132d2e59ede29bcd47959bf929bcf47575d4439a6f5d41d55b813cfe489c2179ebda5bcb8f43608ddc93ba9a8a427ba9c9c02e1e9e8938438ecb96b63dd6533bf0e2c38c05271062cd95c53754dab5b1f9b01ae00ecc704bdf93986ec8f79c564b0a37678dbbac6dd687e5a82ea77853b10fb60ef162b77c01af976bb7f436ebd1c3b2e8ad5655f288cdf7e168bfbe9a61a0366cb159f46f53dda99fa388faddb6e28ba122324f4b881c6cc34d3d54408705a536413357174d9da4e5d75e2464c14d68d8867b53b78e94fbdfe41bd2f272cb865b03e5f0a52097467c40a0396c5b71ba2e89c16ae44c84e1497ed95455c12962a73c9df32616ea73d3f58f863a984817ab0687deba3df2d6b91e329a1d2dcd60ca7515cf18c060c2e1e79dcdca662e5a0385feccc484bc3117068997dd800b40f04ed50338c0cb13b3209f57d34ae30c27253c682e0141319b426c5368c6e5adeba3bbf10e3793b75cc18737edbf32460c22d6e5d8f35a117091fdd2d8ada0b2ed925846e13cbffaa377a42d58a48926c0b636e95e642dc48449cdd55c8b675b54dff940677d37b1a5a027efde9313857ad2ddd91656c8e2691fd37693aca7b60ddbcbe95179c685ad7b242243b2dd1fdb8fcff42550d6d43e5a54cbf6b71a24ae2d561fb457abe79c49449f62c8baf3d45f6d41471498b79be839306b962cbfd115dc0febabcbd0e7926d506ed551a4cd7f0305cec379be36f7b544c41005eea5b21969cb76347b58ac797a22b98177aeba670e0815b31a0ab074fd184494020243729d00792eb2c04eeaf0f91704b8e1f93c1fe02f9f470bcb9032512eef3ec874149a8b286d92f9ffffb7abe9bcde7109e083eb57bcccab46d7b193677067463c8f06778127e1dec33b0c5947086a3b0a5312a6b1246aa509bb53c3afba1657f53a351d9b03faecde309d46d72e6cfeaf31dc29829082bb0dcd8728b4794cf9b1871d382181370e4ee11cf674747ccf7a05d26bef3523615bdb866c906f084ca7f756f8ddf40e2f84ea9151b6ccda74bc3a05cffe9bcd9f67f3cbe1be25db1c8538b72311a971ae5148e61ba6eb569b206b3cbdeafc7579261e0cdc2dba4ccb4d4a9effc1229f8584808d52ba250a427e9f06e022b517a4967d3a4ab3770557081507d0f9b6fe76098dcd4b7d016f1677c4f6b692a824e114c9bad2d2ca94c72c3232cecceaed10b2b6a0d3e373bc5e960c63dab20f8e3c591cd851863d6c6338835c467354237a47c5f2bbc0f3cf07e9eb1acfa2e3c2883171e0c91ef7646f6b12b2e783a4d20901e32991881a73b5c54ad990b0718a24620b064f5b59b0321ff6a447ee043e117eddd3eae3476a00bc3be82e2fe0fa973bd34ff3d295396a6f44dceb329bae3bc8a3aced75ea4dfcecdf801c13df706f65c7bae5c44c455367b5d66deec66d2256dbc960b320dd5705aba05855f177b6833a12a97dfa4f5e202568f7fa595d4769de48dafe26e88d23a3c251aa50ce4c95c040307523ec5120d613e9a1f1fe9581cf86ed39d1a478b6b0cd6a5190eca134f470e6647dcc0bf910cdabfe61272b9fc2708f9761a7aa5429e013bdb7bf15c6181be0165f569867af16c995b08e07d6cb32dd5a04190a91dd0d655921723fdd0bf398ffc8b02810d66731ec8695bc559d580a29431a08d4d6ed02a26012e41e8f8cb9311859d52270615a74a3b6dfe0cca5891242e7ce7b1815b59945eb48fe2c7acc0281f431dabd26bf8d6059e73016a309db4d6f04eaae8f62982b4215696951b4194826afbebbe417e3c4ca6ad5501be4a467743c1ba30247f723b81174720aed31b4bc5dc2be232d37ede9f1a26b9716c9f65d724e9141a9890402ce7a0e5343d845c78daa6a0af6b372fb18e3243120b30ba9cf3549c5e873112f259fddd10f582ebebf549a79e8d76491ea62bd6ba01149eaef7233a7997f28f050a988709794607ad39db7aa4a4fa562841f0f91495f25da2acabb050f8baa14bdc2655ff9651c2e910bb0fe5b8708fe9d4749bb08f871c8461dc5d40bb3f2ca5b26dbe79b0eae8bbc695b78286a7d7ab074a247a154a9b0a09e08d073647f194f0c487fd7e5eabba78576161a2201b4a9b0dd70c9bdf9cf694b7b498f51c7db6b38cd73c0468ec34491f09eb9185c145adc24b6b318f37962848a400e4737cc42b09de7a162c267b2db6df808b3b2c8d09bf8d8065864a6338b030971f266efb1c83429ef3a6aa432a15279e23896a95f5f3f7ba7bfdc1fc98c2a0afe11f07f465dd7363f7509d599521412b3239ac7baa8606d8c315f58d4294daeabe48b507ff03203ad28268936006ed8ce9b904aed309580583dc4fb4af0c96c2fc0470e3afbeb9e18a557c94c4328068b679837a200adfcf37bec100cbc5187ed7cab12ebc03a269cf38aa1d7a286612f5a9bd7302f1d6f54138a6a9e7dae556402f6dac3f08c95612309d0fdc36ebdf5d9b8435be5a61100c21e64174dce2e9774cfdd8a866e5b02fa04cb51dd533c426759774e3c37f9ecb654e14b2fd0ae79e18957e8d346b5f4596febfd9c47489253e8820a15e4a4e083e2c5ab4a65f42308904fe5dfb8905eea9c78a55cbc1f4986e0365b10bdc7b31ee7e401e68231bbdd908394dc7e8756dc5190115fe6d56a93099cfb8fcb49c0e2b5b";
    std::string tx_key_blob = "240000005595e1a3c7f4397d62e879202374644655d2ed158ac98f30139c4a337c3fdbba01008d98023a378ebe1d749c8bd35d55c134987ad4eeca3b5ef2dbf81a79adcb53edce5552050000000000000000a1c113b95e77f6044dc8534ecddb6c7144a056099eb24e556c90d4fbcdd85b357a54a21f732672878125e55a";
    std::string address = "F8GEg8A6gz4PRmLuEZ3nWaAkmpPjGWSEB89mq4Kfu94eeS9WVrKTWkwREGUY7ycZoj2oDTnK5VTdcFdi5yGqC8BfKwfA8yG";
    crypto::secret_key key;
    if (!epee::string_tools::hex_to_pod("0858b2ef752da7552de037181e943e06cf9bdc1033d66770b8f097fb90ba1205", key)) {
        emit errorReceived("Failed to deserialize key");
        return;
    }
    uint64_t amount = 0;
    std::string tx_blob_result;    
    if (!graft::rta_helpers::gui::decrypt_tx_and_amount(address, 
                                                        static_cast<int>(1), 
                                                          key,
                                                          tx_key_blob,
                                                          tx_blob,
                                                          amount, 
                                                          tx_blob_result)) {
        QString err = QString("failed to decrypt amount from tx for payment");
        emit errorReceived(err);
        
    } else {
        QString err = QString("Decrypted tx: ") + QString::number(amount);
        emit errorReceived(err);
    }
    
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
