                 MultiArc plugin for Windows Commander

  What it does:

It allows to view, extract and modify contents of archives that is not currently
supported by Win Commander i.e. JAR or IMP. This plugin transforms commands, that 
WC do into the corresponding external archiver calls.

You can add support for you favorite archiver by yourself - just edit
multiarc.ini file.

Some ideas was "stolen" 8-) from FAR file manager by Eugene Roshal. Thank
you, Eugene - you write a GREAT program but I prefer GUI applications in
GUI environment. 8-)



What's new in latest version:
====================================================== 
Legend:
! - important information about version (MUST TO BE READ)
+ - feature added
- - feature removed
? - problem stay on
* - bug fixed
====================================================== 

29/07/2007 ver 1.4.1.6
* Fix bug Stack owerflow if GUI-settings calling 
26/07/2007 ver 1.4 
26/07/2007 ver 1.4 
+ IDPOS in addon can have hex values (like 0x12345), decimal values supported too
+ Add support enviropment variable %COMMANDER_INI% 
* Fix bug If import Addon via GUI, show message "Do you want to import addon for 
     type(-s): [ s ]?", intand [ s ] shuld be names of section in Addon.
* Replace limit from 4096 to 65536 bytes in import line.

??/04/2006 ver 1.3 beta
  * fix bug if try enter in file with zero lenght
  * fix bug if sfx-part of archive compresed with EXE-Paker, do not always enter to arhive.
  * Fix bug If import addon contaning more 1 section, import all section imposible
  * Fix bug IDPos not always saved correctly
  * Fix bug if same addon import twice FormatsX saved 2 times.
  ! Changed Resource with ID 1002,1003, 1004. Translators of .lang file, update transaltion

22/03/2006 ver 1.2
  + added support different language in visual configuration. (25/11/05)
  * if parameter Editor have environment variable Editing multiarc.ini not start (19/07/2005)


   (c) 2005 by Vladimir Serdyuk
   http://wxc.sourceforge.net
   mailto: vserd(dog)users.sourceforge.net (dog)=@


   (c) 2000-2003 by Siarzhuk Zharski

   http://www.zharik.host.sk
   mailto: imker(dog)gmx.li (dog)=@