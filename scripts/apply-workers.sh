#!/bin/bash

# Variables, with default values
WORKERS_IPS="${WORKERS_IPS:-192.168.1.53,192.168.1.120,192.168.1.34}"

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# For each worker, apply config
echo "${WORKERS_IPS}" | tr "," "\n" | xargs -I% talosctl -n % apply-config --insecure -f worker.yaml
