# Inventory-style update status (does not install updates).
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

Write-Output '=== installed hotfixes (recent) ==='
Get-HotFix -ErrorAction SilentlyContinue |
    Sort-Object InstalledOn -Descending |
    Select-Object -First 15 HotFixID, InstalledOn, Description |
    Format-Table -AutoSize

Write-Output '=== Windows Update service ==='
Get-Service -Name wuauserv -ErrorAction SilentlyContinue |
    Select-Object Status, StartType, Name |
    Format-List

Write-Output '=== note ==='
Write-Output 'Pending update scan in enterprises usually runs via WSUS, Intune, Azure Update Manager, or SSM Patch Manager — not ad hoc on production without a change record.'
