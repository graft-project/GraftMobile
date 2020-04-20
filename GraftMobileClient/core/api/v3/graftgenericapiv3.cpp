#include "graftgenericapiv3.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include "../../config.h"

#include <crypto/crypto.h>
#include <epee/string_tools.h>
#include <utils/cryptmsg.h>

namespace  {
    static constexpr size_t BALANCE_UPDATE_INTERVAL_MS = 1000;
}

GraftGenericAPIv3::GraftGenericAPIv3(const QStringList &addresses, const QString &dapiVersion,
                                     QObject *parent)
    : QObject(parent)
    ,mDAPIVersion(dapiVersion)
{
    mRetries = 0;
    mCurrentAddress = -1;
    mAddresses = addresses;
    mManager = nullptr;
    mRequest = QNetworkRequest(nextAddress());
    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
}

GraftGenericAPIv3::~GraftGenericAPIv3()
{
}

void GraftGenericAPIv3::changeAddresses(const QStringList &addresses)
{
    mAddresses = addresses;
    mCurrentAddress = -1;
    mRequest.setUrl(nextAddress());
}

void GraftGenericAPIv3::setDAPIVersion(const QString &version)
{
    mDAPIVersion = version;
}

void GraftGenericAPIv3::setAccountData(const QByteArray &accountData, const QString &password)
{
    mAccountData = accountData;
    mPassword = password;
}

QByteArray GraftGenericAPIv3::accountData() const
{
    return mAccountData;
}

QString GraftGenericAPIv3::password() const
{
    return mPassword;
}

void GraftGenericAPIv3::createAccount(const QString &password)
{
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("CreateAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished,
            this, &GraftGenericAPIv3::receiveCreateAccountResponse);
}

void GraftGenericAPIv3::getBalance()
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    QJsonObject data = buildMessage(QStringLiteral("GetWalletBalance"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveGetBalanceResponse);
}

void GraftGenericAPIv3::getTransactionHistory(quint64 fromBlock)
{
    mRetries = 0;
    qDebug() << "Requesting tx history from block: " << fromBlock;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("MinHeight"),   QJsonValue::fromVariant(fromBlock));
    QJsonObject data = buildMessage(QStringLiteral("GetWalletTransactions"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveGetTransactionsResponse);
}

void GraftGenericAPIv3::getSeed()
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("GetSeed"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveGetSeedResponse);
}

void GraftGenericAPIv3::restoreAccount(const QString &seed, const QString &password)
{
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Seed"), seed);
    QJsonObject data = buildMessage(QStringLiteral("RestoreAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished,
            this, &GraftGenericAPIv3::receiveRestoreAccountResponse);
}

void GraftGenericAPIv3::transferFee(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("PaymentID"), paymentID);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("GetTransferFee"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveTransferFeeResponse);
}

void GraftGenericAPIv3::transfer(const QString &address, const QString &amount,
                                 const QString &paymentID)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("PaymentID"), paymentID);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("Transfer"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveTransferResponse);
}

void GraftGenericAPIv3::saleStatus(const QString &pid, int blockNumber)
{
    
    Q_UNUSED(blockNumber)
    
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("get_payment_status")));
    
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QByteArray array = QJsonDocument(params).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv3::receiveSaleStatusResponse);
}


double GraftGenericAPIv3::toCoins(double atomic)
{
    return (1.0 * atomic) / 10000000000.0;
}

double GraftGenericAPIv3::toAtomic(double coins)
{
    return coins * 10000000000;
}

void GraftGenericAPIv3::encryptOneToMany(const std::string &input, const QStringList &keys_serialized, std::string &encryptedHex)
{
    std::vector<crypto::public_key> keys;
    
    deserializeKeys(keys_serialized, keys);
    
    std::string buf;
    graft::crypto_tools::encryptMessage(input, keys, buf);
    encryptedHex = epee::string_tools::buff_to_hex_nodelimer(buf);
}

