#!/bin/bash

# Variables, with default values
CLUSTER_NAME="${CLUSTER_NAME:-talos0}"
BOOTSTRAP_CONTROLPLANE_IP="${BOOTSTRAP_CONTROLPLANE_IP:-192.168.1.106}"
INSTALLER_IMAGE="${INSTALLER_IMAGE:-factory.talos.dev/metal-installer-secureboot/53b20d86399013eadfd44ee49804c1fef069bfdee3b43f3f3f5a2f57c03338ac:v1.10.5}"
INSTALL_DISK="${INSTALL_DISK:-/dev/xvda}"

# Force context to be repository root
cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd

# Generate talos config with variables and patches
talosctl gen config "${CLUSTER_NAME}" "https://${BOOTSTRAP_CONTROLPLANE_IP}:6443" \
  --config-patch @patches/cni-patch.yaml \
  --config-patch-control-plane @patches/cilium-patch.yaml \
  --install-image "${INSTALLER_IMAGE}" \
  --install-disk "${INSTALL_DISK}"

#TODO: kubespan, host firewall DNS (Talos or Cilium?), VIP
