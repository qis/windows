@echo off

set shell=HKCU\Software\Classes\Directory\Background\shell

if "%1"=="/U" goto remove
if "%1"=="/u" goto remove

:add

set cmdtext=Open with Console
set cmdicon=%~dp0icons\Console.ico
set cmdopen=\"%~dp0open.exe\" console

reg add "%shell%\x-console" /ve /d "%cmdtext%" /f
reg add "%shell%\x-console" /v Icon /d "%cmdicon%" /f
reg add "%shell%\x-console\command" /ve /d "%cmdopen%" /f

set wsltext=Open with Terminal
set wslicon=%~dp0icons\Terminal.ico
set wslopen=\"%~dp0open.exe\" terminal

reg add "%shell%\x-terminal" /ve /d "%wsltext%" /f
reg add "%shell%\x-terminal" /v Icon /d "%wslicon%" /f
reg add "%shell%\x-terminal\command" /ve /d "%wslopen%" /f

goto exit

:remove

reg delete "%shell%\x-console" /f
reg delete "%shell%\x-terminal" /f

:exit
