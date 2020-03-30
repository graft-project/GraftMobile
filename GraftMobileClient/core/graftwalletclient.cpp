#include "productmodelserializator.h"
#include "api/v3/graftwalletapiv3.h"
#include "api/v3/graftwallethandlerv3.h"
#include "api/v3/privatepaymentdetails.h"
#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
#include "api/v2/graftwallethandlerv2.h"
#endif

#include "graftwalletclient.h"
#include "graftclienttools.h"
#include "accountmanager.h"
#include "productmodel.h"
#include "keygenerator.h"
#include "config.h"
#include "core/txhistory/TransactionHistoryModel.h"
#include "core/txhistory/TransactionInfo.h"
#include "core/txhistory/TransactionHistory.h"

#include "epee/string_tools.h"
#include "utils/cryptmsg.h"
#include "epee/misc_log_ex.h"
#include "libwallet/wallet2_api.h"

#include <QRegularExpressionMatch>
#include <QRegularExpression>
#include <QJsonDocument>
#include <iostream>

namespace  {

bool decryptPaymentData(const QString &encryptedPaymentHex, const QString &walletPrivateKey, quint64 &amount, QByteArray &paymentDetails)
{
    
    crypto::secret_key wallet_key;
    if (!epee::string_tools::hex_to_pod(walletPrivateKey.toStdString(), wallet_key)) {
        qCritical() << "Failed to parse private key from: " << walletPrivateKey;
    } 
    
    std::string encryptedPaymentInfoBlob;
    if (!epee::string_tools::parse_hexstr_to_binbuff(encryptedPaymentHex.toStdString(), encryptedPaymentInfoBlob)) {
        qCritical() << "Failed to deserialize EncryptedPayment from: " << encryptedPaymentHex;
        return false;
    }
    qDebug() << "encrypted paymment binarized";
    
    std::string paymentInfoStr;
    qDebug() << "decrypting: " << QByteArray::fromStdString(encryptedPaymentInfoBlob).toHex().length() << " bytes, " << QByteArray::fromStdString(encryptedPaymentInfoBlob).toHex();
    qDebug() << "with key: " << walletPrivateKey;
    if (!graft::crypto_tools::decryptMessage(encryptedPaymentInfoBlob, wallet_key, paymentInfoStr)) {
        qCritical() << "Failed to decrypt EncryptedPaymentInfo with key";
        return false; 

    }
    qDebug() << "encrypted payment decrypted " << paymentInfoStr.c_str();
    
    QJsonDocument doc = QJsonDocument::fromJson(QByteArray::fromStdString(paymentInfoStr));
    if (doc.isEmpty()) {
        qCritical() << "Failed to parse payment info from: " << QString::fromStdString(paymentInfoStr);
        return false;
    }
    
    QJsonObject paymentInfo = doc.object();
    
    amount = static_cast<quint64>(paymentInfo.value("Amount").toVariant().toLongLong());
    
    // decrypt payment details
    if (!epee::string_tools::parse_hexstr_to_binbuff(paymentInfo.value("Details").toString().toStdString(), encryptedPaymentInfoBlob)) {
        qCritical() << "Failed to deserialize PaymentInfo from: " << paymentInfo.value("Details").toString();
        return false;
    }
    
    std::string _paymentDetails;
    
    if (!graft::crypto_tools::decryptMessage(encryptedPaymentInfoBlob, wallet_key, _paymentDetails)) {
        qCritical() << "Failed to decrypt payment info from " << paymentInfo.value("Details").toString();
        return false;
    }
    
    paymentDetails = QByteArray::fromStdString(_paymentDetails);
    
    return  true;
}

static void encryptOneToMany(const std::string &input, const QStringList &keys_serialized, std::string &encryptedHex)
{
    std::vector<crypto::public_key> keys;
    for (const auto & ks : keys_serialized) {
        crypto::public_key key;
        epee::string_tools::hex_to_pod(ks.toStdString(), key);
        keys.push_back(key);
    }
    
    std::string buf;
    graft::crypto_tools::encryptMessage(input, keys, buf);
    encryptedHex = epee::string_tools::buff_to_hex_nodelimer(buf);
}



static constexpr double RTA_FEE_RATIO = 0.5;

}

GraftWalletClient::GraftWalletClient(QObject *parent)
    : GraftBaseClient(parent)
    ,mClientHandler(nullptr)
{
    mBlockNumber = 0;
    changeGraftHandler();
    mPaymentProductModel = new ProductModel(this);
    
    
}

GraftWalletClient::~GraftWalletClient()
{
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
    return QRegularExpressionMatch(walletAddress.match(data, 0, QRegularExpression::PartialPreferFirstMatch)).hasPartialMatch();
}

bool GraftWalletClient::isSaleQrCodeValid(const QString &data) const
{
    QJsonObject object = QJsonDocument::fromJson(data.toLatin1()).object();
    PrivatePaymentDetails ppd = PrivatePaymentDetails::fromJson(object);
    return ppd.isValid();
}

