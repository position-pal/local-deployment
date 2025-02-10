#!/bin/bash
set -e  # Exit immediately if a command fails
trap cleanup EXIT  # Cleanup on exit

TMP_DIR=".tmp"
COMPOSE_FILE="docker-compose.yaml"
COMPOSE_BACKUP_FILE="$TMP_DIR/docker-compose.backup.yaml"

function cleanup() {
    if [[ -f "$COMPOSE_BACKUP_FILE" ]]; then
        mv "$COMPOSE_BACKUP_FILE" "$COMPOSE_FILE"
    fi
    rm -rf $TMP_DIR
}

function up() {
    ./scripts/init-postgres.sh
    docker compose -f "$COMPOSE_FILE" up -d --build
}

function down() {
    docker compose down
    cleanup
}

function process_overrides() {
    mkdir -p .tmp
    echo "Processing override images..."
    if [[ ${#OVERRIDES[@]} -eq 0 ]]; then
        echo "No override images to process."
        return
    fi
    echo "Modifying $COMPOSE_FILE with override images..."
    if [[ ! -f "$COMPOSE_BACKUP_FILE" ]]; then
        cp "$COMPOSE_FILE" "$COMPOSE_BACKUP_FILE"
    fi
    for SERVICE in "${OVERRIDES[@]}"; do
        NAME="${SERVICE%%:*}"
        IMAGE="${SERVICE#*:}"
        yq eval ".services.$NAME.image = \"$IMAGE\"" -i "$COMPOSE_FILE"
    done
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

OVERRIDES=()

if ! command -v yq &> /dev/null; then
    echo "Error: 'yq' command is required. Install it first!"
    exit 1
fi

COMMAND=""
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        up|down)
            COMMAND="$1"
            ;;
        --override)
            if [[ -n "$2" ]]; then
                OVERRIDES+=("$2")
                shift
            else
                echo "Error: --override requires an argument (<service-name>:<new-image>)"
                exit 1
            fi
            ;;
        *)
            echo "Usage: $0 [up|down] [--override <service-name>:<new-image>]..."
            exit 1
            ;;
    esac
    shift
done

if [[ -z "$COMMAND" ]]; then
    echo "Usage: $0 [up|down] [--override <service-name>:<new-image>]..."
    exit 1
fi

if [[ "$COMMAND" == "up" ]]; then
    down
    process_overrides
    up
elif [[ "$COMMAND" == "down" ]]; then
    down
fi
