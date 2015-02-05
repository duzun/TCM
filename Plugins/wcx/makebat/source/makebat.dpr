library makebat;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  SysUtils,Classes,messages, windows;

{$R INPUTDLG.RES}

type
  char=ansichar;
  pchar=pansichar;

const       {Error codes returned to calling application}
  E_END_ARCHIVE=     10;       {No more files in archive}
  E_NO_MEMORY=       11;       {Not enough memory}
  E_BAD_DATA=        12;       {Data is bad}
  E_BAD_ARCHIVE=     13;       {CRC error in archive data}
  E_UNKNOWN_FORMAT=  14;       {Archive format unknown}
  E_EOPEN=           15;       {Cannot open existing file}
  E_ECREATE=         16;       {Cannot create file}
  E_ECLOSE=          17;       {Error closing file}
  E_EREAD=           18;       {Error reading from file}
  E_EWRITE=          19;       {Error writing to file}
  E_SMALL_BUF=       20;       {Buffer too small}
  E_EABORTED=        21;       {Function aborted by user}
  E_NO_FILES=        22;       {No files found}
  E_TOO_MANY_FILES=  23;       {Too many files to pack}
  E_NOT_SUPPORTED=   24;       {Function not supported}

  {Unpacking flags}
  PK_OM_LIST=           0;
  PK_OM_EXTRACT=        1;

  {Flags for ProcessFile}
  PK_SKIP=              0;     {Skip file (no unpacking)}
  PK_TEST=              1;     {Test file integrity}
  PK_EXTRACT=           2;     {Extract file to disk}

  {Flags passed through ChangeVolProc}
  PK_VOL_ASK=           0;     {Ask user for location of next volume}
  PK_VOL_NOTIFY=        1;     {Notify app that next volume will be unpacked}

  {Packing flags}

  {For PackFiles}
  PK_PACK_MOVE_FILES=   1;    {Delete original after packing}
  PK_PACK_SAVE_PATHS=   2;    {Save path names of files}

  {Returned by GetPackCaps}
  PK_CAPS_NEW=          1;    {Can create new archives}
  PK_CAPS_MODIFY=       2;    {Can modify exisiting archives}
  PK_CAPS_MULTIPLE=     4;    {Archive can contain multiple files}
  PK_CAPS_DELETE=       8;    {Can delete files}
  PK_CAPS_OPTIONS=     16;    {Supports the options dialogbox}
  PK_CAPS_MEMPACK=     32;    {Supports packing in memory}
  PK_CAPS_BY_CONTENT=  64;    {Detect archive type by content}
  PK_CAPS_SEARCHTEXT= 128;    {Allow searching for text in archives created with this plugin}
  PK_CAPS_HIDE=       256;    {Don't show as plugin, needs to open with Ctrl+PgDn}


type
  pbyte=^byte;
  {Definition of callback functions called by the DLL}
  {Ask to swap disk for multi-volume archive}
  PChangeVolProc=^TChangeVolProc;
  TChangeVolProc=function(ArcName:pchar;Mode:longint):longint; stdcall;
  {Notify that data is processed - used for progress dialog}
  PProcessDataProc=^TProcessDataProc;
  TProcessDataProc=function(Addr:pbyte;Size:longint):longint; stdcall;

type
  THeaderData=packed record
    ArcName:array [0..259] of char;
    FileName:array [0..259] of char;
    Flags,
    PackSize,
    UnpSize,
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr:longint;
    CmtBuf:pchar;
    CmtBufSize,
    CmtSize,
    CmtState:longint;
  end;

  tOpenArchiveData=packed record
    ArcName:pchar;
    OpenMode,
    OpenResult:longint;
    CmtBuf:pchar;
    CmtBufSize,
    CmtSize,
    CmtState:longint;
  end;

const maxarchives=10;
type ArchiveRec=record
       ArchiveName:array[0..259] of char;
       SrcDir,LastCurDir:array[0..259] of char;
       CurrentProcessedFile:THeaderData;
       ArchiveHandle:textfile;
       ArchiveMode:longint;
       ArchiveActive:boolean;
       ChangeVolProc:TChangeVolProc;
       ProcessDataProc:TProcessDataProc;
     end;

{Keep a list of currently open archives (up to a maximum of maxarchives)}
var ArchiveList:array[1..maxarchives] of ArchiveRec;
    oemchars:boolean=false;

var _TokenSource: PChar;

FUNCTION StrTok(Source: PChar; Token: CHAR): PChar;
  VAR P: PChar;
BEGIN
  IF Source <> Nil THEN _TokenSource := Source;
  IF _TokenSource = Nil THEN begin
    strTok:=nil;
    exit
  end;
  P := StrScan(_TokenSource, Token);
  StrTok := _TokenSource;
  IF P <> Nil THEN BEGIN
    P^ := #0;
    Inc(P);
  END;
  _TokenSource := P;
END;

function OpenArchive(var ArchiveData:tOpenArchiveData):thandle; stdcall;
begin
  result:=0;
  ArchiveData.OpenResult:=E_UNKNOWN_FORMAT;
  exit
end;

function CloseArchive(hArcData:thandle):longint; stdcall;
begin
  Result:=0;
end;

type
  TDateTime1 = record
    Year, Month, Day, Hour, Min, Sec: Word;
  end;

function ReadHeader(hArcData:thandle;var HeaderData:THeaderData):longint; stdcall;
begin
  Result:=E_BAD_ARCHIVE;
end;

function createvalidoutfile(var g:file;trgfile:pchar;isadir:boolean):integer;
var err:integer;
    buf:array[0..259] of char;
    p,p1:pchar;
begin
  {$i-}
  if not isadir then begin
    assign(g,trgfile);
    rewrite(g,1);
    err:=ioresult;
  end else
    err:=3;
  strlcopy(buf,trgfile,sizeof(buf)-1);
  if (err=3) or isadir then begin  {path not found}
    p1:=strrscan(buf,'\');
    if p1<>nil then inc(p1);  {pointer to filename}
    p:=strscan(buf,'\');
    if p<>nil then p:=strscan(p+1,'\');
    while (p<>nil) and (p<p1) do begin
      p[0]:=#0;
      mkdir(strpas(buf));
      err:=ioresult;
      p[0]:='\';
      p:=strscan(p+1,'\');
    end;
    if isadir then begin
      result:=0;    {A directory -> ok}
      exit;
    end;
    rewrite(g,1);
    err:=ioresult;
  end;
  result:=err;
end;

function ProcessFile(hArcData:thandle;Operation:longint;DestPath,DestName:pchar):longint; stdcall;
begin
  Result:=E_BAD_ARCHIVE;
end;

var PackerChangeVolProc:TChangeVolProc;
    PackerProcessDataProc:TProcessDataProc;

procedure SetChangeVolProc(hArcData:THandle;ChangeVolProc1:TChangeVolProc); stdcall;
begin
  PackerChangeVolProc:=ChangeVolProc1;
end;

procedure SetProcessDataProc(hArcData:THandle;ProcessDataProc1:TProcessDataProc); stdcall;
begin
  PackerProcessDataProc:=ProcessDataProc1;
end;

{==========================================================================}

type  { TMessage windows message record }
  PMessage = ^TMessage;
  TMessage = record
    Receiver: HWnd;
    Message: Word;
    case Integer of
      0: (
        WParam: Word;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Byte;
        WParamHi: Byte;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

const
  id_Prompt = 100;
  id_Input  = 101;
  id_oemchars=102;

var Caption: PChar;
    Prompt: PChar;
    Buffer: PChar;
    BufferSize: Word;
    br:hbrush;
    ininame:array[0..259] of char;

procedure TMyInputDialog_Init(ACaption, APrompt, ABuffer: PChar; ABufferSize: Word);
begin
  Caption := ACaption;
  Prompt := APrompt;
  Buffer := ABuffer;
  BufferSize := ABufferSize;
end;

function TMyInputDialog_CanClose(var msg:tmessage):Boolean;
begin
  GetDlgItemTextA(msg.receiver, id_Input, Buffer, BufferSize);
  TMyInputDialog_CanClose := True;
end;

procedure TMyInputdialog_setupwindow(var msg:tmessage);
var r,pr:trect;
    centerx,centery,hwindow,i:integer;
    template:array[0..1023] of char;
    buf1:array[0..15] of char;
    hasstrings:boolean;
begin
  hwindow:=msg.receiver;
  br:=createsolidbrush(getsyscolor(color_btnface));
  SetWindowTextA(HWindow, Caption);
  SetDlgItemTextA(HWindow, id_Prompt, Prompt);

  hasstrings:=false;
  for i:=0 to 19 do begin
    str(i,buf1);
    GetPrivateProfileStringA('oldstrings',buf1,'',template,sizeof(template)-1,ininame);
    if template[0]<>#0 then begin
      hasstrings:=true;
      SendDlgItemMessageA(HWindow, id_Input, cb_addstring, 0, longint(@template));
    end;
  end;
  if hasstrings then
    SendDlgItemMessageA(HWindow, id_Input, cb_setcursel, 0, 0)
  else
    SetDlgItemTextA(HWindow, id_Input, 'xcopy "%P%N" c:\someotherdir\%D');
  SendDlgItemMessageA(HWindow, id_Input, em_LimitText, BufferSize - 1, 0);

  oemchars:=GetPrivateProfileIntA('options','oemcharset',0,ininame)<>0;
  if oemchars then
    CheckDlgButton(HWindow,id_oemchars,BST_CHECKED);

  Windows.setfocus(GetDlgItem(hwindow,id_Input));

  getwindowrect(hwindow,r);
  getwindowrect(getparent(hwindow),pr);
  centerx:=pr.left+((pr.right-pr.left)-(r.right-r.left)) div 2;
  centery:=pr.top+((pr.bottom-pr.top)-(r.bottom-r.top)) div 2;
  movewindow(hwindow,centerx,centery,r.right-r.left,r.bottom-r.top,true);
end;

procedure TMyInputdialog_Ok(var msg:tmessage);
var hwindow,i,j,nr:integer;
    template,newline:array[0..1023] of char;
    buf1:array[0..15] of char;
    p:pchar;
begin
  hwindow:=msg.receiver;
  GetDlgItemTextA(hwindow,id_Input,newline,sizeof(newline)-1);
  str(0,buf1);
  WritePrivateProfileStringA('oldstrings',buf1,newline,ininame);
  nr:=SendDlgItemMessageA(HWindow, id_Input, cb_getcount, 0, 0);
  j:=1;
  for i:=0 to nr-1 do begin
    SendDlgItemMessageA(HWindow, id_Input, cb_getlbtext, i, longint(@template));
    if strcomp(newline,template)<>0 then begin {No duplicates!}
      str(j,buf1);
      WritePrivateProfileStringA('oldstrings',buf1,template,ininame);
      inc(j);
    end;
  end;
  while j<20 do begin
    str(j,buf1);
    WritePrivateProfileStringA('oldstrings',buf1,nil,ininame);
    inc(j);
  end;
  oemchars:=IsDlgButtonChecked(HWindow,id_oemchars)=BST_CHECKED;
  if oemchars then p:='1' else p:='0';
  WritePrivateProfileStringA('options','oemcharset',p,ininame);

  deleteobject(br);
end;

procedure TMyInputdialog_Cancel(var msg:tmessage);
begin
  deleteobject(br);
end;

procedure TMyInputdialog_wmctlcolor(var msg:tmessage);
begin
  if msg.lparamhi<>ctlcolor_edit then begin
    msg.result:=br;
    SetBkColor(msg.wparam,getsyscolor(color_btnface));
    SetTextColor(msg.wparam,getsyscolor(color_btntext));
  end else begin
    msg.result:=getstockobject(white_brush);
    SetBkColor(msg.wparam,rgb(255,255,255));
    SetTextColor(msg.wparam,0);
  end;
end;

function MyInputDlgProc(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): integer; export; {$ifdef win32} stdcall; {$endif}
var msg:tmessage;
begin
  MyInputDlgProc:=1;
  Msg.Receiver:=dialog;
  Msg.Message:=Message;
  Msg.wparam:=wparam;
  Msg.lparam:=lparam;
  Msg.Result:=1;
  case Message of
    wm_InitDialog:begin
      TMyInputDialog_SetupWindow(msg);
      exit
    end;
    wm_ctlcolor:begin
      TMyInputDialog_wmctlcolor(msg);
      MyInputDlgProc:=msg.result;
      exit
    end;
    wm_command:case msg.wparam of
      idok:begin
        if not TMyInputdialog_CanClose(msg) then exit;
        TMyInputDialog_Ok(msg);
        EndDialog(Dialog, idok);
        Exit;
      end;
      idcancel:begin
        if not TMyInputdialog_CanClose(msg) then exit;
        TMyInputDialog_Cancel(msg);
        EndDialog(Dialog, idcancel);
        Exit;
      end;
    end;
  end;
  MyInputDlgProc:=0;
end;

function PackFiles(PackedFile,SubPath,SrcPath,AddList:pchar;Flags:integer):integer; stdcall;
var s:sysutils.tsearchrec;
    PackedHandle:text;
    pnextname,p,p2:pchar;
    template,fullname,shortpathname:array[0..1023] of char;
    outbuf:array[0..2048] of char;
    rc,j:integer;
    RunOk:boolean;
    ch:char;
begin
  if FileExists(PackedFile) then begin
    if idyes<>MessageBoxA(GetActiveWindow,'File exists, overwrite?',PackedFile,mb_yesnocancel or mb_iconquestion) then begin
      result:=E_EABORTED;
      exit
    end;
  end;
  template[0]:=#0;
  GetModuleFileNameA(hinstance,ininame,sizeof(ininame)-1);
  p:=strrscan(ininame,'.');
  if p<>nil then strcopy(p,'.ini')
            else strcopy(ininame,'makebat.ini');

  TMyInputDialog_Init('Batch file creator',
     'Enter batch file text (%P=Path, %N=Name with relative path (if in subdir), '+
     '%M=Name without relative path, %D=relative path of file in subdir, '#13#10+
     '%L=New line, %O=name without ext., %E=extension, %%=Percent sign):',template,sizeof(template)-1);
  rc:=dialogboxa(hinstance,'MyInputDialog',GetActiveWindow,@MyInputDlgProc);
  if rc<>idok then begin
    result:=E_EABORTED;
    exit
  end;
  assignfile(PackedHandle,PackedFile);
  filemode:=0;
  {$i-}
  rewrite(PackedHandle);
  {$i+}
  if ioresult<>0 then begin
    Result:=E_ECREATE;
    exit
  end else begin
    if GetShortPathNameA(SrcPath,shortpathname,sizeof(shortpathname)-1)=0 then
      strlcopy(shortpathname,SrcPath,sizeof(shortpathname)-1);
    pnextname:=AddList;
    RunOK:=true;
    while (pnextname[0]<>#0) and RunOK do begin
      p:=strend(pnextname)-1;
      if p[0]<>'\' then begin   {Only files, no dirs!}
        outbuf[0]:=#0;
        j:=0;
        while j<strlen(template) do begin
          if template[j]='%' then begin
            case template[j+1] of
              'n':begin
                    strlcopy(fullname,SrcPath,sizeof(outbuf)-1);
                    strlcat(fullname,pnextname,sizeof(outbuf)-1);
                    if sysutils.FindFirst(fullname,faAnyFile,s)<>0 then begin
                      if s.finddata.cAlternateFileName[0]<>#0 then begin
                        {$ifdef win64}
                        {$ifndef fpc}
                        {Delphi64: s.finddata.cAlternateFileName is Unicode!}
                        WideCharToMultiByte(CP_ACP, 0, s.finddata.cAlternateFileName, -1, strend(outbuf), sizeof(outbuf)-1-strlen(outbuf),nil, nil);
                        {$else}
                        strlcat(outbuf,s.finddata.cAlternateFileName,sizeof(outbuf)-1)
                        {$endif}
                        {$else}
                        strlcat(outbuf,s.finddata.cAlternateFileName,sizeof(outbuf)-1)
                        {$endif}
                      end else
                        strlcat(outbuf,pnextname,sizeof(outbuf)-1);
                      sysutils.FindClose(s);
                    end;
                  end;
              'N':strlcat(outbuf,pnextname,sizeof(outbuf)-1); {Aktuelle Datei (langer Name)}
              'O':begin  {Name without extension and relative path}
                    p:=strrscan(pnextname,'\');
                    if p<>nil then inc(p)
                              else p:=pnextname;
                    p2:=strrscan(p,'.');    {Only dots in name, not path!}
                    if p2<>nil then p2[0]:=#0;
                    strlcat(outbuf,p,sizeof(outbuf)-1);
                    if p2<>nil then p2[0]:='.';
                  end;
              'E':begin  {Extension}
                    p:=strrscan(pnextname,'\');
                    if p<>nil then inc(p)
                              else p:=pnextname;
                    p:=strrscan(p,'.');    {Only dots in name, not path!}
                    if p<>nil then
                      strlcat(outbuf,p+1,sizeof(outbuf)-1);
                  end;
              'M':begin         {Aktuelle Datei ohne rel. Pfad (langer Name)}
                    p:=strrscan(pnextname,'\');
                    if p<>nil then inc(p)
                              else p:=pnextname;
                    strlcat(outbuf,p,sizeof(outbuf)-1);
                  end;
              'p':strlcat(outbuf,shortpathname,sizeof(outbuf)-1);
              'P':strlcat(outbuf,SrcPath,sizeof(outbuf)-1);
              'D':begin     {Relative path of file}
                    p:=strrscan(pnextname,'\');
                    if p<>nil then begin
                      ch:=p[1];
                      p[1]:=#0;
                      strlcat(outbuf,pnextname,sizeof(outbuf)-1); {Aktuelle Datei (langer Name)}
                      p[1]:=ch;
                    end;
                  end;
              '%':strlcat(outbuf,'%',sizeof(outbuf)-1);
              'L':strlcat(outbuf,#13#10,sizeof(outbuf)-1);
            end;
            inc(j);
          end else if strlen(outbuf)<sizeof(outbuf)-1 then begin
            p:=strend(outbuf);
            p[0]:=template[j];
            p[1]:=#0;
          end;
          inc(j);
        end;
        if oemchars then
          CharToOemA(outbuf,outbuf);
        writeln(PackedHandle,outbuf);
        if @PackerProcessDataProc<>nil then
          if PackerProcessDataProc(pByte(pnextname),s.size)=0 then
            RunOK:=false;
      end;
      pnextname:=strend(pnextname)+1;
    end;
    CloseFile(PackedHandle);
  end;
  if RunOK then result:=0
           else result:=E_EABORTED;
end;

function DeleteFiles(PackedFile,DeleteList:pchar):integer; stdcall;
begin
  result:=E_NOT_SUPPORTED;
end;

function GetPackerCaps:integer; stdcall;
begin
  result:=PK_CAPS_NEW or PK_CAPS_MULTIPLE or PK_CAPS_MODIFY or PK_CAPS_OPTIONS or PK_CAPS_HIDE;
end;

procedure ConfigurePacker(ParentHandle,DllInstance:thandle); stdcall;
begin
  MessageBox(ParentHandle,'Batch writer plugin, Copyright (C) 1999-2014 by Christian Ghisler',
    'About makebat',mb_iconinformation);
end;

exports
  OpenArchive,
  CloseArchive,
  ReadHeader,
  ProcessFile,
  SetChangeVolProc,
  SetProcessDataProc,
  PackFiles,
  DeleteFiles,
  GetPackerCaps,
  ConfigurePacker;

begin
  FillChar(ArchiveList,sizeof(ArchiveList),#0);
end.

