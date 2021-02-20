# Docker-Cosmos

Dockerized Cosmos Node with Optional Bootstrap for Fast Syncing

---

[![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-cosmos.svg?label=build&logo=circleci&logoColor=white)](https://circleci.com/gh/RyanHendricks/docker-cosmos)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-cosmos.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-cosmos)

[![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-cosmos/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![MicroBadger Image-Size (latest)](https://img.shields.io/microbadger/image-size/ryanhendricks/docker-cosmos:latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-cosmos)

[![Codacy grade](https://img.shields.io/codacy/grade/bc9dcdd26c7a45d597db9fc4b372db23.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-cosmos&amp;utm_campaign=Badge_Grade)

---

## Prerequisites

- Docker
- Docker-Compose (optional)

## Quick Start

The image can be run without any configuration and defaults to mainnet

```bash

export SEEDS=ba3bacc714817218562f743178228f23678b2873@5.83.160.108:26656,1e63e84945837b026f596ed8ae68708783d04ad4@51.75.145.123:26656,d2d452e7c9c43fa5ef017552688de60a5c0053ee@34.245.217.163:26656,dd36969b56c740bb40bb8badd4d4c6facc35dc24@206.189.115.41:26656,a0aca8fb801c69653a290bd44872e8457f8b0982@47.99.180.54:26656,27f8dd3bdbecbef7192291083706c156e523d8e0@3.122.248.21:26656,aee0df1a660f301d456a0c2f805b372f7341e8ec@63.35.230.143:26656,7d1f660b361d6286715c098a3a171e554e9642bb@34.254.205.37:26656,fa105c2291ac4aa452552fa4835266300a8209e1@88.198.41.62:26656,bd410d4564f7e0dd9a0eb16a64c337a059e11b80@47.103.35.130:26656

docker  run --rm -it -P --env SEEDS='$SEEDS' ryanhendricks/docker-cosmos:latest
# Feel free to use an alternate seeds although without one the node will have issues starting

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
CHAIN_ID=cosmoshub-4
SEEDS=$SEEDS
PROMETHEUS=true
PROMETHEUS_LISTEN_ADDR=36660
MAX_OPEN_CONNECTIONS=10
LCD_PORT=3317
RPC_PORT=36657
P2P_PORT=36656
PROXY_APP_PORT=36658

```

You can set ENV variables either in a docker-compose file or in the docker run command if running the container directly. If left unchanged they will default to the standard value except for the following:

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

After starting the container you can check the status here: [http://0.0.0.0:26657/status](http://0.0.0.0:26657/status).

or from the terminal

```bash
curl -X GET \
  http://127.0.0.1:26657/status? \
  -H 'cache-control: no-cache'
```

## NOTES

- The current SEEDS may not be around forever so consider overriding the defaults.
- You probably should not run a validator with this setup.

## Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?)](http://makeapullrequest.com)

### Contributors

[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)

## License

![GitHub](https://img.shields.io/github/license/ryanhendricks/docker-cosmos.svg)
