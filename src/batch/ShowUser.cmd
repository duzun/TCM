@ECHO off

if '%1.'=='.' goto _error

set _user=%1
set _key=HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList
set _value=1

reg ADD "%_key%" /v %_user% /d %_value% /t REG_DWORD /f
goto _end

:_error
Echo.
Echo You must specify a valid user name!
Echo.
Echo Be carefull! Do not hide all the users!!!
echo.
pause

:_end
