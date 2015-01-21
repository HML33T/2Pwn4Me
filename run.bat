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
set /p rc=Computer: 
echo.
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
echo Stage 2 of 3 (1/3)
copy mpg123.exe X:\rc\mp.exe >nul 2>&1
echo Stage 2 of 3 (2/3)
copy libmpg.dll X:\rc\libmpg123-0.dll >nul 2>&1
cd plugins
echo Stage 2 of 3 (3/3)
copy *.* X:\rc\plugins\*.* >nul 2>&1
cd..
echo Stage 3 of 3
copy song.mp3 X:\rc\song.mp3 >nul 2>&1
echo Complete!
echo.
echo Press any key to start the music
echo There will be some delay, please wait patiently.
echo There will be 1 pop up you can close this after the music starts.
echo.
pause
echo Changing volume on RC
psexec \\%rc% C:\rc\nircmd.exe systemvolume 100000
echo starting music
start psexec \\%rc% C:\rc\mpg123.exe C:\rc\song.mp3
pause
