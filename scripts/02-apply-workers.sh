#!/bin/bash

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Load variables
source variables.env

# For each worker, apply config
for i in ${WORKERS_IPS//,/ }; do
  talosctl -n "$i" apply-config --insecure -f worker.yaml
done
