# Docker-Cosmos

Dockerized Cosmos Node with Optional Bootstrap for Fast Syncing

---

[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-cosmos.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-cosmos)

[![Codacy grade](https://img.shields.io/codacy/grade/bc9dcdd26c7a45d597db9fc4b372db23.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-cosmos&amp;utm_campaign=Badge_Grade)

---

## Prerequisites

- Docker
- Docker-Compose (optional)

## Quick Start

The image can be run without any configuration and defaults to mainnet

```bash

docker  run --rm -it -P ryanhendricks/docker-cosmos:latest

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
PROMETHEUS=true
PROMETHEUS_LISTEN_ADDR=26660
MAX_OPEN_CONNECTIONS=10
LCD_PORT=1317
RPC_PORT=26657
P2P_PORT=26656
PROXY_APP_PORT=26658

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

- You probably should not run a validator with this setup.

## Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?)](http://makeapullrequest.com)

### Contributors

[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)

## License

![GitHub](https://img.shields.io/github/license/ryanhendricks/docker-cosmos.svg)
