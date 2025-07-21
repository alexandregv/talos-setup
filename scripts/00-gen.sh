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

# Generate cilium config and insert it in a talos patch
cp patches/cilium.yaml.sample patches/cilium.yaml
helm template cilium cilium/cilium \
  --version "${CILIUM_VERSION}" \
  --namespace kube-system \
  --set ipam.mode=kubernetes \
  --set kubeProxyReplacement=true \
  --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
  --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
  --set cgroup.autoMount.enabled=false \
  --set cgroup.hostRoot=/sys/fs/cgroup \
  --set k8sServiceHost=localhost \
  --set k8sServicePort=7445 \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true | sed 's/^/        /' >> patches/cilium.yaml

# Generate talos config with variables and patches
talosctl gen config "${CLUSTER_NAME}" "https://${ip}:6443" \
  --config-patch @patches/cni.yaml \
  --config-patch @patches/metrics-server-all.yaml \
  --config-patch @patches/time-servers.yaml \
  --config-patch-control-plane @patches/cilium.yaml \
  --config-patch-control-plane @patches/metrics-server-bootstrap.yaml \
  --install-image "${INSTALLER_IMAGE}" \
  --install-disk "${INSTALL_DISK}"

# Rename config to expected file name
mv talosconfig config

# Set endpoints to control planes in config file
talosctl config endpoint ${CONTROLPLANES_IPS//,/ }

# Set default node to first control plane (should generally be overridden with `-n <target node>`)
talosctl config node "${ip}"

#TODO: kubespan, host firewall DNS (Talos or Cilium?), VIP
