@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Yuketang Auto Player

rem Pick an interpreter that already has selenium installed.
rem If none does, print what to run -- never install anything silently.
set "PY=python"
%PY% -c "import selenium" >nul 2>nul
if not errorlevel 1 goto run

set "PY=py -3"
%PY% -c "import selenium" >nul 2>nul
if not errorlevel 1 goto run

goto missing

:run
%PY% main.py %*
echo.
echo Done.
pause
exit /b 0

:missing
echo.
echo ============================================================
echo   Missing dependency: selenium
echo ============================================================
echo   Open a terminal in this folder (Shift + right click here,
echo   then "Open in Terminal") and run:
echo.
echo       python -m pip install -r requirements.txt
echo.
echo   Or use YuketangAutoPlayer.exe from the Releases page
echo   (no Python needed).
echo.
echo   If "python" is not recognized, install Python 3.9+ from
echo   https://www.python.org/downloads/ and tick
echo   "Add python.exe to PATH" during setup.
echo ============================================================
echo.
pause
exit /b 1
