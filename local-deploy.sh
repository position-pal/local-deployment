#!/bin/bash

function up() {
    ./scripts/init-postgres.sh
    # TODO: bring up all services
    docker compose up -d --build rabbitmq-broker cassandra-db cassandra-init location-service gateway
}

function down() {
    docker compose down
    rm -rf .tmp
}

if [ "$1" == "up" ]; then
    up
elif [ "$1" == "down" ]; then
    down
else
    echo "Usage: $0 [up|down]"
fi
