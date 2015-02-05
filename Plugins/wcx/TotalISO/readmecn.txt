关于TotalIsO
Total ISO maker (TotalISO)是一个Total Commander的Paker/unpacker插件。其主要功能是让用户
能够方便地制作关盘镜像文件。TotalISO只是一个图形界面前端。TotalISO通过第三方工具产生ISO
文件。TotalISO支持两种命令行工具：mkisofs.exe 和 cdimage.exe。

TotalISO支持多语言界面。v0.9支持简体中文和英文两种语言。本版TotalISO会自动寻找
$(TOTALISO)\Lang\zh_cn.dll
如果成功找到并且载入这个文件的话，程序将会使用简体中文界面，否则，使用英文界面。


安装：
把TotalISO_v0_9.zip解压缩，把得到的TotalISO.wcx及其他辅助文件放到Total Commander所在的目录，
或者其他你觉得适合的地方。然后打开Total Commander，选择菜单：
	Configuration-->Options...-->Packer
	点击按钮"Configure packer Extension WCXs", 
	然后在出来的对话框中，在“All files with extension (ending with)"
	所对应的那个框中写入tio，然后点击"New type"按钮。选择TotalISO.wcx。
	然后点击Ok，就算搞定了。
注：关于后缀，这里用tio作为例子，你可以用任何你喜欢的字符串。之所以没有用iso是因为
已经有一个TC插件叫做ISO.wcx可以处理ISO文件，为了防止冲突。所以使用别的后缀名。不管
你用什么后缀名，TotalISO都会把他们换成iso然后才开始制作ISO文件。

使用：
在TC里，选择一个目录，按下"Alt+F5"。在压缩格式那里选tio，
然后点击OK，然后在TotalISO的对话框中选择合适的参数。TotalISO将会按照这些参数，产生正确
的命令行参数，调用相应的工具，最终产生ISO文件。

TotalISO也可以对多个目录进行操作，如果选中多个目录的话，TotalISO会为每个目录分别产生一个
ISO文件。


系统要求：
TotalISO需要调用外部工具mkisofs.exe或者cdimage.exe来产生ISO文件。mkisofs.exe包含在
cdrtools工具集。可以免费获得。Win32移植版本的cdrtools的最新版可以从下面的地址获得：
http://smithii.com/files/cdrtools-latest.zip?PHPSESSID=0d4409158844db07be58dac999245dda

不过cdimage.exe只能在Microsoft公司内部使用. 所以不能免费下载。



文件列表：
TotalISO_v0_9.zip包含以下几个文件
TotalISO.wcx ---- 插件文件
totaliso.xml ---- TotalISO的配置文件
Readme.txt ---- 英文说明文件
Readmecn.txt ---- 简体中文说明文件
mkisofs.xml ---- TotalISO可以用的mkisofs.exe所支持的所有的选项配置文件
mkisofs_default.xml ---- TotalISO可用的mkisofs.exe的缺省配置文件
cdimage.xml ---- TotalISO可用的cdimage.exe所支持的所有选项配置文件
Lang\zh_cn.dll ---- 简体中文语言文件
mkisofs.exe ---- 从Bart's PEBuilder获得。



版权
Copyright (C) 2004 W. Dong, taohe@hotmail.com
本软件可免费使用于任何用途。但清在文档中保留这段。 
对可能由于使用这个软件而造成的任何损伤，本作者将不负任何责任。 

