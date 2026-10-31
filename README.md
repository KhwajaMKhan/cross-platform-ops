# Cross-Platform Ops Fundamentals

**Open source (MIT).** Small, reusable scripts and playbooks for the same operational problems on **Linux and Windows** — in the cloud (AWS, Azure, GCP, OCI) or on-premises.

This repo is the **companion lab** for a five-part blog series (drafts under `~/Documents/blogs/blog-ops-fundamentals/` — not committed here).

| Folder | Topic |
|--------|--------|
| [`00-provision-lab/`](00-provision-lab/) | Optional Terraform / Multipass for Linux + Windows test hosts |
| [`01-dual-os-runbook/`](01-dual-os-runbook/) | Parallel health checks for the same incident |
| [`02-identity-access/`](02-identity-access/) | Access patterns — identity first, not wide admin ports |
| [`03-backups-vs-snapshots/`](03-backups-vs-snapshots/) | Pre-change backup checklist (policy vs point-in-time copy) |
| [`04-patch-governance/`](04-patch-governance/) | Patch baseline scripts + Ansible sketch |

Blog **#5** (backups at TB/PB scale) is draft-only in the blogs folder.

## Requirements

- **Linux:** bash, common userland (`df`, `free`, `ss` or `netstat`, `systemd` or `service`).
- **Windows:** PowerShell 5.1+ (Server 2016+) or PowerShell 7.
- **Ansible (optional):** Ansible 2.14+ for `04-patch-governance/ansible/`.
- **Terraform (optional):** >= 1.4 for `00-provision-lab/`.

## Quick start

```bash
# Optional lab (pick one): 00-provision-lab/aws | azure | gcp — or multipass for local Linux
cd 00-provision-lab/aws && terraform init && terraform apply

cd 01-dual-os-runbook/linux && chmod +x health-check.sh && ./health-check.sh
powershell -NoProfile -ExecutionPolicy Bypass -File 01-dual-os-runbook/windows/Health-Check.ps1
```

## Verify scripts locally

```bash
bash -n 01-dual-os-runbook/linux/health-check.sh
bash -n 04-patch-governance/linux/check-updates.sh
```

## License

MIT — see [LICENSE](LICENSE).
