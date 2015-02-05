@echo off
REM @reg add HKLM\SYSTEM\CurrentControlSet\Services\Cdrom                     /v "AutoRun"            /t REG_DWORD /f /d 00
@reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v "NoDriveTypeAutoRun" /t REG_DWORD /f /d 255
@reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v "NoDriveTypeAutoRun" /t REG_DWORD /f /d 255

REM @pause
