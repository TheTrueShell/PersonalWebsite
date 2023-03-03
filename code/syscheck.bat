@echo off

REM Check if script is running with elevated privileges (i.e., as administrator)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as an administrator.
    echo Please right-click the file and select "Run as administrator".
    pause
    exit /b
)

echo Scanning your computer for corrupt files...
echo This may take a while, please be patient.
echo.

REM Run DISM to repair the Windows image
DISM.exe /Online /Cleanup-image /Restorehealth >nul
echo DISM scan completed.

REM Run SFC to scan for corrupted system files
echo.
sfc /scannow >nul
echo SFC scan completed.

echo.

REM Check the results and generate a report
if %errorlevel% neq 0 (
    echo Some errors were detected and repaired.
    echo Please check the log file for details: %windir%\logs\cbs\cbs.log
) else (
    echo No errors were found.
)

pause
