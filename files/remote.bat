echo Unmuting volume on RC
C:\rc\ncmd.exe mutesysvolume 0 
echo Setting volume on RC
C:\rc\ncmd.exe setsysvolume 65535 
echo Starting music... This will stay here until it's finished!
C:\rc\mp.exe C:\rc\song.mp3 