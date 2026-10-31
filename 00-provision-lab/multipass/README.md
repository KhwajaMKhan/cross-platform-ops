# Multipass — local Linux VM (macOS / Linux / Windows host)

[Multipass](https://multipass.run/) runs **Linux guests** on your laptop. It does **not** provide Windows guests — for Windows Server practice, use [../aws/](../aws/), [../azure/](../azure/), or [../gcp/](../gcp/), or Hyper-V on Windows.

## Launch Ubuntu for script practice

```bash
multipass launch 24.04 --name ops-linux --cpus 2 --memory 2G --disk 10G
multipass shell ops-linux
```

Inside the VM:

```bash
sudo apt update && sudo apt install -y curl
# Clone cross-platform-ops and run 01-dual-os-runbook/linux/health-check.sh
```

## Cloud-init (optional)

```bash
multipass launch --name ops-linux --cloud-init cloud-init.yaml
```

See [cloud-init.yaml](cloud-init.yaml) for a minimal package set.

## Cleanup

```bash
multipass delete ops-linux && multipass purge
```