void GraftGenericAPIv3::deserializeKeys(const QStringList &serialized_keys, std::vector<crypto::public_key> &keys)
{
    keys.clear();
    for (const auto & ks : serialized_keys) {
        crypto::public_key key;
        epee::string_tools::hex_to_pod(ks.toStdString(), key);
        keys.push_back(key);
    }
}

void GraftGenericAPIv3::setNetworkManager(QNetworkAccessManager *networkManager)
{
    if (networkManager && mManager != networkManager)
    {
        mManager = networkManager;
    }
}

QString GraftGenericAPIv3::accountPlaceholder() const
{
    return QString("????");
}

QByteArray GraftGenericAPIv3::serializeAmount(double amount) const
{
    QByteArray serializedAmount;
    serializedAmount.setNum(toAtomic(amount), 'f', 0);
    return serializedAmount;
}

QJsonObject GraftGenericAPIv3::buildMessage(const QString &key, const QJsonObject &params) const
{
    QJsonObject data;
    data.insert(QStringLiteral("jsonrpc"), QStringLiteral("2.0"));
    data.insert(QStringLiteral("id"), QStringLiteral("0"));
    data.insert(QStringLiteral("method"), key);
    data.insert(QStringLiteral("dapi_version"), mDAPIVersion);
    if (!params.isEmpty())
    {
        data.insert(QStringLiteral("params"), params);
    }
    return data;
}

QJsonObject GraftGenericAPIv3::processReply(QNetworkReply *reply)
{
    QJsonObject object;
    QByteArray rawData = reply->readAll();
    qDebug() << __FUNCTION__ << " reply from: " << reply->request().url() << ", data: " << rawData << ", httpStatus: " 
             << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (reply->error() == QNetworkReply::NoError)
    {
        if (!rawData.isEmpty())
        {
            QJsonObject response = QJsonDocument::fromJson(rawData).object();
            // qDebug() << response.toVariantMap();
            if (response.contains(QLatin1String("result")))
            {
                object = response.value(QLatin1String("result")).toObject();
            }
            else
            {
                mLastError = QLatin1String("Response error");
            }
        }
        else
        {
            mLastError = QLatin1String("Couldn't parse request response, url: ") + reply->request().url().toString();
            
        }
    }
    else
    {
        mLastError = reply->errorString();
    }
    reply->deleteLater();
    reply = nullptr;
    return object;
}

bool GraftGenericAPIv3::processReplyRest(QNetworkReply *reply, int &httpStatus, QJsonObject &response)
{
    bool result = false;
    if (reply->error() == QNetworkReply::NoError)
    {
        httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QByteArray rawData = reply->readAll();
        if (!rawData.isEmpty())
        {
            response = QJsonDocument::fromJson(rawData).object();
            result = true;
        } else if (httpStatus == 202) { // some calls return 202 and empty body
            result = true;
        }
        else
        {
            mLastError = QLatin1String("Couldn't parse request response, url: ") + reply->request().url().toString();
        }
    }
    else
    {
        mLastError = reply->errorString();
    }
    reply->deleteLater();
    reply = nullptr;
    return result;
}

QUrl GraftGenericAPIv3::nextAddress(const QString &endpoint)
{
    mCurrentAddress++;
    if (mCurrentAddress >= mAddresses.count())
    {
        mCurrentAddress = 0;
    }
    if (endpoint.isEmpty())
    {
        return QUrl(scUrl.arg(mAddresses.value(mCurrentAddress)));
    }
    else
    {
        return QUrl(scDapiUrl.arg(mAddresses.value(mCurrentAddress)).arg(endpoint));
    }
}



QNetworkReply *GraftGenericAPIv3::retry()
{
    if (mRetries < mAddresses.count() - 1)
    {
        mRetries++;
        mRequest.setUrl(nextAddress());
        return mManager->post(mRequest, mLastRequest);
    }
    else
    {
        mRetries = 0;
        emit error(QString("Services cannot process request. Reason: %1").arg(mLastError));
    }
    return nullptr;
}

