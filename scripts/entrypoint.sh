#!/bin/sh


# exit script on any error
set -e
echo "setting up initial configurations"

if [ ! -d "$GAIAD_HOME/data" ];
then

  gaiad init ${MONIKER:-nonamenode} --home=${GAIAD_HOME:-/.gaiad} --chain-id=${CHAIN_ID:-cosmoshub-2}

  cd $GAIAD_HOME/config

  rm genesis.json
  rm config.toml

  if [ ! -z "$GENESIS_URL" ]; then
      wget $GENESIS_URL
  else
      wget https://raw.githubusercontent.com/cosmos/launch/master/genesis.json
  fi


cat > config.toml << EOF
# This is a TOML config file.
# For more information, see https://github.com/toml-lang/toml

##### main base config options #####

# TCP or UNIX socket address of the ABCI application,
# or the name of an ABCI application compiled in with the Tendermint binary
proxy_app = "${PROXY_APP:-tcp://127.0.0.1:26658}"

# A custom human readable name for this node
moniker = "${MONIKER:-moniker}"

# If this node is many blocks behind the tip of the chain, FastSync
# allows them to catchup quickly by downloading blocks in parallel
# and verifying their commits
fast_sync = ${FAST_SYNC:-true}

# Database backend: leveldb | memdb | cleveldb
db_backend = "${DB_BACKEND:-leveldb}"

# Database directory
db_dir = "${DB_DIR:-data}"

# Output level for logging, including package level options
log_level = "${LOG_LEVEL:-main:info,state:info,*:error}"

##### additional base config options #####

# Path to the JSON file containing the initial validator set and other meta data
genesis_file = "${GENESIS_FILE:-config/genesis.json}"

# Path to the JSON file containing the private key to use as a validator in the consensus protocol
priv_validator_file = "${PRIV_VALIDATOR_FILE:-config/priv_validator.json}"

# TCP or UNIX socket address for Tendermint to listen on for
# connections from an external PrivValidator process
priv_validator_laddr = "${PRIV_VALIDATOR_LADDR:-}"

# Path to the JSON file containing the private key to use for node authentication in the p2p protocol
node_key_file = "${NODE_KEY_FILE:-config/node_key.json}"

# Mechanism to connect to the ABCI application: socket | grpc
abci = "${ABCI:-socket}"

# TCP or UNIX socket address for the profiling server to listen on
prof_laddr = "${PROF_LADDR:-localhost:6060}"

# If true, query the ABCI app on connecting to a new peer
# so the app can decide if we should keep the connection or not
filter_peers = ${FILTER_PEERS:-false}

##### advanced configuration options #####

##### rpc server configuration options #####
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
laddr = "${RPC_LADDR:-tcp://0.0.0.0:26657}"

# TCP or UNIX socket address for the gRPC server to listen on
# NOTE: This server only supports /broadcast_tx_commit
grpc_laddr = "${GRPC_LADDR:-}"

# Maximum number of simultaneous connections.
# Does not include RPC (HTTP&WebSocket) connections. See max_open_connections
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
grpc_max_open_connections = ${GRPC_MAX_OPEN_CONNECTIONS:-900}

# Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool
unsafe = ${UNSAFE:-false}

# Maximum number of simultaneous connections (including WebSocket).
# Does not include gRPC connections. See grpc_max_open_connections
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
max_open_connections = ${MAX_OPEN_CONNECTIONS:-900}

##### peer to peer configuration options #####
[p2p]

# Address to listen for incoming connections
laddr = "${P2P_LADDR:-tcp://0.0.0.0:26656}"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address.
external_address = "${EXTERNAL_ADDRESS:-}"

# Comma separated list of seed nodes to connect to
seeds = "${SEEDS:-}"

# Comma separated list of nodes to keep persistent connections to
persistent_peers = "${PERSISTENT_PEERS:-}"

# UPNP port forwarding
upnp = ${UPNP:-false}

# Path to address book
addr_book_file = "${ADDR_BOOK_FILE:-config/addrbook.json}"

# Set true for strict address routability rules
# Set false for private or local networks
addr_book_strict = ${ADDR_BOOK_STRICT:-false}

# Maximum number of inbound peers
max_num_inbound_peers = ${MAX_NUM_INBOUND_PEERS:-40}

# Maximum number of outbound peers to connect to, excluding persistent peers
max_num_outbound_peers = ${MAX_NUM_OUTBOUND_PEERS:-10}

# Time to wait before flushing messages out on the connection
flush_throttle_timeout = "${FLUSH_THROTTLE_TIMEOUT:-100ms}"

