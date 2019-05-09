# Docker-Cosmos

Dockerized Cosmos Node

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
docker  run --rm -it -P --env SEEDS='b1c618b89f8f996b7d07e1df710a33e4e4e186c5@stakehedge.com:26656' ryanhendricks/docker-cosmos:latest

# Feel free to use an alternate seed node although without one the node will have issues starting

```

## Configuration

### Environment Variables

You can set the following env variables either in a docker-compose file or in the docker run command if running the container directly. If left unchanged they will default to the values listed below.

- MONIKER
  - defaults to "nonamenode"
- GAIAD_HOME
  - defaults to /.gaiad
- CHAIN_ID
  - defaults to cosmoshub-2
- GENESIS_URL
  - defaults to cosmoshub-2 github [genesis file url](https://raw.githubusercontent.com/cosmos/launch/master/genesis.json)


### Config.toml Parameters

The node configuration file is generated when starting the container. All parameters specified in the standard config.toml file can be set at runtime using environmental variables. If left unset the default values will be used.

You can modify the config within the /scripts/entrypoint.sh file if you are cloning and building the image yourself. The config.toml is created dynamically when starting the container based on the ENV variables supplied above.

## Build

The following command will build the image.

```bash
docker build --rm -f Dockerfile -t docker-cosmos:latest .
```

## Running

### Mainnet

[![image](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Cosmoshub-2&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fstakeswaps.com:26657%2Fstatus&prefix=Block%2B)](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Cosmoshub-2&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fstakeswaps.com:26657%2Fstatus&prefix=Block%2B)

```sh
docker-compose up -d --build
```

### Testnet

[![image](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Gaia-13003&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fdigiderivatives.com:26657%2Fstatus&prefix=Block%2B)](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Gaia-13003&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fdigiderivatives.com:26657%2Fstatus&prefix=Block%2B)

```sh
docker-compose docker-compose-testnet.yml up -d --build
```

Check the status here: [http://127.0.0.1:26657/status](http://127.0.0.1:26657/status).

## Start the JSON-RPC rest server

attach to the running container and execute (or ```docker exec```) the following command:

```bash
gaiacli rest-server --trust-node --cors * --home $GAIAD_HOME --laddr tcp://0.0.0.0:1317

# verify with
curl -X GET \
  http://127.0.0.1:1317/blocks/latest \
  -H 'cache-control: no-cache'
```

Alternatively,

```bash
# This will keep the rest-server running after term disconnect.
nohup gaiacli rest-server --trust-node --cors * --home $GAIAD_HOME --laddr tcp://0.0.0.0:1317 > rest_log.txt &
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
