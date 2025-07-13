#!/bin/bash

# Exit at first command error, undefined variable, or pipe error
# See https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Load variables
source variables.env

# Apply config to each control plane
for i in ${CONTROLPLANES_IPS//,/ }; do
  talosctl -n "$i" apply-config --insecure -f controlplane.yaml
done
