@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Source\Prepare-Portable.ps1"
if errorlevel 1 (
  echo.
  echo Tao bo chay chua thanh cong. Hay gui noi dung loi phia tren.
  pause
  exit /b 1
)
echo.
echo Xong. Tu lan sau chi can bam ChayDuAn.exe.
pause
