[![](https://images.microbadger.com/badges/image/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
[![](https://images.microbadger.com/badges/version/ryanhendricks/docker-cosmos.svg)](https://microbadger.com/images/ryanhendricks/docker-cosmos)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ryanhendricks/docker-cosmos.svg?style=popout)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ryanhendricks/docker-cosmos.svg)
# Docker-Cosmos

## Prerequisites

  - Docker
  - Docker-Compose

## Getting Started


### Environment Variables

You will need to set the following env variables either in a docker-compose file or in the docker run command if running the container directly. Not to worry though,
- MONIKER
  - defaults to "nonamenode"
- GAIAD_HOME
  - defaults to /.gaiad
- CHAIN_ID
  - defaults to gaia-13003
- GENESIS_URL
  - defaults to gaia-13003 github genesis file url

You can modify the config within the /scripts/entrypoint.sh file if you are cloning and building the image yourself. The config.toml is created dynamically when starting the container based on the ENV variables supplied above.

### Running the Node

```sh
docker-compose up -d
```

You're now running a cosmos node on gaia-13003 testnet.

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
nohup gaiacli rest-server --trust-node --cors * --home $GAIAD_HOME --laddr tcp://0.0.0.0:1317 > rest_log.txt &
```

