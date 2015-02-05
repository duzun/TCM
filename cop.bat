@ECHO off
set do=%1
shift
copy %1 %do%>nul
:l
shift
if '%1.'=='.' goto e
type %1 >>%do%
goto l
:e