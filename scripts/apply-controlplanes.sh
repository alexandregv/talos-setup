#!/bin/bash

# Variables, with default values
BOOTSTRAP_CONTROLPLANE_IP="${BOOTSTRAP_CONTROLPLANE_IP:-192.168.1.106}"

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Apply talos config to bootstrap control plane (first one only)
talosctl -n "${BOOTSTRAP_CONTROLPLANE_IP}" apply-config --insecure -f controlplane.yaml

# Bootstrap first control plane
talosctl bootstrap --nodes "${BOOTSTRAP_CONTROLPLANE_IP}" --endpoints "${BOOTSTRAP_CONTROLPLANE_IP}" --talosconfig=./talosconfig
