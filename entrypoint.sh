#!/bin/sh

# FROM https://github.com/hasura/graphql-engine/blob/master/scripts/cli-migrations/docker-entrypoint.sh

set -e

log() {
    MESSAGE=$1
    echo $REVISION $MESSAGE
}

DEFAULT_MIGRATIONS_DIR="/hasura-migrations"

# check server port and ser default as 8080
if [ -z ${HASURA_GRAPHQL_SERVER_PORT+x} ]; then
    HASURA_GRAPHQL_SERVER_PORT=8080
fi

if [ -z ${HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT+x} ]; then
    HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT=30
fi

# wait for a port to be ready
wait_for_port() {
    local PORT=$1
    log "waiting $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT for $PORT to be ready"
    for i in `seq 1 $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT`;
    do
        nc -z localhost $PORT > /dev/null 2>&1 && log "port $PORT is ready" && return
        sleep 1
    done
    log "failed waiting for $PORT" && exit 1
}

# wait for port to be ready
wait_for_port $HASURA_GRAPHQL_SERVER_PORT