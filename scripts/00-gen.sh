#!/bin/bash

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
  --config-patch-control-plane @patches/cilium-patch.yaml \
  --install-image "${INSTALLER_IMAGE}" \
  --install-disk "${INSTALL_DISK}"

#TODO: kubespan, host firewall DNS (Talos or Cilium?), VIP