void GraftWalletClient::saleDetails(const QString &data)
{
    QString _data = data;
    
    if (data == "debug") {
        QFile f("/tmp/rta-qr-code.json");
        f.open(QIODevice::ReadOnly);
        _data = f.readAll();
    }
    
    
    
    if (isSaleQrCodeValid(_data))
    {
        QJsonObject object = QJsonDocument::fromJson(_data.toLatin1()).object();
        PrivatePaymentDetails ppd = PrivatePaymentDetails::fromJson(object);

        mPID = ppd.paymentId;
        mMerchantKey     = ppd.posAddress.Id;
        mMerchantAddress = ppd.posAddress.WalletAddress;
        
        mPrivateKey = ppd.key;
        
        // mTotalCost = dataList.value(2).toDouble(); // XXX this will received from dapi
       
        mBlockNumber = ppd.blockHeight;
        mBlockHash   = ppd.blockHash;
                
        // updateQuickExchange(mTotalCost); // XXX: this needs to be called after payment data received from dapi
        mClientHandler->saleDetails(mPID, mBlockNumber, mBlockHash);
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
        mClientHandler->getSupernodeInfo(mKeys);
    }
}

void GraftWalletClient::payStatus()
{
    if (mClientHandler)
    {
        mClientHandler->payStatus(mPID, mBlockNumber);
    }
}

void GraftWalletClient::buildRtaTransaction()
{
    if (mClientHandler) {
        mClientHandler->buildRtaTransaction(mPID, mMerchantAddress, mKeys, mWallets, mTotalCost, RTA_FEE_RATIO, mBlockNumber);
    }
}

void GraftWalletClient::receiveSaleDetails(int result, const GraftGenericAPIv3::PaymentData &pd, const GraftGenericAPIv3::NodeAddress &walletProxyAddress)
{
    const bool isStatusOk = (result == 0);
    mPaymentProductModel->clear();
    
    qDebug() << "Payment Data received: " << pd.toJson();
    quint64 amount = 0;
    QByteArray data;
    // decrypt payment data
    if (!decryptPaymentData(pd.EncryptedPayment, mPrivateKey, amount, data)) {
        emit saleDetailsReceived(false);
    } else {
        mKeys.clear();
        mWallets.clear();
        ProductModelSerializator::deserialize(data, mPaymentProductModel);
        mTotalCost = GraftWalletAPIv3::toCoins(amount);
        mKeys.push_back(mMerchantKey);
        mKeys.push_back(pd.PosProxy.Id);
        mKeys.push_back(walletProxyAddress.Id);
        mWallets.push_back(pd.PosProxy.WalletAddress);
        mWallets.push_back(walletProxyAddress.WalletAddress);
        for (const auto & item : pd.AuthSampleKeys) {
            mKeys.push_back(item.Id);
        }
        
        updateQuickExchange(mTotalCost);
        
        emit saleDetailsReceived(isStatusOk);
    }
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

void GraftWalletClient::receiveBuildRtaTransaction(int result, const QString &errorMessage, const QStringList &ptxVector, double recepientAmount, double feePerDestination)
{
    const bool isStatusOk = (result == 0);
    if (!isStatusOk) {
        emit errorReceived(QString("Failed to build rta tx: %1").arg(errorMessage));
    } else {
        // submit transaction
        qDebug() << "Submitting transaction, amount: " << recepientAmount << ", fee per each destination: " << feePerDestination;
        // TODO:
        // 1. de-serialize ptxVector using `PendingTransaction` interface
        for (const auto &ptx_hex : ptxVector) {
            Monero::PtxProxy * ptxProxy = Monero::PtxProxy::deserialize(ptx_hex.toStdString());
            // 2. get serialized 'cryptonote::transaction' from `PendingTransaction` object
            // 3. get transaction key (to be added to `PendingTransaction` interface)
            // 4. encrypt both tx and key and call `/dapi/v2.0/pay`
            std::string tx_hex, tx_key_hex;
            encryptOneToMany(ptxProxy->txBlob(), mKeys, tx_hex);
            encryptOneToMany(ptxProxy->txKeyBlob(), mKeys, tx_key_hex);
            mClientHandler->submitRtaTx(QString::fromStdString(tx_hex), QString::fromStdString(tx_key_hex));
            qDebug() << "submitting tx: " << ptxProxy->txHash().c_str();
            delete ptxProxy;
        }
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
        mClientHandler = new GraftWalletHandlerV3(dapiVersion(), getServiceAddresses(), this);
        break;
//    case GraftClientTools::PublicExperimentalTestnet:
//#if defined(Q_OS_IOS) || defined(Q_OS_MACOS)
//        mClientHandler = new GraftWalletHandlerV2(dapiVersion(), getServiceAddresses(),
//                                                  getServiceAddresses(true),
//                                                  networkType() != GraftClientTools::Mainnet, this);
//#else
//        mClientHandler = new GraftWalletHandlerV1(dapiVersion(), getServiceAddresses(), this);
//#endifEncryptedPayment
        break;
    }
    mClientHandler->setNetworkManager(mNetworkManager);
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
    connect(mClientHandler, &GraftBaseHandler::transactionHistoryReceived,
            this, [this](const QList<TransactionInfo*> &tx_items) {
        mTxHistoryModel->setTransactionHistoryItems(tx_items);
    });
    connect(mClientHandler, &GraftWalletHandler::getSupernodeInfoReceived, this,
            [this](const QStringList &wallets) { 
        mWallets = wallets;
        this->buildRtaTransaction();
    });
    
    connect(mClientHandler, &GraftWalletHandler::buildRtaTransactionReceived, this, &GraftWalletClient::receiveBuildRtaTransaction);
    
    initAccountSettings();
}

GraftBaseHandler *GraftWalletClient::graftHandler() const
{
    Q_ASSERT_X(mClientHandler, "GraftWalletClient", "GraftWalletHandler not initialized!");
    return mClientHandler;
}
