#ifndef u_tcmH
#define u_tcmH
#include <process.h>
#include <dir.h>   
#include <stdio.h>
//#include <system.hpp>
#include <Filectrl.hpp>

//---------------------------------------------------------------------------
#define tcmexe "totalcmd.exe"
//---------------------------------------------------------------------------
#define BUFFER_SIZE 1024
#define GetWide(ansistr) ansistr.WideChar((wchar_t*)buffer,BUFFER_SIZE)
//---------------------------------------------------------------------------
char*           Ansi2C(AnsiString s, char** r);                        //Convert AnsiString to C string
AnsiString      FullPath(char* Dir, char* Name="\x0", char Disk='`');  //Adds real path to the relative file name
AnsiString      RealPath(char* Dir, char* Name="\x0", char Disk='`');  //Same as FullPath, if file exists, else - null string is returned
AnsiString      FiltreEnv(AnsiString s);                //Replaces %varname% with enviroment variables' value, if it exists
AnsiString      DirName(AnsiString path);
AnsiString      dirname(char* path);
AnsiString      findRecur(AnsiString *path, char *fn=0);//Find the file fn in the path and its parent paths
char*           findArgV(char *bstr, char mk=0);        //Returns pointer to the _argv begining with bstr. If not found and mk!=0, _argv is aded, overwise null is returned 
void            EnvVar(char *name, char *value);        //sets an enviroment variable
char            setPath(char *p);                       //Adds p to PATH enviroment variable
char            copyfile(char *dest, char *src);
char            CopyFile(AnsiString dest, AnsiString src);
AnsiString      getTimeStr(TDateTime t); // Returns the current time + 1 min (hh:mm)

char*           CharAlloc(int nBytes, void* OldMem=NULL);
char*           CharFree(void* Mem);

AnsiString      FindTcm(char *t);                       //Looks for file t and gives its path
char            setTcmDirs(char *exename);
//---------------------------------------------------------------------------
#include "u_tcm.cpp"
#endif
