@ECHO off
set d=/now
if not '%1.'=='.' set d=%1
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v NextPwDn /d "tsshutdn /powerdown %d%" /f
set d=
