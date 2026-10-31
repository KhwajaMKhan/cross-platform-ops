# 02 — Backups vs snapshots

A **snapshot** (disk/array/VM point-in-time) is one **tool**. A **backup strategy** adds retention, scope, off-site/immutable copies, and **tested restore**.

## Checklist

Use [`checklists/pre-change-backup.md`](checklists/pre-change-backup.md) before maintenance, patching, or migrations.

## Platform mapping (names only)

| Layer | AWS | Azure | GCP | OCI | On-premises |
|-------|-----|-------|-----|-----|-------------|
| Block snapshot | EBS snapshot | Managed disk snapshot | Persistent disk snapshot | Block volume backup | Storage LUN / hypervisor snapshot |
| Image / template | AMI | Shared image gallery | Machine image | Custom image | VM template / golden image |
| File / app backup | AWS Backup, 3rd party | Azure Backup | Backup and DR | Object Storage + agent | Veeam, Commvault, native DB backup |
| Restore discipline | New volume/instance first | Restore to new disk/VM | New disk/VM | New volume/instance | Isolated restore VLAN |

Blog draft: `~/Documents/blogs/blog-ops-fundamentals/03-backups-vs-snapshots/blog-draft.md`
