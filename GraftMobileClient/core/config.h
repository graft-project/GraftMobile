#ifndef CONFIG_H
#define CONFIG_H

#include <QStringList>

static const QString scUrl("%1/dapi");
static const QString scDapiUrl("%1/dapi/v2.0/%2");

namespace MainnetConfiguration
{
static const QString scConfigTitle("Mainnet");

static const QStringList scHttpSeedSupernodes{"mainnet-seed.graft.network:18900"
                                              //"13.58.215.50:18900",
                                              //"13.59.105.220:18900",
                                              //"18.216.94.64:18900"
                                             };

static const QStringList scHttpsSeedSupernodes{"mainnet-seed.graft.network:18943"};

static const QString scDAPIVersion("1.0G");
}

namespace TestnetConfiguration
{
static const QString scConfigTitle("Public Testnet");

static const QStringList scHttpSeedSupernodes{"testnet-pub-seed.graft.network:28900"
                                              //"34.204.170.120:28900",
                                              //"54.88.58.35:28900",
                                              //"34.228.64.99:28900"
                                             };

static const QStringList scHttpsSeedSupernodes{"testnet-pub-seed.graft.network:28943"};

static const QString scDAPIVersion("1.0F");
}

namespace ExperimentalTestnetConfiguration
{
static const QString scConfigTitle("Alpha RTA Testnet");

static const QStringList scHttpSeedSupernodes{"35.169.179.171:28690"//"testnet-dev-seed.graft.network:28600"
                                              //"18.214.197.224:28690"
                                              //"18.214.197.50:28690"
                                              //"35.169.179.171:28690"
                                              //"34.192.115.160:28690"

                                              //"testnet-rta-seed.graft.network:28900"
                                              //"34.200.186.98:28900",
                                              //"34.224.118.182:28900",
                                              //"52.206.105.250:28900"
                                             };

static const QStringList scHttpsSeedSupernodes{"testnet-dev-seed.graft.network:28643"
                                               //"testnet-rta-seed.graft.network:28943"
                                              };

static const QString scDAPIVersion("1.0R");
}

#endif // CONFIG_H
