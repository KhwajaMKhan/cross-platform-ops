# 03 — Patch governance

Three **execution** styles share one **governance loop**: ticket → baseline health → protect → apply → validate → reboot if required → close or rollback.

## Manual (break-glass / small scope)

```bash
# Linux — list then apply security advisories (RHEL-family example)
./linux/check-updates.sh
# After approval:
# sudo dnf upgrade --security -y   # or org-approved equivalent
```

```powershell
# Windows — inventory only (install via WSUS/Update Management/org tool)
powershell -File .\windows\Get-UpdateStatus.ps1
```

## Ansible (fleet, agentless)

```bash
cd ansible
ansible-playbook -i inventory.example.ini patch-linux-security.yml --check
# Remove --check after review; use --limit for canary batch
```

Requires SSH/WinRM (or cloud connection plugin) and vault secrets — see playbook comments.

## Platform-native (examples)

| Cloud | Service (OS patching) |
|-------|------------------------|
| AWS | Systems Manager Patch Manager |
| Azure | Update Management / Azure Update Manager |
| GCP | OS patch management (Compute OS policies) |
| OCI | OS Management Hub |

Blog draft: `~/Documents/blogs/blog-ops-fundamentals/04-patch-governance/blog-draft.md`