void GraftGenericAPIv3::receiveCreateAccountResponse()
{
    mLastError.clear();
    qDebug() << "CreateAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() != QNetworkReply::NoError)
    {
        mLastError = reply->errorString();
        reply->deleteLater();
        reply = nullptr;
    }
    else
    {
        QByteArray arr = reply->readAll();
        reply->deleteLater();
        reply = nullptr;
        QByteArray temp("\"Account\": \"");
        int index = arr.indexOf(temp);
        int end = arr.indexOf("\",\r\n    \"Address\":");
        QByteArray accountArr;
        for (int i = index + temp.size(); i < end; ++i)
        {
            accountArr.append(arr.at(i));
        }
        arr.remove(index + temp.size(), end - (index + temp.size()));
        QString address;
        QString viewKey;
        QString seed;
        QJsonObject response = QJsonDocument::fromJson(arr).object();
        if (response.contains(QLatin1String("result")))
        {
            QJsonObject object = response.value(QLatin1String("result")).toObject();
            address = object.value(QLatin1String("Address")).toString();
            seed = object.value(QLatin1String("Seed")).toString();
            viewKey = object.value(QLatin1String("ViewKey")).toString();
            if (accountArr.isEmpty() || address.isEmpty())
            {
                mLastError = QLatin1String("Couldn't get account data!");
            }
            else
            {
                mAccountData = accountArr;
                qDebug() << mAccountData << address << viewKey << seed;
                emit createAccountReceived(mAccountData, mPassword, address, viewKey, seed);
            }
        }
        else
        {
            mLastError = QLatin1String("Response error");
        }
    }
    if (!mLastError.isEmpty())
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv3::receiveCreateAccountResponse);
        }
        else
        {
            emit createAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPIv3::receiveGetBalanceResponse()
{
    mLastError.clear();
    qDebug() << "GetBalance Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit balanceReceived(toCoins(object.value(QLatin1String("Balance")).toDouble()),
                             toCoins(object.value(QLatin1String("UnlockedBalance")).toDouble()));
    }
    else
    {
        mRequest.setUrl(nextAddress());
        QTimer::singleShot(BALANCE_UPDATE_INTERVAL_MS, this, [this]() {
            getBalance();
        });
        
    }
}

void GraftGenericAPIv3::receiveGetSeedResponse()
{
    mLastError.clear();
    qDebug() << "GetSeed Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getSeedReceived(object.value(QLatin1String("Seed")).toString());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv3::receiveGetSeedResponse);
        }
    }
}

void GraftGenericAPIv3::receiveRestoreAccountResponse()
{
    mLastError.clear();
    qDebug() << "RestoreAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() != QNetworkReply::NoError)
    {
        mLastError = reply->errorString();
        reply->deleteLater();
        reply = nullptr;
    }
    else
    {
        QByteArray arr = reply->readAll();
        reply->deleteLater();
        reply = nullptr;
        QByteArray temp("\"Account\": \"");
        int index = arr.indexOf(temp);
        int end = arr.indexOf("\",\r\n    \"Address\":");
        QByteArray accountArr;
        for (int i = index + temp.size(); i < end; ++i)
        {
            accountArr.append(arr.at(i));
        }
        arr.remove(index + temp.size(), end - (index + temp.size()));
        QString address;
        QString viewKey;
        QString seed;
        QJsonObject response = QJsonDocument::fromJson(arr).object();
        if (response.contains(QLatin1String("result")))
        {
            QJsonObject object = response.value(QLatin1String("result")).toObject();
            address = object.value(QLatin1String("Address")).toString();
            seed = object.value(QLatin1String("Seed")).toString();
            viewKey = object.value(QLatin1String("ViewKey")).toString();
            if (accountArr.isEmpty() || address.isEmpty())
            {
                mLastError = QLatin1String("Couldn't get account data!");
            }
            else
            {
                mAccountData = accountArr;
                qDebug() << mAccountData << address << viewKey << seed;
                emit restoreAccountReceived(mAccountData, mPassword, address, viewKey, seed);
            }
        }
        else
        {
            mLastError = QLatin1String("Response error");
        }
    }
    if (!mLastError.isEmpty())
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv3::receiveRestoreAccountResponse);
        }
        else
        {
            emit restoreAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPIv3::receiveTransferFeeResponse()
{
    mLastError.clear();
    qDebug() << "GetTransferFee Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit transferFeeReceived(object.value(QLatin1String("Result")).toInt(),
                                 object.value(QLatin1String("Fee")).toDouble());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv3::receiveTransferFeeResponse);
        }
    }
}

