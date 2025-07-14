#!/bin/bash

# Exit at first command error, undefined variable, or pipe error
# See https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Load variables
source variables.env

# Split control planes IPs and use first one to bootstrap
ips=(${CONTROLPLANES_IPS//,/ })
ip=${ips[0]}

# Generate kubeconfig and add to existing config
talosctl kubeconfig --nodes "${ip}" --endpoints "${ip}" --talosconfig=./talosconfig
