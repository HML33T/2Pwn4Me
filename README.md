# 2Pwn4Me
Plays music on a remote PC (Active Directory and SMB required!)

This tool uses the followig programs:
----
 - PsExec (Microsoft)
 - mpg123
 - nircmd

How it Works:
----
1. We make an SMB connection to the remote computer<br>
2. We copy a mp3, mpg123 (cmd line mp3 player) and nircmd to the remote computer<br>
3. We make a remote shell connection to the remote computer using PsExec<br>
4. We use the remote shell to turn the volume to max with NirCMD (Which we put on the remote computer in step 2)<br>
5. We now use mpg123 to play the music<br>

How to stop?
----
Currently the tool does not allow to do this remotly, you can however connect to the remote computer yourself with "PsExec \\remotecomputername cmd", wait for it to start and when your on the remote shell use: "TASKKILL /im mp.exe /f"<br>
On the remote computer itself, you'll either have to run the TASKKILL command from above, or turn off the computer. You could also turn down the volume, though that wouldn't stop the music from playing you wouldn't be able to hear it anymore.

Credits:
----
- MrJPGames
- Microsoft (for PsExec)
- NirSoft (for NirCMD)
- http://www.mpg123.de/ (mpg123)
