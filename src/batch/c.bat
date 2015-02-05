@echo off
@rem ---------------------------------------------------------
@rem Ver   : 2.3 
@rem Date 2.3 : 24.05.2012
@rem Date 2.2 : 15.01.2010
@rem Author: Dumitru Uzun (DUzun) (C)
@rem Web   : http://duzun.teologie.net/
@rem ---------------------------------------------------------

if '%1.'=='/C.' goto %2 
if '%1.'=='/D.' goto doo 

@rem ~ Add here the commands you want to be shown ~
@set enum=mv2, km, mmk, libertv, sk, mailru, gt, pd, eng, lerdic, aud, ro, wamp, apmon, wdc, bt, ps, o, moz
@set enum=%enum%, fz, dw, fl, blue, alc, wac, tor, km, ai, edit, pedit

@rem ~ Do not change the following unless you know what it does!

@goto preg

@rem ---------------------------------------------------------
@rem  Script pentru rularea unor programe de la linia de comanda.
@rem  Linia de comanda se cheama prin combinatia de taste 
@rem    <Windows>+R  (Windows Run)
@rem ---------------------------------------------------------

@rem ---------------------------------------------------------
@rem Sintaxa scriptului este:
@rem   c <cmd>
@rem   unde:
@rem   c      - numele acestui script, 
@rem   <cmd>  - oricare din scurtaturile enumerate la "set enum=..."
@rem Ex:
@rem   c sk - ruleaza Skype
@rem ---------------------------------------------------------

:cver
set cver=2.3
echo Version: %cver% 
echo. 
goto e 

@rem ---------------------------------------------------------
@rem -------- /Begin of user data --------
@rem ~ Aici poti adauga comenzile proprii ~

	:cwamp
set title=WAMP Manager
set progpath=D:\VM\wamp
if not exist "%progpath%\." set progpath=D:\wamp
set exename=wampmanager
goto tpl

    :ctor
set exename=uTorrent
goto tpl

	:ckm
set title=The KM Player
set progdir=The KMPlayer
set exename=KMPlayer
goto tpl

	:cai
set title=AIMP Player
set progpath=%ProgramFiles%\AIMP4
if not exist "%progpath%\." set progpath=%ProgramFiles%\AIMP3
if not exist "%progpath%\." set progpath=%ProgramFiles%\AIMP2
set exename=AIMP2
goto tpl

	:cwac
set title=WinAVI Video Converter
set progdir=WinAVI Video Converter
set exename=WinAvi
goto tpl

	:cmv2
set title=Mv2 Player
set progdir=Mv2Player
set exename=Mv2PlayerPlus
goto tpl

	:ccep
set title=Cool Edit Pro 2
set progdir=coolpro2
set exename=coolpro2
goto tpl

	:cblue
set title=Blue Soleil
set progdir=IVT Corporation\BlueSoleil
set exename=BlueSoleil
goto tpl

	:co
	:copera
set exename=Opera
set progdir=Opera
goto tpl

	:cmoz
set title=Mozilla Firefox
set progdir=Mozilla Firefox
set exename=firefox
goto tpl

	:cfz
set title=FileZilla FTP Client
set progdir=FileZilla FTP Client
set exename=filezilla
goto tpl

	:cps
set title=PhotoShop
set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS6
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS5
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS4
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS3
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS2
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Photoshop CS1
set exename=Photoshop
goto tpl

	:cmmk
set title=MULTIMEDIA KEYBOARD
set progdir=Keymaestro\Multimedia Keyboard
set exename=MMKeybd
goto tpl

	:cmailru
set title=MailRu
set progdir=Mail.Ru\Agent
set exename=Magent
goto tpl

	:clibertv
REM set title=LiberTV
REM set progdir=LiberTV
set exename=LiberTV
set param=-silent
goto tpl

	:csk
	:cskype
set title=Skype
set progdir=Skype\Phone
set exename=Skype
set param=/nosplash /minimized
goto tpl

	:cbt
set title=Babylon Translator
set progdir=BABYLO~1
set exename=babylon
goto tpl

	:cgt
	:cgtalk
set title=GTalk
set progdir=Google\Google Talk
set exename=googletalk
REM set param=/autostart
goto tpl

	:cpd
	:cpidgin
set title=Pidgin
set progdir=Pidgin
set exename=Pidgin
goto tpl

	:capmon
set title=Apache Monitor
set progpath=D:\www\Apache22\bin
set exename=ApacheMonitor
goto tpl

	:cwdc
set title=Web Developer Controller
set progpath=D:\www
if not exist "%progpath%\." set progpath=D:\VM\www
set exename=WDController
goto tpl


	:crodex
    :cro
    :cdex
set progpath=%ProgramFiles%\Sign\RoDEX12
if not exist "%progpath%\." set progpath=%ProgramFiles%\Sign\RoDEX11
if not exist "%progpath%\." set progpath=%ProgramFiles%\Sign\RoDEX10
set exename=RoDex
goto tpl

	:caud
set exename=Audition
goto tpl

	:clerdic
set title=LerDic
set progdir=lerdic200
set exename=LerDic
goto tpl

    :ceng