void GraftGenericAPIv3::receiveTransferResponse()
{
    mLastError.clear();
    qDebug() << "Transfer Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit transferReceived(object.value(QLatin1String("Result")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv3::receiveTransferResponse);
        }
    }
}

void GraftGenericAPIv3::receiveGetTransactionsResponse()
{
    mLastError.clear();
    qDebug() << "GetWalletTransactions Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    qDebug() << "GetWalletTransactions processing reply";
    QJsonObject object = processReply(reply);
    qDebug() << "GetWalletTransactions Response Processed\nTime: " << mTimer.elapsed();
    if (!object.isEmpty())
    {
        emit transactionHistoryReceived(
                    object.value("TransfersOut").toArray(),
                    object.value("TransfersIn").toArray(),
                    object.value("TransfersPending").toArray(),
                    object.value("TransfersFailed").toArray(),
                    object.value("TransfersPool").toArray()
                    );
    }
    else
    {
        mRequest.setUrl(nextAddress());
        // getTransactionHistory(); // TODO: do we need this?
    }
}

void GraftGenericAPIv3::receiveSaleStatusResponse()
{
    mLastError.clear();
    qDebug() << "/get_payment_status Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    
    // specific case: in case wallet is not called /pay yet - supernode will respond with "Payment ID is invalid" error
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray rawData = reply->readAll();
    if (!rawData.isEmpty()) {
        object = QJsonDocument::fromJson(rawData).object();
    }
    
    if (httpStatusCode == 500 && object.value("code").toInt() == ERROR_INVALID_PAYMENT_ID) { // try again
        // just pass GUI "inProgress" status
        // TODO: make sense to introduce some 'intermediate' status e.g. SalePosted ?
        emit saleStatusResponseReceived(static_cast<int>(OperationStatus::None));
    } else if (httpStatusCode == 200 && object.contains("Status")) {
        emit saleStatusResponseReceived(object.value("Status").toInt());
    } else {
        qCritical() << __FUNCTION__ << "Unhandled error: rawData: " << rawData << ", http_status: " << httpStatusCode;
        mLastError = QString("Failed to call '%1' - '%2'")
                .arg(mRequest.url().toString())
                .arg(reply->errorString());
        emit error(mLastError);
    }
    reply->deleteLater();
    reply = nullptr;
}

GraftGenericAPIv3::NodeAddress GraftGenericAPIv3::NodeAddress::fromJson(const QJsonObject &arg)
{
    NodeAddress result;
    result.Id = arg.value("Id").toString();
    result.WalletAddress = arg.value("WalletAddress").toString();
    return result;
}

QJsonObject GraftGenericAPIv3::NodeAddress::toJson() const
{
    QJsonObject result;
    result.insert("Id", QJsonValue(Id));
    result.insert("WalletAddress", QJsonValue(WalletAddress));
    return result;
}

GraftGenericAPIv3::NodeId GraftGenericAPIv3::NodeId::fromJson(const QJsonObject &arg)
{
    NodeId result;
    result.Id = arg.value("Id").toString();
    return result;
}

QJsonObject GraftGenericAPIv3::NodeId::toJson() const
{
    QJsonObject result;
    result.insert("Id", QJsonValue(Id));
    return result;
}

GraftGenericAPIv3::PaymentData GraftGenericAPIv3::PaymentData::fromJson(const QJsonObject &arg)
{
    PaymentData result;
    
    for (const auto key : arg.value("AuthSampleKeys").toArray()) {
        NodeId id = NodeId::fromJson(key.toObject());
        result.AuthSampleKeys.push_back(id);
    }
    
    result.EncryptedPayment = arg.value("EncryptedPayment").toString();
    result.PosProxy = NodeAddress::fromJson(arg.value("PosProxy").toObject());
    return result;
}

