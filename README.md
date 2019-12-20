# Docker-Cosmos

Dockerized Cosmos Node with Optional Bootstrap for Fast Syncing

---

[![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-cosmos.svg?label=build&logo=circleci&logoColor=white)](https://circleci.com/gh/RyanHendricks/docker-cosmos)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-cosmos.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-cosmos)

[![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-cosmos/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![MicroBadger Image-Size (latest)](https://img.shields.io/microbadger/image-size/ryanhendricks/docker-cosmos:latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-cosmos)

[![Codacy grade](https://img.shields.io/codacy/grade/c35da045d95b4f07b09948d19bacaa47.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-cosmos&amp;utm_campaign=Badge_Grade)

---

## Prerequisites

- Docker
- Docker-Compose (optional)

## Quick Start

The image can be run without any configuration and defaults to mainnet

```bash
docker  run --rm -it -P --env SEEDS='067041dc191225c016749d43b0c51964e74aded4@35:245:96:132:26656' ryanhendricks/docker-cosmos:latest
# Feel free to use an alternate seed node although without one the node will have issues starting

```

## Configuration

### Config.toml Parameters

- The config.toml is created dynamically when starting the container.
- All parameters specified in the standard config.toml file can be set using environmental variables with the same name as the config parameter but in all caps. See [entrypoint script](./scripts/entrypoint.sh) for more details.
- If left unset the default values will be used.
- Parameters can be set directly by modifying the config.toml portion of ./scripts/entrypoint.sh if you are cloning and building the image yourself.

### Environment Variables

```bash
# EXAMPLES

MONIKER=nonamenode
CHAIN_ID=cosmoshub-2
GENESIS_URL=https://raw.githubusercontent.com/cosmos/launch/master/genesis.json
BOOTSTRAP=TRUE
SEEDS=
PROMETHEUS=true

```

You can set ENV variables either in a docker-compose file or in the docker run command if running the container directly. If left unchanged they will default to the standard value except for the following:

- MONIKER
  - defaults to "nonamenode"
- CHAIN_ID
  - defaults to cosmoshub-3
- GENESIS_URL
  - defaults to cosmoshub-3 github [genesis file url](https://raw.githubusercontent.com/cosmos/launch/master/genesis.json)

### Bootstrapping

  The entrypoint script allows for the node to be bootstrapped upon creation. This drastically reduces the time required to fully sync with the network. The start up time is increased relative to the amount of time it takes the host machine to download ~20GB of data and extract it into the data directory.

  Set the ENV variable ```BOOTSTRAP=TRUE``` to enable bootstrapping.

## Build

The following command will build the image.

```bash
docker build --rm -f Dockerfile -t docker-cosmos:latest .
```

## Running

### Mainnet

```sh
docker-compose up -d --build
```

### Testnet

```sh
docker-compose docker-compose-testnet.yml up -d --build
```

## Supervisor

The image uses Supervisor to run both gaiad and gaiacli simultaneously at container runtime. Supervisor also restarts either process should it fail for some reason.

### Gaiad

After starting the container you can check the status here: [http://127.0.0.1:26657/status](http://127.0.0.1:26657/status).

or from the terminal

```bash
curl -X GET \
  http://127.0.0.1:26657/status? \
  -H 'cache-control: no-cache'
```

## Gaiacli Rest-Server

Supervisor starts the rest-server with the following command:

```bash
gaiacli rest-server --trust-node --cors * --home $GAIAD_HOME --laddr tcp://0.0.0.0:1317

```

You can verify that the rest-server is running using the following example

```bash
curl -X GET \
  http://127.0.0.1:1317/blocks/latest \
  -H 'cache-control: no-cache'
```

## NOTES

- The current SEEDS (nodes I am running and supplying here since the ones from cosmos/launch repo all are not working as of this update) may not be around forever so consider overriding the defaults. If the badges above have do not have block numbers for either chain that means the seed nodes are no longer with us.
- You probably should not run a validator with this setup.

## Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?)](http://makeapullrequest.com)

### Contributors

[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)

## License

![GitHub](https://img.shields.io/github/license/ryanhendricks/docker-cosmos.svg)
