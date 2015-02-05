@echo off
SET Home=%CD%
set Prm_1_8_9=
:p
if '%1'=='/alt' (
  set alt=%2
  shift
  shift
)
if '%1.'=='.' goto h
set Prm_1_8_9=%Prm_1_8_9% %1
shift
goto p

:h
if exist "%tcm%" goto tcm

  Rem Determinarea HomePath
set TcmDir="
for %%n in (%Home%,\Tcm,\TotalCmd,C:\Tcm,C:\TotalCmd,%ProgramFiles%\TotalCmd,%ProgramFiles%\Tcm,%WinDir%\Tcm,%WinDir%)do (
  if exist "%%n\Totalcmd.exe" Set TcmDir="%%n\
)

if '%TcmDir%"'=='""' if not '%alt%.'=='.' (
  %alt%
  goto e
)

if exist "%Home%\Tcm.do" (
   type "%Home%\Tcm.do">"%temp%\T~dir.bat"
   call "%temp%\T~dir.bat"
)

del "%temp%\T~dir.bat"

set Tcm=%TcmDir%TotalCmd.exe"

:tcm
path=%path%;%TcmDir%

if not exist %TcmDir%Tcm_Prof\nul"            md %TcmDir%Tcm_Prof"
if not exist %TcmDir%Tcm_Prof\%username%\nul" md %TcmDir%Tcm_Prof\%username%"

for %%n in (wcx_ftp.ini wincmd.ini utcm.ini Sys.bar DEFAULT.BAR RebooterConfig.ini)do (
 if not exist %TcmDir%Tcm_Prof\%%n"            copy %TcmDir%\%%n" %TcmDir%Tcm_Prof\">nul
 if not exist %TcmDir%Tcm_Prof\%username%\%%n" copy %TcmDir%Tcm_Prof\%%n" %TcmDir%Tcm_Prof\%username%\">nul )

cd %TcmDir%Tcm_Prof\%username%"
if not exist %TcmDir%Tcm_Prof\%username%\utcm.ini" copy "%TcmDir%Tcm_Prof\%username%\wincmd.ini" %TcmDir%Tcm_Prof\%username%\utcm.ini" > nul
del *.br1

start "DUzunSys" %Tcm% /i=%TcmDir%Tcm_Prof\%username%\utcm.ini" /f=%TcmDir%Tcm_Prof\%username%\wcx_ftp.ini" %Prm_1_8_9%

:e
set Prm_1_8_9=
set alt=

