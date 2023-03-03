# Check if script is running with elevated privileges (i.e., as administrator)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    Write-Host "Please right-click the file and select 'Run as administrator'."
    Read-Host -Prompt "Press Enter to exit."
    exit
}

Write-Host "Scanning your computer for corrupt files..." -ForegroundColor Yellow
Write-Host "This may take a while, please be patient." -ForegroundColor Yellow
Write-Host ""

# Run DISM to repair the Windows image
Write-Host "Running DISM scan..." -ForegroundColor Yellow
DISM.exe /Online /Cleanup-image /Restorehealth > $null
Write-Host "DISM scan completed." -ForegroundColor Green
Write-Host ""

# Run SFC to scan for corrupted system files
Write-Host "Running SFC scan..." -ForegroundColor Yellow
sfc /scannow > $null
Write-Host "SFC scan completed." -ForegroundColor Green
Write-Host ""

# Check the results and generate a report
if ($LASTEXITCODE -ne 0) {
    Write-Host "Some errors were detected and repaired." -ForegroundColor Red
    Write-Host "Please check the log file for details: $env:windir\logs\cbs\cbs.log" -ForegroundColor Red
} else {
    Write-Host "No errors were found." -ForegroundColor Green
}

Read-Host -Prompt "Press Enter to exit."
