#ifndef CONFIG_H
#define CONFIG_H

#include <QStringList>

static const QString scUrl("%1/dapi");
static const QString scDapiUrl("%1/dapi/v2.0/%2");

namespace MainnetConfiguration
{
static const QString scConfigTitle("Mainnet");

static const QStringList scHttpSeedSupernodes{
                                              "mainnet-seed.graft.network:18900"
                                             };

static const QStringList scHttpsSeedSupernodes{"mainnet-seed.graft.network:18943"};

static const QString scDAPIVersion("1.0G");
}

namespace TestnetConfiguration
{
static const QString scConfigTitle("Public Testnet");

static const QStringList scHttpSeedSupernodes{
                                              "testnet-pub-seed.graft.network:28690"
                                             };

static const QStringList scHttpsSeedSupernodes{"testnet-pub-seed.graft.network:28643"};

static const QString scDAPIVersion("1.0F");
}

namespace ExperimentalTestnetConfiguration
{
static const QString scConfigTitle("Public Devnet");


static const QStringList scHttpSeedSupernodes{
                                              "testnet-pub-seed.graft.network:28690"
                                             };

static const QStringList scHttpsSeedSupernodes{"testnet-pub-seed.graft.network:28643"};

static const QString scDAPIVersion("1.0R");
}

#endif // CONFIG_H
