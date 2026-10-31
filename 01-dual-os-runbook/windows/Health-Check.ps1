# Read-only host health snapshot for Windows Server / Windows client.
#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

function Write-Section($Name) {
    Write-Output ""
    Write-Output "=== $Name ==="
}

Write-Section 'identity'
whoami
hostname
Get-ComputerInfo -Property CsName, OsName, OsVersion | Format-List

Write-Section 'disk'
Get-PSDrive -PSProvider FileSystem | Format-Table -AutoSize

Write-Section 'memory'
$os = Get-CimInstance Win32_OperatingSystem
[PSCustomObject]@{
    TotalVisibleMemoryMB = [math]::Round($os.TotalVisibleMemorySize / 1024, 1)
    FreePhysicalMemoryMB = [math]::Round($os.FreePhysicalMemory / 1024, 1)
} | Format-List

Write-Section 'cpu (sample)'
Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage | ForEach-Object {
    [PSCustomObject]@{ LoadPercentage = $_ } | Format-List
}

Write-Section 'ports (listening)'
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
    Select-Object -First 20 LocalAddress, LocalPort, State |
    Format-Table -AutoSize

Write-Section 'installed updates (recent)'
Get-HotFix -ErrorAction SilentlyContinue |
    Sort-Object InstalledOn -Descending |
    Select-Object -First 10 HotFixID, InstalledOn |
    Format-Table -AutoSize

Write-Section 'management agent'
$ssm = Get-Service -Name AmazonSSMAgent -ErrorAction SilentlyContinue
if ($ssm) {
    $ssm | Select-Object Status, Name | Format-List
} else {
    Write-Output 'AmazonSSMAgent service not installed'
}
