@echo off
setlocal
set "GAME_DIR=%~dp0"
where godot >nul 2>nul
if %errorlevel%==0 (
  godot --path "%GAME_DIR%godot"
  goto :eof
)
if exist "%GAME_DIR%..\Godot_v4.7.2-stable_win64.exe" (
  "%GAME_DIR%..\Godot_v4.7.2-stable_win64.exe" --path "%GAME_DIR%godot"
  goto :eof
)
echo Godot 4 was not found on PATH or next to this project.
echo Install Godot 4.7.x, then run:  godot --path godot
