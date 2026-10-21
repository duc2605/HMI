@echo off
setlocal
powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0Tools\AutoSync.ps1" -Mode Remove
if errorlevel 1 pause
