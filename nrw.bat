@ECHO off
Echo.
if '%1.'=='.' goto e
if '%deftime%.'=='.' set deftime=3
:l
if not exist .\%1 goto else
if '%ans%'=='all' goto skall
if exist ..\%1 if '%ans%.'=='.' goto ask
if not '%ans%'=='skip' copy %1 ..\.>nul
shift
set ans=
if not '%1.'=='.' goto l
goto e

:skall
if not exist .\%1 goto else
if not exist ..\%1 copy %1 ..\.>nul
shift
if not '%1.'=='.' goto skall
goto e

:ask
choice /n /c:aos /t:s,%deftime% %1 already exists: S(kip), O(verwrite), A(ll skip)
if errorlevel 3 set ans=skip
if not errorlevel 3 if errorlevel 2 set ans=over
if not errorlevel 2 if errorlevel 1 set ans=all
goto l

:else
shift
if '%0'=='/a' set ans=all
if '%0'=='/A' set ans=all
if '%0'=='/s' set ans=skip
if '%0'=='/S' set ans=skip
if '%0'=='/o' set ans=over
if '%0'=='/O' set ans=over
if not '%1.'=='.' goto l

:e
set ans=
set deftime=
