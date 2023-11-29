#!/bin/bash
set -e

# Run your custom command before starting MongoDB
bash -c "rm -rf /data/db/* && mongod --bind_ip_all --dbpath /data/db"

# Continue with the default entrypoint provided by the official MongoDB image
exec docker-entrypoint.sh "$@"
