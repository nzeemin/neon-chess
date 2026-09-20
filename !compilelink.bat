@echo off
set rt11exe=C:\bin\rt11\rt11.exe

rem Define ESCchar to use in ANSI escape sequences
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESCchar=%%E"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "DATESTAMP=%YYYY%-%MM%-%DD%"
for /f %%i in ('git rev-list HEAD --count') do (set REVISION=%%i)
echo REV.%REVISION% %DATESTAMP%

echo VERSTR:	.ASCII /REV.%REVISION% %DATESTAMP%/ > VERSIO.MAC

@if exist CHESS.SAV del CHESS.SAV
@if exist MAIN.LST del MAIN.LST
@if exist MAIN.OBJ del MAIN.OBJ

%rt11exe% MACRO/LIST:DK: MAIN.MAC

for /f "delims=" %%a in ('findstr /B "Errors detected" MAIN.LST') do set "errdet=%%a"
if "%errdet%"=="Errors detected:  0" (
  echo COMPILED SUCCESSFULLY
) ELSE (
  findstr /RC:"^[ABDEILMNOPQRTUZ] " MAIN.LST
  echo ======= %errdet% =======
  exit /b
)

@if exist MAIN.MAP del MAIN.MAP
@if exist MAIN.SAV del MAIN.SAV

%rt11exe% LINK MAIN /MAP:MAIN.MAP
@if not exist MAIN.SAV (
  echo %ESCchar%[91m======= LINK FAILED =======%ESCchar%[0m
  exit /b
)

for /f "delims=" %%a in ('findstr /B "Undefined globals" MAIN.MAP') do set "undefg=%%a"
if "%undefg%"=="" (
  type MAIN.MAP
  echo.
  echo %ESCchar%[92mLINKED SUCCESSFULLY%ESCchar%[0m
) ELSE (
  echo %ESCchar%[91m======= LINK FAILED =======%ESCchar%[0m
  exit /b
)

rename MAIN.SAV CHESS.SAV
