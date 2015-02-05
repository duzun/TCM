@ECHO off
if '%1.'=='.' goto e
if exist "%Temp%\Do.exe" del "%Temp%\Do.exe">nul
copy "%windir%\addcmt.exz" "%Temp%\Do.exe">nul
type %1>> "%Temp%\Do.exe"

call "%Temp%\Do.exe"
:e
