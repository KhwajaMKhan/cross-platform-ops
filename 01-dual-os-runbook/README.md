# 01 — Dual-OS runbook (health check)

Run the **same incident questions** on Linux and Windows before you change anything.

**Provision hosts (optional):** [`../00-provision-lab/`](../00-provision-lab/) — AWS, Azure, GCP Terraform, or Multipass for local Linux.

## Linux

```bash
chmod +x health-check.sh
./health-check.sh
```

Read-only: identity, OS, disk, memory, load, listening ports, pending updates (dnf/yum/apt when present), recent package installs (RPM only), critical agent/service status.

## Windows

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Health-Check.ps1
```

Read-only: identity, OS, drives, memory, CPU sample, listening ports, recent hotfixes, SSM agent status (if installed).

## Blog

Draft: `~/Documents/blogs/blog-ops-fundamentals/01-dual-os-runbook/blog-draft.md`

Captured example output (sanitized): `~/Documents/blogs/blog-ops-fundamentals/01-dual-os-runbook/evidence/`
