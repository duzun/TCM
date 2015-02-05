@rem Author: DUzun
@rem Web:    www.duzun.teologie.net
@echo off
cls

if not exist "%windir%\TPlayer.%Username%.xml" copy /Y "%windir%\TPlayer.xml" "%windir%\TPlayer.%Username%.xml">nul

set TParam=
:par
set TParam=%TParam% %1
shift
if not "%1."=="." goto par

start TPlayer.exe %TParam%

set TParam=
exit