QJsonObject GraftGenericAPIv3::PaymentData::toJson() const
{
    QJsonObject result;
    QJsonArray AuthSampleKeysJson;
    for (const auto & key : AuthSampleKeys) {
        AuthSampleKeysJson.push_back(QJsonValue(key.toJson()));
    }
    result["AuthSampleKeys"] = QJsonValue(AuthSampleKeysJson);
    result["PosProxy"]  = QJsonValue(PosProxy.toJson());
    result["EncryptedPayment"] = QJsonValue(EncryptedPayment);
    
    return result;
}

GraftGenericAPIv3::PaymentStatus GraftGenericAPIv3::PaymentStatus::fromJson(const QJsonObject &arg)
{
    PaymentStatus result;
    result.Status = arg.value("Status").toInt();
    result.PaymentID = arg.value("PaymentID").toString();
    result.Signature = arg.value("Signature").toString();
    return result;
}

QJsonObject GraftGenericAPIv3::PaymentStatus::toJson() const
{
    QJsonObject result;
    result["Status"] = Status;
    result["PaymentID"]  = PaymentID;
    result["Signature"] = Signature;
    return result;
}

void GraftGenericAPIv3::PaymentStatus::sign(const crypto::public_key &pubkey, const crypto::secret_key &seckey)
{
    
    std::string msg = PaymentID.toStdString() + std::to_string(Status) + std::to_string(PaymentBlock);
    crypto::hash hash;
    crypto::cn_fast_hash(msg.data(), msg.size(), hash);
    
    crypto::signature sig;
    crypto::generate_signature(hash, pubkey,  seckey, sig);
    Signature = QString::fromStdString(epee::string_tools::pod_to_hex(sig));
}

GraftGenericAPIv3::EncryptedPaymentStatus GraftGenericAPIv3::EncryptedPaymentStatus::fromJson(const QJsonObject &arg)
{
    EncryptedPaymentStatus result;
    result.PaymentID = arg.value("PaymentID").toString();
    result.PaymentStatusBlob = arg.value("PaymentStatusBlob").toString();
    return result;
}

QJsonObject GraftGenericAPIv3::EncryptedPaymentStatus::toJson() const
{
    QJsonObject result;
    result["PaymentID"]  = PaymentID;
    result["PaymentStatusBlob"] = PaymentStatusBlob;
    return result;
}


bool GraftGenericAPIv3::EncryptedPaymentStatus::encrypt(const GraftGenericAPIv3::PaymentStatus &ps, const std::vector<crypto::public_key> &keys)
{
    QString ps_str = QJsonDocument(ps.toJson()).toJson();
    std::string encryptedBlob;
    graft::crypto_tools::encryptMessage(ps_str.toStdString(), keys, encryptedBlob);
    PaymentStatusBlob = QString::fromStdString(epee::string_tools::buff_to_hex_nodelimer(encryptedBlob));
    return true;
}

bool GraftGenericAPIv3::EncryptedPaymentStatus::decrypt(const crypto::secret_key &key, GraftGenericAPIv3::PaymentStatus &status)
{
    std::string paymentStatusJson;
    std::string encryptedBlob;
    epee::string_tools::parse_hexstr_to_binbuff(PaymentStatusBlob.toStdString(), encryptedBlob);
    
    if (!graft::crypto_tools::decryptMessage(encryptedBlob, key, paymentStatusJson)) {
        return false;
    }
    
    QJsonObject json = QJsonDocument::fromJson(QByteArray::fromStdString(paymentStatusJson)).object();
    if (json.isEmpty()) {
        qCritical() << "Failed to deserialize payment status from: " << QString::fromStdString(paymentStatusJson);
        return false;
    }
    
    status = PaymentStatus::fromJson(json);
    return true;
}
