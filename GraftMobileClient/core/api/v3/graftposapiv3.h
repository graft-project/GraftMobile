#ifndef GRAFTPOSAPIV3_H
#define GRAFTPOSAPIV3_H

#include "graftgenericapiv3.h"
#include "libcncrypto/crypto.h"

class GraftPOSAPIv3 : public GraftGenericAPIv3
{
    Q_OBJECT
public:
    
    
    explicit GraftPOSAPIv3(const QStringList &addresses, const QString &dapiVersion,
                           QObject *parent = nullptr);

    void sale(const QString &address, const QString &viewKey, double amount,
              const QString &saleDetails = QString());
    void rejectSale(const QString &pid);
    void getSaleStatus(const QString &pid);

private:
    void presale();

private:
    struct PresaleResponse
    {
        PresaleResponse() {}
        quint64 BlockNumber = 0;
        QString BlockHash;
        QStringList AuthSample;
        GraftGenericAPIv3::NodeAddress NodeAddress;
        static PresaleResponse fromJson(const QJsonObject &arg);
    };
    
signals:
    void presaleResponseReceived(int result);
    void saleResponseReceived(int result, const QString &payment_id, int blockNum);
    void rejectSaleResponseReceived(int result);
    void getSaleStatusResponseReceived(int result, int status);

private slots:
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveSaleStatusResponse();
    
private:
    crypto::secret_key m_secret_key; // key to encrypt payment data
        
};

#endif // GRAFTPOSAPIV3_H
