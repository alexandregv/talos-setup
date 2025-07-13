#!/bin/bash

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Load variables
source variables.env

# Apply config to each control plane
for i in ${CONTROLPLANES_IPS//,/ }; do
  talosctl -n "$i" apply-config --insecure -f controlplane.yaml
done
