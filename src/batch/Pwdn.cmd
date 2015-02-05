@echo off
if not '%1'=='' goto do

set /p choice="Doresti sa deconectezi computerul (D/N)?  "
if not '%choice%'=='' set choice=%choice:~0,1%
if not '%choice%'=='d' if not '%choice%'=='D' goto end
REM choice /c:dn /t:d,30  
REM if errorlevel 2 goto end

:do
set d=%1
if '%d%'=='' set d=/now
set downcmd=%systemroot%\system32\tsshutdn.exe
if not exist "%downcmd%" set downcmd=%systemroot%\tsshutdn.exe
if not exist "%downcmd%" set downcmd=tsshutdn.exe

%downcmd% /powerdown %d%
:end
