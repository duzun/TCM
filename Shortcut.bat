@ECHO off
if '%1.'=='.' goto e
if '%instdir%.'=='.' set instdir=%%windir%%
set params=
:l
set params=%params%%1,
shift
if '%1.'=='.' goto sh
goto l
:sh
copy "%Windir%\addcmt.exz" "%Temp%\Short.exe">nul
type "%Windir%\HdShort.cmt" >> "%Temp%\Short.exe"
echo %params%>>"%Temp%\Short.exe"
echo path=%instdir%>>"%Temp%\Short.exe"
call "%Temp%\Short.exe"

rem del "%Temp%\Short.exe">nul

:e
set params=