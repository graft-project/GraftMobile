#ifndef CONFIG_H
#define CONFIG_H

#include <QStringList>

static const QString scUrl("%1/dapi");

namespace MainnetConfiguration {
static const QString scConfigTitle("Mainnet");

static const QStringList scSeedSupernodes{"%1mainnet-seed.graft.network:18943"
                                          //"%113.58.215.50:18900",
                                          //"%113.59.105.220:18900",
                                          //"%118.216.94.64:18900"
                                         };

static const QString scDAPIVersion("1.0G");
}

namespace TestnetConfiguration {
static const QString scConfigTitle("Public Testnet");

static const QStringList scSeedSupernodes{"%1testnet-pub-seed.graft.network:28943"
                                          //"%134.204.170.120:28900",
                                          //"%154.88.58.35:28900",
                                          //"%134.228.64.99:28900"
                                         };

static const QString scDAPIVersion("1.0F");
}

namespace ExperimentalTestnetConfiguration {
static const QString scConfigTitle("Public RTA Testnet");

static const QStringList scSeedSupernodes{"%1testnet-rta-seed.graft.network:28943"
                                          //"%134.200.186.98:28900",
                                          //"%134.224.118.182:28900",
                                          //"%152.206.105.250:28900"
                                         };

static const QString scDAPIVersion("1.0R");
}


#endif // CONFIG_H
