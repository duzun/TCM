#ifndef u_tcmCPP
#define u_tcmCPP
#include "u_tcm.h"
//---------------------------------------------------------------------------
AnsiString      Dirs[256]       ={"Do not change this string!!!", "%TcmDir%", "\\", "C:\\", "%WinDir%", "%ProgramFiles%", \
                                  "D:\\", "U:\\"},\
                SubDirs[]      ={"", "TCM", "TotalCmd", 0},\
                CopyFiles[]    ={"wcx_ftp.ini", "wincmd.ini", "utcm.ini", "DEFAULT.BAR", "Sys.bar", "Others.bar", "Dirs.bar", "Original.bar", 0},\
                TcmProf, TcmUser, wincmd, wcx_ftp, T;
//---------------------------------------------------------------------------
AnsiString      TcmParam="";
//---------------------------------------------------------------------------
int buffer[BUFFER_SIZE];
//---------------------------------------------------------------------------
#ifndef MAXDIR
   #define MAXDIR 255
   #define MAXPATH 255
#endif

char  TcmDir[MAXDIR], TCM[MAXPATH];
char  HDisk='A'+getdisk(),\
      HDir[MAXDIR];
//---------------------------------------------------------------------------
char init_tcm(char* CmdLn=0)
{
        int i, l;
        char *p, *q, inter=0;

        if(!CmdLn) CmdLn = (char*)GetCommandLine();
        if(setTcmDirs(tcmexe))
        {
               i = _argc;
               if(p = (char*)TcmParam.data()) do
               {
                  if( !(q = AnsiStrPos(p+1, "/")) ) l = strlen(p);
                  else l = q-p;
                  _argv[i]  =CharAlloc(l+1);
                  memcpy(_argv[i], p, l);
                  _argv[i++][l] = 0;
                  p += l;
               }
               while(p[0]);

               p = q = _argv[0];
               for(l=0; l<i; l++)
               {
                   if(p)  if( strstr(_argv[l], "/i=") ) p = 0;
                   if(q)  if( strstr(_argv[l], "/f=") ) q = 0;
                   if( strstr(_argv[l], "/interactive") )
                   {
                      _argv[l] = _argv[--i]; // drop the current param
                      inter = 1;
                   }
               }

                if( p )
                {
                   p=_argv[i]  =CharAlloc(wincmd.Length()+6);
                   strcpy(p,"/i=\"");             p+=strlen(p);
                   strcpy(p, wincmd.c_str());     p+=strlen(p);
                   strcpy(p,"\"");
                   i++;
                }

                if( q )
                {
                   p=_argv[i]=CharAlloc(wcx_ftp.Length()+6);
                   strcpy(p,"/f=\"");             p+=strlen(p);
                   strcpy(p, wcx_ftp.c_str());    p+=strlen(p);
                   strcpy(p,"\"");
                   i++;
                }

                _argv[i] = NULL;

                if(inter)
                {
                     p = (char*)memmove(&_argv[3], _argv, i*sizeof(_argv[0]));
                     Ansi2C(getTimeStr(Time()+(double)1/1440), _argv+1);
                     Ansi2C("/interactive", _argv+2);
                     _argv[i+=3] = NULL;
//                     return spawnvp(P_OVERLAY,"at",_argv);

                     TcmParam = "";
                     for(l=1; l<i; l++){ TcmParam += _argv[l]; TcmParam += " "; }
                     // at hh:mm /interactive %0
                     return !ShellExecute(0, 0, "at", TcmParam.c_str(), ".", SW_MINIMIZE);
                }

               TcmParam = "";
               for(l=1; l<i; l++){ TcmParam += _argv[l]; TcmParam += " "; }
               return !ShellExecute(0,0,TCM,TcmParam.c_str(),TcmDir, SW_SHOWNA);
//               try{ ChDir(TcmDir); } catch(...){}
//               return spawnv(P_OVERLAY,TCM,_argv);
        }
       return 0;
}
//---------------------------------------------------------------------------
char*   CharAlloc(int nBytes, void* OldMem)
{
  if(OldMem) return (char*)LocalReAlloc(OldMem, nBytes, LMEM_FIXED);
  else       return (char*)LocalAlloc  (LMEM_FIXED, nBytes);

//   if(OldMem) return (char*)realloc(OldMem, nBytes);
//   else       return (char*)malloc(nBytes);
}
char* CharFree(void* Mem){ return (char*)LocalFree(Mem); }
//---------------------------------------------------------------------------
char setTcmDirs(char *exename){
  // Program Home Path /
     getcurdir(0,HDir);
     Dirs[0]="@:\\";
     Dirs[0]+=HDir;
     Dirs[0][1]=HDisk;
     if(FindTcm(exename)=="") return 0;

     TcmProf=TcmDir;  TcmProf+="Tcm_Prof\\";
     TcmUser=TcmProf;
     if( (T=getenv("UserName"))!=NULL ) TcmUser+=T+"\\";
     if( !DirectoryExists(TcmProf) && CreateDir(TcmProf) ) TcmProf="";
     if( !DirectoryExists(TcmUser) && CreateDir(TcmUser) || !DirectoryExists(TcmUser)) TcmUser="";
     char i=0;
//     T=TcmDir; //T+="\\";
     if(TcmProf!="") while(CopyFiles[i]!="")
     {
        if(!FileExists(T=TcmProf+CopyFiles[i])) CopyFile(T, TcmDir + CopyFiles[i]);
        if((TcmUser!="")&&!FileExists(T=TcmUser+CopyFiles[i])) CopyFile(T, TcmProf + "\\" + CopyFiles[i]);
        i++;
     }
     T=TcmUser; wincmd = findRecur(&T,"utcm.ini");
     T=TcmUser; if(wincmd=="") wincmd = findRecur(&T,"wincmd.ini");
     T=TcmUser; wcx_ftp = findRecur(&T,"wcx_ftp.ini");

     setPath(TcmDir);
     EnvVar("TcmDir",  TcmDir);
     EnvVar("TCM",     TCM);
     EnvVar("TcmUser", TcmUser.c_str());

     return 1;
}
//---------------------------------------------------------------------------
AnsiString getTimeStr(TDateTime t)
{
   return TimeToStr(t).SubString(0, 5);
}
//---------------------------------------------------------------------------
char*  findArgV(char *bstr, char mk)
{
        int i=0;
        char *p, *q;
        while(i<_argc){
                p=bstr; q=_argv[i];
                while( *p && *q && (toupper(*p)==toupper(*q)) )
                {
                    p++;    
                    q++;
                }
                if(!*p) return _argv[i];
                i++;
        }
        if( !mk || !(_argv[i]=CharAlloc(strlen(bstr)+1)) ) return NULL;
        strcpy(_argv[i],bstr);
        return _argv[i];
}
//---------------------------------------------------------------------------
AnsiString      FindTcm(char *t){
        int i=0, j, k;
        AnsiString r = "", p, d, tmp;
        if(*t=='\\') t++;
        for(i=0;Dirs[i]>"";i++)
        {
           p=FiltreEnv(Dirs[i]);
           j=0;
           do{
                d=SubDirs[j]; d+="\\"; d+=t;
                if((tmp=RealPath(p.c_str(), d.c_str()))!=""){
                        r=DirName(tmp); r+="\\";
                        strcpy(TcmDir, r.c_str());
                        TcmDir[r.Length()]=0;
                        strcpy(TCM, TcmDir);
                        strcpy(TCM+strlen(TcmDir), t);
                        return r;
                }
                j++;
           } while(SubDirs[j]!="");
        }
return r;
}
//---------------------------------------------------------------------------
AnsiString  findRecur(AnsiString *path, char *fn){
    if(!path || ((*path).Length()==0)) return "";
    if((*path)[(*path).Length()]=='\\') (*path).SetLength((*path).Length()-1);
    if(fn){
        if(*fn!='\\') *(--fn)='\\';
        if(FileExists(*path+fn)) return *path+fn;
        (*path)=DirName(*path);
        return findRecur(path, fn);
    }
    if(DirectoryExists(*path))   return *path;
    (*path)=DirName(*path);
    return findRecur(path);
}
//---------------------------------------------------------------------------
char  copyfile(char *dest, char *src){
#define nbuf 32768
   FILE *in, *out;
   char buf[nbuf];
   size_t n;
   if ( !(in  = fopen(src,  "rb")) ) return 1;
   if ( !(out = fopen(dest, "wb")) ) return 2;
   while(n = fread(buf,1,nbuf,in)) fwrite(buf,1,n,out);
   fclose(in);   fclose(out);
   return 0;
}
//---------------------------------------------------------------------------
char   CopyFile(AnsiString dest, AnsiString src){ return copyfile(dest.c_str(),src.c_str()); }
//---------------------------------------------------------------------------
void EnvVar(char *name, char *value)   // %ComSpec% /C set name=value
{
        unsigned int n=strlen(name), v=strlen(value);
        char *buf;
        
        if(name[n-1]=='=') name[n--]=0;
        if(!(buf=getenv(name))) buf=CharAlloc(n+v+2);
        else buf-=n+1;
        strcpy(buf,name);
        buf[n]='=';
        strcpy(buf+n+1,value);
        buf[n+v+1]=0;
        putenv(buf);
}
//---------------------------------------------------------------------------
AnsiString  dirname(char* path){
        AnsiString r=path;
        char slash=0, i=0;
        while(path[i]){
                if(path[i]=='\\') slash=i;
                i++;
        }
//        if(!slash) slash=i;
        r.SetLength(slash);
        return r;
}
//---------------------------------------------------------------------------
AnsiString  DirName(AnsiString path){ return dirname(path.c_str()); }
//---------------------------------------------------------------------------
char setPath(char *p){
        char *path=getenv("PATH"), *tab[256]={p,path}, i=1, j, *t, *s;
        int pi=0;

        if(!(tab[0]=CharAlloc(strlen(p)+1))) return 0;
        if(!(tab[i]=t=CharAlloc(strlen(path)+1))){ CharFree(tab[0]); return 0; }
        do tab[0][pi]=toupper(p[pi]); while(p[pi++]);
        pi=0;
        while(path[pi]){
                if(path[pi]==';') {
                      i++;
                      t[pi]=0;
                      tab[i]=t+pi+1;
                }else{t[pi]=toupper(path[pi]);}
                pi++;
        }
        t[pi]=0;   i=0;
        while(tab[i]){
             while((*tab[i]=='"')||(*tab[i]==' ')) tab[i]++;
             j=strlen(tab[i]);
             if(j--){
                while((tab[i][j]=='\\') || (tab[i][j]=='"') || (tab[i][j]==' ')) j--;
                tab[i][j+1]=0;
             }
             j=0;
             while(j<i) if(!strcmp(tab[i],tab[j++])) {tab[i]=tab[0];break;}
             i++;
        }
        i=tab[0] ? 0 : 1;
        p=path;
        while(tab[i]){
                if(i && (tab[i]==tab[0])){i++; continue;}
                strcpy(p,tab[i]);
                *(p+=strlen(tab[i]))=';';
                p++;    i++;
        }
        *p=0;
        CharFree(t);   CharFree(tab[0]);
        EnvVar("PATH",path);
        return 1;
}
//---------------------------------------------------------------------------
AnsiString FiltreEnv(AnsiString s){
        char *p[32], i=0, *r, *e, *rs;
        unsigned char len; //lungimea tuturor sirurilor fragmentare
        unsigned long m=2;
    try{
        if(Ansi2C(s,&r))
        {
                *p=r;
                // Se imparte r in mai multe siruri
                while(p[i]=AnsiStrPos(p[i++],"%")) *p[i]++=0;
                i--;
                i  &= ~0^1; //i - par
                len = i;
                //Se inlocuiesc variabilele din mediu, iar cele care nu sunt gasite, se marcheaza in bitul corespunzator din m
                while(i--)
                {
                        m<<=2;
                        if( !*p[i] || !(e=getenv(p[i])) ) m^=3; else p[i]=e;
                        i--;
                }
                i^=i; // i:=0;
                while(p[i]) len+=strlen(p[i++]);
                i^=i;
                if(e=CharAlloc(len+1))
                {
                   rs=e;
                   while(p[i]) 
                   {
                         strcpy(rs,p[i]);
                         rs+=strlen(p[i++]);
                         if(m&1) *(rs++)='%%';
                         m>>=1;
                   }
                   *rs=0;
                   CharFree(r); r=e;
                }
        }
    }__finally{
        s=r;
        CharFree(r);
        return s;
    }
}
//---------------------------------------------------------------------------
AnsiString FullPath(char* Dir, char* Name, char Disk)
{
        char buf[MAXPATH]="?:\\", *p=buf;
        if(Dir[1]==':'){ Disk=*Dir; Dir+=2; }
        if((Disk&=31)==0) Disk=getdisk()+1;
        *p='@'+Disk;
        p+=3;
        if(*Dir!='\\'){
                strcpy(p,HDir);
                *(p+=strlen(HDir))='\\';
                if(strlen(HDir)) p++;
        }else   Dir++;
        if(*Name=='\\') Name++;
        strcpy(p,Dir);
        if(*((p+=strlen(Dir))-1)!='\\') *(p++)='\\';
        if(*Name=='\x0') p--;
        strcpy(p,Name);
        p[strlen(Name)]=0;

        return buf;
}
//---------------------------------------------------------------------------
AnsiString RealPath(char* Dir, char* Name, char Disk)
{
        AnsiString Path = FullPath(Dir, Name, Disk);
        return FileExists(Path)?Path:Path="";
}
//---------------------------------------------------------------------------
char* Ansi2C(AnsiString s, char** r)
{
        *r = CharAlloc(s.Length()+1);
        if(*r) strcpy(*r,s.c_str()); //else *r = NULL;
        return *r;
}

//---------------------------------------------------------------------------

/*

:h
if exist "%tcm%" goto tcm

if exist "%Home%\Tcm.do" (
   type "%Home%\Tcm.do">"%temp%\T~dir.bat"
   call "%temp%\T~dir.bat"
)

cd %TcmDir%Tcm_Prof\%username%"

del *.br1

start "DUzunSys" %Tcm% /i=%TcmDir%Tcm_Prof\%username%\utcm.ini" /f=%TcmDir%Tcm_Prof\%username%\wcx_ftp.ini" %Prm_1_8_9%

*/

//---------------------------------------------------------------------------
#endif
