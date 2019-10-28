// Copyright (c) 2014-2019, The Monero Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef TRANSACTIONINFO_H
#define TRANSACTIONINFO_H

#include <QObject>
#include <QDateTime>
#include <QSet>
#include <QVariant>
#include <QDebug>

namespace Monero {
class TransactionInfo;
}

class Transfer;
class TransactionInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Direction direction READ direction)
    Q_PROPERTY(Status status READ status)
    Q_PROPERTY(double amount READ amount)
    Q_PROPERTY(double fee READ fee)
    Q_PROPERTY(quint64 blockHeight READ height)
    Q_PROPERTY(quint64 confirmations READ confirmations)
    Q_PROPERTY(quint64 unlockTime READ unlockTime)
    Q_PROPERTY(QString hash READ hash)
    Q_PROPERTY(QDateTime timestamp READ timestamp)
    Q_PROPERTY(QString paymentId READ paymentId) 
    Q_PROPERTY(QString destinations_formatted READ destinations_formatted)
    
public:
    enum Direction {
        In  =  0,
        Out,
        Invalid // invalid direction value, used for filtering
    };
    Q_ENUM(Direction)
    
    enum Status {
        Completed = 0,
        Pending,
        Failed
    };
    
    Q_ENUM(Status)
    
    explicit TransactionInfo(Direction direction, Status status, double amount,
        double fee, quint64 height, const QString &hash, const QDateTime &timestamp,
        const QString &paymentId, QObject * parent = nullptr);
    ~TransactionInfo();
    
    Direction direction() const;
    Status status() const;
    double amount() const  { return m_amount; }
    double fee() const     { return m_fee; }
    quint64 height() const { return m_height; }
    quint64 confirmations() const { return 0;}
    quint64 unlockTime() const { return 0; }
    //! transaction_id
    QString hash() const { return m_hash; }
    QDateTime timestamp() const { return m_timestamp; }
    QString paymentId() const   { return m_paymentId; }
    QString destinations_formatted() const;
    Q_INVOKABLE QList<Transfer*> transfers() const;
    
    static TransactionInfo * createFromTransferEntry(const QJsonObject &item, TransactionInfo::Direction direction, 
                                                     TransactionInfo::Status status);
    static TransactionInfo * createFromMoneroTransactionInfo(const Monero::TransactionInfo * info);


    
private:
    Direction   m_direction = In;
    Status      m_status    = Failed;
    double      m_amount    = 0;
    double      m_fee       = 0;
    quint64     m_height    = 0;
    QString     m_hash;
    QDateTime   m_timestamp;
    QString     m_paymentId;
    
    mutable QList<Transfer*> m_transfers;
};

// in order to wrap it to QVariant
Q_DECLARE_METATYPE(TransactionInfo*)



#endif // TRANSACTIONINFO_H