set title=Dic (En-Ro-En) 
set progdir=Dic(En-Ro-En)
set exename=dictionar
goto tpl

	:cdw
set title=DreamWaver
set progpath=%ProgramFiles%\Adobe\Adobe Dreamweaver CS6
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Dreamweaver CS5
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Dreamweaver CS4
if not exist "%progpath%\." set progpath=%ProgramFiles%\Adobe\Adobe Dreamweaver CS3
if not exist "%progpath%\." set progpath=%ProgramFiles%\Macromedia\Dreamweaver 8
set exename=Dreamweaver
goto tpl

	:cfl
set title=Macromedia Flash 8
set progdir=Macromedia\Flash 8
set exename=Flash
goto tpl

	:calc
set title=Alcohol 120%
set progdir=Alcohol Soft\Alcohol 120 
set exename=Alcohol
goto tpl

	:cedit
set title=Edit this command file %0
set progpath=%windir%
set exename=notepad
set param=%self%
if exist %orig_% set param=%orig_%
goto tpl

	:cpedit
set title=Edit this command file %0 with PSPad
set progpath=%windir%
set exename=pspad
set param=%self%
if exist %orig_% set param=%orig_%
goto tpl

@rem -------- End of user data/ --------

@rem ---------------------------------------------------------
@rem ---------------------------------------------------------
@rem ~ Aici sunt instructiunile executate pentru fiecare comanda ~

:tpl
if not "%progpath%."=="." goto tpl_path

:tpl_dir
if "%progdir%."=="." set progdir=%exename%
if "%title%."=="." set title=%exename%

for %%i in (%search_progs_%) do if exist "%%~i\%progdir%\." (
   %self% /C tpl_do "%%~i\%progdir%"
   goto e
)
goto no_prog

:tpl_path
if not exist "%progpath%\." goto no_prog
set progpath="%progpath%"

:tpl_do
if '%progpath%.'=='.'  set progpath=%3
 
echo %cmd%: %title%
if not "%e%."=="end." goto %e% 

:exec
cd %progpath%
set cmd_="%title%" /D%progpath% %exename% %param%
REM echo %cmd_%
REM pause
call %self% /C end1
start %cmd_%
set cmd_=
cd "%~pd0"
REM ???
exit
goto %e%

@rem ---------------------------------------------------------
:no_prog
set not_inst=%not_inst%, %cmd% 
if not "%e%"=="end" goto end_tpl

Color 4E
Echo.
Echo Nu e instalat programul "%title%" !
Echo.
Pause
goto end
@rem ---------------------------------------------------------
@rem ~ If no command is passed ~
:c
for %%I in (%self%) do (
   if /I "%%~dpI" EQU "%windir%\" goto win 
   if /I "%%~dpI" EQU "%windir%\system32\" goto win 
   if not exist "%windir%\%%~nxI" goto selfcpy
)
call %self% /C cver
@rem ~ Bak some values ~
set myver=%cver%
set myself=%self%
set myenum=%enum%
set cver=
call "%windir%\%self_name%" /C cver > nul
set self=%myself%
set enum=%myenum%
set myself=
set myenum=
if "%cver%."=="." goto selfcpy 
if /I "%myver%" LSS "%cver%" goto enum
:selfcpy
  copy %self% "%windir%" > nul
  if exist "%windir%\system32\%self_name%" del /F "%windir%\system32\%self_name%">nul
goto enum
@rem ---------------------------------------------------------
:end
@rem ~ Removing all added enviroment variables ~
set e=
:end1
set self=
set self_name=
set param=
set enum=
set not_inst=
set orig_=
set search_progs_=
:end_tpl
set cmd=
set title=
set progpath=
set progdir=
set exename=

goto e
@rem ---------------------------------------------------------
:preg
REM @echo off
set search_progs_="D:\sys\Progs", "%ProgramFiles%", "%SystemDrive%\Program Files", "%SystemDrive%\Program Files (x86)"
set self_name=%~nx0
set self="%~dpnx0"
set orig_="D:\DUzunSys\%self_name%"
set cmd=%1
@REM Variabile importante, trebuiesc setate de TPL
set title=
set progpath=
set progdir=
set exename=
set param=

Title Quick Launch Commander (by DUzunSys)
Color 81

:param
  shift
  if '%1.'=='.' goto fwd
  set param=%param%%1 
goto param

:fwd
set e=end
goto c%cmd%
@rem ---------------------------------------------------------
echo Error with command: %cmd%
pause>nul
errorlevel 1
goto end
@rem ---------------------------------------------------------
:win
if not '%orig_%.'=='.' if /I '%self%' NEQ '%orig_%' if exist %orig_% (
  for %%I in (%orig_%) do for %%J in (%self%) do if %%~dpI NEQ %%~dpJ (
     echo.
     echo Executing %%I ...
     echo.
     cd %%~dpI
     %orig_% %param%
     goto end
  ) 
)
goto enum
@rem ---------------------------------------------------------
:enum
@for %%n in (%enum%) do (
   call %self% /C cshow %%n
)
pause>nul
goto end
@rem ---------------------------------------------------------
:cshow
call %self% /C end_tpl
set e=e
set cmd=%3
call %self% /C c%cmd%
goto e
@rem ---------------------------------------------------------

:e
