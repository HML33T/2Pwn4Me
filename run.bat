@echo off
:freboot
if EXIST song.mp3 goto begin
echo NO SONG FOUND! (Note: all .mp3's in the work dir will be removed before download!)
echo.
echo Youtube URL for music:
set /p yturl=
del *.mp3
youtube-dl --extract-audio --audio-format mp3 %yturl%
rename *.mp3 song.mp3
goto freboot
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
echo Stage 1 of 3 (1/2)
copy nircmd.exe X:\rc\ncmd.exe  >nul 2>&1 
if %errorlevel% == 0 (echo Copy succesful) else (echo Failed to copy file!) 
echo Stage 1 of 3 (2/2)
copy files\remote.bat X:\rc\remote.bat
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
psexec \\%rc% C:\rc\remote.bat
pause
goto begin
