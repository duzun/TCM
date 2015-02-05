About TotalISO
Total ISO maker (TotalISO) is a Packer/unpacker plugin for TotalCommander (TC). It's function 
is to make it easier for you to create ISO image files. 

TotalISO supports multi-lingual interface. In version 0.9.0.55, TotalISO supports English and 
Chinese (simplified). Upon startup, TotalISO will try to find the default language settng in totaliso.xml, then load the language file for the GUI. If it fails to load the specified language 
file, GUI will be displayed in English.

Installation:
Unzip TotalISO.zip, put the files in the folder where TC sits or anywhere you like. 
Run TC, from the menu:
	Configuration-->Options...-->Packer
	click "Configure packer extension WCXs",
	then enter "tio", for example, without quotes in the field of 
	"All files with extension (ending with)". Then click "New type" button, 
	select "TotalISO.wcx". Click "OK". That's all of it.
Note: Don't worry about the extension you write here. TotalISO will automatically 
replace it with "iso" before create the file. Use "iso" as the extension for the 
plugin is not recommended, as there is already a plugin called iso.wcx which seems to 
require "iso" as the extension.


Requirements:
TotalISO is only a GUI front end to third party tools. To actually create ISO files, 
you need either mkisofs.exe or cdimage.exe, or both.

mkisofs.exe is included in cdrtools. You may find the latest version of cdrtools for 
win32 from the following link:
http://smithii.com/files/cdrtools-latest.zip?PHPSESSID=0d4409158844db07be58dac999245dda

cdimage.exe, however, is only used internally in Microsoft company. It's not available in 
the public domain.


Usuage:
In TC, select one directory, then press "Alt+F5". From the opened dialog, 
choose tio as the external packer. Click OK, and in the opened TotalISO dialog, set 
the appropriate parameters, then click OK. TotalISO will collect infomation and compose 
the correct the command line options for the tool you select and run the command to create 
iso file for you.

TotalISO can also operate on multiple folders. In this case, TotalISO will create multiple 
iso files, one for each directory. TotalISO does not work on files.


File list:
TotalISO_v0_9.zip contains the following files:
TotalISO.wcx ---- The plugin
totaliso.xml ---- Configuration file for TotalISO
Readme.txt ---- Introduction in English
Readmecn.txt ---- Introduction in Chinese (simplified)
mkisofs.xml ---- A file containing all the supported options of mkisofs.exe
mkisofs_default.xml ---- A file containing the default options of mkisofs provided by TotalISO
cdimage.xml ---- A file containing all the supported options of cdimage.exe
Lang\zh_cn.dll ---- Language file in Chinese (simplified)
mkisofs.exe ---- Obtained from Bart's PEBuilder.


License:
Copyright (C) 2004 W. Dong, taohe@hotmail.com
License to copy, use, and redistribute this software for any purpose is granted 
provided that this notice may not be removed from this document. 

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the 
use of this software. 

