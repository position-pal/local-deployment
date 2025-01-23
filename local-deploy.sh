#!/bin/bash

function up() {
    ./scripts/init-postgres.sh
    docker compose up --build -d
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
