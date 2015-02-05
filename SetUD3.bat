@ECHO off
cd %windir%
Echo.
Echo Installing UD3Pack...  Please, be patient!
Echo===========================================
Echo.
if '%ans%'=='all' goto auto
if not "%1"=="ask" goto auto
Echo How to install UD3Pack?
choice /n /c:asc /t:a,20 A(utomaticaly); S(tep by step); C(ancel) 
if errorlevel 3 goto e
if not errorlevel 2 set ans=all
if '%ans%'=='all' goto auto

cd temp

call nrw.bat /a WinCmd.key Wa.m3u Wa.ini DTEMP.EXE reg.exe BSA.INI vc.ini volume.exe wheel.dll

Echo.
choice /c:yn /t:y,10 Add information to the registry
if not errorlevel 2 start regedit /s UD3.reg>nul

cd..
Echo.
choice /c:yn /t:y,10 Create Start Menu group
if not errorlevel 2 start DoCmt Prog.cmt

Echo.
choice /c:yn /t:y,10 Create Quick Lunch group
if not errorlevel 2 start DoCmt Quick.cmt 

Echo.
choice /c:yn /t:n,10 Start "Total Commander" when windows starts
if not errorlevel 2 start ShortCut T tcm.exe "" "" "TotalCMD.lnk"

call ShortCut T, "volume", "", "", "VolumeCtrl"

goto e

:auto
cd temp
call nrw.bat /a  Wa.m3u Wa.ini BSA.INI vc.ini
start regedit /s UD3.reg>nul
cd..

start /B reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v TCM /d "TCM.exe /min" /f
start /B reg add HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunOnce /v _UD3_Prog  /d """"DoCmt %SystemRoot%\Prog.cmt"""" /f
start /B reg add HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunOnce /v _UD3_Quick /d """"DoCmt %SystemRoot%\Quick.cmt"""" /f

start /wait DoCmt Prog.cmt
start /wait DoCmt Quick.cmt 
start volume.sfx.exe

REM call ShortCut T, "tcm", "", "", "Total Commander"


:e
if exist "%windir%\TPlayer.xml" copy /Y "%windir%\TPlayer.xml" "%windir%\TPlayer.%Username%.xml"

rem call start tcm
set ans=

if '%ans%'=='all' del %0>nul
