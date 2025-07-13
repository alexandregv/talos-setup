#!/bin/bash

# Variables, with default values
BOOTSTRAP_CONTROLPLANE_IP="${BOOTSTRAP_CONTROLPLANE_IP:-192.168.1.106}"

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Bootstrap first control plane (one and only one needed)
talosctl bootstrap --nodes "${BOOTSTRAP_CONTROLPLANE_IP}" --endpoints "${BOOTSTRAP_CONTROLPLANE_IP}" --talosconfig=./talosconfig
