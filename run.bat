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
net use x: /delete >nul 2>&1  ::Unmount x: drive, as we'll need to mount it to SMB and we can't if it's premounted.
if %errorlevel% == 0 ( 
		echo Succesful!
	) else (
		echo Failed! Drive was not mounted?
	)
echo Mounting remove comuter's (rc) harddrive (\\RC\c$) to x:
net use x: \\%rc%\c$ >nul 2>&1 ::Make a connection to the smb server and mounts it's C drive as drive X:
if %errorlevel% == 0 ( ::Check if it was succesful as it is needed!
		echo Mount succesful!
	) else (
		echo Mount failed, aborting! ::Aborting as it will not work without the mount
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
copy nircmd.exe X:\rc\ncmd.exe  >nul 2>&1 ::Needed for volume controls
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!) ::Copying files no aborts here as it could be because of a overwrite issue, which is non critical
echo Stage 2 of 3 (1/3)
copy mpg123.exe X:\rc\mp.exe >nul 2>&1 ::Audio player exe
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
echo Stage 2 of 3 (2/3)
copy *.dll X:\rc\*.dll >nul 2>&1 ::Audio player dll files
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
cd plugins
echo Stage 2 of 3 (3/3)
copy *.* X:\rc\plugins\*.* >nul 2>&1 ::More audio player dll files
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
cd..
echo Stage 3 of 3
copy song.mp3 X:\rc\song.mp3 >nul 2>&1 ::The song to be used!
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!)
echo Complete! ::This prosses shouldn't take longer than 10 seconds, unless your song is really long!
echo.
echo Press any key to start the music
echo There will be some delay, please wait patiently.
echo There will be 1 pop up you can close this after the music starts.
echo.
pause
echo Unmuting volume on RC
psexec \\%rc% C:\rc\ncmd.exe mutesysvolume 0 ::Using PsExec to remotly unmute the volume (if it was muted)
echo Setting volume on RC
psexec \\%rc% C:\rc\ncmd.exe setsysvolume 65535 ::Using PsExec to remoltly turn up the volume completly
echo Starting music... This will stay here until it's finished!
psexec \\%rc% C:\rc\mp.exe C:\rc\song.mp3 ::Actualy playing the song!
pause
