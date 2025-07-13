#!/bin/bash

# Variables, with default values
CONTROLPLANES_IPS="${CONTROLPLANES_IPS:-192.168.1.106}"

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Apply config to each control plane
for i in ${CONTROLPLANES_IPS//,/ }; do
  talosctl -n "$i" apply-config --insecure -f controlplane.yaml
done
