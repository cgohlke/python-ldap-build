:: Download and build OpenLDAP
@echo on
setlocal

:: set OPENLDAP_VER=openldap-2.5.16
:: set VS_PLATFORM=x64

curl -L -o %OPENLDAP_VER%.tgz https://www.openldap.org/software/download/OpenLDAP/openldap-release/%OPENLDAP_VER%.tgz
if errorlevel 1 exit /B 1

tar -xf %OPENLDAP_VER%.tgz
if errorlevel 1 exit /B 1

git apply -p1 --verbose --directory=%OPENLDAP_VER% openldap.diff
if errorlevel 1 exit /B 1

cd %OPENLDAP_VER%
if errorlevel 1 exit /B 1

xcopy include ..\include\ /E /H /C /R /Q /Y
if errorlevel 1 exit /B 1

set INCLUDE=%INCLUDE%;%~dp0\include
set LIB=%LIB%;%~dp0\lib

msbuild win32\vc17\liblber.sln /m /t:Clean;Rebuild /p:UseEnv=true /p:Configuration=Release /p:Platform=%VS_PLATFORM%
if errorlevel 1 exit /B 1

copy /Y /B Release\*.lib ..\lib
if errorlevel 1 exit /B 1

cd ..

endlocal
