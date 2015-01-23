@echo off
:begin
cls
echo  ____    ___                 _  _               
echo ^|___ \  / _ \__      ___ __ ^| ^|^| ^|   /\/\   ___ 
echo   __) ^|/ /_)/\ \ /\ / / '_ \^| ^|^| ^|_ /    \ / _ \
echo  / __// ___/  \ V  V /^| ^| ^| ^|__   _/ /\/\ \  __/
echo ^|_____\/       \_/\_/ ^|_^| ^|_^|  ^|_^| \/    \/\___^|
echo.
echo Play music on remote computers!
echo.
if %1 == /stop echo Stop music on
set /p rc=Computer: 
echo.
if %1 == /stop goto stop
echo Removing previous mounts to x:
net use x: /delete >nul 2>&1  
if %errorlevel% == 0 ( 
		echo Succesful!
	) else (
		echo Failed! Drive was not mounted?
	)
echo Mounting remove comuter's (rc) harddrive (\\RC\c$) to x:
net use x: \\%rc%\c$ >nul 2>&1 
if %errorlevel% == 0 ( 
		echo Mount succesful!
	) else ( 
		echo Mount failed, aborting!
		pause
		goto begin
	)
echo Creating folders in RC
X:
mkdir rc
cd rc
mkdir plugins
C:
echo Copying required files to RC...
echo Stage 1 of 3
copy nircmd.exe X:\rc\ncmd.exe  >nul 2>&1 
::Needed for volume controls
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!) 
echo Stage 2 of 3 (1/3)
copy mpg123.exe X:\rc\mp.exe >nul 2>&1 
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
echo Stage 2 of 3 (2/3)
copy *.dll X:\rc\*.dll >nul 2>&1 
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
cd plugins
echo Stage 2 of 3 (3/3)
copy *.* X:\rc\plugins\*.* >nul 2>&1 
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
cd..
echo Stage 3 of 3
copy song.mp3 X:\rc\song.mp3 >nul 2>&1 
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
echo Complete! 
echo.
echo Press any key to start the music
echo There will be some delay, please wait patiently.
echo There will be 1 pop up you can close this after the music starts.
echo.
pause
echo Unmuting volume on RC
psexec \\%rc% C:\rc\ncmd.exe mutesysvolume 0 
echo Setting volume on RC
psexec \\%rc% C:\rc\ncmd.exe setsysvolume 65535 
echo Starting music... This will stay here until it's finished!
psexec \\%rc% C:\rc\mp.exe C:\rc\song.mp3 
pause
goto begin
:stop
echo Connecting to RC to stop audio
psexec \\%rc% TASKKILL /im mp.exe /f
echo Complete!
pause
goto begin
