# Talos Setup 🤖

A Talos setup based on simple bash scripts.

### What's included?

- Declarative HA Talos setup
- Cilium CNI
- Secure Boot
- System Extensions needed for Xen/XCP-ng and Longhorn
- Metrics Server
- Custom Time Servers

> [!NOTE]  
> Everything is easily customizable, like removing Secure Boot or changing System Extensions, etc.

### Usage

1. Clone the repository
2. Edit `variables.env` with your variables
3. Run the scripts in order. Some time must pass between `01-apply-controlplanes.sh` and `03-bootstrap-controleplane.sh`, check the bootstrap control plane logs to see when to start the bootstraping process. Other scripts can basically be chained directly.

### Might be added in the future

- VIP - Virtual (Shared) IP
- Ingress Firewall / Cilium Host Firewall
- Gateway API
- KubeSpan
- Omni (but not really sure it can be declarative)
