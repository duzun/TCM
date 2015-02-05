Set objWMIService = GetObject("winmgmts:{(Shutdown)}")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For Each objOperatingSystem in colOperatingSystems
    ObjOperatingSystem.Win32Shutdown(1)
Next
