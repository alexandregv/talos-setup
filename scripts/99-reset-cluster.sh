#!/bin/bash

# Exit at undefined variable
# See https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -u

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Load variables
source variables.env

# Reset all workers
for i in ${WORKERS_IPS//,/ }; do
  talosctl reset -n "$i" -e "$i" --graceful=false --talosconfig=./talosconfig
done

# Reset all control planes
for i in ${CONTROLPLANES_IPS//,/ }; do
  talosctl reset -n "$i" -e "$i" --graceful=false --talosconfig=./talosconfig
done
