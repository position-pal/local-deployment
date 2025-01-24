#!/bin/bash

function cleanup() {
    rm -rf .tmp
}

function up() {
    ./scripts/init-postgres.sh
    docker compose up -d --build
    cleanup
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
