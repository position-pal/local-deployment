#!/bin/bash

function up() {
    ./scripts/init-postgres.sh
    # TODO: bring up all services
    docker compose up -d --build rabbitmq-broker postgres-db cassandra-db cassandra-init location-service gateway
    cleanup
}

function cleanup() {
    rm -rf .tmp
}

function down() {
    docker compose down
    cleanup
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd $SCRIPT_DIR
if [ "$1" == "up" ]; then
    up
elif [ "$1" == "down" ]; then
    down
else
    echo "Usage: $0 [up|down]"
fi
