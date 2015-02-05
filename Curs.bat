@Echo off
set cur=%1
if "%cur%."=="." set cur=%%windir%%\Cursors\Pointer.cur
reg add "HKCU\Control Panel\Cursors" /v Arrow /d %cur% /f
If not errorlevel 1 goto e
Echo.
Echo Error!
Pause>nul
:e
set cur=