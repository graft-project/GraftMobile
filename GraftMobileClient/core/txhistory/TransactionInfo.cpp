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

#include "TransactionInfo.h"
#include "Transfer.h"
#include "core/api/v3/graftgenericapiv3.h"
#include "wallet2_api.h"
#include <QDateTime>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>






TransactionInfo::TransactionInfo(TransactionInfo::Direction direction, TransactionInfo::Status status,
                                 double amount, double fee, quint64 height, 
                                 const QString &hash, const QDateTime &timestamp, 
                                 const QString &paymentId, QObject *parent)
    : QObject(parent)
    , m_direction(direction)
    , m_status(status)
    , m_amount(amount)
    , m_fee(fee)
    , m_height(height)
    , m_hash(hash)
    , m_timestamp(timestamp)
    , m_paymentId(paymentId)
{
    
}

TransactionInfo::~TransactionInfo()
{
    qDeleteAll(m_transfers);
}

TransactionInfo::Direction TransactionInfo::direction() const
{
    return m_direction;
}

TransactionInfo::Status TransactionInfo::status() const
{
    return m_status;
}

QString TransactionInfo::destinations_formatted() const
{
    QString destinations;
    for (auto const& t: transfers()) {
        if (!destinations.isEmpty())
          destinations += "<br> ";
        destinations +=  QString::number(t->amount()) + ": " + t->address();
    }
    return destinations;
}

QList<Transfer*> TransactionInfo::transfers() const
{
    return m_transfers;
}

TransactionInfo *TransactionInfo::createFromTransferEntry(const QJsonObject &item, TransactionInfo::Direction direction, TransactionInfo::Status status)
{
    
    TransactionInfo * result = new TransactionInfo(direction,
                                                   status,
                                                   GraftGenericAPIv3::toCoins(item.value("amount").toDouble()),
                                                   GraftGenericAPIv3::toCoins(item.value("fee").toDouble()),
                                                   item.value("height").toVariant().toLongLong(),
                                                   item.value("txid").toString(),
                                                   QDateTime::fromTime_t(item.value("timestamp").toVariant().toULongLong()),
                                                   item.value("payment_id").toString());
    
    QJsonArray destinations = item.value("destinations").toArray();
  
    for (int i = 0; i < destinations.size(); ++i) {
        QJsonObject destination = destinations.at(i).toObject();
  
        result->m_transfers.push_back(new Transfer(GraftGenericAPIv3::toCoins(destination.value("amount").toDouble()),
                                                   destination.value("address").toString()));
    }
    return result;
    
}

TransactionInfo *TransactionInfo::createFromMoneroTransactionInfo(const Monero::TransactionInfo *info)
{
    TransactionInfo * result = new TransactionInfo(
                info->direction() == Monero::TransactionInfo::Direction_In ? TransactionInfo::In : TransactionInfo::Out,
                info->isFailed() ? TransactionInfo::Failed : info->isPending() ? TransactionInfo::Pending : TransactionInfo::Completed,
                GraftGenericAPIv3::toCoins(info->amount()),
                GraftGenericAPIv3::toCoins(info->fee()),
                info->blockHeight(),
                QString::fromStdString(info->hash()),
                QDateTime::fromTime_t(info->timestamp()),
                QString::fromStdString(info->paymentId()));
    for (const auto & transfer : info->transfers()) {
        result->m_transfers.push_back(new Transfer(GraftGenericAPIv3::toCoins(transfer.amount),
                                                   QString::fromStdString(transfer.address)));
    }
    return result;
}


