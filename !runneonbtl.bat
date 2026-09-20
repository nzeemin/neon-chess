@echo off
set rt11dsk=C:\bin\rt11dsk

del x-neonbtl\System.dsk
@if exist "x-neonbtl\System.dsk" (
  echo.
  echo ####### FAILED to delete old disk image file #######
  exit /b
)
copy x-neonbtl\SystemOrig.dsk chess.dsk
%rt11dsk% a chess.dsk CHESS.SAV
move chess.dsk x-neonbtl\chess.dsk

@if not exist "x-neonbtl\chess.dsk" (
  echo ####### ERROR disk image file not found #######
  exit /b
)

start x-neonbtl\neonbtl.exe /faststart:14
