# Docker-Cosmos

Run a Dockerized full node on cosmoshub-2

---

![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-cosmos.svg?label=circleci%20&logo=circleci&logoColor=white)
![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-cosmos.svg?label=docker%20build&logo=docker&logoColor=white)

[![version](https://images.microbadger.com/badges/version/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![layers](https://images.microbadger.com/badges/image/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-cosmos.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-cosmos)

![https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Cosmoshub-2&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fstakeswaps.com:26657%2Fstatus&prefix=Block%2B](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Cosmoshub-2&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fstakeswaps.com:26657%2Fstatus&prefix=Block%2B) ![https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Gaia-13003&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fdigiderivatives.com:26657%2Fblocks%2Flast](https://img.shields.io/badge/dynamic/json.svg?color=blue&label=Gaia-13003&query=result.sync_info.latest_block_height&url=http%3A%2F%2Fdigiderivatives.com:26657%2Fstatus&prefix=Block%2B)
---

## Prerequisites

- Docker
- Docker-Compose

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
  - defaults to cosmoshub2 github [genesis file url](https://raw.githubusercontent.com/cosmos/launch/master/genesis.json)

You can modify the config within the /scripts/entrypoint.sh file if you are cloning and building the image yourself. The config.toml is created dynamically when starting the container based on the ENV variables supplied above.

### Running the Node

```sh
docker  run --rm -it -P registry.gitlab.com/appealtoheavenllc/docker-cosmos:latest

# or

docker-compose up -d
```

You're now running a cosmos node on cosmoshub-2 (mainnet).

Check the status here: [http://127.0.0.1:26657/status](http://127.0.0.1:26657/status).

You probably should not run a validator with this setup.

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


[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)
