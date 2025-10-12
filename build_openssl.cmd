:: Download and build OpenSSL
@echo on
setlocal

:: set OPENSSL_VER=openssl-3.0.18
:: set OPENSSL_CONFIG=VC-WIN64A-masm
:: set PATH=%PATH%;X:\Perl\bin

curl -L -o %OPENSSL_VER%.tar.gz https://www.openssl.org/source/%OPENSSL_VER%.tar.gz
if errorlevel 1 exit /B 1

tar -xf %OPENSSL_VER%.tar.gz
if errorlevel 1 exit /B 1

git apply -p1 --verbose --directory=%OPENSSL_VER% openssl.diff
if errorlevel 1 exit /B 1

cd %OPENSSL_VER%
if errorlevel 1 exit /B 1

perl Configure %OPENSSL_CONFIG% no-shared no-makedepend no-zlib --prefix=%~dp0 --openssldir=openssl
if errorlevel 1 exit /B 1

perl configdata.pm --dump
if errorlevel 1 exit /B 1

nmake /nologo build_all_generated
if errorlevel 1 exit /B 1

nmake /nologo PERL=no-perl
if errorlevel 1 exit /B 1

nmake /nologo install_sw
if errorlevel 1 exit /B 1

nmake /nologo install_ssldirs
if errorlevel 1 exit /B 1

cd ..

endlocal