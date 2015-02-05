@echo off
REM @reg add HKLM\SYSTEM\CurrentControlSet\Services\Cdrom /v "AutoRun" /t REG_DWORD /f /d 1
@reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v "NoDriveTypeAutoRun" /t REG_DWORD /f /d 95
@reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v "NoDriveTypeAutoRun" /t REG_DWORD /f /d 95

REM @pause

REM NoDriveTypeAutoRun:
REM 0x1  (1)   Disables Autoplay on drives of unknown type.
REM 0x4  (4)   Disables Autoplay on removable drives.
REM 0x8  (8)   Disables Autoplay on fixed drives.
REM 0x10 (16)  Disables Autoplay on network drives.
REM 0x20 (32)  Disables Autoplay on CD-ROM drives.
REM 0x40 (64)  Disables Autoplay on RAM disks.
REM 0x80 (128) Disables Autoplay on drives of unknown type.
REM 0xFF (255) Disables Autoplay on all types of drives.
