@echo off
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Running with administrative privileges
    goto :run
) else (
    echo Requesting administrative privileges...
    goto :elevate
)

:elevate
powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb runAs" >nul 2>&1
exit /b

:run
for /f "tokens=2 delims= " %%a in ('tasklist ^| find /i "wslservice"') do (
    echo Found wslservice running with PID %%a. Terminating...
    taskkill /f /pid %%a
)
echo Done.
exit
