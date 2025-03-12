#!/bin/bash
# This script make sure to setup the Cassandra database with the needed tables for the PositionPal services.
# This is intended to be executed inside a Cassandra container after the database is up and running
#  (see `cassandra-init` in ../docker-compose.yaml for more details).
POSITION_PAL_ORG="https://raw.githubusercontent.com/position-pal"
INIT_SCRIPTS=(
    "location-service/main/tracking-actors/src/main/resources/db-scripts/create-tables.cql"
    "location-service/main/storage/src/main/resources/db-scripts/create-tables.cql"
    "chat-service/main/infrastructure/src/main/resources/db-scripts/cassandra-schema-creation.cql"
)
OUT_DIR="/init-scripts"

if [ ! -d "$OUT_DIR" ]; then
    mkdir $OUT_DIR
fi

cd $OUT_DIR

for script in "${INIT_SCRIPTS[@]}"; do
    echo "Downloading $script..."
    wget $POSITION_PAL_ORG/$script
done

for script in ${OUT_DIR}/*; do
    echo "Running $script..."
    cqlsh cassandra-db -f $script
done
