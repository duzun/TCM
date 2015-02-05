@Echo off
set e=%1
if not 'x%1'=='x' goto do
choice /c:dn /t:n,30 Doresti sa restartezi computerul 
if errorlevel 2 goto end
set e=0
:do
shutdown -r -f -t %e% -c "This computer will restart soon!                Acest computer se va restarta curand!"
if not '%e%'=='0' (
Echo.
Echo Press any key to cancel restarting of the computer!
echo.
echo Apasa orice tasta pentru a anula restartarea computerului!
pause > nul
shutdown -a)
:end
set e=