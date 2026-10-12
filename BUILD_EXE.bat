@echo off
setlocal
cd /d "%~dp0"
title KONE Elevator - build one-file EXE

echo [1/5] Checking Python 3.13...
py -3.13 -V >nul 2>&1
if errorlevel 1 goto :nopython

echo [2/5] Installing/updating build packages...
py -3.13 -m pip install -r requirements.txt
if errorlevel 1 goto :fail

echo [3/5] Building one-file desktop application...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist KONE_Elevator.spec del /q KONE_Elevator.spec
py -3.13 -m PyInstaller --noconfirm --clean --onefile --windowed --name KONE_Elevator --icon app.ico --add-data "web;web" --collect-all webview app.py
if errorlevel 1 goto :fail
if not exist "dist\KONE_Elevator.exe" goto :fail

echo [4/5] Creating download ZIP...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path 'dist\KONE_Elevator.exe' -DestinationPath 'dist\KONE_Elevator_Windows.zip' -Force"
if errorlevel 1 goto :fail

echo [5/5] SUCCESS
echo.
echo EXE: %CD%\dist\KONE_Elevator.exe
echo ZIP: %CD%\dist\KONE_Elevator_Windows.zip
echo The EXE can be moved and run by itself.
start "" explorer.exe "%CD%\dist"
pause
exit /b 0

:nopython
echo ERROR: Python 3.13 is not installed.
echo Run: py install 3.13
pause
exit /b 1

:fail
echo.
echo ERROR: EXE was not created. Read the messages above.
pause
exit /b 1
