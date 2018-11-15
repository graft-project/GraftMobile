#include "graftwalletlistener.h"
#include "graftwallet.h"
#include <QDebug>

GraftWalletListener::GraftWalletListener(GraftWallet *wallet)
    : mWallet(wallet)
{

}

void GraftWalletListener::moneySpent(const std::string &txId, uint64_t amount)
{
    qDebug() << __FUNCTION__ << QString::fromStdString(txId) << amount;
}

void GraftWalletListener::moneyReceived(const std::string &txId, uint64_t amount)
{
    qDebug() << __FUNCTION__ << QString::fromStdString(txId) << amount;
}

void GraftWalletListener::unconfirmedMoneyReceived(const std::string &txId, uint64_t amount)
{
    qDebug() << __FUNCTION__ << QString::fromStdString(txId) << amount;
}

void GraftWalletListener::newBlock(uint64_t height)
{
    qDebug() << __FUNCTION__ << height;
}

void GraftWalletListener::updated()
{
    mWallet->updateWallet();
}

void GraftWalletListener::refreshed()
{
    mWallet->refreshWallet();
}
