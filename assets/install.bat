echo off
REM Multi-Disk install, part 1.
cls

if %0==a:install goto adrive
if %0==A:install goto adrive
if %0==A:INSTALL goto adrive
if %0==b:install goto bdrive
if %0==B:install goto bdrive
if %0==B:INSTALL goto bdrive
if %0==install goto doinstall
if %0==INSTALL goto doinstall
echo Please switch to the drive you wish to install from before
echo starting install.  For example, to install from the B: drive,
echo Enter         B:
echo Then enter    INSTALL %1
goto End

:adrive
a:
goto doinstall

:bdrive
b:
goto doinstall

:doinstall

if "%1"=="" goto DriveNeeded
if %1==c: goto MakeDir
if %1==C: goto MakeDir
if %1==d: goto MakeDir
if %1==D: goto MakeDir
if %1==e: goto MakeDir
if %1==E: goto MakeDir
if %1==f: goto MakeDir
if %1==F: goto MakeDir
if %1==g: goto MakeDir
if %1==G: goto MakeDir
if %1==h: goto MakeDir
if %1==H: goto MakeDir
if %1==i: goto MakeDir
if %1==I: goto MakeDir
if %1==j: goto MakeDir
if %1==J: goto MakeDir
if %1==k: goto MakeDir
if %1==K: goto MakeDir
if %1==l: goto MakeDir
if %1==L: goto MakeDir
if %1==m: goto MakeDir
if %1==M: goto MakeDir
if %1==n: goto MakeDir
if %1==N: goto MakeDir
if %1==o: goto MakeDir
if %1==O: goto MakeDir
if %1==p: goto MakeDir
if %1==P: goto MakeDir

:InvalidDrive
echo "%1" is an invalid drive name.  Please use the drive's letter
echo followed by a colon:
goto Example

:DriveNeeded
echo Please specify which drive to install "Monkey Island" on, for example:
:Example
echo 
echo         install c:
goto End

:MakeDir
echo ���������������������������������������������������������������ͻ
echo �                                                               �
echo �                         MONKEY ISLAND                         �
echo �                                                               �
echo �                   Hard Disk Install Utility                   �
echo �                                                               �
echo �                                                               �
echo � This program will install all files into a directory          �
echo � called "MONKEY" on drive %1.  If you do not wish to do this,  �
echo � then press Ctrl-C now.                                        �
echo �                                                               �
echo ���������������������������������������������������������������ͼ
echo 
pause
echo 

if exist %1\MONKEY\*.* goto DirExists
mkdir %1\MONKEY
goto CopyFiles

:DirExists
echo WARNING:  The directory %1\MONKEY already exists. Press Ctrl-C now if
echo           you don't want to overwrite the contents of that directory.
echo 
pause
echo 

:CopyFiles
echo Copying "Disk 1" files to %1\MONKEY...
copy *.* %1\MONKEY > NUL

if not exist %1\MONKEY\monkey.exe goto InstallError
if not exist %1\MONKEY\_install.bat goto InstallError

%1\MONKEY\_install %1

goto End

:InstallError
echo ERROR:  Installation of "Monkey Island" into %1\MONKEY was unsuccessful.  This might
echo         be because your hard disk is full.  "Monkey Island" needs at least 2,880K of
echo         free disk space.
:End
echo 
