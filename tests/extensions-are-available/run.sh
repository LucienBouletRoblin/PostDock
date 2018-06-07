#!/usr/bin/env bash

docker-compose up -d postgres_ext
docker-compose exec  postgres_ext wait_local_postgres
set -e

for EXTENSION in postgis pglogical pgl_ddl_deploy pg_repack;
do
    echo ">>> Checking now: $EXTENSION"
    docker-compose exec -T postgres_ext bash -c "gosu postgres psql -c 'CREATE EXTENSION $EXTENSION'"
done

for LIB in libpgosm.so nominatim.so;
do
    echo ">>> Checking now: $LIB"
    docker-compose exec -T postgres_ext gosu postgres psql -c "load '$LIB'"
done

