# Pre-change backup checklist

Use this **before** OS patches, package upgrades, disk changes, or config pushes.

## 1. Define recovery targets

- [ ] **RPO** (how much data loss is acceptable) documented for this system tier
- [ ] **RTO** (how fast must service return) documented
- [ ] Owner / on-call contact for go/no-go

## 2. Choose the right protection (not “snapshot only”)

- [ ] **Application-consistent** backup for databases (native backup + logs), if applicable
- [ ] **Crash-consistent** snapshot acceptable only when rebuild path is proven
- [ ] **Retention** tag or policy matches change ticket ID
- [ ] **Off-account / immutable** copy for tier-0 systems (where org policy requires it)

## 3. Capture point-in-time

- [ ] Block snapshot / VM snapshot / array snapshot **or** verified backup job completed successfully
- [ ] Snapshot/backup **time and ID** recorded in change ticket
- [ ] No silent overwrite of last known-good — create **new** recovery point

## 4. Validate you can restore (periodic; spot-check before risky changes)

- [ ] Last restore drill within policy window **or** explicit exception approved
- [ ] Runbook says restore to **new** resource, validate, then cut over

## 5. Rollback trigger

- [ ] Defined failure signals (health check, error rate, data check)
- [ ] Rollback steps: revert package → restore snapshot/backup → DNS/LB failback
