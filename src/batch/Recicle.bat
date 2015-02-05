@ECHO off
set recicledfile=%userprofile%\Recicle.bin
set recicledcomp=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}
set recicleddesk=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}

@call reg query %recicleddesk% /v "@" > nul
cls
if errorlevel 1 goto back
REM if exist "%recicledfile%" goto back

:del
call reg add %recicledcomp% /v @ /d "Recicle bin" /f>nul
call reg delete %recicleddesk% /f>nul
echo Search your "Recicle bin" in "My Computer" >"%recicledfile%"
echo My Computer: Recicled
goto end


:back
call reg add %recicleddesk% /v @ /d "Recicle bin" /f>nul
call reg delete %recicledcomp% /f>nul
del "%recicledfile%"
echo Desktop: Recicled
goto end


:end
set recicledfile=
set recicledcomp=
set recicleddesk=

pause>nul

if not '%cd%'=='%windir%' copy "%0" "%windir%">nul
