# 02 — Identity and access (not “open port 22”)

**Authentication** proves *who* you are. **Network rules** limit *where* packets may flow. Confusing the two leads to `0.0.0.0/0` on SSH, RDP, or WinRM.

## Preferred pattern

1. Human or automation assumes a **role** (cloud IAM, Entra ID, LDAP/Kerberos, PAM).
2. Access **broker** connects to the host (agent, bastion, or private endpoint) — often **outbound** from the host.
3. **Session** is logged; standing shared passwords avoided.

## Platform examples (same idea)

| Environment | Broker / path | Identity |
|-------------|---------------|----------|
| AWS | SSM Session Manager, EC2 Instance Connect | IAM |
| Azure | Bastion, Run Command, Arc | Entra ID / RBAC |
| GCP | IAP TCP forwarding, OS Login | Google identity / IAM |
| OCI | Bastion service | OCI IAM |
| On-premises | Jump host + PAM | AD / LDAP + MFA |

## Scripts

This folder is **documentation-first**. Operational scripts live in `01-dual-os-runbook/` (health) and `04-patch-governance/` (patch inventory).

Blog draft: `~/Documents/blogs/blog-ops-fundamentals/02-identity-access/blog-draft.md`
