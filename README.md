# Docker-Cosmos

## Prerequisites

  - Docker
  - Docker-Compose

## Getting Started

```sh
docker-compose up -d
```

You're now running a cosmos node on gaia-13003 testnet.

Check the status here: [http://127.0.0.1:26657/status](http://127.0.0.1:26657/status). 

Modify the environment variables in the docker-compose.yml file as needed.

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