# Maximum size of a message packet payload, in bytes
max_packet_msg_payload_size = ${MAX_PACKET_MSG_PAYLOAD_SIZE:-1024}

# Rate at which packets can be sent, in bytes/second
send_rate = ${SEND_RATE:-5120000}

# Rate at which packets can be received, in bytes/second
recv_rate = ${RECV_RATE:-5120000}

# Set true to enable the peer-exchange reactor
pex = ${PEX:-true}

# Seed mode, in which node constantly crawls the network and looks for
# peers. If another node asks it for addresses, it responds and disconnects.
#
# Does not work if the peer-exchange reactor is disabled.
seed_mode = ${SEED_MODE:-false}

# Comma separated list of peer IDs to keep private (will not be gossiped to other peers)
private_peer_ids = "${PRIVATE_PEER_IDS:-}"

# Toggle to disable guard against peers connecting from the same ip.
allow_duplicate_ip = ${ALLOW_DUPLICATE_IP:-true}

# Peer connection configuration.
handshake_timeout = "${HANDSHAKE_TIMEOUT:-20s}"
dial_timeout = "${DIAL_TIMEOUT:-3s}"

##### mempool configuration options #####
[mempool]

recheck = ${RECHECK:-true}
broadcast = ${BROADCAST:-true}
wal_dir = "${WAL_DIR}"

# size of the mempool
size = ${SIZE_OF_MEMPOOL:-5000}

# size of the cache (used to filter transactions we saw earlier)
cache_size = ${CACHE_SIZE:-10000}

##### consensus configuration options #####
[consensus]

wal_file = "${WAL_FILE:-data/cs.wal/wal}"

timeout_propose = "${TIMEOUT_PROPOSE:-3s}"
timeout_propose_delta = "${TIMEOUT_PROPOSE_DELTA:-500ms}"
timeout_prevote = "${TIMEOUT_PREVOTE:-1s}"
timeout_prevote_delta = "${TIMEOUT_PREVOTE_DELTA:-500ms}"
timeout_precommit = "${TIMEOUT_PRECOMMIT:-1s}"
timeout_precommit_delta = "${TIMEOUT_PRECOMMIT_DELTA:-500ms}"
timeout_commit = "${TIMEOUT_COMMIT:-5s}"


# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
skip_timeout_commit = ${SKIP_TIMEOUT_COMMIT:-false}

# EmptyBlocks mode and possible interval between empty blocks
create_empty_blocks = ${CREATE_EMPTY_BLOCKS:-true}
create_empty_blocks_interval = "${CREATE_EMPTY_BLOCKS_INTERVAL:-0s}"

# Reactor sleep duration parameters
peer_gossip_sleep_duration = "${PEER_GOSSIP_SLEEP_DURATION:-100ms}"
peer_query_maj23_sleep_duration = "${PEER_QUERY_MAJ23_SLEEP_DURATION:-2s}"

##### transactions indexer configuration options #####
[tx_index]

# What indexer to use for transactions
#
# Options:
#   1) "null" (default)
#   2) "kv" - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
indexer = "${INDEXED:-kv}"

# Comma-separated list of tags to index (by default the only tag is "tx.hash")
#
# You can also index transactions by height by adding "tx.height" tag here.
#
# It's recommended to index only a subset of tags due to possible memory
# bloat. This is, of course, depends on the indexer's DB and the volume of
# transactions.
index_tags = "${INDEX_TAGS:-}"

# When set to true, tells indexer to index all tags (predefined tags:
# "tx.hash", "tx.height" and all tags from DeliverTx responses).
#
# Note this may be not desirable (see the comment above). IndexTags has a
# precedence over IndexAllTags (i.e. when given both, IndexTags will be
# indexed).
index_all_tags = ${INDEX_ALL_TAGS:-true}

##### instrumentation configuration options #####
[instrumentation]

# When true, Prometheus metrics are served under /metrics on
# PrometheusListenAddr.
# Check out the documentation for the list of available metrics.
prometheus = ${PROMETHEUS:-false}

# Address to listen for Prometheus collector(s) connections
prometheus_listen_addr = "${PROMETHEUS_LISTEN_ADDR:-:26660}"

# Maximum number of simultaneous connections.
# If you want to accept more significant number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
max_open_connections = ${MAX_OPEN_CONNECTIONS:-3}

# Instrumentation namespace
namespace = "${NAMESPACE:-tendermint}"

EOF


fi

gaiad start --home=$GAIAD_HOME
