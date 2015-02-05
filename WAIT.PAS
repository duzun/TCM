uses crt, dos, strings;
const calendar:array[1..5]of byte=(1,60,60,24,7);
{      expc:array[1..5]of longint=(1,60,3600,3600*24,3600*24*7);}
      cicl=3600*24*7;
type tm=array[1..5]of word;
var lshow,wt,current,ending:longint;
    w: string;
    k: char;
    ms, Interval: word;
    i: byte;
    ToExit,Show: boolean;

Procedure DoEnd(n:integer);
begin
writeln;
halt(n);
end;

Procedure GetTm(var wt:longint);
var i:byte;t:tm;
begin
gettime(t[3],t[2],t[1],ms);
getdate(ms,ms,t[4],t[5]);
wt:=0;
for i:=5 downto 1 do wt:=(wt+t[i])*calendar[i];
end;

function WaitTime:longint;
begin
gettm(current);
wt:=ending-current;
if wt<0 then wt:=(cicl+wt)mod cicl;
waittime:=wt;
end;

function Left:string;
var shown:tm;s2,s1:string;i:byte;lung:byte;
begin
lung:=1;
{WaitTime;}
for i:=1 to 4 do begin shown[i]:=wt mod calendar[i+1];wt:=wt div calendar[i+1];if shown[i]<>0 then lung:=i;end;shown[5]:=wt;
s2:='';
for i:=1 to lung do begin
 str(shown[i],s1);
 if i in[1..3]then if length(s1)<2 then s1:='0'+s1;
 if i<>1 then s2:=':'+s2;
 s2:=s1+s2;
end;
left:=s2;
end;

Function StrToLongi(w:string):Longint;
var wt:longint;c,i:byte;
begin
wt:=0;
for i:=1 to length(w) do begin
 c:=ord(w[i])-48;
 if c in[0..9]then wt:=wt*10+c;
end;
StrToLongi:=wt;
end;

Procedure WriteAll(s:string);
begin
gotoxy(1,wherey);write(s);
while wherex<lo(windmax)-1 do write(' ');
gotoxy(1,wherey);
end;

Procedure ShowLeft;
begin
   if show then WriteAll(Left);
   if interval > waittime then dec(interval, waittime);
   lshow := current+interval;
end;

function ShowHelp(rk: boolean): char;
begin
   Writeln('S: Stop, L: Show left time, E: Enter time, C: ClrScr, H: Help');
   WriteLn('CommandLine: WAIT <time> [/I <ShowInterval>] [/S] [/H|/?]');
   if rk then ShowHelp := readkey else ShowHelp := #27;
end;


Function EnterTime:string;
var w:string;
begin
  WriteAll(' ');
  write('Enter time (sec): ');
  readln(w);
  gotoxy(1, wherey-1);
  EnterTime := w;
  WriteAll(' ');
end;

Function ReadParam: integer;
var s: string;
    i, n: integer;
begin
   Show := true;
   n    := ParamCount;
   i    := 1;
   while i<=n do begin
     s := paramstr(i);
     StrUpper(@s);
     if (s = '/H') or (s = '/?') then begin if(ShowHelp((i=n)and(n=1))<>#27)then DoEnd(0) end else
     if s = '/S' then show := false else
     if s = '/I' then begin inc(i); Interval := StrToLongi(paramstr(i)); end else
     w := s;
     inc(i);
   end;
   ReadParam := n;
end;
{*************************************************************}
Begin
  {Defaults}
   w        := '';
   Show     := true;
   ToExit   := false;
   Interval := 1; {sec}

   {CommandLine parameters}
   ReadParam;
   if w = '' then w := EnterTime;

gettm(ending);
ending:=ending+StrToLongi(w);
repeat
 if show and(lshow<=current) then begin ShowLeft;end;
 if keypressed then begin
  if ToExit then DoEnd(ord(readkey));
  k := readkey;
  case UpCase(k) of
   'C':ClrScr;
   'S':DoEnd(2);
   'L':ShowLeft;
   'E':ending:=current+StrToLongi(EnterTime);
   'H':begin
         ShowHelp(false);
         ShowLeft;
       end;
   #27:ToExit:=not ToExit;
  end;
 end;
until waittime=0;
End.
