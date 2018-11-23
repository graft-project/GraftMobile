#include "graftclientconstants.h"

GraftClientConstants::GraftClientConstants(QObject *parent) : QObject(parent)
{
}

QString GraftClientConstants::mainnetDescription()
{
    return tr("Actual GRAFT blockchain, production network. This is the blockchain "
              "that carry real GRFT transactions.");
}

QString GraftClientConstants::testnetDescription()
{
    return tr("Exact functional copy of mainnet for public testing of mining, "
              "supernodes, wallet apps, and other features of GRAFT ecosystem.");
}

QString GraftClientConstants::alphaRTADescription()
{
    return tr("Blockchain and test network running on the code branch that contains "
              "Real Time Authorization and other future features that are not yet "
              "available on mainnet.\n\nCurrently available only for iOS and MacOS.\n"
              "Other platforms are coming soon.");
}

QString GraftClientConstants::licensingLets()
{
    return tr("The Graft Wallet is provided to you free of charge to allow "
              "you to access the Graft Blockchain. Graft is not responsible "
              "for any loss of use or loss of funds, and some of the "
              "technology we use is still under active development and "
              "testing. Use the Graft Wallet at your own risk, and please "
              "do not invest more than you are willing to lose.\n\n"
              "You are responsible for the safety of your wallet and the "
              "protection of your username and password. Always backup your "
              "keys: The Graft Wallets are not exchange accounts, and we do "
              "not hold funds for you. No data leaves your computer or your "
              "web browser. The Graft Wallet allows you to access and "
              "interact with the Graft Blockchain directly, but it does not "
              "copy or retain your information. If you lose your wallet or "
              "your access key, you will lose any funds associated with "
              "that wallet.\n\n"
              "Permission is hereby granted, free of charge, to any person "
              "obtaining a copy of the Graft Wallet software and associated "
              "documentation files (the \"Software\"), to deal in the "
              "Software without restriction, including without limitation "
              "the rights to use, copy, modify, merge, publish, distribute, "
              "sublicense, and/or sell copies of the Software, and to "
              "permit persons to whom the Software is furnished to do so, "
              "subject to the following conditions:\n");
}

QString GraftClientConstants::licenseDescription()
{
    return tr("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY "
              "KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE "
              "WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR "
              "PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS "
              "OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR "
              "OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR "
              "OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE "
              "SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.");
}

QString GraftClientConstants::cameraPermission()
{
    return tr("You haven't permission for the camera. Please, turn on camera permission "
              "in settings of the application.");
}

QString GraftClientConstants::walletCreated()
{
    return tr("Your wallet is created! Your mnemonic phrase is the only way to restore "
              "your wallet!\nCopy and store in the safe place this mnemonic password.");
}

