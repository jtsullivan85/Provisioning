@echo off
set "username=username to access network share"
set "password=password for user"
set "network_path=\\server\share\"
set "local_path=C:\welcome"
set "log_path=\\server\share\logs"

for /f "tokens=2 delims==" %%a in ('wmic bios get serialnumber /value') do set "serial=%%a"
echo Log file > "%log_path%\%serial%.log"

net use "%network_path%" /user:%username% %password% || echo %DATE% %TIME%: Failed to authenticate with network share >> "%log_path%\%serial%.log" && exit /b
echo %DATE% %TIME%: Connected to network share >> %log_path%\%serial%.log

echo %DATE% %TIME%: Making directory C:\welcome >> %log_path%\%serial%.log
mkdir "%local_path%" || echo %DATE% %TIME%: Failed to create directory >> "%log_path%\%serial%.log" && exit /b

echo %DATE% %TIME%: Starting download from network >> %log_path%\%serial%.log
xcopy /E /I "%network_path%" "%local_path%" >> %log_path%\%serial%.log 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME%: Download failed with error code %ERRORLEVEL% >> %log_path%\%serial%.log
) ELSE (
    echo %DATE% %TIME%: Download completed successfully >> %log_path%\%serial%.log
)


echo %DATE% %TIME%: Installing Printer Suite C >> %log_path%\%serial%.log
C:\welcome\printer\install.exe /sm*addPrinterIpHere* /q /n"Suite C (Corporate)" /gcfm"C:\welcome\printer\config\hpcpu270.cfm" >> %log_path%\%serial%.log 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME%: Installing Printer Suite C failed with error code %ERRORLEVEL% >> %log_path%\%serial%.log
) ELSE (
    echo %DATE% %TIME%: Printers installed successfully >> %log_path%\%serial%.log
)

echo %DATE% %TIME%: Installing Printer Suite D >> %log_path%\%serial%.log
C:\welcome\printer\install.exe /sm*addPrinterIpHere* /q /n"Suite D (Accounting)" /gcfm"C:\welcome\printer\config\hpcpu270.cfm" >> %log_path%\%serial%.log 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME%: Installing Printer Suite C failed with error code %ERRORLEVEL% >> %log_path%\%serial%.log
) ELSE (
    echo %DATE% %TIME%: Printers installed successfully >> %log_path%\%serial%.log
)

echo %DATE% %TIME%: Installing Office >> %log_path%\%serial%.log
C:\welcome\setup.exe /configure C:\welcome\configuration.xml >> %log_path%\%serial%.log 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME%: Installing Office failed with error code %ERRORLEVEL% >> %log_path%\%serial%.log
) ELSE (
    echo %DATE% %TIME%: Office installed successfully >> %log_path%\%serial%.log
)

echo %DATE% %TIME%: Installing Datto >> %log_path%\%serial%.log
C:\welcome\AgentSetup_DATTO.exe /S >> %log_path%\%serial%.log 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME%: Installing Datto failed with error code %ERRORLEVEL% >> %log_path%\%serial%.log
) ELSE (
    echo %DATE% %TIME%: Datto installed successfully >> %log_path%\%serial%.log
)

echo %DATE% %TIME%: Copying provisioning logs >> %log_path%\%serial%.log
xcopy /E /I "C:\$SysReset" "\\server\share\logs\provisioning" 

echo %DATE% %TIME%: Finished running script >> %log_path%\%serial%.log