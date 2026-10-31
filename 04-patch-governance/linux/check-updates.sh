#!/usr/bin/env bash
# List pending updates (does not install). Exit 0 always unless script error.
set -euo pipefail

echo "=== pending updates ==="
if command -v dnf >/dev/null 2>&1; then
  dnf check-update || [[ $? -eq 100 ]]
elif command -v yum >/dev/null 2>&1; then
  yum check-update || [[ $? -eq 100 ]]
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -qq
  apt-get -s upgrade | head -40
else
  echo "Unsupported distro for this helper"
  exit 1
fi

echo ""
echo "=== reboot required? (RHEL-family) ==="
if command -v needs-restarting >/dev/null 2>&1; then
  # Exit 0 = reboot NOT required; exit 1 = reboot required (dnf-utils)
  if needs-restarting -r >/dev/null 2>&1; then
    echo "Reboot not required"
  else
    rc=$?
    if [[ "$rc" -eq 1 ]]; then
      echo "Reboot required"
    else
      echo "needs-restarting returned unexpected exit $rc — check manually"
    fi
  fi
else
  echo "needs-restarting not installed — check kernel vs running version manually"
fi
