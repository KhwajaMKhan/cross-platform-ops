# 00 — Provision Linux + Windows test hosts

Optional **starting point** to run scripts in `01-dual-os-runbook/` and `04-patch-governance/`. Pick **one** path — do not merge snippets blindly.

| Path | Linux | Windows | Notes |
|------|-------|---------|--------|
| [aws/](aws/) | Amazon Linux 2023 (Terraform) | Windows Server 2022 (Terraform) | SSM instance profile; tighten SGs in prod |
| [azure/](azure/) | Ubuntu LTS (Terraform) | Windows Server (Terraform) | Run Command / Bastion for access |
| [gcp/](gcp/) | Debian/Ubuntu (Terraform) | Windows Server (Terraform) | OS Login / IAP for SSH/RDP patterns |
| [multipass/](multipass/) | Ubuntu VM locally | — | **Linux only**; use cloud or Hyper-V for Windows |

After provision: install or verify **management agent** (SSM, Azure VM Agent, Google ops agent) before relying on agent-based access (see `02-identity-access/`).

**Cost:** Use smallest SKUs; **stop/deallocate** when idle; destroy when finished.
