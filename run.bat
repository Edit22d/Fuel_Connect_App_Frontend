@echo off
echo ========================================
echo Fuel Connect App Launcher
echo ========================================
echo.
echo Checking for process using port 5000...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":5000" ^| find "LISTENING"') do (
    echo Found process %%a using port 5000. Killing it...
    taskkill /F /PID %%a 2>nul
)
echo.
echo Starting Flutter on port 5000...
echo.
flutter run -d chrome --web-port=5000