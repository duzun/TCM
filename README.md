# TCM

A collection of useful tools for every day use in Windows environment, built around Total Commander.

You have to launch `TCM.exe` instead of `TotalCmd.exe`.

`TCM.exe` is a [Total Commander](http://www.ghisler.com/) launcher, which prepares the environment and settings files to start [Total Commander](http://www.ghisler.com/) with your toolbars and settings.

It supports multi-user environment by makeing a copy of user settings (from `TCM_Prof\` or `%COMMANDER_PATH%`) in `%APPDATA%\TCM\` and passing them to `TotalCmd.exe` on launch.

`TCM.exe` also copies itself to `%WinDir%`, so that it can be launched from command line.
When launched from `%WinDir%` (or any other location outside `TCM\` folder), it looks for `TCM` in few locations, including
`%ProgramFiles%\TCM`, `%SystemDrive%\TCM`, `\TCM`, and then looks for [Total Commander](http://www.ghisler.com/)'s forlder (`totalcmd\`) under same locations. 

Thus, it is enough to have `TCM.exe` and `TCM_Prof\` folder on a memory stick, take it to any other PC which has a version of [Total Commander](http://www.ghisler.com/) installed, launch `TCM.exe` from your memory stick and you have [Total Commander](http://www.ghisler.com/) with your setting.

