#!/bin/bash

POSITION_PAL_ORG="https://raw.githubusercontent.com/position-pal"
INIT_SCRIPTS=(
    "user-service/refs/heads/main/init.sql"
    "/notification-service/refs/heads/main/storage/src/main/resources/ddl-scripts/create-tables.sql"
)
TMP_DIR=".tmp/"
echo "Temporary dir: $TMP_DIR"

if [ ! -d "$TMP_DIR" ]; then
    mkdir $TMP_DIR
fi

for script in "${INIT_SCRIPTS[@]}"; do
    echo "Downloading $script..."
    wget --directory-prefix=$TMP_DIR $POSITION_PAL_ORG/$script
done
