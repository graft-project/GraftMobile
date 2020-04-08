#ifndef GRAFTPOSAPIV3_H
#define GRAFTPOSAPIV3_H

#include "graftgenericapiv3.h"
#include "crypto/crypto.h"

class GraftPOSAPIv3 : public GraftGenericAPIv3
{
    Q_OBJECT
public:
    
    
    explicit GraftPOSAPIv3(const QStringList &addresses, GraftGenericAPIv3::NetType nettype, const QString &dapiVersion,
                           QObject *parent = nullptr);

    void sale(const QString &address, double amount, const QString &saleDetails = QString());
    void rejectSale(const QString &pid);
    void approveSale(const QString &pid);
    QString paymentId() const;
    QString walletEncryptionKey() const;
    QString posPubkey() const;
    QString blockHash() const;
    int blockHeight() const;
    void getRtaTx(const QString &pid);

private:
    void presale();
    void sale();

private:
    struct PresaleResponse
    {
        PresaleResponse() {}
        quint64 BlockNumber = 0;
        QString BlockHash;
        QStringList AuthSample;
        GraftGenericAPIv3::NodeAddress PosProxy;
        static PresaleResponse fromJson(const QJsonObject &arg);
    };
    
    
    
    
signals:
    void saleResponseReceived(int result, const QString &payment_id, int blockNum);
    void rejectSaleResponseReceived(int result);
    void saleStatusResponseReceived(int status);
    void rtaTxResponseReceived(const QByteArray &txBlob, const QByteArray &txKeyBlob);
    void rtaTxValidated(bool);
    void saleApproveProcessed(bool);

private slots:
    void receivePresaleResponse();
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveGetRtaTxResponse();
    void receiveApproveSale();
    
    
    
private:
    crypto::public_key m_public_key;        
    crypto::secret_key m_secret_key;        // key to encrypt payment data
    crypto::secret_key m_wallet_secret_key; // key to encrypt payment data
    PresaleResponse m_presaleResponse;
    QString m_address;
    double m_amount = 0;
    QString m_saleDetails;
    NetType m_nettype;
    std::string m_txBlob;
};

#endif // GRAFTPOSAPIV3_H
