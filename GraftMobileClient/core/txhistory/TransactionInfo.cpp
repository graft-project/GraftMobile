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
#include <QDateTime>
#include <QDebug>






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
    // TODO
    return QString();     
}

QList<Transfer*> TransactionInfo::transfers() const
{
    return m_transfers;
}

