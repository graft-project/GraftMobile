#ifndef GRAFTPOSAPIV3_H
#define GRAFTPOSAPIV3_H

#include "graftgenericapiv3.h"
#include "crypto/crypto.h"

class GraftPOSAPIv3 : public GraftGenericAPIv3
{
    Q_OBJECT
public:
    
    
    explicit GraftPOSAPIv3(const QStringList &addresses, const QString &dapiVersion,
                           QObject *parent = nullptr);

    void sale(const QString &address, double amount, const QString &saleDetails = QString());
    void rejectSale(const QString &pid);
    void saleStatus(const QString &pid, int blockNumber);
    QString paymentId() const;
    QString walletEncryptionKey() const;
    QString posPubkey() const;
    QString blockHash() const;
    int blockHeight() const;

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

private slots:
    void receivePresaleResponse();
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveSaleStatusResponse();
    
private:
    crypto::public_key m_public_key;
    crypto::secret_key m_secret_key; // key to encrypt payment data
    crypto::secret_key m_wallet_secret_key; // key to encrypt payment data
    PresaleResponse m_presaleResponse;
    QString m_paymentId;
    QString m_address;
    double m_amount = 0;
    QString m_saleDetails;
};

#endif // GRAFTPOSAPIV3_H
