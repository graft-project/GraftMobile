#ifndef CONFIG_H
#define CONFIG_H

#include <QStringList>

static const QString scUrl("http://%1/dapi");

namespace MainnetConfiguration {
static const QString scConfigTitle("Mainnet");

static const QStringList scSeedSupernodes{"54.207.21.115:28900",
                                          "54.207.116.130:28900",
                                          "54.233.159.189:28900"
                                         };

static const QString scDAPIVersion("1.0G");
}

namespace TestnetConfiguration {
static const QString scConfigTitle("Public Testnet");

static const QStringList scSeedSupernodes{"54.207.21.115:28900",
                                          "54.207.116.130:28900",
                                          "54.233.159.189:28900"
                                         };

static const QString scDAPIVersion("1.0F");
}

namespace ExperimentalTestnetConfiguration {
static const QString scConfigTitle("Public RTA Testnet");

static const QStringList scSeedSupernodes{"54.207.21.115:28900",
                                          "54.207.116.130:28900",
                                          "54.233.159.189:28900"
                                         };

static const QString scDAPIVersion("1.0R");
}


#endif // CONFIG_H
