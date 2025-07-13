#!/bin/bash

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Load variables
source variables.env

# Split control planes IPs and use first one to bootstrap
ips=(${CONTROLPLANES_IPS//,/ })
ip=${ips[0]}

# Bootstrap first control plane (one and only one needed)
talosctl bootstrap --nodes "${ip}" --endpoints "${ip}" --talosconfig=./talosconfig
