Set objWMIService = GetObject("winmgmts:{(Shutdown)}")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For Each objOperatingSystem in colOperatingSystems
    ObjOperatingSystem.Reboot()
Next
