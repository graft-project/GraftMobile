#ifndef CONFIG_H
#define CONFIG_H

#include <QStringList>

static const QString scUrl("http://%1/dapi");

static const int scMaxRetryNumber = 3;

namespace MainnetConfiguration {
static const QString scConfigTitle("Mainnet");

static const QStringList scSeedSupernodes{"13.58.215.50:18900",
                                          "13.59.105.220:18900",
                                          "18.216.94.64:18900"
                                         };

static const QString scDAPIVersion("1.0G");
}

namespace TestnetConfiguration {
static const QString scConfigTitle("Public Testnet");

static const QStringList scSeedSupernodes{"34.239.34.92:28900",
                                          "35.153.242.98:28900",
                                          "35.169.204.213:28900"
                                         };

static const QString scDAPIVersion("1.0F");
}

namespace ExperimentalTestnetConfiguration {
static const QString scConfigTitle("Public RTA Testnet");

static const QStringList scSeedSupernodes{"34.200.186.98:28900"//,
                                          //"34.224.118.182:28900",
                                          //"52.206.105.250:28900"
                                         };

static const QString scDAPIVersion("1.0R");
}


#endif // CONFIG_H
