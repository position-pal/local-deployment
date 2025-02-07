#!/bin/bash
set -e  # Exit immediately if a command fails

COMPOSE_FILE="docker-compose.yaml"

function cleanup() {
    rm -rf .tmp
}

function up() {
    ./scripts/init-postgres.sh
    docker compose -f "$COMPOSE_FILE" up -d --build
    cleanup
}

function down() {
    docker compose down
    cleanup
}

function process_locals() {
    mkdir -p .tmp
    echo "Processing local images..."
    if [[ ${#LOCALS[@]} -eq 0 ]]; then
        echo "No local images to process."
        return
    fi
    echo "Modifying $COMPOSE_FILE with local images..."
    for SERVICE in "${LOCALS[@]}"; do
        NAME="${SERVICE%%:*}"
        IMAGE="${SERVICE#*:}"
        yq eval ".services.$NAME.image = \"$IMAGE\"" -i "$COMPOSE_FILE"
    done
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

LOCALS=()
COMMAND=""

if ! command -v yq &> /dev/null; then
    echo "Error: yq is required. Install it with:"
    exit 1
fi

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        up|down)
            COMMAND="$1"
            ;;
        --local)
            if [[ -n "$2" ]]; then
                LOCALS+=("$2")
                shift
            else
                echo "Error: --local requires an argument (service:image)"
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 [up|down] [--local service-name:local-image]..."
            exit 1
            ;;
    esac
    shift
done

if [[ -z "$COMMAND" ]]; then
    echo "Usage: $0 [up|down] [--local service-name:local-image]..."
    exit 1
fi

process_locals

if [[ "$COMMAND" == "up" ]]; then
    up
elif [[ "$COMMAND" == "down" ]]; then
    down
fi
