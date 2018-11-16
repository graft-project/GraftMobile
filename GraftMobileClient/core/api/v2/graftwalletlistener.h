#ifndef GRAFTWALLETLISTENER_H
#define GRAFTWALLETLISTENER_H

#include "wallet2_api.h"

class GraftWallet;

class GraftWalletListener : public Monero::WalletListener
{
public:
    GraftWalletListener(GraftWallet *wallet);

    void moneySpent(const std::string &txId, uint64_t amount) override;
    void moneyReceived(const std::string &txId, uint64_t amount) override;
    void unconfirmedMoneyReceived(const std::string &txId, uint64_t amount) override;
    void newBlock(uint64_t height) override;

    void updated() override;
    void refreshed() override;

private:
    GraftWallet *mWallet;
};

#endif // GRAFTWALLETLISTENER_H
