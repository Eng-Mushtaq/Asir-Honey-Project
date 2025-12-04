@echo off
echo ========================================
echo   Asir Honey Marketplace
echo   Flutter Application Launcher
echo ========================================
echo.

echo [1/3] Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo ERROR: Flutter is not installed or not in PATH
    pause
    exit /b 1
)
echo.

echo [2/3] Installing dependencies...
flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

echo [3/3] Launching application...
echo.
echo Available commands during run:
echo   r - Hot reload
echo   R - Hot restart
echo   q - Quit
echo.
flutter run

pause
