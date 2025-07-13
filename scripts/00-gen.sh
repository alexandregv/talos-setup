#!/bin/bash

# Exit at first command error, undefined variable, or pipe error
# See https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Load variables
source variables.env

# Split control planes IPs and use first one as initial endpoint
ips=(${CONTROLPLANES_IPS//,/ })
ip=${ips[0]}

# Generate talos config with variables and patches
talosctl gen config "${CLUSTER_NAME}" "https://${ip}:6443" \
  --config-patch @patches/cni-patch.yaml \
  --config-patch @patches/rotate-certs-patch.yaml \
  --config-patch-control-plane @patches/cilium-patch.yaml \
  --config-patch-control-plane @patches/bootstrap-extra-manifests.yaml \
  --install-image "${INSTALLER_IMAGE}" \
  --install-disk "${INSTALL_DISK}"

#TODO: kubespan, host firewall DNS (Talos or Cilium?), VIP
