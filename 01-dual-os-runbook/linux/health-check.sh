#!/usr/bin/env bash
# Read-only host health snapshot for Linux (RHEL-family, Debian-family, Amazon Linux).
set -euo pipefail

section() { printf '\n=== %s ===\n' "$1"; }

section "identity"
whoami
hostname -f 2>/dev/null || hostname
if [[ -f /etc/os-release ]]; then
  grep -E '^(NAME|VERSION|ID)= ' /etc/os-release || true
else
  uname -a
fi

section "disk"
df -h

section "memory"
if command -v free >/dev/null 2>&1; then
  free -h
else
  echo "free(1) not available"
fi

section "load"
uptime
if command -v nproc >/dev/null 2>&1; then
  nproc
fi

section "ports (listening)"
if command -v ss >/dev/null 2>&1; then
  ss -tulpn 2>/dev/null | head -25 || ss -tuln | head -25
elif command -v netstat >/dev/null 2>&1; then
  netstat -tulpn 2>/dev/null | head -25 || netstat -tuln | head -25
else
  echo "Neither ss nor netstat found"
fi

section "pending updates"
if command -v dnf >/dev/null 2>&1; then
  sudo -n dnf check-update 2>&1 | head -20 || dnf check-update 2>&1 | head -20 || true
elif command -v yum >/dev/null 2>&1; then
  sudo -n yum check-update 2>&1 | head -20 || true
elif command -v apt-get >/dev/null 2>&1; then
  apt-get -s upgrade 2>/dev/null | head -20 || true
else
  echo "No supported package manager detected"
fi

section "recent packages (RPM)"
if command -v rpm >/dev/null 2>&1; then
  rpm -qa --last | head -10
else
  echo "rpm not available (non-RPM distro)"
fi

section "management agent"
for svc in amazon-ssm-agent amazon-ssm-agent.service; do
  if systemctl is-active "$svc" >/dev/null 2>&1; then
    systemctl is-active "$svc"
    break
  fi
done || true
