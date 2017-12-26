@echo off
REM -------------------------------------------------------------------------
REM
REM xtack - Web Development Stack for Windows, by xcentra!
REM Copyright (c) xcentra, 2014-2017 (www.xcentra.com) - https://xtack.org
REM
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program. If not, see https://www.gnu.org/licenses/
REM
REM -------------------------------------------------------------------------
REM This is a xtack system file. Please DO NOT remove it!
REM -------------------------------------------------------------------------
REM
REM Last update: 2017-10-30 00:20 CET
REM
REM Revision: r423

REM ==> Save path from which xtack was called and pushd to xtack base path:
pushd "%~dp0"

REM ==> Initial setup: Set local variable scope and try to activate Windows
REM ==> Command Extensions:
set xWinCmdExtActive=0
verify other 2>nul
setlocal enableextensions
if "%errorlevel%" == "0" set xWinCmdExtActive=1

REM ==> Set initial parameters:
set xBatRev=r423
set xCmd=%0
set xParams=%*
title xtack
set xDownloadBaseUrl=https://d.xtack.org/
set xProfiling=0
set xSilentMode=0
set xFirstRun=0
set xFunctionalityArea=Other
set xBatPhp=70
set xUCF=status
set xPingHost=www.microsoft.com
set xDebugMode=1

REM ==> Setup the xtack.bat's default logfile:
if not exist .\logs md .\logs>nul 2>nul
set xLogfile=xtack.log
del /F /Q .\logs\%xLogfile%.bak>nul 2>nul
if exist .\logs\%xLogfile% ren .\logs\%xLogfile% %xLogfile%.bak>nul 2>nul
set xLogfile=.\logs\%xLogfile%
set xLog=.\bin\wtee.exe -a %xLogfile%
set xCR=Copyright (c) xcentra, 2014-2017 (www.xcentra.com) - https://xtack.org

REM ==> Check and create important directories:
if exist .\bin goto :CHECK_7ZA
echo.
call :SHOW_XTACK_HEADER
echo INFO: xtack is not installed on its current running location:
echo %~dp0
echo.
echo Trying to install it now. Checking Internet connection. Please wait ...
echo.
echo INFO: xtack is not installed on its current running location:>> %xLogfile%
echo %~dp0>> %xLogfile%
echo.>> %xLogfile%
echo Trying to install it now. Checking Internet connection. Please wait ...>> %xLogfile%
echo.>> %xLogfile%

REM ==> Check if Internet is reachable so xtack can be installed:
ping -n 4 -w 1250 %xPingHost%>nul 2>nul
if "%errorlevel%" == "0" goto :INSTALL_XTACK_NOW
echo FATAL ERROR: xtack needs an Internet connection to be installed!
echo FATAL ERROR: xtack needs an Internet connection to be installed!>> %xLogfile%

REM ==> Remove subfolders created so far to leave current directory intact:
move /Y %xLogfile% .>nul 2>nul
rd /S /Q .\logs>nul 2>nul
goto :END3

:INSTALL_XTACK_NOW
if not exist .\tmp md .\tmp>nul 2>nul
md .\bin>nul 2>nul
md .\bin\cgi-bin>nul 2>nul
if not exist .\swu md .\swu>nul 2>nul
set xFirstRun=1
set xInstallationAborted=0
del /F /Q .\xtack_install.log>nul 2>nul

:CHECK_7ZA
REM ==> Expand xtack Runtime to secure a predictable execution environment:
if not exist .\bin\7za.exe goto :7ZA_NOT_FOUND

:CHECK_AND_EXPAND_RUNTIME
title xtack
if not exist .\bin\runtime.7z goto :RUNTIME_NOT_FOUND

REM ==> Expand xtack Runtime:
.\bin\7za.exe e -aos -y -o.\bin\ .\bin\runtime.7z *.exe *.man>nul 2>nul

REM ==> If xtack Runtime expansion successful, proceed:
if "%errorlevel%" == "0" goto :RUNTIME_EXPANSION_SUCCESSFUL

REM ==> Inform about the xtack Runtime expansion error and exit:
echo FATAL ERROR: xtack Runtime cannot be expanded. Now exiting ...
echo FATAL ERROR: xtack Runtime cannot be expanded. Now exiting ...>> %xLogfile%
goto :END3

:7ZA_NOT_FOUND
REM ==> Try to blindly download 7-Zip's 7za.exe engine:
powershell /?>.\tmp\pstmp.txt 2>&1 & del /F /Q .\tmp\pstmp.txt>nul 2>nul
if not "%errorlevel%" == "0" goto :7ZA_FATAL_ERROR
if not "%xFirstRun%" == "1" echo 7-Zip Engine not found. Trying to download it. Please wait ...
if not "%xFirstRun%" == "1" echo 7-Zip Engine not found. Trying to download it. Please wait ...>> %xLogfile%
if "%xFirstRun%" == "1" echo Downloading 7-Zip Engine. Please wait ...
if "%xFirstRun%" == "1" echo Downloading 7-Zip Engine. Please wait ...>> %xLogfile%
echo Add-Type -AssemblyName System;$d=New-Object System.Net.WebClient;$d.Headers['Xtack-Update-Package']='7-Zip Engine';$d.DownloadFile("%xDownloadBaseUrl%7za.exe",".\bin\7za.exe")>.\tmp\dwnfile.ps1
verify other 2>nul
powershell -ExecutionPolicy ByPass -File .\tmp\dwnfile.ps1>nul 2>nul
if "%errorlevel%" == "0" if exist .\bin\7za.exe goto :CHECK_AND_EXPAND_RUNTIME

:7ZA_FATAL_ERROR
REM ==> Inform about the missing xtack Runtime error and exit:
title xtack
echo FATAL ERROR: 7-Zip Engine can't be downloaded. Now exiting ...
echo FATAL ERROR: 7-Zip Engine can't be downloaded. Now exiting ...>> %xLogfile%
goto :END3

:RUNTIME_NOT_FOUND
REM ==> Try to blindly download the Runtime:
powershell /?>.\tmp\pstmp.txt 2>&1 & del /F /Q .\tmp\pstmp.txt>nul 2>nul
if not "%errorlevel%" == "0" goto :RUNTIME_FATAL_ERROR
if not "%xFirstRun%" == "1" echo xtack Runtime not found. Trying to download it. Please wait ...
if "%xFirstRun%" == "1" echo Downloading xtack Runtime. Please wait ...
echo.
if not "%xFirstRun%" == "1" echo xtack Runtime not found. Trying to download it. Please wait ...>> %xLogfile%
if "%xFirstRun%" == "1" echo Downloading xtack Runtime. Please wait ...>> %xLogfile%
echo.>> %xLogfile%
echo Add-Type -AssemblyName System;$d=New-Object System.Net.WebClient;$d.Headers['Xtack-Update-Package']='xtack Runtime';$d.DownloadFile("%xDownloadBaseUrl%runtime.7z",".\bin\runtime.7z")>.\tmp\dwnfile.ps1
verify other 2>nul
powershell -ExecutionPolicy ByPass -File .\tmp\dwnfile.ps1>nul 2>nul
if "%errorlevel%" == "0" if exist .\bin\runtime.7z goto :CHECK_AND_EXPAND_RUNTIME

:RUNTIME_FATAL_ERROR
REM ==> Inform about the missing xtack Runtime error and exit:
title xtack
echo FATAL ERROR: xtack Runtime can't be downloaded. Now exiting ...
echo FATAL ERROR: xtack Runtime can't be downloaded. Now exiting ...>> %xLogfile%
goto :END3

:RUNTIME_EXPANSION_SUCCESSFUL
del /F /Q .\bin\*.conf .\bin\*.ini .\bin\*.js .\bin\changelog.r* .\bin\pubring.gpg .\bin\LICENSE.txt>nul 2>nul

REM ==> From this point onwards, all the xtack Runtime binaries will be
REM ==> available. Now get the initial timestamp:
if "%xWinCmdExtActive%" == "1" for /f "usebackq delims=" %%i in (`.\bin\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\",systime()-2)}"`) do set xTime0=%%i
del /F /Q .\bin\runtime.man .\tmp\dwnfile.ps1>nul 2>nul

REM ==> Initialize default legacy OpMode, default root OpMode and other stuff.
REM ==> If you manually modify the default legacy OpMode or the default root
REM ==> OpMode, make sure that they are valid OpMode combinations!!!
set xLegacyOpMode=a13p54m55
set xRootDefaultOpMode=a24p70m57
set xJustShowCfg=0
set xGawk=.\bin\gawk.exe
set xDbgM=[xtack Debug Mode/
set xUpdateFromXonOrSwitch=0
set xSilentModeStatusLogged=0
set xPrerequisitesCheckDayInterval=3
set xRstatusDownloadedOk=0

REM ==> Check CLI command (first parameter passed to the script) to see
REM ==> whether xtack should be started in silent mode (ultra brief output,
REM ==> no browsers). Silent mode is only applicable to the "start", "stop"
REM ==> and "switch" commands:
echo %1|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^silent$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" set xSilentMode=1
echo %1|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(start|stop|update|switch|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :ELIGIBLE_FOR_SILENT_MODE
goto :CHECK_SILENT_MODE_TO_SKIP_HEADER

:ELIGIBLE_FOR_SILENT_MODE
echo %2|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(-s|-silent)$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" set xSilentMode=1
echo %3|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(-s|-silent)$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" set xSilentMode=1

REM ==> Check if xtack.bat self-update is in progress:
echo %~nx0-%1-%2|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(xselfupd.bat-update--selfupdate|xtack.bat-update--postupdate)$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" (
    goto :UPDATE_PERFORM_SELFUPDATE
)

:CHECK_SILENT_MODE_TO_SKIP_HEADER
REM ==> If operation made in silent mode skip the header:
if "%xFirstRun%" == "1" goto :SKIP_NORMAL_HEADER
if "%xSilentMode%" == "1" goto :SILENT_MODE_SKIP_HEADER

REM ==> If regression testing ongoing, skip initial cls:
echo %2|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^-regression$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SKIP_INITIAL_CLS
echo %3|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^-regression$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SKIP_INITIAL_CLS
echo %4|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^-regression$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SKIP_INITIAL_CLS
cls&&echo.

:SKIP_INITIAL_CLS
REM ==> Show and log the initial header and message:
call :SHOW_XTACK_HEADER

:SKIP_NORMAL_HEADER
if "%xWinCmdExtActive%" == "1" (
    echo xtack execution started on %xTime0%
    echo.
)

:SILENT_MODE_SKIP_HEADER
REM ==> Log user's invoked command:
echo xtack execution started on %xTime0%>> %xLogfile%
echo.>> %xLogfile%
echo [xtack user called command: %xCmd% %xParams%]>> %xLogfile%
echo.>> %xLogfile%
if "%xSilentMode%" == "1" echo Silent mode ON. Proceeding, please wait ...|%xLog%

:CHECK_WIN_CMD_EXTENSIONS
REM ==> Check whether Windows Command Extensions are enabled, since they are
REM ==> required beyond this point:
set xTemp=0
if "%xWinCmdExtActive%" == "1" goto :GET_XTACKBAT_REVISION_AND_LAST_UPDATE
for /f "usebackq delims=" %%i in (`echo %%SystemRoot%%^|%xGawk% "{gsub(/\\/,\"\\\\\\\\\");print $0}"`) do set xTemp=%%i
call :SHOW_MSG "ERROR: xtack can't run on this computer system as Windows Command\nExtensions are currently disabled. You can enable them by setting\nthe following Windows registry key to \0421\042:\n\n\042HKEY_CURRENT_USER\\Software\\Microsoft\\Command Processor\\EnableExtensions\042\n\nWith the Windows registry editor ^(%xTemp%\\regedit.exe^)\n\nMake sure to run it with Administrator rights, especially if User\nAccount Control ^(UAC^) is enabled in your computer. Now exiting ..."

:GET_XTACKBAT_REVISION_AND_LAST_UPDATE
REM ==> From this point forward, all features unleashed by Windows Command
REM ==> Extensions are fully available.
REM ==> Confirm/get xtack.bat revision and last update now:
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "BEGIN{IGNORECASE=1}/^REM Revision: r/{print $3}"`) do set xBatRev=%%i
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "BEGIN{IGNORECASE=1}/^REM Last update: /{print $4 \" \" $5 \" \" $6}"`) do set xBatLastUpdate=%%i

REM ==> If necessary, recreate the xtack.json and LICENSE.txt files:
if exist .\xtack.json if exist .\LICENSE.txt goto :CHECK_XTACKBAT_COMPLETENESS
call :REGENERATE_XTACKBAT_PKGJSON_AND_LICENSE

:CHECK_XTACKBAT_COMPLETENESS
REM ==> Perform a xtack.bat file completeness self-check:
type .\%~nx0|%xGawk% "BEGIN{IGNORECASE=1;l=\"\"}{if($0 !~ /^[ \t]*$/){l=$0}}END{if(l ~ /^REM -+? xtack.bat file completeness boundary -+?$/){exit 0}else{exit 1}}"
if "%errorlevel%" == "0" goto :CHECK_WIN_VER_AND_ARCH
call :SHOW_MSG "FATAL ERROR: File xtack.bat is incomplete or tampered and so it can't\nrun. Please download a fresh copy from https://xtack.org and try again.\n\nNow exiting ..." "FATAL ERROR: xtack can't run: File xtack.bat is incomplete or tampered."
call :LOG_ENTRY error "FATAL ERROR: File xtack.bat is incomplete or tampered. Now exiting."
goto :END

:CHECK_WIN_VER_AND_ARCH
REM ==> Check Microsoft Windows version and architecture:
call :GET_WINDOWS_VERSION_AND_ARCHITECTURE
if /i not "%xWinProduct%" == "Unsupported" goto :CHECK_REQUIRED_PREREQUISITES

REM ==> Show invalid Microsoft Windows version error message and exit:
call :SHOW_MSG "ERROR: xtack can't run on this system, as the system is running on an\nunsupported Windows version. xtack supports Microsoft Windows Vista,\n2008 Server, 7, 8 and 8.1. Now exiting ..." "ERROR: xtack can't run: System running on unsupported Windows version."
call :LOG_ENTRY error "Unsuccessful xtack run attempt as the system is running on an unsupported Windows version. Now exiting."
goto :END

:CHECK_REQUIRED_PREREQUISITES
REM ==> Check and eventually create/start xtack prerequisites:
if exist .\cfg goto :CHECK_DBS_DIR

REM ==> Create the .\cfg directory and all the default configuration files:
call :SHOW_MSG "Extracting default xtack configuration files from xtack Runtime ...\n"
.\bin\7za.exe e -aos -y -o.\cfg\ .\bin\runtime.7z *.conf *.ini *.js *.config>nul 2>nul
if not exist .\cfg\xtack.ini call :CREATE_DEFAULT_XTACK_INI

:CHECK_DBS_DIR
if not exist .\dbs (
    md .\dbs\m55>nul 2>nul
    md .\dbs\m57>nul 2>nul
    md .\dbs\pgs>nul 2>nul
    md .\dbs\mra>nul 2>nul
)
if not exist .\swu md .\swu>nul 2>nul

REM ==> Adjust the default PHP engine according to the root default OpMode:
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "BEGIN{IGNORECASE=1}/^set xRootDefaultOpMode=/{gsub(/set xRootDefaultOpMode=/,\"\");p=tolower(substr($0,5,2));print p}"`) do set xTemp=%%i
if not "%xTemp%" == "%xBatPhp%" set xBatPhp=%xTemp%

REM ==> Check and install all/any eventual required MS VC Redistributable
REM ==> Packages now:
call :INSTALL_ALL_REQUIRED_VC_REDISPKGS

REM ==> xtack profiling item:
if not "%xProfiling%" == "1" goto :CLI_COMMAND_DISTRIBUTION
call :TIME_DELTA "%xTime0%"
call :SHOW_MSG "PROFILING: Initial checks (including MS VC redispkgs) took %xTookStr%.\n"
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTime1=%%i

:CLI_COMMAND_DISTRIBUTION
if not exist .\docs md .\docs>nul 2>nul
if not exist .\www (
    md .\www>nul 2>nul
    md .\www\users>nul 2>nul
)

REM ==> If not xtack.bat's first run, jump to check if help page needed:
if not "%xFirstRun%" == "1" goto :CHECK_HELP
call :SHOW_MSG "Checking autenticity of xtack's initial installation. Please wait ...\n"

REM ==> Try to validate SHA512 checksums and PGP file signatures for
REM ==> the initial xtack installation set (xtack.bat, 7za.exe and
REM ==> the xtack runtime.
REM ==> First, and if not already done while checking prerequisites,
REM ==> download the online update status information file now:
if exist .\swu\rstatus.txt goto :CHECK_THAT_XTACKBAT_IS_LATEST_AVAILABLE_REVISION
del /F /Q .\swu\status .\swu\status.txt .\swu\rstatus.txt>nul 2>nul
call :DOWNLOAD_UCF
ren .\swu\%xUCF% rstatus.txt>nul 2>nul
if "%xTemp%" == "0" goto :CHECK_THAT_XTACKBAT_IS_LATEST_AVAILABLE_REVISION
call :SHOW_MSG "WARNING: Autenticity check for xtack's initial installation (SHA512\nchecksum and PGP signature validation) can't be performed right now.\n"
call :LOG_ENTRY warning "Autenticity check for xtack's initial installation (SHA512 checksum and PGP signature validation for files xtack.bat, 7za.exe and runtime.7z) can't be performed right now as the online update status information file can't be currently accessed at URL %xDownloadBaseUrl%%xUCF%. Please check. Now exiting."

REM ==> Jump to initial total system update:
goto :PERFORM_XTACK_UPDATE

:CHECK_THAT_XTACKBAT_IS_LATEST_AVAILABLE_REVISION
REM ==> Perform last-minute check to secure that the xtack.bat
REM ==> revision that will be instaled is the latest one (older
REM ==> revision installation previention):
for /f "usebackq delims=" %%i in (`type .\swu\rstatus.txt^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 !~ /(^^[ \t]*#|^$)/ && ($1\" \"$2) ~ /xtackbat xtack\.bat/){print $3}}"`) do set xTemp=%%i
if /i "%xTemp%" == "%xBatRev%" goto :INSTALL_AUTENTICITY_CHECK
call :SHOW_MSG "ERROR: You are trying to install an outdated xtack.bat revision (%xBatRev%).\nPlease download the latest one (%xTemp%) from %xDownloadBaseUrl%xtack.bat\nand try again. Now exiting ..."
goto :UPDATE_DELETE_XTACK_INSTALLATION_FILES

:INSTALL_AUTENTICITY_CHECK
REM ==> Proceed with the autenticity check:
type .\swu\rstatus.txt|%xGawk% "BEGIN{IGNORECASE=1}{if($0 !~ /(^^[ \t]*#|^$)/ && ($1\" \"$2) ~ /(7za 7-Zip|runtime Runtime|xtackbat xtack\.bat)/ && $6 ~ /[a-f0-9]{128}/){gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(/[ \t]+/,\" \");print $2\" \"$6}}">.\tmp\xtacktmp1.txt
type .\tmp\xtacktmp1.txt|%xGawk% "BEGIN{IGNORECASE=1}/xtack\.bat/{print $0}">.\tmp\autenticity.txt
type .\tmp\xtacktmp1.txt|%xGawk% "BEGIN{IGNORECASE=1}/7-Zip/{print $0}">>.\tmp\autenticity.txt
type .\tmp\xtacktmp1.txt|%xGawk% "BEGIN{IGNORECASE=1}/Runtime/{print $0}">>.\tmp\autenticity.txt

REM ==> Reset components check counter:
set xComponentsCounter=0

:INSTALL_AUTENTICITY_CHECK_LOOP
REM ==> Execute the autenticity loop:
set /a xComponentsCounter+=1

REM ==> Get install component information:
for /f "usebackq delims=" %%i in (`type .\tmp\autenticity.txt^|%xGawk% "{if(NR==%xComponentsCounter%){print $0}}"`) do set xFileName=%%i
for /f "usebackq delims=" %%i in (`echo %xFileName%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"7-Zip\",\"7-Zip Engine\",$1);gsub(\"Runtime\",\"xtack Runtime\",$1);print $1}"`) do set xTitle=%%i
for /f "usebackq delims=" %%i in (`echo %xFileName%^|%xGawk% "BEGIN{IGNORECASE=1}{if($2 ~ /[a-f0-9]{128}/){print $2}else{print \"z\"}}"`) do set xSha512=%%i
for /f "usebackq delims=" %%i in (`echo %xFileName%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"xtack.bat\",\"xtack.sig\",$1);gsub(\"7-Zip\",\"7za.sig\",$1);gsub(\"Runtime\",\"runtime.sig\",$1);print $1}"`) do set xPgpSignature=%%i
set xTemp=%~dp0
set xTemp=%xTemp:\=\\%
for /f "usebackq delims=" %%i in (`echo %xFileName%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"xtack.bat\",\"%xTemp%xtack.bat\",$1);gsub(\"7-Zip\",\"%xTemp%bin\\7za.exe\",$1);gsub(\"Runtime\",\"%xTemp%bin\\runtime.7z\",$1);print $1}"`) do set xFileName=%%i
call :GET_FILE_SHA512 "%xFileName%"
if /i not "%xTemp%" == "%xSha512%" goto :INSTALL_AUTENTICITY_CHECK_FAILURE_SHA512

REM ==> Download and verify the component's PGP file signature:
del /F /Q .\bin\%xSha512%.sig .\%xSha512%.sig .\xtack.sig .\bin\7za.sig .\bin\runtime.sig>nul 2>nul
call :DOWNLOAD_FILE "%xTitle% PGP Signature" "%xDownloadBaseUrl%%xPgpSignature%" "%~dp0bin\" 0 1 1 "TLSv1"
if not "%xTemp%" == "0" goto :INSTALL_AUTENTICITY_CHECK_FAILURE_PGP_DOWNLOAD

REM ==> Adjust PGP signature file's name/location for xtack.bat:
if /i "%xTitle%" == "xtack.bat" move /Y .\bin\xtack.sig .\xtack.sig>nul 2>nul

call :VERIFY_PGP_SIGNATURE "%xFileName%"
if not "%xTemp%" == "0" goto :INSTALL_AUTENTICITY_CHECK_FAILURE_PGP_VERIFICATION

call :SHOW_MSG "INFO: SHA512 and PGP signature verified OK for %xTitle%  :-)"
if %xComponentsCounter% LSS 3 goto :INSTALL_AUTENTICITY_CHECK_LOOP

REM ==> Jump to initial total system update:
del /F /Q .\xtack.sig .\bin\*.sig .\*.sig>nul 2>nul
echo.|%xLog%
goto :PERFORM_XTACK_UPDATE

:INSTALL_AUTENTICITY_CHECK_FAILURE_SHA512
call :SHOW_MSG "WARNING: Autenticity check verification failed for component %xTitle%:\nWrong SHA512 checksum.\n"
call :LOG_ENTRY warning "Autenticity check verification failed for component %xTitle% upon xtack initial installation (expected SHA512 checksum = %xSha512%; measured SHA512 checksum for file %xFileName% = %xTemp%). Please check."
goto :INSTALL_AUTENTICITY_CHECK_LOOP_CHECK

:INSTALL_AUTENTICITY_CHECK_FAILURE_PGP_DOWNLOAD
call :SHOW_MSG "WARNING: Autenticity check verification failed for component %xTitle%:\nPGP component file signature could not be downloaded.\n"
call :LOG_ENTRY warning "Autenticity check verification failed for component %xTitle% upon xtack initial installation: PGP component file signature could not be downloaded from URL %xDownloadBaseUrl%%xPgpSignature%. Please check."
goto :INSTALL_AUTENTICITY_CHECK_LOOP_CHECK

:INSTALL_AUTENTICITY_CHECK_FAILURE_PGP_VERIFICATION
call :SHOW_MSG "WARNING: Autenticity check verification failed for component %xTitle%:\nWrong PGP component file signature.\n"
call :LOG_ENTRY warning "Autenticity check verification failed for component %xTitle% upon xtack initial installation: Wrong PGP component file signature. Please check."

:INSTALL_AUTENTICITY_CHECK_LOOP_CHECK
if %xComponentsCounter% LSS 3 goto :INSTALL_AUTENTICITY_CHECK_LOOP

REM ==> Jump to initial total system update:
goto :PERFORM_XTACK_UPDATE

:CHECK_HELP
REM ==> If xtack invoked with an empty command, catch it early and redirect
REM ==> to the help page:
if /i "%1" == "" goto :HELPTXT

REM ==> Main xtack command distribution code:

REM ==> Scan command for xtack startup:
echo %1|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(start|silent|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :INITIATE_XTACK_STARTUP

REM ==> Scan command for xtack shutdown:
if /i "%1" == "stop" goto :INITIATE_XTACK_STOP

REM ==> Scan command for showing software versions:
if /i "%1" == "ver" goto :PRINT_XTACK_VER

REM ==> Scan command for xtack switch:
if /i "%1" == "switch" goto :INITIATE_XTACK_SWITCHOVER

REM ==> Scan command for opening update web pages:
if /i "%1" == "update" goto :PERFORM_XTACK_UPDATE

REM ==> Scan command for xtack status:
if /i "%1" == "status" goto :CHECK_XTACK_STATUS

REM ==> Scan command for showing configuration in xtack.ini:
if /i "%1" == "config" goto :FLAG_FOR_SHOWING_XTACK_INI_CONFIG

REM ==> Scan command for xtack status:
if /i "%1" == "docs" goto :DOWNLOAD_XTACK_DOCS

REM ==> Scan command for cleaning up for previous xtack runs:
if /i "%1" == "clean" goto :PERFORM_XTACK_CLEANUP

REM ==> Scan command for cleaning up for previous xtack runs:
if /i "%1" == "install" goto :CHECK_XTACK_INSTALLATION

REM ==> Scan if user requested execution of Composer:
if /i "%1" == "changelog" goto :OPEN_XTACK_CHANGELOG

REM ==> Scan if user requested execution of Composer:
if /i "%1" == "composer" goto :EXECUTE_XTACK_COMPOSER

REM ==> Scan if user requested execution of PHP_CodeSniffer:
if /i "%1" == "phpcs" goto :EXECUTE_XTACK_PHPCS
if /i "%1" == "phpcbf" goto :EXECUTE_XTACK_PHPCS

REM ==> Scan if user requested execution of PHPUnit:
if /i "%1" == "phpunit" goto :EXECUTE_XTACK_PHPUNIT

REM ==> Scan if user requested execution of npm:
if /i "%1" == "npm" goto :EXECUTE_XTACK_NPM

REM ==> Scan if user requested execution of Bower:
if /i "%1" == "bower" goto :EXECUTE_XTACK_BOWER

REM ==> Scan if user requested execution of PHPMD:
if /i "%1" == "phpmd" goto :EXECUTE_XTACK_PHPMD

REM ==> Scan if user requested execution of PHPMD:
if /i "%1" == "pgp" goto :PRINT_XTACK_PGP_INFO

REM ==> Scan command for xtack regression, test all modes testing:
if /i "%1" == "regression" goto :INITIATE_XTACK_REGRESSION

REM ==> redirect all remaining command combinations to the help page:
REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: xtack help page handling.
REM -------------------------------------------------------------------------

:HELPTXT
set xFunctionalityArea=Help

REM ==> Show the help page and finish:
type .\bin\xtack.man|%xGawk% "{if(NR>2){print $0}}"|%xLog%|more
goto :END

:HELP_FOR_XTACK_START
set xFunctionalityArea=Help

REM ==> Show the "xtack start" help page and finish:
echo xtack start command syntax:|%xLog%
echo.|%xLog%
type .\bin\xtack.man|%xGawk% "{if((NR>14&&NR<63)||(NR>152&&NR<156)){print $0}}"|%xLog%|more
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Flag just to show current configuration.
REM -------------------------------------------------------------------------

:FLAG_FOR_SHOWING_XTACK_INI_CONFIG
REM ==> Update logfile settings:
set xFunctionalityArea=Config
call :REFRESH_LOGFILE "xtack_config"

REM ==> If xtack is being run just to show the current configuration, jump
REM ==> to xtack.ini parsing:
set xJustShowCfg=1
echo Running xtack just to show the current configuration in xtack.ini ...|%xLog%
echo.|%xLog%
goto :XON_FILTER_AND_CACHE_XTACK_INI

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Perform cleanup of any eventual xtack leftovers.
REM -------------------------------------------------------------------------

:PERFORM_XTACK_CLEANUP
REM ==> Update logfile settings:
set xFunctionalityArea=Cleanup
call :REFRESH_LOGFILE "xtack_clean"

echo Cleaning up any eventual xtack leftovers ...|%xLog%

REM ==> If xtack isn't running, delete all temporary files possibly created
REM ==> during xtack startup:
if not exist .\bin\xtack.lck (
    call :PERFORM_FINAL_CLEANUP
    if /i not "%2" == "-regression" call :PERFORM_FINAL_REGRESSION_TESTING_CLEANUP
)

REM ==> If "clean" command complemented with "-l" switch, also delete the
REM ==> xtack control file (.\bin\xtack.lck):
if /i "%2" == "-l" del /F /Q .\bin\xtack.lck>nul 2>nul

REM ==> If "clean" command complemented with "-L" switch, delete also contents
REM ==> of the .\swu\backup directory and the MySQL/MariaDB cache files:
if "%2" == "-L" (
    if exist .\swu\backup\ rd /S /Q .\swu\backup\>nul 2>nul
    md .\swu\backup>nul 2>nul
    del /F /Q .\dbs\m55\ib_logfile* .\dbs\m55\ibdata1 .\dbs\m57\ib_logfile* .\dbs\m57\ibdata1 .\dbs\m57\ibtmp1 .\dbs\m57\ib_buffer_pool .\dbs\m57\auto.cnf>nul 2>nul
    del /F /Q .\dbs\mra\ib_logfile* .\dbs\mra\ibdata1 .\dbs\mra\ibtmp1 .\dbs\mra\ib_buffer_pool .\dbs\mra\aria_log*.* .\dbs\mra\mysql-bin*.* .\dbs\mra\multi-master.info>nul 2>nul
)

goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Show xtack software versions.
REM -------------------------------------------------------------------------

:PRINT_XTACK_VER
REM ==> Update logfile settings:
set xFunctionalityArea=Versions
call :REFRESH_LOGFILE "xtack_ver"

REM ==> If missing MS VC Redistributable Packages, show/log error and exit:
if %xNoOfMissingRedisPkgs% GEQ 4 goto :VER_END

REM ==> Check if long printout format requested:
if "%2" == "-l" goto :VER_CALL_SHOW_SW_VERSIONS_LONG
if "%2" == "-L" goto :VER_CALL_SHOW_SW_VERSIONS_LONGER
call :SHOW_SW_VERSIONS_SHORT

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing short versions summary" 1 0
goto :VER_END

:VER_CALL_SHOW_SW_VERSIONS_LONG
call :SHOW_SW_VERSIONS_LONG

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing long versions summary" 1 0
goto :VER_END

:VER_CALL_SHOW_SW_VERSIONS_LONGER
call :SHOW_SW_VERSIONS_LONGER

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing longer versions summary" 1 0

:VER_END
REM ==> If applicable, check for xtack component updates:
call :CREATE_INSTALLED_COMPONENTS_LIST
call :CHECK_FOR_AVAILABLE_UPDATES
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: xtack startup.
REM -------------------------------------------------------------------------

:INITIATE_XTACK_STARTUP
REM ==> Update logfile settings:
set xFunctionalityArea=Start
call :REFRESH_LOGFILE "xtack_start"

REM ==> If debug mode enabled, log it:
call :LOG_SILENT_MODE_STATUS

REM ==> Check whether any required xtack configuration files are missing:
set xMissingCfgFiles=empty
if not exist .\cfg\xtack.ini set xMissingCfgFiles=%xMissingCfgFiles%, xtack.ini
if not exist .\cfg\apache13.conf set xMissingCfgFiles=%xMissingCfgFiles%, apache13.conf
if not exist .\cfg\apache24.conf set xMissingCfgFiles=%xMissingCfgFiles%, apache24.conf
if not exist .\cfg\nginx.conf set xMissingCfgFiles=%xMissingCfgFiles%, nginx.conf
if not exist .\cfg\nodejs.js set xMissingCfgFiles=%xMissingCfgFiles%, nodejs.js
if not exist .\cfg\iis.config set xMissingCfgFiles=%xMissingCfgFiles%, iis.config
if not exist .\cfg\php52.ini set xMissingCfgFiles=%xMissingCfgFiles%, php52.ini
if not exist .\cfg\php53.ini set xMissingCfgFiles=%xMissingCfgFiles%, php53.ini
if not exist .\cfg\php54.ini set xMissingCfgFiles=%xMissingCfgFiles%, php54.ini
if not exist .\cfg\php55.ini set xMissingCfgFiles=%xMissingCfgFiles%, php55.ini
if not exist .\cfg\php56.ini set xMissingCfgFiles=%xMissingCfgFiles%, php56.ini
if not exist .\cfg\php70.ini set xMissingCfgFiles=%xMissingCfgFiles%, php70.ini
if not exist .\cfg\php71.ini set xMissingCfgFiles=%xMissingCfgFiles%, php71.ini
if not exist .\cfg\php72.ini set xMissingCfgFiles=%xMissingCfgFiles%, php72.ini
if not exist .\cfg\mysql55.ini set xMissingCfgFiles=%xMissingCfgFiles%, mysql55.ini
if not exist .\cfg\mysql57.ini set xMissingCfgFiles=%xMissingCfgFiles%, mysql57.ini
if not exist .\cfg\mariadb.ini set xMissingCfgFiles=%xMissingCfgFiles%, mariadb.ini
if not exist .\cfg\postgresql.conf set xMissingCfgFiles=%xMissingCfgFiles%, postgresql.conf
if not exist .\cfg\pma.ini set xMissingCfgFiles=%xMissingCfgFiles%, pma.ini
if not exist .\cfg\pga.ini set xMissingCfgFiles=%xMissingCfgFiles%, pga.ini
if not exist .\cfg\gpg.conf set xMissingCfgFiles=%xMissingCfgFiles%, gpg.conf
if not exist .\cfg\pubring.gpg set xMissingCfgFiles=%xMissingCfgFiles%, pubring.gpg
if /i "%xMissingCfgFiles%" == "empty" goto :XON_GET_CLI_OPMODE
if not "%xSilentMode%" == "1" goto :XON_WARN_ABOUT_MISSING_CONFIGURATION_FILES
for /f "usebackq delims=" %%i in (`echo %xMissingCfgFiles%^|%xGawk% "BEGIN{IGNORECASE=1}/, /{}END{print NF-1}"`) do set xNoOfMissingCfgFiles=%%i
echo ERROR: xtack can't run: %xNoOfMissingCfgFiles% xtack configuration files are missing.|%xLog%
call :LOG_ENTRY error "xtack can't be started as %xNoOfMissingCfgFiles% required configuration file(s) (%xMissingCfgFiles%) are missing and silent mode has been requested. Now exiting."
goto :XON_END

:XON_WARN_ABOUT_MISSING_CONFIGURATION_FILES
REM ==> Remove "empty," from the beginning of the string containing the
REM ==> list of missing files:
for /f "usebackq delims=" %%i in (`echo %xMissingCfgFiles%^|%xGawk% "{gsub(/(empty |\t*$)/,\"\");print $0}"`) do set xMissingCfgFiles=%%i

REM ==> Split the list of missing configuration files, save it to a temporary
REM ==> file and count them:
echo %xMissingCfgFiles%|%xGawk% "{gsub(/ /,\"\n\")};1">.\tmp\xtacktmp1.txt
for /f "usebackq delims=" %%i in (`type .\tmp\xtacktmp1.txt^|%xGawk% "END{print NR}"`) do set xNoOfMissingCfgFiles=%%i

REM ==> One or more required xtack configuration files were found to be
REM ==> missing. Ask the user whether to recover them from the default
REM ==> ones in the xtack Runtime:
call :SHOW_MSG "WARNING: %xNoOfMissingCfgFiles% required xtack configuration file(s) are missing:\n%xMissingCfgFiles%\n"

REM ==> Ask the user whether he/she wants to restore configuration files from
REM ==> the default ones now:
call :ASK_USER_YES_NO_QUESTION "Do you want to restore them from their default versions now" 1
if /i "%xTemp%" == "Y" goto :XON_YES_RESTORE_FROM_DEFAULTS

REM ==> The user refused to restore the configuration files:
echo.|%xLog%
echo OK, thanks, now exiting without starting up xtack ...|%xLog%
for /f "usebackq delims=" %%i in (`echo %xMissingCfgFiles%^|%xGawk% "{gsub(/(empty |\t*$)/,\"\");print $0}"`) do set xMissingCfgFiles=%%i
call :LOG_ENTRY error "xtack can't be started as %xNoOfMissingCfgFiles% required configuration file(s) (%xMissingCfgFiles%) are missing but the user refused to restore them from defaults. Now exiting."
goto :XON_END

:XON_YES_RESTORE_FROM_DEFAULTS
REM ==> The user accepted to restore the configuration files:
echo.|%xLog%
echo OK thanks, the %xNoOfMissingCfgFiles% missing configuration file(s) will now be restored:|%xLog%

REM ==> Reset counter for number of recovered configuration files and proceed:
set xNoOfRecoveredCfgFiles=0
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\runtime.7z *.conf *.ini *.js>nul 2>nul
if "%errorlevel%" == "0" goto :XON_RESTORE_FROM_DEFAULTS_LOOP
echo ERROR: xtack default configuration files can't be retrieved. Now exiting ...|%xLog%
call :LOG_ENTRY error "xtack can't be started as default configuration files can't be retrieved from the xtack Runtime. Now exiting."
goto :XON_END

:XON_RESTORE_FROM_DEFAULTS_LOOP
REM ==> Remove unneeded non configuration files also expanded from the
REM ==> xtack Runtime:
del /F /Q .\tmp\*.exe .\tmp\*.man .\tmp\changelog.r* .\tmp\LICENSE.txt>nul 2>nul

REM ==> Loop to restore each missing configuration file:
for /f "usebackq delims=" %%i in (`type .\tmp\xtacktmp1.txt`) do (
    set xTemp=%%i
    setlocal enabledelayedexpansion
    echo Restoring missing configuration file !xTemp! from defaults ...| .\bin\wtee.exe -a !xLogfile!
    move /Y .\tmp\!xTemp! .\cfg\>nul 2>nul
    if !errorlevel! EQU 0 (
        endlocal
        set /a xNoOfRecoveredCfgFiles+=1
        setlocal enabledelayedexpansion
        echo Configuration file .\cfg\!xTemp! successfully recovered.| .\bin\wtee.exe -a !xLogfile!
    ) else (
        echo ERROR: Configuration file .\cfg\!xTemp!| .\bin\wtee.exe -a !xLogfile!
        echo could not be recovered.| .\bin\wtee.exe -a !xLogfile!
    )
    echo.| .\bin\wtee.exe -a !xLogfile!
    endlocal
)

REM ==> If not all the missing configuration files could be restored
REM ==> from defaults, show and log error and exit, otherwise proceed:
if /i "%xNoOfRecoveredCfgFiles%" == "%xNoOfMissingCfgFiles%" (
    echo The %xNoOfMissingCfgFiles% configuration file^(s^) originally missing have been successfully|%xLog%
    echo restored from defaults. Now proceeding ...|%xLog%
    echo.|%xLog%
    call :LOG_ENTRY error "%xNoOfMissingCfgFiles% required configuration file(s) (%xMissingCfgFiles%) were missing during xtack startup, but they were successfully restored from defaults. Now proceeding."
) else (
    echo Not all the %xNoOfMissingCfgFiles% configuration files originally|%xLog%
    echo missing could have been successfully restored from defaults.|%xLog%
    echo In this condition, xtack can't be started. Now exiting ...|%xLog%
    for /f "usebackq delims=" %%i in (`echo %xMissingCfgFiles%^|%xGawk% "{gsub(/empty, /,\"\");print $0}"`) do set xMissingCfgFiles=%%i
    call :LOG_ENTRY error "xtack can't be started as %xNoOfMissingCfgFiles% required configuration file(s) (%xMissingCfgFiles%) were missing during xtack startup, but only %xNoOfRecoveredCfgFiles% of could be restored from defaults. Now exiting."
    goto :XON_END
)

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Restoring missing configuration files" 0 1

:XON_GET_CLI_OPMODE
REM ==> Detect and handle "direct OpMode as xtack command" invocations:
for /f "usebackq delims=" %%i in (`echo %1^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(start|silent|switch)$/{i++;print\"%2\"}END{if(i==0){print\"%1\"}}"`) do set xCliOpMode=%%i

REM ==> Detect flag to start IDE on top of the rest of URLs requested
REM ==> in xtack.ini's BrowserURL configuration setting:
for /f "usebackq delims=" %%i in (`echo %1^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(start|silent|switch)$/{i++;ideFlag=\"%3\"}END{if(i==0){ideFlag=\"%2\"};if(ideFlag ~ /-(i|I)/){print 1}else{print 0}}"`) do set xIdeFlag=%%i
if /i "%1" == "switch" set xIdeFlag=0

REM ==> Set user requested OpMode (including detection of "empty" CLI ones):
for /f "usebackq delims=" %%i in (`echo %xCliOpMode%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(ECHO is o(n|ff)\.|-regression)$/{i++;{print \"none\"}}END{if(i==0){gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}}"`) do set xCliOpMode=%%i

REM ==> Validate the requested CLI OpMode. If an invalid OpMode is requested,
REM ==> show OpMode error message and exit:
echo %xCliOpMode%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(none|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :XON_CHECK_IF_PREVIOUS_XTACK_INSTANCES_ARE_RUNNING

REM ==> An invalid CLI OpMode has been requested. Show invalid OpMode error
REM ==> message and redirect user to the help "xtack start" page:
call :LOG_ENTRY error "Unsuccessful xtack startup attempt in unsupported CLI OpMode '%xCliOpMode%'. Now exiting."
if "%xSilentMode%" == "1" goto :XON_SILENT_UNSUPPORTED_OPMODE
call :SHOW_MSG "ERROR: Sorry, but the Operating Mode requested through the CLI\n^(\042%xCliOpMode%\042^) is not supported by xtack. Now exiting ...\n"
goto :HELP_FOR_XTACK_START

:XON_SILENT_UNSUPPORTED_OPMODE
echo ERROR: xtack can't run: Unsupported OpMode "%xCliOpMode%".|%xLog%
goto :XON_END

:XON_CHECK_IF_PREVIOUS_XTACK_INSTANCES_ARE_RUNNING
REM ==> Check pre-existing, currently running instances of xtack.
REM ==> They are detected through the presence of file .\bin\xtack.lck:
if not exist .\bin\xtack.lck goto :XON_FILTER_AND_CACHE_XTACK_INI
call :SHOW_MSG "ERROR: xtack is already running on this system. Please shut it down\nand try again or switch to another Operating Mode. Now exiting ..." "ERROR: xtack is already running on this system."
call :LOG_ENTRY error "Unsuccessful xtack startup attempt: already running. Now exiting."
goto :XON_END

:XON_FILTER_AND_CACHE_XTACK_INI
set xFunctionalityArea=Start

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Startup initial preparations" 0 1

REM ==> Filter + cache xtack.ini configuration settings for quicker parsing:
call :FILTER_AND_CACHE_XTACK_INI

REM ==> Check whether xtack should be run in "debug mode" to log and print
REM ==> additional helpful information:
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*DebugMode[ \t]*=[ \t]*(1|Yes|True|On|Enabled)[ \t]*$/{i++;if(i<2){print \"1\"}}END{if(i==0){print \"0\"}}"`) do set xDebugMode=%%i

REM ==> Check and map the CLI "legacy" OpMode keyword to the actual legacy
REM ==> OpMode configured:
if /i not "%xCliOpMode%" == "legacy" goto :XON_PARSE_XTACK_INI
for /f "usebackq delims=" %%i in (`echo %xLegacyOpMode%^|%xGawk% "END{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xCliOpMode=%%i
call :LOG_ENTRY info "xtack legacy CLI OpMode request mapped to OpMode %xCliOpMode% during xtack startup."
call :SHOW_MSG "INFO: Originally requested CLI legacy Operating Mode mapped to %xCliOpMode%\n"

:XON_PARSE_XTACK_INI
REM ==> Reset browser startup flags (used latter):
set xStartFirefox=0&set xStartOpera=0&set xStartSafari=0&set xStartChrome=0&set xStartMsie=0&set xStartEdge=0

REM ==> Extract and pre-validate variables from the configuration cache file.
REM ==> Only the first match is considered:
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*DefaultOpMode[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*DefaultOpMode[ \t]*=[ \t]*|[ \t]*$)/,\"\");if($0 ~ /^^(legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/){print toupper($0)}else{print toupper($0) \" ^(INVALID MODE!^)\"}}}END{if(i==0){print \"Not set\"}}"`) do set xIniOpMode=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*VerboseDbServer[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*VerboseDbServer[ \t]*=[ \t]*|[ \t]*$)/,\"\");gsub(/^^(1|Yes|True|On|Enabled)$/,\"Yes\");gsub(/^^(0|No|False|Off|Disabled)$/,\"No\");if($0 ~ /^(Yes|No)$/){print $0}else{print $0 \" ^(INVALID SETTING^, defaults to Off^)\"}}}END{if(i==0){print \"Not set\"}}"`) do set xVerboseDbServer=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*KillExistingServers[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*KillExistingServers[ \t]*=[ \t]*|[ \t]*$)/,\"\");gsub(/^^(1|Yes|True|On|Enabled)$/,\"Yes\");gsub(/^^(0|No|False|Off|Disabled)$/,\"No\");if($0 ~ /^(Yes|No)$/){print $0}else{print $0 \" ^(INVALID SETTING^, defaults to Off^)\"}}}END{if(i==0){print \"Not set\"}}"`) do set xKillExistingServers=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*KillExistingBrowsers[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*KillExistingBrowsers[ \t]*=[ \t]*|[ \t]*$)/,\"\");gsub(/^^(1|Yes|True|On|Enabled)$/,\"Yes\");gsub(/^^(0|No|False|Off|Disabled)$/,\"No\");if($0 ~ /^(Yes|No)$/){print $0}else{print $0 \" ^(INVALID SETTING^, defaults to Off^)\"}}}END{if(i==0){print \"Not set\"}}"`) do set xKillExistingBrowsers=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*StartBrowsers[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*StartBrowsers[ \t]*=[ \t]*|[ \t]*[,]?$)/,\"\");gsub(/(MSIE|IE|(Microsoft ?)?Internet ?Explorer)/,\"MSIE\");gsub(/[ \t]*[,][ \t]*/,\"^,\");if($0 ~ /^^(0|None|No|False|Off|Disabled|((Firefox|MSIE|Edge|Opera|Safari|Chrome)+)(,(Firefox|MSIE|Edge|Opera|Safari|Chrome))*?)$/){print $0}else{print $0 \" ^(INVALID SETTING^, defaults to None^)\"}}}END{if(i==0){print \"Not set\"}}"`) do set xStartBrowsers=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*BrowserURL[ \t]*=[ \t]*/{i++;if(i<2){gsub(/([ \t]*BrowserURL[ \t]*=[ \t]*|[ \t]*$)/,\"\");print $0}}END{if(i==0){print \"Not set\"}}"`) do set xBrowserURL=%%i

REM ==> If not in silent mode, show the configuration settings detected in
REM ==> xtack.ini:
if "%xSilentMode%" == "1" goto :XON_SILENT_SKIP_SHOWING_XTACK_INI_SETTINGS

echo x|%xGawk% "END{print \"Generic configuration settings found in xtack.ini:\n\nDefaultOpMode        : %xIniOpMode%\nVerboseDbServer      : %xVerboseDbServer%\nKillExistingServers  : %xKillExistingServers%\nKillExistingBrowsers : %xKillExistingBrowsers%\nStartBrowsers        : %xStartBrowsers%\"}"|%xLog%
echo BrowserURL           : %xBrowserURL%|%xLog%
if "%xDebugMode%" == "1" (
    echo DebugMode            : Enabled|%xLog%
) else (
    echo DebugMode            : Disabled|%xLog%
)
echo.|%xLog%
echo Please read comments in xtack.ini for further details ...|%xLog%

REM ==> If xtack run just to show the current configuration, exit now:
if "%xJustShowCfg%" == "1" goto :XON_END

:XON_SILENT_SKIP_SHOWING_XTACK_INI_SETTINGS
set xJustShowCfg=
if "%xProfiling%" == "1" call :PROFILING "Showing xtack.ini configuation settings" 1 0

REM ==> Validate and transform the xtack.ini configuration settings. First,
REM ==> validate DefaultOpMode:
for /f "usebackq delims=" %%i in (`set xIniOpMode^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/ \(INVALID MODE!\)$/{i++;print \"Invalid\"}END{if(i==0){gsub(/(xIniOpMode|=)/,\"\");print $0}}"`) do set xIniOpMode=%%i

REM ==> Check and if necessary map xtack.ini "legacy" OpMode keyword to the
REM ==> actual legacy OpMode:
if /i not "%xIniOpMode%" == "legacy" goto :XON_TRANSFORM_VERBOSEDBSERVER_SETTING
set xIniOpMode=%xLegacyOpMode%
call :SHOW_MSG "INFO: Original INI Legacy OpMode requested mapped to %xIniOpMode%\n"

:XON_TRANSFORM_VERBOSEDBSERVER_SETTING
REM ==> Transform VerboseDbServer setting to its final operating value:
for /f "usebackq delims=" %%i in (`set xVerboseDbServer^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^xVerboseDbServer=Yes$/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xVerboseDbServer=%%i

REM ==> Transform KillExistingServers setting to its final operating value:
for /f "usebackq delims=" %%i in (`set xKillExistingServers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^xKillExistingServers=Yes$/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xKillExistingServers=%%i

REM ==> If in silent mode, reset all browser related variables to effectively
REM ==> disable browser startup altogether:
if not "%xSilentMode%" == "1" goto :XON_TRANSFORM_KILLEXISTINGBROWSERS_SETTING
call :ABORT_BROWSER_STARTUP
goto :XON_ANALYSE_OPMODE

:XON_TRANSFORM_KILLEXISTINGBROWSERS_SETTING
REM ==> At this point, we aren't running on silent mode, thus transform
REM ==> KillExistingBrowsers setting to its final operating value:
for /f "usebackq delims=" %%i in (`set xKillExistingBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^KillExistingBrowsers=Yes$/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xKillExistingBrowsers=%%i

REM ==> Transform StartBrowsers setting to its final operating value:
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*xStartBrowsers[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*xStartBrowsers[ \t]*=[ \t]*|[ \t]*[,]?$)/,\"\");gsub(/(MSIE|IE|(Microsoft ?)?Internet ?Explorer)/,\"MSIE\");gsub(/[ \t]*[,][ \t]*/,\"^,\");if($0 ~ /^^(Firefox|MSIE|Edge|Opera|Safari|Chrome)+(,(Firefox|MSIE|Edge|Opera|Safari|Chrome))*?$/){print $0}else{print \"Invalid\"}}}END{if(i==0){print \"0\"}}"`) do set xStartBrowsers=%%i
if /i not "%xStartBrowsers%" == "Invalid" goto :XON_VALIDATE_BROWSER_URL

REM ==> Show warning and abort the browser startup sequence altogether:
call :ABORT_BROWSER_STARTUP
echo WARNING: The browser(s) can't be started because invalid values have|%xLog%
echo been specified in xtack.ini. Supported browsers are Mozilla Firefox,|%xLog%
echo Microsoft Internet Explorer, Microsoft Edge, Google Chrome, Opera and|%xLog%
echo Apple Safari.|%xLog%
echo.|%xLog%
goto :XON_ANALYSE_OPMODE

:XON_VALIDATE_BROWSER_URL
REM ==> Roughly check the validity of the BrowserURL option from xtack.ini.
REM ==> At this stage the only prerequisite is that the URLs are enclosed in
REM ==> double quotes:
if not defined xBrowserURL goto :XON_WARNING_BROWSER_URL_NOT_SET_IN_XTACK_INI
set xBrowserURL|%xGawk% "BEGIN{IGNORECASE=1;i=0}/\".*\"/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XON_WARNING_NO_VALID_BROWSER_URL_IN_XTACK_INI
goto :XON_FLAG_BROWSERS_TO_START_ONE_BY_ONE

:XON_WARNING_BROWSER_URL_NOT_SET_IN_XTACK_INI
call :ABORT_BROWSER_STARTUP
echo WARNING: The BrowserURL directive is not set in xtack.ini|%xLog%
echo and so xtack can't automatically start any browser(s)!|%xLog%
echo.|%xLog%
goto :XON_ANALYSE_OPMODE

:XON_WARNING_NO_VALID_BROWSER_URL_IN_XTACK_INI
call :ABORT_BROWSER_STARTUP
echo WARNING: The format of the BrowserURL directive in xtack.ini is|%xLog%
echo invalid and so xtack can't automatically start any browser(s).|%xLog%
echo URLs must be enclosed within double quotes. So, xtack can't|%xLog%
echo automatically start any browser(s)!|%xLog%
echo.|%xLog%
goto :XON_ANALYSE_OPMODE

:XON_FLAG_BROWSERS_TO_START_ONE_BY_ONE
REM ==> Find out which browsers to start up, according to the
REM ==> StartBrowsers configuration setting in the xtack.ini file.
if "%xStartBrowsers%" == "0" goto :XON_ANALYSE_OPMODE
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*Firefox/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartFirefox=%%i
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*(MSIE|IE|(Microsoft ?)?Internet ?Explorer)/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartMsie=%%i
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*Edge/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartEdge=%%i
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*Chrome/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartChrome=%%i
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*Opera/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartOpera=%%i
for /f "usebackq delims=" %%i in (`set xStartBrowsers^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xStartBrowsers=.*Safari/{i++;print \"1\"}END{if(i==0){print \"0\"}}"`) do set xStartSafari=%%i

:XON_ANALYSE_OPMODE
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Parsing of xtack.ini configuration settings" 1 0

if /i "%xCliOpMode%" == "none" goto :XON_CHECK_XTACK_INI_OPMODE

REM ==> If a valid OpMode has been explicitly requested via CLI, use it:
set xFinalOpMode=%xCliOpMode%
set xOpModeOrigin=CLI
call :SHOW_MSG "\nUsing Operating Mode requested through the command line: %xFinalOpMode%\n"
goto :XON_CHECK_TARGET_OPMODE_SUITABILITY

:XON_CHECK_XTACK_INI_OPMODE
REM ==> No valid OpMode has been explicitly requested via CLI. If OpMode
REM ==> in xtack.ini is present and valid, use it:
if /i "%xIniOpMode%" == "invalid" goto :XON_USE_ROOT_DEFAULT_OPMODE
if /i "%xIniOpMode%" == "Not set" goto :XON_USE_ROOT_DEFAULT_OPMODE
set xFinalOpMode=%xIniOpMode%
set xOpModeOrigin=xtack.ini
call :SHOW_MSG "Using default Operating Mode found in xtack.ini: %xFinalOpMode%\n"
goto :XON_CHECK_TARGET_OPMODE_SUITABILITY

:XON_USE_ROOT_DEFAULT_OPMODE
REM ==> No valid CLI or xtack.ini OpModes found. Use the root default OpMode
REM ==> as last option:
set xFinalOpMode=%xRootDefaultOpMode%
set xOpModeOrigin=Root
call :SHOW_MSG "WARNING: No valid Operating Mode found in xtack.ini. Using root\ndefault mode %xRootDefaultOpMode% ...\n"
call :LOG_ENTRY warning "No valid OpMode found in xtack.ini. Root default %xRootDefaultOpMode% OpMode used instead. Please check."

:XON_CHECK_TARGET_OPMODE_SUITABILITY
REM ==> Check whether the target switchover OpMode requested can acatually be
REM ==> used, that is, check that the requested HTTP server, DBMS and PHP
REM ==> version are actually installed:
call :CHECK_TARGET_OPMODE "%xFinalOpMode%"
if "%xTemp%" == "0" goto :XON_CHECK_MS_VC_REDIS_REQUIREMENTS
call :SHOW_MSG "ERROR: xtack cannot be started up in target Operating Mode requested\n^(%xFinalOpMode%^), as not all required xtack components are installed.\n" "ERROR: xtack can't run: Required components missing."
call :LOG_ENTRY error "xtack cannot be started up in the target Operating Mode requested ^(%xFinalOpMode%^), as not all required xtack components are installed (return value from :CHECK_TARGET_OPMODE subroutine = %xTemp%)."
call :ASK_USER_YES_NO_QUESTION "Do you want to install Operating Mode %xFinalOpMode% components" 0
if /i "%xTemp%" == "Y" (
    set xUpdateFromXonOrSwitch=1
    echo.|%xLog%
    goto :PERFORM_XTACK_UPDATE
)

REM ==> The user refused to install required components for requested OpMode:
call :SHOW_MSG "\nOK, thanks, now exiting without starting xtack up ..."
call :LOG_ENTRY info "The user refused to install required components for OpMode %xFinalOpMode%. Now exiting."
goto :XON_END

:XON_CHECK_MS_VC_REDIS_REQUIREMENTS
REM ==> Check whether xtack can be started up even if there are missing MS
REM ==> VC Redistributable Packages:
if "%xNoOfMissingRedisPkgs%" == "0" goto :XON_GET_SELECTORS_FROM_OPMODE

REM ==> If (PHP <= 5.4 AND missing VC9) OR ((PHP 5.5 or PHP 5.6) AND missing
REM ==> VC11) OR (PostgreSQL AND missing VC12) OR ((Apache 2.4) OR (PHP 7.0)
REM ==> AND missing VC14)) flag = 1 and xtack cannot be started up:
for /f "usebackq delims=" %%i in (`echo %xFinalOpMode%-%xMissingRedisPkgs%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /^^(a13|a24|ngx|njs|iis)(p52|p53|p54)(m55|m57|pgs|mra|ndb)-.*VC9.*$/){print \"1\"}else if($0 ~ /^^((a13|a24|ngx|njs|iis)(p55|p56)(m55|m57|pgs|mra|ndb))-.*VC11.*$/){print \"1\"}else if($0 ~ /^^(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)pgs)-.*VC12.*$/){print \"1\"}else if($0 ~ /^^(a24(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb)|(a13|a24|ngx|njs|iis)(p70|p71|p72)(m55|m57|pgs|mra|ndb))-.*VC14.*$/){print \"1\"}else{print \"0\"}}"`) do set xTemp=%%i
if "%xTemp%" == "0" goto :XON_GET_SELECTORS_FROM_OPMODE

REM ==> xtack definitely can't be started up, as required MS VC
REM ==> Redistributable Packages are missing for the requested OpMode:
call :SHOW_MSG "ERROR: xtack can't run on this system right now, as required MS\nVC++ Redistributable Package(s) for the requested Operating Mode\nare missing. Please install them and try again. Now exiting ..." "ERROR: xtack can't run: Required VC redis package(s) missing."
call :LOG_ENTRY error "xtack can't run on this system right now, as required MS %xMissingRedisPkgs% Redistributable Package(s) for the requested Operating Mode are missing. Please install them and try again. Now exiting."
goto :XON_END

:XON_GET_SELECTORS_FROM_OPMODE
REM ==> Get server selectors from final OpMode chosen:
for /f "usebackq delims=" %%i in (`echo %xFinalOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set xHttpSrvSelector=%%i
for /f "usebackq delims=" %%i in (`echo %xFinalOpMode%^|%xGawk% "{print tolower(substr($0,4,3))}"`) do set xPhpSelector=%%i
for /f "usebackq delims=" %%i in (`echo %xFinalOpMode%^|%xGawk% "{print tolower(substr($0,7,3))}"`) do set xDbmsSelector=%%i

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Determination of final OpMode and server selectors" 0 1

REM ==> Log xtack's startup attempt in Operating Mode specified in the CLI:
call :LOG_ENTRY info "xtack startup attempt in %xOpModeOrigin% OpMode %xFinalOpMode%."

REM ==> At this point, it has been verified that the HTTP server and DBMS can
REM ==> be started according to the OpMode, either from CLI, xcentra.ini or
REM ==> root. Check if xtack is not started but DBMS pre-existing instances
REM ==> are running:
.\bin\ps.exe mysqld.exe postgres.exe>nul 2>nul
if not "%errorlevel%" == "0" goto :XON_START_DBMS_UP

REM ==> Infer binary filename from DBMS selector and check if xtack is not
REM ==> started but MySQL or PostgreSQL pre-existing instances are running:
for /f "usebackq delims=" %%i in (`echo %xDbmsSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(m55|m57|mra)/){print \"mysqld.exe\"}else if($0 ~ /pgs/){print \"postgres.exe\"}else{print \"none\"}}"`) do set xTemp=%%i
call :KILL_DBMS_PREEXISTING_INSTANCES "%xTemp%"
if "%xTemp%" == "2" goto :XON_ERROR_PREEXISTING_SERVERS_RUNNING
if "%xTemp%" == "3" goto :XON_ERROR_PREEXISTING_SERVERS_RUNNING

:XON_START_DBMS_UP
REM ==> Perform the actual DBMS startup. If exitcode = 0 DBMS was started OK:
call :START_DBMS_UP "%xDbmsSelector%"
if not "%xTemp%" == "0" goto :XON_END

REM ==> HTTP server startup sequence starts here. xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "DBMS server startup" 0 1

REM ==> Check if xtack is not started but HTTP server pre-existing instances
REM ==> are running:
.\bin\ps.exe Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe>nul 2>nul
if not "%errorlevel%" == "0" goto :XON_PERFORM_START_HTTP_SERVER_UP

REM ==> Infer binary filename from HTTP server selector:
for /f "usebackq delims=" %%i in (`echo %xHttpSrvSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /a24/){print \"httpd.exe\"}else if($0 ~ /ngx/){print \"nginx.exe\"}else if($0 ~ /a13/){print \"Apache.exe\"}else if($0 ~ /iis/){print \"iisexpress.exe\"}else{print \"node.exe\"}}"`) do set xTemp=%%i
call :KILL_HTTP_SERVER_PREEXISTING_INSTANCES "%xTemp%"
if "%xTemp%" == "2" goto :XON_ERROR_PREEXISTING_SERVERS_RUNNING
if "%xTemp%" == "3" goto :XON_ERROR_PREEXISTING_SERVERS_RUNNING

:XON_PERFORM_START_HTTP_SERVER_UP
REM ==> Perform the actual HTTP server startup. If exitcode = 0 HTTP server
REM ==> was started OK:
call :START_HTTP_SERVER_UP "%xHttpSrvSelector%" "%xPhpSelector%"
if "%xTemp%" == "0" goto :XON_HTTP_SERVER_STARTED_UP_OK

REM ==> The HTTP server failed to start up. Now we have to perform some
REM ==> cleanup. Shut down DBMS now, then show error message and exit:
call :SHUT_DBMS_DOWN "%xDbmsSelector%"
goto :XON_END

:XON_HTTP_SERVER_STARTED_UP_OK
for /f "usebackq delims=" %%i in (`echo %xFinalOpMode%^|%xGawk% "{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xFinalOpMode=%%i
call :LOG_ENTRY info "xtack succesfully started in %xOpModeOrigin% OpMode %xFinalOpMode%."
if "%xSilentMode%" == "1" goto :XON_SILENT_SKIP_TRAY_NOTIFICATION
if exist .\bin\nircmdc.exe .\bin\nircmdc.exe trayballoon "xtack Startup" "xtack succesfully started in %xOpModeOrigin% Operating Mode %xFinalOpMode% ..." .\bin\icons\xon.ico 4000
echo %xPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(p52|p53|p54)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XON_SILENT_SKIP_TRAY_NOTIFICATION
echo %xPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(p52|p53|p54)/{gsub(\"p5\",\"PHP 5.\");print \"INFO: Using \"$0\" will make phpMyAdmin fail (PHP ^>= 5.5 required).\n\"}"|%xLog%

:XON_SILENT_SKIP_TRAY_NOTIFICATION
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "HTTP server startup" 0 1

REM ==> Start the browsers up. First find out which browser to start by
REM ==> taking a look to the StartBrowsers configuration setting in the
REM ==> xtack.ini file. Anyway, if this setting is set to no, false or 0,
REM ==> we will just skip it and jump to the part in which the started
REM ==> processes are shown. This will be the case for example when
REM ==> starting xtack in silent mode:
if "%xStartBrowsers%" == "0" goto :XON_EXIT_BROWSER_STARTUP

REM ==> If we get here, StartBrowsers is NOT set to no, false or 0
REM ==> (xStartBrowsers != 0).
if not exist .\www\favicon.ico copy /D /V /Y .\docs\assets\img\favicon.ico .\www\favicon.ico>nul 2>nul

REM ==> Readjust phpMyAdmin for MySQL/MariaDB and phpPgAdmin
REM ==> for PostgreSQL:
for /f "usebackq delims=" %%i in (`echo %xBrowserURL%^|%xGawk% "BEGIN{IGNORECASE=1}{s=\"%xDbmsSelector%\";if(s ~ /(m55|m57|mra)/){gsub(/\/pga\//,\"/pma/\")}else if(s ~ /pgs/){gsub(/\/pma\//,\"/pga/\")};print $0}"`) do set xBrowserURL=%%i

REM ==> Workaround for index.php and index.html on IIS Express by
REM ==> modifying URLs in xtack.ini's BrowserURL setting to add
REM ==> the file extension.
for /f "usebackq delims=" %%i in (`echo %xBrowserURL%^|%xGawk% "BEGIN{IGNORECASE=1}{s=\"%xHttpSrvSelector%\";if(s !~ /iis/){print $0}else{gsub(/\/docs\/\042/,\"/docs/index.html\042\");gsub(/\/pma\/\042/,\"/pma/index.php\042\");gsub(/\/pga\/\042/,\"/pga/index.php\042\");print $0}}"`) do set xBrowserURL=%%i

REM ==> If IDE not requested via "-i" switch, jump directly to browser
REM ==> startup:
if not "%xIdeFlag%" == "1" goto :XON_START_FIREFOX_UP

REM ==> Check whether the IDE index file actually exists:
dir /b .\ide\index.php .\ide\index.html .\ide\index.htm>nul 2>nul
if not "%errorlevel%" == "0" goto :XON_IDE_NOT_FOUND

REM ==> Check whether the IDE index file actually exist
REM ==> exists and, if so, add it to the xBrowserURL setting:
if exist .\ide\index.php set xBrowserURL=%xBrowserURL% "http://127.0.0.1/ide/index.php"
if exist .\ide\index.html set xBrowserURL=%xBrowserURL% "http://127.0.0.1/ide/index.html"
if exist .\ide\index.htm set xBrowserURL=%xBrowserURL% "http://127.0.0.1/ide/index.htm"
goto :XON_START_FIREFOX_UP

:XON_IDE_NOT_FOUND
call :SHOW_MSG "WARNING: No IDE was found, so xtack can't start it. Please check.\n"
call :LOG_ENTRY warning "xtack requested to start with IDE, but no IDE was found on subfolder %~dp0ide\. Please check."

:XON_START_FIREFOX_UP
REM ==> Check if Firefox is selected for startup along with xtack:
if "%xStartFirefox%" == "0" goto :XON_START_CHROME_UP
call :START_BROWSER_UP "Firefox" "https://www.mozilla.org/en-US/firefox/all/" 0
if "%xProfiling%" == "1" call :PROFILING "Firefox startup" 0 1

:XON_START_CHROME_UP
REM ==> Check if Chrome is selected for startup along with xtack:
if "%xStartChrome%" == "0" goto :XON_START_MSIE_UP
call :START_BROWSER_UP "Chrome" "https://www.google.com/chrome/browser/" 0
if "%xProfiling%" == "1" call :PROFILING "Chrome startup" 0 1

:XON_START_MSIE_UP
REM ==> Check if Internet Explorer is selected for startup along with xtack:
if "%xStartMsie%" == "0" goto :XON_START_EDGE_UP
call :START_BROWSER_UP "MSIE" "https://support.microsoft.com/en-us/help/17621/internet-explorer-downloads" 0
if "%xProfiling%" == "1" call :PROFILING "Internet Explorer startup" 0 1

:XON_START_EDGE_UP
REM ==> Check if Internet Explorer is selected for startup along with xtack:
if "%xStartEdge%" == "0" goto :XON_START_OPERA_UP
call :START_BROWSER_UP "Edge" "https://www.microsoft.com/en-us/download/details.aspx?id=48126" 0
if "%xProfiling%" == "1" call :PROFILING "Microsoft Edge startup" 0 1

:XON_START_OPERA_UP
REM ==> Check if Opera is selected for startup along with xtack:
if "%xStartOpera%" == "0" goto :XON_START_SAFARI_UP
call :START_BROWSER_UP "Opera" "https://www.opera.com/computer/windows" 0
if "%xProfiling%" == "1" call :PROFILING "Opera startup" 0 1

:XON_START_SAFARI_UP
REM ==> Check if Safari is selected for startup along with xtack:
if "%xStartSafari%" == "0" goto :XON_EXIT_BROWSER_STARTUP
call :START_BROWSER_UP "Safari" "http://appldnld.apple.com/Safari5/041-5487.20120509.INU8B/SafariSetup.exe" 0
if "%xProfiling%" == "1" call :PROFILING "Safari startup" 0 1

:XON_EXIT_BROWSER_STARTUP
REM ==> Give some additional time for all the xtack processes to start up:
call :SHOW_MSG "Giving some time to xtack processes to fully start up. Please wait ...\n"
if "%xDebugMode%" == "1" (
    REM ==> By getting and logging system info:
    call :COLLECT_SYSTEM_INFO_WITH_WMIC 0 1
) else (
    REM ==> Or just by simply waiting 2.5 seconds more:
    .\bin\ps.exe -d 2500 cmd.exe>nul 2>nul
)

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Browser(s) startup" 0 1

REM ==> Create the xtack execution control file now, so that xtack startup
REM ==> can be tracked back later:
call :GET_TIMESTAMP_TZ
echo.> .\bin\xtack.lck
type .\%~nx0|%xGawk% "{if(NR>1&&NR<24){gsub(\"REM\",\"#\");print $0}}">> .\bin\xtack.lck
echo # Last update: %xTemp%>> .\bin\xtack.lck
echo.>> .\bin\xtack.lck
echo xtack started in OpMode %xFinalOpMode% (%xOpModeOrigin%) by "xtack start">> .\bin\xtack.lck
echo.>> .\bin\xtack.lck

REM ==> Show the list of processes started by xcentra. First, build the
REM ==> caption for the WMIC query to get all the xtack processes that
REM ==> should be checked:
set xTemp=Caption="Apache.exe" or Caption="httpd.exe" or Caption="nginx.exe" or Caption="node.exe" or Caption="iisexpress.exe" or Caption="mysqld.exe" or Caption="postgres.exe" or Caption="php.exe" or Caption="php-cgi.exe" or Caption="php-win.exe" or Caption="phpdbg.exe"
if "%xStartFirefox%" == "1" set xTemp=%xTemp% or Caption="firefox.exe"
if "%xStartMsie%" == "1" set xTemp=%xTemp% or Caption="iexplore.exe"
if "%xStartOpera%" == "1" set xTemp=%xTemp% or Caption="launcher.exe"
if "%xStartSafari%" == "1" set xTemp=%xTemp% or Caption="Safari.exe"
if "%xStartChrome%" == "1" set xTemp=%xTemp% or Caption="chrome.exe"
if "%xStartEdge%" == "1" set xTemp=%xTemp% or Caption="MicrosoftEdge.exe"
wmic PROCESS where (%xTemp%) get Caption,ExecutablePath,Processid,CreationDate,WindowsVersion /format:csv 2>&1|%xGawk% "BEGIN{IGNORECASE=1}/\.exe/{print $0}">.\tmp\xtackprc.txt 2>nul

REM ==> Get DBMS creation timestamp, which was the first process created
REM ==> during xtack startup or, if not required (DBMS selector = "ndb")
REM ==> get the HTTP server creation timestamp:
if /i not "%xDbmsSelector%" == "ndb" for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{i=0}/\\bin\\(m5[56]|mra|pgs)\\bin\\(mysqld\.exe|postgres*\.exe)/{if(i==0){print $3;i++}}"`) do set xTemp=%%i
if /i "%xDbmsSelector%" == "ndb" for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{i=0}/(Apache\.exe|httpd\.exe|nginx\.exe|node\.exe|iisexpress\.exe)/{if(i==0){print $3;i++}}"`) do set xTemp=%%i

REM ==> Create xtack process creation time filter file.
REM ==> Process creation window = the last 2-3 minutes):
echo %xTemp%|%xGawk% "{ts=int(substr($0,0,4));mo=int(substr($0,5,2));d=int(substr($0,7, 2));h=int(substr($0,9,2));m=int(substr($0,11,2));s=int(substr($0,13,2));ts=mktime(ts\" \"mo\" \"d\" \"h\" \"m\" \"s);print strftime(\",%%Y%%m%%d%%H%%M\",ts);print strftime(\",%%Y%%m%%d%%H%%M\",ts+60);print strftime(\",%%Y%%m%%d%%H%%M\",ts+120)}">.\tmp\xtacktmp1.txt

REM ==> Include single PID browsers like Firefox, if required:
if "%xStartFirefox%" == "1" type .\tmp\xtackprc.txt|%xGawk% -F, "/firefox\.exe/{print $3}">>.\tmp\xtacktmp1.txt

REM ==> If not in silent mode, show the list of processes started by xtack.
REM ==> Otherwise skip it altogether:
if "%xSilentMode%" == "1" goto :XON_SILENT_SAVE_PROCESSES_LIST_TO_EXEC_CONTROL_FILE

REM ==> Count number of xtack processes started:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% "END{print NR}"`) do set xTemp=%%i

echo xtack has successfully started the following %xTemp% processes:|%xLog%
echo.|%xLog%
echo Process            PID     Full Path|%xLog% .\bin\xtack.lck
set xTemp=%~dp0
set xTemp=%xTemp:\=\\%
%xGawk% "BEGIN{i=0}FNR==NR{a[i++]=$1;next}{for(j=0;j<i;j++) if(index($0,a[j])){print $0;break}}" .\tmp\xtacktmp1.txt .\tmp\xtackprc.txt|%xGawk% -F, "{if($2 ~ /iisexpress\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\iis\\iisexpress.exe\"}else if($2 ~ /php-cgi\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\%xPhpSelector%\\php-cgi.exe\"}else{b=$4};printf(\"%%-19s%%-8s%%-90s\n\",$2,$5,b);}"
goto :XON_SAVE_PIDS_TO_EXEC_CONTROL_FILE

:XON_SILENT_SAVE_PROCESSES_LIST_TO_EXEC_CONTROL_FILE
echo Process            PID     Full Path>> .\bin\xtack.lck
set xTemp=%~dp0
set xTemp=%xTemp:\=\\%
%xGawk% "BEGIN{i=0}FNR==NR{a[i++]=$1;next}{for(j=0;j<i;j++) if(index($0,a[j])){print $0;break}}" .\tmp\xtacktmp1.txt .\tmp\xtackprc.txt|%xGawk% -F, "{if($2 ~ /iisexpress\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\iis\\iisexpress.exe\"}else if($2 ~ /php-cgi\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\%xPhpSelector%\\php-cgi.exe\"}else{b=$4};printf(\"%%-19s%%-8s%%-90s\n\",$2,$5,b);}">> .\bin\xtack.lck

:XON_SAVE_PIDS_TO_EXEC_CONTROL_FILE
echo.>> .\bin\xtack.lck
REM ==> Save the DBMS server processes PIDs:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1}/\\bin\\(m5[57]|mra|pgs)\\bin\\(mysqld|postgres)?(\.exe)?/{printf \" \" $5}"`) do set xTemp=%%i
echo xtack DB server PIDs      :%xTemp%>> .\bin\xtack.lck

REM ==> Save the HTTP server and PHP processes PIDs:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1}/(Apache|httpd|nginx|node|iisexpress|php|php-cgi|php-win|phpdbg)+(\.exe)?/{printf \" \" $5}"`) do set xTemp=%%i
echo xtack HTTP server/PHP PIDs:%xTemp%>> .\bin\xtack.lck

REM ==> Save the browser processes PIDs:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1}/(firefox|iexplore|MicrosoftEdge|opera|Safari|chrome)\.exe/{printf \" \" $5}"`) do set xTemp=%%i
echo xtack browser PIDs        :%xTemp%>> .\bin\xtack.lck

REM ==> Save "startup completed on" timestamp:
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
echo.>> .\bin\xtack.lck
echo xtack startup completed on %xTemp%>> .\bin\xtack.lck

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing xtack process list" 1 0

REM ==> Some clean up:
for /f "usebackq delims=" %%i in (`echo %xHttpSrvSelector%%xPhpSelector%%xDbmsSelector%^|%xGawk% "{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xTemp=%%i
call :SHOW_MSG "\nxtack has been succesfully started in %xOpModeOrigin% Operating Mode %xTemp%." "xtack succesfully started ^(%xTemp%, no browsers^)."

REM ==> If applicable, check for xtack component updates:
call :CREATE_INSTALLED_COMPONENTS_LIST
call :CHECK_FOR_AVAILABLE_UPDATES
goto :XON_END

:XON_ERROR_PREEXISTING_SERVERS_RUNNING
REM ==> Show HTTP Server/DBMS pre-existing instances running error and exit:
if not "%xSilentMode%" == "1" (
    call :SHOW_MSG "ERROR: No previous instances of xtack were found running, but the\nfollowing processes required in exclusive use by xtack are already\nrunning on the system:\n\nProcess         PID     Prio    Full Path"
    .\bin\ps.exe -q -e Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe mysqld.exe postgres.exe php.exe php-cgi.exe php-win.exe phpdbg.exe|%xLog%
)
call :SHOW_MSG "\nYou can set \042KillExistingServers=yes\042 in xtack.ini so xtack tries to\nkill any pre-existing HTTP/DB server and PHP instances. You can also\ncheck if HTTP and/or DB servers are running as services outside xtack\nby executing Windows \042services.msc\042 management console. Now exiting ..." "ERROR: xtack can't run: Processes required by xtack already running."

:XON_END
REM ==> Startup specific cleanup:
del /F /Q .\tmp\*.vbs .\tmp\launchsf.bat .\tmp\xtackprc.txt .\tmp\xtacktmp1.txt .\tmp\xtacktmp2.txt>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: xtack shutdown.
REM -------------------------------------------------------------------------

:INITIATE_XTACK_STOP
REM ==> Update logfile settings, but skip updating the logfile if coming
REM ==> from xtack switch:
if "%xUpdateFromXonOrSwitch%" == "1" goto :XOFF_LOG_DEBUG_MODE
set xFunctionalityArea=Stop
call :REFRESH_LOGFILE "xtack_stop"

:XOFF_LOG_DEBUG_MODE
REM ==> If debug mode enabled, log it:
call :LOG_SILENT_MODE_STATUS

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Show the current xcentra status:
call :SHOW_XTACK_STATUS "stop"

REM ==> If xtack is not currently running on the system, exit:
if "%xTemp%" == "1" goto :XOFF_END

REM ==> Reset the default xtack process successful closure flags:
set xDbmsShutdownOk=0
set xHttpSrvShutdownOk=0

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Shutdown initial preparations" 1 0

REM ==> Get the current OpMode in which xtack is running:
call :GET_CURRENT_OPMODE
for /f "usebackq delims=" %%i in (`echo %xOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set xSrvFromSelector=%%i

if /i not "%xOpMode%" == "Unknown" goto :XOFF_KILL_PHP_INSTANCES
call :SHOW_MSG "ERROR: The current Operating Mode is unknown. Shutdown aborted\nNow exiting ..." "ERROR: Current Operating Mode unknown. Switchover aborted."
call :LOG_ENTRY error "No current OpMode info found in xtack.lck, unknown From OpMode. Shutdown aborted. Now exiting."
goto :XOFF_END

:XOFF_KILL_PHP_INSTANCES
REM ==> Kill any running PHP instances:
set %xOpMode%=%xTemp%
call :KILL_PHP_INSTANCES 0

REM ==> Check whether the xtack control file (.\bin\xtack.lck) contains
REM ==> xtack browser PIDs details:
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack browser PIDs/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :XOFF_KILL_XTACK_BROWSER_INSTANCES
call :LOG_ENTRY warning "No browser PIDs found in xtack.lck, so no browsers could be killed during xtack normal shut down. Please check."
goto :XOFF_KILL_XTACK_DBMS_INSTANCES

:XOFF_KILL_XTACK_BROWSER_INSTANCES
REM ==> Kill xtack browser instances. Get the xtack browser PIDs from the
REM ==> xtack control file:
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% -F^: "/xtack browser PIDs        : /{printf \" \" $2}"^|%xGawk% "{$1=$1};1"`) do set xBrowserPids=%%i

REM ==> And close down all the browsers merciless in one shot:
call :SHOW_MSG "\nClosing all browsers launched by xtack ..."
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\ps.exe -c -f -i %xBrowserPids%]>> %xLogfile%
if not "%xSilentMode%" == "1" echo.|%xLog%
.\bin\ps.exe -c -f -i %xBrowserPids%>nul 2>nul

REM ==> If Microsoft Edge started along xtack, re-kill it with taskkill:
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1;i=0}/MicrosoftEdge.exe/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XOFF_KILL_XTACK_DBMS_INSTANCES
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "/MicrosoftEdge.exe/{printf \" \" $2}"^|%xGawk% "{$1=$1};1"`) do set xBrowserPids=%%i
taskkill /f /pid %xBrowserPids%>nul 2>nul

:XOFF_KILL_XTACK_DBMS_INSTANCES
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Killing PHP and browser(s) instances" 0 1

REM ==> Shut DBMS down now. First get the current DBMS selector:
for /f "usebackq delims=" %%i in (`echo %xOpMode%^|%xGawk% "{print tolower(substr($0,7,3))}"`) do set xSrvFromSelector=%%i
call :SHUT_DBMS_DOWN "%xSrvFromSelector%"
if "%xTemp%" == "1" set xDbmsShutdownOk=1

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "DBMS server shutdown" 0 1

REM ==> Shut HTTP server down now. First get the current HTTP server selector:
for /f "usebackq delims=" %%i in (`echo %xOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set xSrvFromSelector=%%i
call :SHUT_HTTP_SERVER_DOWN "%xSrvFromSelector%"
if "%xTemp%" == "1" set xHttpSrvShutdownOk=1

:XOFF_FINAL_XTACK_PROCESS_CHECK
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "HTTP server shutdown" 0 1

REM ==> If in silent mode, skip showing the process list altogether:
if "%xSilentMode%" == "1" goto :XOFF_FINAL_CLEANUP

:XOFF_FINAL_CLEANUP
REM ==> Clean up all the temporary files:
call :SHOW_MSG "Cleaning up. Please wait ..."
call :PERFORM_FINAL_CLEANUP

REM ==> Conditionally show the xtack shutdown success message:
for /f "usebackq delims=" %%i in (`echo %xDbmsShutdownOk%^|%xGawk% "END{print %xDbmsShutdownOk%+%xHttpSrvShutdownOk%}"`) do set xTemp=%%i
if not "%xTemp%" == "2" goto :XOFF_DELETE_XTACK_CONTROL_FILE

REM ==> Inform user that xtack has been successfully shut down (with OpMode):
call :SHOW_MSG "\nxtack has been successfully shut down from %xOpModeOrigin% OpMode %xOpMode%." "xtack successfully shut down from %xOpModeOrigin% OpMode %xOpMode%."
call :LOG_ENTRY info "xtack succesfully shut down from %xOpModeOrigin% OpMode %xOpMode%."
if "%xSilentMode%" == "1" goto :XOFF_DELETE_XTACK_CONTROL_FILE
if exist .\bin\nircmdc.exe .\bin\nircmdc.exe trayballoon "xtack Shutdown" "xtack has been successfully shut down from %xOpModeOrigin% Operating Mode %xOpMode% ..." .\bin\icons\xoff.ico 4000
goto :XOFF_DELETE_XTACK_CONTROL_FILE

:XOFF_REPORT_SUCCESSFUL_SHUTDOWN_WITHOUT_OPMODE
REM ==> Inform the user that xtack has been successfully shut down
REM ==> (without OpMode):
call :SHOW_MSG "xtack has been successfully shut down." "xtack successfully shut down."
call :LOG_ENTRY info "xtack succesfully shut down (no OpMode info detected in xtack.lck)."
if exist .\bin\nircmdc.exe .\bin\nircmdc.exe trayballoon "xtack Shutdown" "xtack has been successfully shut down ..." .\bin\icons\xoff.ico 4000

:XOFF_DELETE_XTACK_CONTROL_FILE
REM ==> Delete the xtack control file (.\bin\xtack.lck):
del /F /Q .\bin\xtack.lck>nul 2>nul
call :SHOW_XTACK_PROCESS_LIST

:XOFF_END
REM ==> Jump to xtack update if coming from xtack switch:
if "%xUpdateFromXonOrSwitch%" == "1" (
    echo.|%xLog%
    goto :PERFORM_XTACK_UPDATE
)
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Operating Mode switchover.
REM -------------------------------------------------------------------------

:INITIATE_XTACK_SWITCHOVER
REM ==> Update logfile settings:
set xFunctionalityArea=Switch
call :REFRESH_LOGFILE "xtack_switch"
set xSwitchToOpMode=0

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> If debug mode enabled, log it:
call :LOG_SILENT_MODE_STATUS

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Switchover initial preparations" 0 1

REM ==> Check if xtack is currently running on the system. It is
REM ==> detected through the presence of the .\bin\xtack.lck file:
if exist .\bin\xtack.lck goto :SWITCH_GET_CURRENT_OPMODE

call :SHOW_MSG "ERROR: Sorry, but xtack is not currently running on this system." "ERROR: xtack not currently running on this system."
if /i "%4" == "-regression" goto :SWITCH_VALIDATE_TARGET_OPMODE_REQUESTED
if not "%xSilentMode%" == "1" goto :SWITCH_ASK_USER_WHETHER_TO_START_XTACK_FROM_SCRATCH
call :LOG_ENTRY error "xtack not running on this system and silent mode enabled, thus skipping switchover. Now exiting."
goto :SWITCH_END

:SWITCH_ASK_USER_WHETHER_TO_START_XTACK_FROM_SCRATCH
REM ==> Ask the user whether he/she wants to start xtack from scratch now:
call :ASK_USER_YES_NO_QUESTION "Do you want to start it now" 1
if /i "%xTemp%" == "Y" goto :INITIATE_XTACK_STARTUP

REM ==> The user refused to start xtack from scratch now:
call :SHOW_MSG "\nOK, thanks, now exiting without starting xtack up ..."
call :LOG_ENTRY error "xtack was requested to switch over to a new OpMode while it wasn't running on the system, then the user refused to start it from scratch. Now exiting."
goto :SWITCH_END

:SWITCH_GET_CURRENT_OPMODE
REM ==> First of all, get the current OpMode in which xtack is running:
call :GET_CURRENT_OPMODE
if /i not "%xOpMode%" == "Unknown" goto :SWITCH_CHECK_IF_SWITCHOVER_ACTUALLY_NEEDED
call :SHOW_MSG "ERROR: The current Operating Mode is unknown. Operating mode\nswitchover will be skipped. Now exiting ..." "ERROR: Current Operating Mode unknown. Switchover aborted."
call :LOG_ENTRY error "No current OpMode info found in xtack.lck, unknown From OpMode. OpMode switchover skipped. Now exiting."
goto :SWITCH_END

:SWITCH_CHECK_IF_SWITCHOVER_ACTUALLY_NEEDED
REM ==> Check if the target OpMpde requested is different to the current one.
REM ==> If not, show/log error message and exit:
set xFromOpMode=%xOpMode%
for /f "usebackq delims=" %%i in (`echo %2^|%xGawk% "{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xTemp=%%i
if /i not "%xFromOpMode%" == "%xTemp%" goto :SWITCH_VALIDATE_TARGET_OPMODE_REQUESTED
call :SHOW_MSG "WARNING: The current and the target Operating Modes ^(%xTemp%^) are\nthe same. Operating mode switchover will be skipped. Now exiting ..." "ERROR: Same Operating Mode requested. Switchover aborted."
call :LOG_ENTRY warning "xtack was requested to switch to the same OpMode in which it is currently running (%xTemp%). OpMode switchover skipped. Now exiting."
goto :SWITCH_END

:SWITCH_VALIDATE_TARGET_OPMODE_REQUESTED
REM ==> Check if the OpMpde requested for the switchover is valid:
set xSwitchToOpMode=%xTemp%
echo %xSwitchToOpMode%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SWITCH_CHECK_LEGACY_TARGET_OPMODE
call :SHOW_MSG "ERROR: The target Operating Mode requested ^(%xSwitchToOpMode%^) is invalid.\nOperating mode switchover can't be performed. Now exiting ..." "ERROR: Invalid target Operating Mode. Switchover not possible."
call :LOG_ENTRY error "xtack was requested to switch to an invalid OpMode (%xSwitchToOpMode%). OpMode switchover can't be performed. Now exiting."
goto :SWITCH_END

:SWITCH_CHECK_LEGACY_TARGET_OPMODE
REM ==> Check and map the CLI "legacy" OpMode keyword to the actual legacy
REM ==> OpMode configured:
if /i not "%xSwitchToOpMode%" == "legacy" goto :SWITCH_CHECK_TARGET_OPMODE_SUITABILITY
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%^|%xGawk% "END{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xSwitchToOpMode=%%i
call :LOG_ENTRY info "xtack legacy CLI OpMode request mapped to OpMode %xCliOpMode% during xtack switchover."
call :SHOW_MSG "INFO: Originally requested CLI legacy Operating Mode mapped to %xCliOpMode%\n"

:SWITCH_CHECK_TARGET_OPMODE_SUITABILITY
REM ==> Check whether the target switchover OpMode requested can acatually be
REM ==> used, that is, check that the requested HTTP server, DBMS and PHP
REM ==> version are actually installed:
call :CHECK_TARGET_OPMODE "%xSwitchToOpMode%"
if "%xTemp%" == "0" goto :SWITCH_CHECK_MS_VC_REDIS_REQUIREMENTS
call :SHOW_MSG "ERROR: xtack cannot be switched over to the requested Operating Mode\n^(%xSwitchToOpMode%^), as not all required xtack components are installed.\n" "ERROR: Required components missing. Switchover not possible."
call :LOG_ENTRY error "xtack cannot be switched over to the target OpMode requested ^(%xSwitchToOpMode%^), as not all required xtack components are installed (return value from :CHECK_TARGET_OPMODE subroutine = %xTemp%)."
call :ASK_USER_YES_NO_QUESTION "Do you want to install Operating Mode %xSwitchToOpMode% components" 0
if /i "%xTemp%" == "Y" (
    set xUpdateFromXonOrSwitch=1
    echo.|%xLog%
    call :SHOW_MSG "Shutting down xtack in order to install the components now ...\n"
    goto :INITIATE_XTACK_STOP
)

REM ==> The user refused to install required components for requested OpMode:
call :SHOW_MSG "\nOK, thanks, now exiting without switching xtack over ..."
call :LOG_ENTRY info "The user refused to install required components to switch xtack over to OpMode %xSwitchToOpMode%. Now exiting."
goto :SWITCH_END

:SWITCH_CHECK_MS_VC_REDIS_REQUIREMENTS
REM ==> Check whether xtack can be switched over even if there are missing
REM ==> MS VC Redistributable Packages:
if "%xNoOfMissingRedisPkgs%" == "0" goto :SWITCH_GET_SELECTORS_FROM_OPMODES

REM ==> If (PHP <= 5.4 AND missing VC9) OR ((PHP 5.5 or PHP 5.6) AND missing
REM ==> VC11) OR (PostgreSQL AND missing VC12) OR ((Apache 2.4) OR (PHP 7.x)
REM ==> AND missing VC14)) flag = 1 and xtack cannot be switched over:
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%-%xMissingRedisPkgs%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /^^(a13|a24|ngx|njs|iis)(p52|p53|p54)(m55|m57|pgs|mra|ndb)-.*VC9.*$/){print \"1\"}else if($0 ~ /^^((a13|a24|ngx|njs|iis)(p55|p56)(m55|m57|pgs|mra|ndb))-.*VC11.*$/){print \"1\"}else if($0 ~ /^^(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)pgs)-.*VC12.*$/){print \"1\"}else if($0 ~ /^^(a24(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb)|(a13|a24|ngx|njs|iis)(p70|p71|p72)(m55|m57|pgs|mra|ndb))-.*VC14.*$/){print \"1\"}else{print \"0\"}}"`) do set xTemp=%%i
if "%xTemp%" == "0" goto :SWITCH_GET_SELECTORS_FROM_OPMODES

REM ==> xtack definitely can't be switched over, as required MS VC
REM ==> Redistributable Packages are missing for the target OpMode:
call :SHOW_MSG "ERROR: xtack can't be switched over as required MS VC Redistributable\nPackage(s) are missing. Now exiting ..." "ERROR: xtack can't switch over: Required VC redis package(s) missing."
call :LOG_ENTRY error "xtack can't be switched over as required MS %xMissingRedisPkgs% Redistributable Package(s) are missing. Now exiting."
goto :SWITCH_END

:SWITCH_GET_SELECTORS_FROM_OPMODES
REM ==> Get DBMS selectors, check if DBMS switchover necessary and if not,
REM ==> skip it:
call :SHOW_MSG "xtack will be switched over from Operating Mode %xFromOpMode% to %xSwitchToOpMode%.\n"
for /f "usebackq delims=" %%i in (`echo %xFromOpMode%^|%xGawk% "{print tolower(substr($0,7,3))}"`) do set xSrvFromSelector=%%i
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%^|%xGawk% "{print tolower(substr($0,7,3))}"`) do set xSrvToSelector=%%i
if /i "%xSrvToSelector%" == "%xSrvFromSelector%" goto :SWITCH_CHECK_HTTP_SRV_PHP_SWITCHOVER

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "OpMode switchover extraction and validation" 0 1

REM ==> Switch DBMS over now:
call :SHOW_MSG "Switching over database server now. Please wait ...\n"

REM ==> Read VerboseDbServer setting before starting DBMS up:
for /f "usebackq delims=" %%i in (`type .\cfg\xtack.ini^|%xGawk% "!/([ \t]*#|^$)/"^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*VerboseDbServer[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*VerboseDbServer[ \t]*=[ \t]*|[ \t]*$)/,\"\");gsub(/^^(1|Yes|True|On|Enabled)$/,\"1\");gsub(/^^(0|No|False|Off|Disabled)$/,\"0\");if($0 ~ /^(1|0)$/){print $0}else{print \"0\"}}}END{if(i==0){print \"Not set\"}}"`) do set xVerboseDbServer=%%i
call :SHUT_DBMS_DOWN "%xSrvFromSelector%"
call :START_DBMS_UP "%xSrvToSelector%"

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "DBMS switchover" 0 1

:SWITCH_CHECK_HTTP_SRV_PHP_SWITCHOVER
REM ==> Now we check and if necessary shut down PHP. First get the HTTP
REM ==> server selectors:
for /f "usebackq delims=" %%i in (`echo %xFromOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set xSrvFromSelector=%%i
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set xSrvToSelector=%%i

REM ==> Get PHP selectors:
for /f "usebackq delims=" %%i in (`echo %xFromOpMode%^|%xGawk% "{print tolower(substr($0,4,3))}"`) do set xPhpFromSelector=%%i
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%^|%xGawk% "{print tolower(substr($0,4,3))}"`) do set xPhpToSelector=%%i

REM ==> If no switchover is required for both PHP or the HTTP server,
REM ==> exit now:
if /i "%xSrvToSelector%%xPhpToSelector%" == "%xSrvFromSelector%%xPhpFromSelector%" goto :SWITCH_REWRITE_XTACK_LCK
call :SHOW_MSG "Switching over HTTP server and/or PHP version now. Please wait ....\n"

REM ==> Check whether there are running PHP instances and, if any, kill them:
call :KILL_PHP_INSTANCES 1

:SWITCH_EXECUTE_HTTP_SRV_SWITCHOVER
REM ==> Switch HTTP server over now:
call :SHUT_HTTP_SERVER_DOWN "%xSrvFromSelector%"
call :START_HTTP_SERVER_UP "%xSrvToSelector%" "%xPhpToSelector%"

REM ==> If Apache 2.4, allow 2 more seconds for Apache's worker process
REM ==> to start up:
if /i "%xSrvToSelector%" == "a24" .\bin\ps.exe -d 2000 httpd.exe>nul 2>nul

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "HTTP server/PHP switchover" 0 1

:SWITCH_REWRITE_XTACK_LCK
REM ==> Rewrite the xtack execution control file now so that xtack switchover
REM ==> can be tracked back later:
call :GET_TIMESTAMP_TZ
type .\bin\xtack.lck|%xGawk% "{if(NR<25){gsub(\"REM\",\"#\");print $0}}"> .\bin\new.lck
echo # Last update: %xTemp%>> .\bin\new.lck
echo.>> .\bin\xtack.lck
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1}/^xtack started in OpMode /{print $0}">> .\bin\new.lck
for /f "usebackq delims=" %%i in (`echo %xSwitchToOpMode%^|%xGawk% "{print toupper($0)}"`) do set xTemp=%%i
echo xtack later switched over to OpMode %xTemp% (CLI) by "xtack switch">> .\bin\new.lck
echo.>> .\bin\new.lck
echo Process            PID     Full Path>> .\bin\new.lck
wmic PROCESS where (Caption="Apache.exe" or Caption="httpd.exe" or Caption="nginx.exe" or Caption="node.exe" or Caption="iisexpress.exe" or Caption="mysqld.exe" or Caption="postgres.exe" or Caption="php.exe" or Caption="php-cgi.exe" or Caption="php-win.exe" or Caption="phpdbg.exe") get Caption,ExecutablePath,Processid,CreationDate,WindowsVersion /format:csv 2>&1|%xGawk% "BEGIN{IGNORECASE=1}/\.exe/{print $0}">.\tmp\xtackprc.txt 2>nul
set xTemp=%~dp0
set xTemp=%xTemp:\=\\%
type .\tmp\xtackprc.txt|%xGawk% -F, "{if($2 ~ /iisexpress\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\iis\\iisexpress.exe\"}else if($2 ~ /php-cgi\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\%xPhpSelector%\\php-cgi.exe\"}else{b=$4};printf(\"%%-19s%%-8s%%-90s\n\",$2,$5,b);}">> .\bin\new.lck
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1}/(firefox.exe|iexplore.exe|MicrosoftEdge.exe|launcher.exe|Safari.exe|chrome.exe)/{print $0}">> .\bin\new.lck
echo.>> .\bin\new.lck

if "%xSilentMode%" == "1" goto :SWITCH_SAVE_PIDS_TO_EXEC_CONTROL_FILE
echo %xPhpToSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(p52|p53|p54)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :SWITCH_SHOW_XTACK_PROCESSES_RUNNING_NOW
echo %xPhpToSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(p52|p53|p54)/{gsub(\"p5\",\"PHP 5.\");print \"INFO: Using \"$0\" will make phpMyAdmin fail (PHP ^>= 5.5 required).\n\"}"|%xLog%

:SWITCH_SHOW_XTACK_PROCESSES_RUNNING_NOW
echo The following xtack processes are now running:|%xLog%
echo.|%xLog%
echo Process            PID     Full Path|%xLog% .\bin\xtack.lck
type .\tmp\xtackprc.txt|%xGawk% -F, "{if($2 ~ /iisexpress\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\iis\\iisexpress.exe\"}else if($2 ~ /php-cgi\.exe/ && $4 ~ /^$/){b=\"%xTemp%bin\\%xPhpSelector%\\php-cgi.exe\"}else{b=$4};printf(\"%%-19s%%-8s%%-90s\n\",$2,$5,b);}"|%xLog%
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1}/(firefox.exe|iexplore.exe|MicrosoftEdge.exe|launcher.exe|Safari.exe|chrome.exe)/{print $0}"|%xLog%

:SWITCH_SAVE_PIDS_TO_EXEC_CONTROL_FILE
REM ==> Save the DBMS server processes PIDs:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1}/\\bin\\(m5[57]|mra|pgs)\\bin\\(mysqld|postgres)?(\.exe)?/{printf \" \" $5}"`) do set xTemp=%%i
echo xtack DB server PIDs      :%xTemp%>> .\bin\new.lck

REM ==> Save the HTTP server and PHP processes PIDs:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1}/(Apache|httpd|nginx|node|iisexpress|php|php-cgi|php-win|phpdbg)+(\.exe)?/{printf \" \" $5}"`) do set xTemp=%%i
echo xtack HTTP server/PHP PIDs:%xTemp%>> .\bin\new.lck

REM ==> Add the original browser processes PIDs:
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1}/xtack browser PIDs/{print $0}">> .\bin\new.lck
echo.>> .\bin\new.lck
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1}/xtack startup completed on /{print $0}">> .\bin\new.lck
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
echo xtack switchover later completed on %xTemp%>> .\bin\new.lck

REM ==> Delete the original xtack control file (.\bin\xtack.lck) and rename
REM ==> the new one:
del /F /Q .\bin\xtack.lck>nul 2>nul
ren .\bin\new.lck xtack.lck>nul 2>nul

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Rewritting of xtack control file" 0 1

REM ==> Inform user that xtack has been switched over:
set xTemp=xtack Operating Mode switched over OK from %xFromOpMode% to %xSwitchToOpMode%
call :LOG_ENTRY info "%xTemp%."
call :SHOW_MSG "\n%xTemp%.\nYou can now refresh all browsers' windows to use the new servers." "xtack Operating Mode switched over OK to %xSwitchToOpMode%."
if "%xSilentMode%" == "1" goto :SWITCH_END
if exist .\bin\nircmdc.exe .\bin\nircmdc.exe trayballoon "xtack Switchover" "%xTemp% ..." .\bin\icons\xon.ico 4000

:SWITCH_END
REM ==> Switchover specific cleanup:
del /F /Q .\tmp\xtackprc.txt>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Check and show xtack status.
REM -------------------------------------------------------------------------

:CHECK_XTACK_STATUS
REM ==> Update logfile settings:
set xFunctionalityArea=Status
call :REFRESH_LOGFILE "xtack_status"

REM ==> Show the current xcentra status:
call :SHOW_XTACK_STATUS "status"

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing xtack status" 1 0
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Check and show xtack installation status.
REM -------------------------------------------------------------------------

:CHECK_XTACK_INSTALLATION
REM ==> Update logfile settings:
set xFunctionalityArea=Install
call :REFRESH_LOGFILE "xtack_install"

REM ==> If this is the first time xtack is run, secure installation:
if "%xFirstRun%" == "1" goto :INSTALL_XTACK_NOW
call :SHOW_MSG "Congratulations, xtack seems to be successfully installed already :-)"

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Checking xtack installation status" 1 0
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Open xtack change log in a default browser window.
REM -------------------------------------------------------------------------

:OPEN_XTACK_CHANGELOG
REM ==> Update logfile settings:
set xFunctionalityArea=Changelog
call :REFRESH_LOGFILE "xtack_changelog"

REM ==> Open xtack change log in a default browser window:
call :SHOW_MSG "Opening xtack change log in default browser now."
start /max https://xtack.org/changelog.htm

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Checking xtack installation status" 1 0
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Update manuals and documents.
REM -------------------------------------------------------------------------

:DOWNLOAD_XTACK_DOCS
REM ==> Update logfile settings:
set xFunctionalityArea=Docs
call :REFRESH_LOGFILE "xtack_docs"
call :LOG_ENTRY info "xtack docs updating attempt."

:GETDOCS_ENTRY_POINT_FROM_XTACK_UPDATE
REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Filter + cache xtack.ini configuration settings for quicker parsing:
type .\cfg\xtack.ini|%xGawk% "!/([ \t]*#|^$)/"|%xGawk% "BEGIN{IGNORECASE=1}/(Manual|Document|Guide|Book|Reference|Paper|Documentation|ApiDocumentation)[ \t]*=[ \t]*/{gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(\"[ \t]*=[ \t]*\",\"=\");gsub(/=(Yes|True|On|Enabled)$/,\"=1\");gsub(/=(No|False|Off|Disabled)$/,\"=0\");print $0}">.\tmp\doccache.txt

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Caching document configuration" 0 1

REM ==> If xtack docs being called via "xtack update -d", skip Internet
REM ==> connectivity check and user polling:
if defined xNumberOfNewComponentsAvailable goto :GETDOCS_PREPARE_DOWNLOAD_LOOP

REM ==> Verify Internet connectivity:
call :CHECK_INET_CONNECTIVITY

if "%xHostHasInetConnectivity%" == "1" goto :GETDOCS_CHECK_IF_IN_REGRESSION
call :SHOW_MSG "\nManuals and documents can't be updated as Internet can't be reached!\nPlease check and try again. Now exiting ..."
call :LOG_ENTRY error "Manuals and documents can't be updated due to lack of Internet connectivity. Now exiting."

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Checking Internet connectivity" 0 1
goto :GETDOCS_END

:GETDOCS_CHECK_IF_IN_REGRESSION
if /i "%2" == "-regression" goto :GETDOCS_YES_DOWNLOAD_AND_OVERWRITE_DOCS

REM ==> Ask the user whether he/she wants to download/rewrite manuals and
REM ==> documents now:
call :ASK_USER_YES_NO_QUESTION "Do you want to download/rewrite manuals and documents now" 1
if /i "%xTemp%" == "Y" goto :GETDOCS_YES_DOWNLOAD_AND_OVERWRITE_DOCS

REM ==> The user refused to download documents now:
call :SHOW_MSG "\nOK, thanks, now exiting without downloading anything ..."
goto :GETDOCS_END

:GETDOCS_YES_DOWNLOAD_AND_OVERWRITE_DOCS
REM ==> The user accepted to download documents now:
call :SHOW_MSG "\nOK thanks, setting everything up for the downloads. They may take some\ntime, depending on your connection speed ..."

:GETDOCS_PREPARE_DOWNLOAD_LOOP
REM ==> Reset counter of successfully downloaded and moved documents:
if not exist .\docs md .\docs>nul 2>nul
set xUpdatedDocs=0
set xTemp=
del /F /Q .\tmp\xtacktmp1.txt>nul 2>nul

REM ==> Execute the main download loop:
for /f "usebackq delims=" %%i in (`type .\tmp\doccache.txt`) do (
    set xTemp=%%i

    REM ==> Reset the manual/document title, URL and destination:
    set xTitle=
    set xUrl=
    set xDestination=%~dp0docs\

    REM ==> Get the manual/document title and URL:
    for /f "usebackq delims=" %%j in (`set xTemp^|%xGawk% -F^= "{gsub(\"Manual\",\" Manual\");gsub(\"ApiDocumentation\",\" API Documentation\");gsub(\"Php\",\"PHP\");gsub(\"Pear\",\"PEAR\");gsub(\"Sql\",\"SQL\");gsub(\"SQL5\",\"SQL 5.\");print $2}"`) do set xTitle=%%j
    for /f "usebackq delims=" %%j in (`set xTemp^|%xGawk% -F^= "{print $3}"`) do set xUrl=%%j

    REM ==> Now perform the download:
    setlocal enabledelayedexpansion
    call :DOWNLOAD_FILE "!xTitle!" "!xUrl!" "!xDestination!" 0 0 0

    REM ==> Save the result from the download subroutine to a temporary file
    REM ==> for later success rate calculation:
    set xTemp>>.\tmp\xtacktmp1.txt
    endlocal
)

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Documentation downloading loop" 1 0

REM ==> Count the total number of manuals/documents originally requested
REM ==> for update in xtack.ini:
for /f "usebackq delims=" %%i in (`type .\tmp\doccache.txt^|%xGawk% "END{print NR}"`) do set xTemp=%%i

REM ==> Count the actual number of manuals/documents successfully downloaded
REM ==> and updated and calculate the %:
for /f "usebackq delims=" %%i in (`type .\tmp\xtacktmp1.txt^|%xGawk% "BEGIN{i=0}/^xTemp=0$/{i++}END{print i}"`) do set xUpdatedDocs=%%i
set /a xPercentage=xUpdatedDocs*100/xTemp

REM ==> Inform the user about the number of successful downloads/updates:
if "%xUpdatedDocs%" == "0" (
    call :SHOW_MSG "\nUnfortunately, no documents could be downloaded/updated. Please check!"
    call :LOG_ENTRY error "xtack getdocs run but no documents could be downloaded/updated."
)
if /i "%xUpdatedDocs%" == "%xTemp%" (
    call :SHOW_MSG "\nAll the %xTemp% requested documents have been successfully updated!"
    call :LOG_ENTRY info "xtack getdocs run, all the %xTemp% requested documents have been successfully downloaded/updated."
) else if /i %xUpdatedDocs% LSS %xTemp% (
    call :SHOW_MSG "\nWARNING: Only %xUpdatedDocs% documents out of %xTemp% (~%xPercentage%\045) have been downloaded OK.\nPlease check their URLs in xtack.ini and try again if you want ..."
    call :LOG_ENTRY warning "xtack getdocs run, but only %xUpdatedDocs% documents out of %xTemp% (~%xPercentage% percent) have been downloaded/updated OK."
)

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Documentation download success rate calculation" 1 0

:GETDOCS_END
REM ==> Getdocs specific cleanup:
del /F /Q .\tmp\doccache.txt .\tmp\wgetitem.txt .\tmp\xtacktmp1.txt>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Composer wrapper: Call Composer from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_COMPOSER
REM ==> Update logfile settings:
set xFunctionalityArea=Composer
call :REFRESH_LOGFILE "xtack_composer"
call :LOG_ENTRY info "xtack composer wrapper run for command/switch %2."

REM ==> If default packages folder doesn't exist, create it now:
if not exist .\www\packages md .\www\packages>nul 2>nul

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check whether composer.phar file exists and can be run:
if not exist .\bin\composer\composer.phar goto :COMPOSER_DOESNT_EXIST
if not exist .\bin\p%xBatPhp%\php.exe goto :COMPOSER_CANT_RUN

REM ==> Verify Internet connectivity and eventually show and log a warning:
call :CHECK_PACKAGE_MANAGER_CONNECTIVITY "Composer"

:COMPOSER_PREPARE_PHP_INI
REM ==> Portabilize/copy php.ini for PHP:
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\php%xBatPhp%.ini" "%~dp0bin\p%xBatPhp%\php.ini"
REM ==> If corresponding php.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\php%xBatPhp%.ini .\bin\p%xBatPhp%\php.ini">nul 2>nul

REM ==> Check if composer.json file exists and if not create a default one:
if exist .\composer.json goto :COMPOSER_RUN
echo Creating xtack's default composer.json file. Please wait ...|%xLog%
echo.|%xLog%
echo {>.\composer.json
echo     "name": "xcentra/xtack",>>.\composer.json
echo     "description": "Base xtack composer.json configuration file. This is a xtack system file. Please DO NOT remove it!",>>.\composer.json
echo     "license": "GPL-3.0",>>.\composer.json
echo     "authors": [>>.\composer.json
echo         {>>.\composer.json
echo             "name": "%xCR%",>>.\composer.json
echo             "email": "info@xtack.org">>.\composer.json
echo         }>>.\composer.json
echo     ],>>.\composer.json
echo     "require": {},>>.\composer.json
echo     "config": {>>.\composer.json
echo         "vendor-dir": "www\\packages">>.\composer.json
echo     }>>.\composer.json
echo }>>.\composer.json

:COMPOSER_RUN
REM ==> Run Composer now:
if not "%xHostHasInetConnectivity%" == "1" goto :COMPOSER_SKIP_SELFUPDATE
echo Self-updating Composer (if necessary). Please wait ...|%xLog%
echo.|%xLog%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\composer\composer.phar selfupdate>nul 2>nul

:COMPOSER_SKIP_SELFUPDATE
echo Running Composer from within xtack. Please wait ...|%xLog%
echo.|%xLog%
for /f "usebackq delims=" %%i in (`echo %2 %3 %4 %5 %6 %7 %8 %9^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{i++;gsub(/(-regression|ECHO is on\.)/, \"\");print \"--no-ansi \" $0}END{if(i==0){print \"--no-ansi\"}}"`) do set xTemp=%%i
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\composer\composer.phar %xTemp%]>> %xLogfile%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\composer\composer.phar %xTemp% 2>&1|%xLog%
goto :COMPOSER_END

:COMPOSER_CANT_RUN
echo ERROR: Sorry but Composer can't run as PHP %xBatPhp% is missing.|%xLog%
call :LOG_ENTRY error "Composer can't run as PHP %xBatPhp% is missing."
goto :COMPOSER_END

:COMPOSER_DOESNT_EXIST
echo ERROR: Sorry but Composer can't run as it is missing in directory|%xLog%
echo %~dp0bin\composer\|%xLog%
echo.|%xLog%
if "%xHostHasInetConnectivity%" == "0" goto :COMPOSER_END
call :LOG_ENTRY error "Composer can't run as it is missing on directory %~dp0bin\composer\. Now asking user whether to download/install it."

REM ==> Ask the user whether he/she wants to download and install Composer:
call :ASK_USER_YES_NO_QUESTION "Do you want to download and install it now" 1
if /i "%xTemp%" == "Y" goto :COMPOSER_YES_DOWNLOAD_COMPOSER_PHAR

REM ==> The user refused to download and install Composer now:
echo.|%xLog%
echo OK, thanks, you can download it from https://getcomposer.org/download/|%xLog%
call :LOG_ENTRY info "The user refused to download/install Composer. Now exiting."
goto :COMPOSER_END

:COMPOSER_YES_DOWNLOAD_COMPOSER_PHAR
call :DOWNLOAD_COMPOSER
if not "%xTemp%" == "2" (
    call :LOG_ENTRY info "The user accepted to download/install Composer and it was successfully installed on directory %~dp0bin\composer\"
    echo.|%xLog%
    goto :COMPOSER_PREPARE_PHP_INI
)

echo Download it from https://getcomposer.org/download/ and try again ...|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "The user accepted to download/install Composer, but it failed to download. Now exiting."

:COMPOSER_END
del /F /Q .\bin\p%xBatPhp%\php.ini .\tmp\composer-cacert-*.pem>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: PHP_CodeSniffer wrapper: Call phpcs from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_PHPCS
REM ==> Update logfile settings:
set xFunctionalityArea=PHP_CodeSniffer
call :REFRESH_LOGFILE "xtack_phpcs"
call :LOG_ENTRY info "xtack PHP_CodeSniffer wrapper run for command/switch %~1 %~2."

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

:PHPCS_CHECK_IF_INSTALLED
REM ==> Check whether phpcs.phar and phpcbf.phar files exist:
if /i "%1" == "phpcs" if not exist .\bin\phpcs\phpcs.phar goto :PHPCS_DOESNT_EXIST
if /i "%1" == "phpcbf" if not exist .\bin\phpcs\phpcbf.phar goto :PHPCS_DOESNT_EXIST

:PHPCS_CHECK_IF_PHP_ENGINE_EXISTS
if not exist .\bin\p%xBatPhp%\php.exe goto :PHPCS_CANT_RUN

:PHPCS_PREPARE_PHP_INI
REM ==> Portabilize/copy php.ini for PHP:
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\php%xBatPhp%.ini" "%~dp0bin\p%xBatPhp%\php.ini"
REM ==> If corresponding php.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\php%xBatPhp%.ini .\bin\p%xBatPhp%\php.ini">nul 2>nul

REM ==> Overwrite .\bin\phpcs\CodeSniffer.conf file to enable WordPress
REM ==> coding standards:
set xTemp=%~dp0bin\phpcs\Standards\
set xTemp=%xTemp:\=\\%
echo Recreating PHP_CodeSniffer configuration file. Please wait ...|%xLog%
echo.|%xLog%
echo ^<?php $phpCodeSnifferConfig = array('installed_paths' =^> '%xTemp%',)?^>> .\bin\phpcs\CodeSniffer.conf

:PHPCS_RUN
REM ==> Run PHP_CodeSniffer now:
echo Running PHP_CodeSniffer's %~1 from within xtack. Remember to enclose|%xLog%
echo all PHP_CodeSniffer arguments including an equal sign (=) within|%xLog%
echo double quotes, so they can be properly parsed. Please wait ...|%xLog%
echo.|%xLog%
for /f "usebackq delims=" %%i in (`echo %2 %3 %4 %5 %6 %7 %8 %9^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{i++;gsub(/(-regression|ECHO is on\.)/, \"\");print \"--no-colors \" $0}END{if(i==0){print \"--no-colors\"}}"`) do set xTemp=%%i
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpcs\%~1.phar %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9]>> %xLogfile%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpcs\%~1.phar %xTemp%|%xLog%
goto :PHPCS_END

:PHPCS_CANT_RUN
echo ERROR: Sorry but PHP_CodeSniffer can't run as PHP %xBatPhp% is missing.|%xLog%
call :LOG_ENTRY error "PHP_CodeSniffer can't run as PHP %xBatPhp% is missing."
goto :PHPCS_END

:PHPCS_DOESNT_EXIST
echo ERROR: Sorry but PHP_CodeSniffer can't run as it is missing in directory|%xLog%
echo %~dp0bin\phpcs\|%xLog%
echo.|%xLog%
if "%xHostHasInetConnectivity%" == "0" goto :PHPCS_END
call :LOG_ENTRY error "PHP_CodeSniffer can't run as it is missing on directory %~dp0bin\phpcs\. Now asking user whether to download/install it."

REM ==> Ask the user whether he/she wants to download and install
REM ==> PHP_CodeSniffer now:
call :ASK_USER_YES_NO_QUESTION "Do you want to download and install it now" 1
if /i "%xTemp%" == "Y" goto :PHPCS_YES_DOWNLOAD_PHPCS_PHAR

REM ==> The user refused to download and install PHP_CodeSniffer now:
echo.|%xLog%
echo OK, thanks, you can download it from:|%xLog%
echo https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar|%xLog%
echo https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar|%xLog%
call :LOG_ENTRY info "The user refused to download/install PHP_CodeSniffer. Now exiting."
goto :PHPCS_END

:PHPCS_YES_DOWNLOAD_PHPCS_PHAR
call :DOWNLOAD_FILE "PHP_CodeSniffer" "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar" ".\bin\phpcs\" 0 1 0
call :DOWNLOAD_FILE "PHP_CodeSniffer" "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar" ".\bin\phpcs\" 0 1 0
if exist .\bin\phpcs\phpcs.phar if exist .\bin\phpcs\phpcbf.phar (
    call :LOG_ENTRY info "The user accepted to download/install PHP_CodeSniffer and it was successfully installed on directory %~dp0bin\phpcs\"
    echo.|%xLog%
    goto :PHPCS_PREPARE_PHP_INI
)

echo Download it from https://squizlabs.github.io/PHP_CodeSniffer/ and try again ...|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "The user accepted to download/install PHP_CodeSniffer, but it failed to download. Now exiting."

:PHPCS_END
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: PHPUnit wrapper: Call PHPUnit from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_PHPUNIT
REM ==> Update logfile settings:
set xFunctionalityArea=PHPUnit
call :REFRESH_LOGFILE "xtack_phpunit"
call :LOG_ENTRY info "xtack xtack_phpunit wrapper run for command/switch %2."

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check whether composer.phar file exists:
if not exist .\bin\phpunit\phpunit.phar goto :PHPUNIT_DOESNT_EXIST
if not exist .\bin\p%xBatPhp%\php.exe goto :PHPUNIT_CANT_RUN

REM ==> Verify Internet connectivity:
call :CHECK_INET_CONNECTIVITY 1
if "%xDebugMode%" == "1" echo %xDbgM%Host has Internet connectivity: %xHostHasInetConnectivity%]>> %xLogfile%

:PHPUNIT_PREPARE_PHP_INI
REM ==> Portabilize/copy php.ini for PHP:
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\php%xBatPhp%.ini" "%~dp0bin\p%xBatPhp%\php.ini"
REM ==> If corresponding php.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\php%xBatPhp%.ini .\bin\p%xBatPhp%\php.ini">nul 2>nul

REM ==> Run PHPUnit now:
if not "%xHostHasInetConnectivity%" == "1" goto :PHPUNIT_SKIP_SELFUPGRADE
echo Self-upgrading PHPUnit (if necessary). Please wait ...|%xLog%
echo.|%xLog%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpunit\phpunit.phar self-upgrade>nul 2>nul

:PHPUNIT_SKIP_SELFUPGRADE
echo Running PHPUnit from within xtack. Please wait ...|%xLog%
echo.|%xLog%
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpunit\phpunit.phar %2 %3 %4 %5 %6 %7 %8 %9]>> %xLogfile%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpunit\phpunit.phar %2 %3 %4 %5 %6 %7 %8 %9|%xLog%
goto :PHPUNIT_END

:PHPUNIT_CANT_RUN
echo ERROR: Sorry but PHPUnit can't run as PHP %xBatPhp% is missing.|%xLog%
call :LOG_ENTRY error "PHPUnit can't run as PHP %xBatPhp% is missing."
goto :PHPUNIT_END

:PHPUNIT_DOESNT_EXIST
echo ERROR: Sorry but PHPUnit can't run as it is missing in directory|%xLog%
echo %~dp0bin\phpunit\|%xLog%
echo.|%xLog%
if "%xHostHasInetConnectivity%" == "0" goto :PHPUNIT_END
call :LOG_ENTRY error "PHPUnit can't run as it is missing on directory %~dp0bin\phpunit\. Now asking user whether to download/install it."

REM ==> Ask the user whether he/she wants to download and install Composer:
call :ASK_USER_YES_NO_QUESTION "Do you want to download and install it now" 1
if /i "%xTemp%" == "Y" goto :PHPUNIT_YES_DOWNLOAD_PHPUNIT_PHAR

REM ==> The user refused to download and install PHPUnit now:
echo.|%xLog%
echo OK, thanks, you can download it from https://phar.phpunit.de/phpunit.phar|%xLog%
call :LOG_ENTRY info "The user refused to download/install PHPUnit. Now exiting."
goto :PHPUNIT_END

:PHPUNIT_YES_DOWNLOAD_PHPUNIT_PHAR
call :DOWNLOAD_PHPUNIT
if not "%xTemp%" == "2" (
    call :LOG_ENTRY info "The user accepted to download/install PHPUnit and it was successfully installed on directory %~dp0bin\phpunit\"
    echo.|%xLog%
    goto :PHPUNIT_PREPARE_PHP_INI
)

echo Download it from https://phar.phpunit.de/phpunit.phar and try again ...|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "The user accepted to download/install PHPUnit, but it failed to download. Now exiting."

:PHPUNIT_END
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: PHPMD wrapper: Call PHPMD from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_PHPMD
REM ==> Update logfile settings:
set xFunctionalityArea=PHPMD
call :REFRESH_LOGFILE "xtack_phpmd"
call :LOG_ENTRY info "xtack xtack_phpmd wrapper run for command/switch %2."

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check whether composer.phar file exists:
if not exist .\bin\phpmd\phpmd.phar goto :PHPMD_DOESNT_EXIST
if not exist .\bin\p%xBatPhp%\php.exe goto :PHPMD_CANT_RUN

REM ==> Verify Internet connectivity:
call :CHECK_INET_CONNECTIVITY 1
if "%xDebugMode%" == "1" echo %xDbgM%Host has Internet connectivity: %xHostHasInetConnectivity%]>> %xLogfile%

:PHPMD_PREPARE_PHP_INI
REM ==> Portabilize/copy php.ini for PHP:
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\php%xBatPhp%.ini" "%~dp0bin\p%xBatPhp%\php.ini"
REM ==> If corresponding php.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\php%xBatPhp%.ini .\bin\p%xBatPhp%\php.ini">nul 2>nul

REM ==> Run PHPMD now:
echo INFO: PHPMD documentation: https://phpmd.org/documentation/index.html|%xLog%
echo.|%xLog%
echo Running PHPMD from within xtack. Please wait ...|%xLog%
echo.|%xLog%
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpmd\phpmd.phar %2 %3 %4 %5 %6 %7 %8 %9]>> %xLogfile%
.\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpmd\phpmd.phar %2 %3 %4 %5 %6 %7 %8 %9|%xLog%
goto :PHPMD_END

:PHPMD_CANT_RUN
echo ERROR: Sorry but PHPMD can't run as PHP %xBatPhp% is missing.|%xLog%
call :LOG_ENTRY error "PHPMD can't run as PHP %xBatPhp% is missing."
goto :PHPM_END

:PHPMD_DOESNT_EXIST
echo ERROR: Sorry but PHPMD can't run as it is missing in directory|%xLog%
echo %~dp0bin\phpmd\|%xLog%
echo.|%xLog%
if "%xHostHasInetConnectivity%" == "0" goto :PHPMD_END
call :LOG_ENTRY error "PHPMD can't run as it is missing on directory %~dp0bin\phpmd\. Now asking user whether to download/install it."

REM ==> Ask the user whether he/she wants to download and install Composer:
call :ASK_USER_YES_NO_QUESTION "Do you want to download and install it now" 1
if /i "%xTemp%" == "Y" goto :PHPMD_YES_DOWNLOAD_PHPMD_PHAR

REM ==> The user refused to download and install PHPMD now:
echo.|%xLog%
echo OK, thanks, you can download it from:|%xLog%
echo https://static.phpmd.org/php/latest/phpmd.phar|%xLog%
call :LOG_ENTRY info "The user refused to download/install PHPMD. Now exiting."
goto :PHPMD_END

:PHPMD_YES_DOWNLOAD_PHPMD_PHAR
call :DOWNLOAD_PHPMD
if not "%xTemp%" == "2" (
    call :LOG_ENTRY info "The user accepted to download/install PHPMD and it was successfully installed on directory %~dp0bin\phpmd\"
    echo.|%xLog%
    goto :PHPMD_PREPARE_PHP_INI
)

echo You can download it from https://static.phpmd.org/php/latest/phpmd.phar|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "The user accepted to download/install PHPMD, but it failed to download. Now exiting."

:PHPMD_END
del /F /Q .\bin\p%xBatPhp%\php.ini>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: NPM wrapper: Call NPM from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_NPM
REM ==> Update logfile settings:
set xFunctionalityArea=npm
call :REFRESH_LOGFILE "xtack_npm"
call :LOG_ENTRY info "xtack npm wrapper run for command/switch %2."

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check whether npm can't run:
if not exist .\bin\njs\node.exe goto :NPM_CANT_RUN
if not exist .\bin\njs\node_modules\npm\bin\npm-cli.js goto :NPM_CANT_RUN

REM ==> Verify Internet connectivity and eventually show and log a warning:
call :CHECK_PACKAGE_MANAGER_CONNECTIVITY "npm"

REM ==> Run npm now:
echo Running npm from within xtack. Please wait ...|%xLog%
echo.|%xLog%
npm set tmp .\\tmp
npm set cache .\\tmp
npm set init-module .\\bin\\njs\\.npm-init.js
npm set userconfig .\\bin\\njs\\.npmrc
copy /D /V /Y "%USERPROFILE%\.npmrc" .\bin\njs\.npmrc>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\njs\node.exe "%~dp0bin\njs\node_modules\npm\bin\npm-cli.js" --prefix "%~dp0bin\njs\node_modules" %2 %3 %4 %5 %6 %7 %8 %9]>> %xLogfile%
.\bin\njs\node.exe "%~dp0bin\njs\node_modules\npm\bin\npm-cli.js" --prefix "%~dp0bin\njs\node_modules" %2 %3 %4 %5 %6 %7 %8 %9|%xLog%
goto :NPM_END

:NPM_CANT_RUN
call :LOG_ENTRY error "npm can't run as it is missing on directory %~dp0bin\bin\njs\node_modules\npm\bin\. Now asking user whether to download/install it."
echo ERROR: Sorry but npm can't run as it is missing in directory|%xLog%
echo %~dp0bin\bin\njs\node_modules\npm\bin\|%xLog%
echo.|%xLog%
echo You can download it from https://nodejs.org/en/download/current/ and try again ...|%xLog%
echo.|%xLog%

:NPM_END
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Bower wrapper: Call Bower from xtack.bat.
REM -------------------------------------------------------------------------

:EXECUTE_XTACK_BOWER
REM ==> Update logfile settings:
set xFunctionalityArea=Bower
call :REFRESH_LOGFILE "xtack_bower"
call :LOG_ENTRY info "xtack Bower wrapper run for command/switch %2."

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check whether Bower can't run:
if not exist .\bin\njs\node.exe goto :BOWER_CANT_RUN
if not exist .\bin\njs\node_modules\bower\lib\bin\bower.js goto :BOWER_CANT_RUN

REM ==> Verify Internet connectivity and eventually show and log a warning:
call :CHECK_PACKAGE_MANAGER_CONNECTIVITY "Bower"

REM ==> Run Bower now:
echo Running Bower from within xtack. Please wait ...|%xLog%
echo.|%xLog%
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\njs\node.exe "%~dp0bin\njs\node_modules\bower\lib\bin\bower.js" %2 %3 %4 %5 %6 %7 %8 %9]>> %xLogfile%
.\bin\njs\node.exe "%~dp0bin\njs\node_modules\bower\lib\bin\bower.js" %2 %3 %4 %5 %6 %7 %8 %9|%xLog%
title xtack
goto :BOWER_END

:BOWER_CANT_RUN
call :LOG_ENTRY error "Bower can't run as it is missing on directory %~dp0bin\bin\njs\node_modules\npm\bin\. Now asking user whether to download/install it."
echo ERROR: Sorry but Bower can't run as it is missing in directory|%xLog%
echo %~dp0bin\njs\node_modules\bower\lib\bin\|%xLog%
echo.|%xLog%
echo You can instal it with command "xtack npm install bower" and try again ...|%xLog%
echo.|%xLog%

:BOWER_END
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: All OpModes regression testing.
REM -------------------------------------------------------------------------

:INITIATE_XTACK_REGRESSION
REM ==> Update logfile settings:
set xFunctionalityArea=Regression
set xRegreLogCmd=.\tmp\wtee.exe -a %xLogfile%

REM ==> If missing VC Redistributable Packages, show/log error and exit:
if %xNoOfMissingRedisPkgs% GEQ 4 goto :XREGRE_END2

REM ==> Re-expand the xtack Runtime to temporary folder .\tmp\. This
REM ==> additional copy of the xtack Runtime is needed to avoid interferences
REM ==> with the target xtack instances that will be progressively launched
REM ==> during regression testing, which expand their own at %~dp0bin\:
if not exist .\bin\7za.exe goto :XREGRE_XTACK_RUNTIME_EXPANSION_FATAL_ERROR
if not exist .\bin\7za.exe goto :XREGRE_XTACK_RUNTIME_EXPANSION_FATAL_ERROR
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\runtime.7z *.*>nul 2>nul
if "%errorlevel%" == "0" goto :XREGRE_INITIAL_CLEANUP

:XREGRE_XTACK_RUNTIME_EXPANSION_FATAL_ERROR
echo FATAL ERROR: The xtack Runtime can't be expanded to folder|%xRegreLogCmd%
echo %~dp0tmp\. Now exiting ...|%xRegreLogCmd%
goto :XREGRE_END

:XREGRE_INITIAL_CLEANUP
del /F /Q .\tmp\xtack.man .\tmp\runtime.man .\tmp\*.conf .\tmp\*.ini .\tmp\*.js .\tmp\changelog.r* .\tmp\LICENSE.txt .\tmp\tstmodes.txt>nul 2>nul

:XREGRE_ASK_WHETHER_TO_PROCEED_WITH_REGRESSION_TESTING
REM ==> Ask the user whether he/she wants to start the regression test now:
echo WARNING: The full xtack regression testing could take long, over ^~2|%xRegreLogCmd%
echo hours, depending on the speed of your system ...|%xRegreLogCmd%
echo.|%xRegreLogCmd%
echo Do you really want to proceed with the testing now (Y/N)?>> %xLogfile%
set /p xTemp=Do you really want to proceed with the testing now (Y/N)?
if "%xDebugMode%" == "1" echo %xDbgM%User Answer: %xTemp%]>> %xLogfile%
if /i "%xTemp%" == "Y" goto :XREGRE_YES_PROCEED_WITH_REGRESSION_TESTING
if /i "%xTemp%" == "Yes" goto :XREGRE_YES_PROCEED_WITH_REGRESSION_TESTING
if /i "%xTemp%" == "N" goto :XREGRE_USER_HAS_ANSWERED_NOPE
if /i "%xTemp%" == "No" goto :XREGRE_USER_HAS_ANSWERED_NOPE
if /i "%xTemp%" == "Q" goto :XREGRE_USER_HAS_ANSWERED_NOPE
if /i "%xTemp%" == "Quit" goto :XREGRE_USER_HAS_ANSWERED_NOPE
echo Sorry, please answer Y/N ("Yes/No") or Q to quit ...|%xRegreLogCmd%
goto :XREGRE_ASK_WHETHER_TO_PROCEED_WITH_REGRESSION_TESTING

:XREGRE_USER_HAS_ANSWERED_NOPE
echo.|%xRegreLogCmd%
echo OK, thanks, now exiting without testing ...|%xRegreLogCmd%
goto :XREGRE_END

:XREGRE_YES_PROCEED_WITH_REGRESSION_TESTING
echo.|%xRegreLogCmd%
echo OK thanks, setting everything up to start testing. Please wait ...|%xRegreLogCmd%
echo.|%xRegreLogCmd%

REM ==> Regression tests log file setup:
if not exist .\tests md .\tests>nul 2>nul
set xTemp=%xLogfile%
for /f "usebackq delims=" %%i in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y%%m%%d_%%H%%M\")}"`) do set xLogfile=%%i
set xLogfile=xtack_%xBatRev%_regression_%COMPUTERNAME%_%xWinProduct%_%xLogfile%.log
del /F /Q .\tests\%xLogfile%.bak>nul 2>nul
if exist .\tests\%xLogfile% ren .\tests\%xLogfile% %xLogfile%.bak>nul 2>nul
set xLogfile=.\tests\%xLogfile%
move /Y %xTemp% %xLogfile%>nul
set xRegreLogCmd=.\tmp\wtee.exe -a %xLogfile%

REM ==> Show/log detailed system information to leave full traceability
REM ==> about it:
call :COLLECT_SYSTEM_INFO_WITH_WMIC 1 1
set xLog=%xRegreLogCmd%
call :SHOW_WORDWRAPPED_MSG "%xTemp%" 68

REM ==> Show short versions summary to leave traceability of what has been
REM ==> regression tested:
echo.|%xRegreLogCmd%
call :SHOW_SW_VERSIONS_SHORT
set xLog=

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Showing short versions summary" 1 0
echo.|%xRegreLogCmd%

REM ==> Apache 1.3 + MySQL 5.5:
echo a13p52m55>.\tmp\tstmodes.txt
echo a13p53m55>>.\tmp\tstmodes.txt
echo a13p54m55>>.\tmp\tstmodes.txt
echo a13p55m55>>.\tmp\tstmodes.txt
echo a13p56m55>>.\tmp\tstmodes.txt
echo a13p70m55>>.\tmp\tstmodes.txt
echo a13p71m55>>.\tmp\tstmodes.txt
echo a13p72m55>>.\tmp\tstmodes.txt

REM ==> Apache 1.3 + MySQL 5.7:
echo a13p52m57>>.\tmp\tstmodes.txt
echo a13p53m57>>.\tmp\tstmodes.txt
echo a13p54m57>>.\tmp\tstmodes.txt
echo a13p55m57>>.\tmp\tstmodes.txt
echo a13p56m57>>.\tmp\tstmodes.txt
echo a13p70m57>>.\tmp\tstmodes.txt
echo a13p71m57>>.\tmp\tstmodes.txt
echo a13p72m57>>.\tmp\tstmodes.txt

REM ==> Apache 1.3 + PostgreSQL:
echo a13p52pgs>>.\tmp\tstmodes.txt
echo a13p53pgs>>.\tmp\tstmodes.txt
echo a13p54pgs>>.\tmp\tstmodes.txt
echo a13p55pgs>>.\tmp\tstmodes.txt
echo a13p56pgs>>.\tmp\tstmodes.txt
echo a13p70pgs>>.\tmp\tstmodes.txt
echo a13p71pgs>>.\tmp\tstmodes.txt
echo a13p72pgs>>.\tmp\tstmodes.txt

REM ==> Apache 1.3 + MariaDB:
echo a13p52mra>>.\tmp\tstmodes.txt
echo a13p53mra>>.\tmp\tstmodes.txt
echo a13p54mra>>.\tmp\tstmodes.txt
echo a13p55mra>>.\tmp\tstmodes.txt
echo a13p56mra>>.\tmp\tstmodes.txt
echo a13p70mra>>.\tmp\tstmodes.txt
echo a13p71mra>>.\tmp\tstmodes.txt
echo a13p72mra>>.\tmp\tstmodes.txt

REM ==> Apache 1.3 + No DBMS:
echo a13p52ndb>>.\tmp\tstmodes.txt
echo a13p53ndb>>.\tmp\tstmodes.txt
echo a13p54ndb>>.\tmp\tstmodes.txt
echo a13p55ndb>>.\tmp\tstmodes.txt
echo a13p56ndb>>.\tmp\tstmodes.txt
echo a13p70ndb>>.\tmp\tstmodes.txt
echo a13p71ndb>>.\tmp\tstmodes.txt
echo a13p72ndb>>.\tmp\tstmodes.txt

REM ==> Apache 2.4 + MySQL 5.5:
echo a24p52m55>>.\tmp\tstmodes.txt
echo a24p53m55>>.\tmp\tstmodes.txt
echo a24p54m55>>.\tmp\tstmodes.txt
echo a24p55m55>>.\tmp\tstmodes.txt
echo a24p56m55>>.\tmp\tstmodes.txt
echo a24p70m55>>.\tmp\tstmodes.txt
echo a24p71m55>>.\tmp\tstmodes.txt
echo a24p72m55>>.\tmp\tstmodes.txt

REM ==> Apache 2.4 + MySQL 5.7:
echo a24p52m57>>.\tmp\tstmodes.txt
echo a24p53m57>>.\tmp\tstmodes.txt
echo a24p54m57>>.\tmp\tstmodes.txt
echo a24p55m57>>.\tmp\tstmodes.txt
echo a24p56m57>>.\tmp\tstmodes.txt
echo a24p70m57>>.\tmp\tstmodes.txt
echo a24p71m57>>.\tmp\tstmodes.txt
echo a24p72m57>>.\tmp\tstmodes.txt

REM ==> Apache 2.4 + PostgreSQL:
echo a24p52pgs>>.\tmp\tstmodes.txt
echo a24p53pgs>>.\tmp\tstmodes.txt
echo a24p54pgs>>.\tmp\tstmodes.txt
echo a24p55pgs>>.\tmp\tstmodes.txt
echo a24p56pgs>>.\tmp\tstmodes.txt
echo a24p70pgs>>.\tmp\tstmodes.txt
echo a24p71pgs>>.\tmp\tstmodes.txt
echo a24p72pgs>>.\tmp\tstmodes.txt

REM ==> Apache 2.4 + MariaDB:
echo a24p52mra>>.\tmp\tstmodes.txt
echo a24p53mra>>.\tmp\tstmodes.txt
echo a24p54mra>>.\tmp\tstmodes.txt
echo a24p55mra>>.\tmp\tstmodes.txt
echo a24p56mra>>.\tmp\tstmodes.txt
echo a24p70mra>>.\tmp\tstmodes.txt
echo a24p71mra>>.\tmp\tstmodes.txt
echo a24p72mra>>.\tmp\tstmodes.txt

REM ==> Apache 2.4 + No DBMS:
echo a24p52ndb>>.\tmp\tstmodes.txt
echo a24p53ndb>>.\tmp\tstmodes.txt
echo a24p54ndb>>.\tmp\tstmodes.txt
echo a24p55ndb>>.\tmp\tstmodes.txt
echo a24p56ndb>>.\tmp\tstmodes.txt
echo a24p70ndb>>.\tmp\tstmodes.txt
echo a24p71ndb>>.\tmp\tstmodes.txt
echo a24p72ndb>>.\tmp\tstmodes.txt

REM ==> Nginx + MySQL 5.5:
echo ngxp52m55>>.\tmp\tstmodes.txt
echo ngxp53m55>>.\tmp\tstmodes.txt
echo ngxp54m55>>.\tmp\tstmodes.txt
echo ngxp55m55>>.\tmp\tstmodes.txt
echo ngxp56m55>>.\tmp\tstmodes.txt
echo ngxp70m55>>.\tmp\tstmodes.txt
echo ngxp71m55>>.\tmp\tstmodes.txt
echo ngxp72m55>>.\tmp\tstmodes.txt

REM ==> Nginx + MySQL 5.7:
echo ngxp52m57>>.\tmp\tstmodes.txt
echo ngxp53m57>>.\tmp\tstmodes.txt
echo ngxp54m57>>.\tmp\tstmodes.txt
echo ngxp55m57>>.\tmp\tstmodes.txt
echo ngxp56m57>>.\tmp\tstmodes.txt
echo ngxp70m57>>.\tmp\tstmodes.txt
echo ngxp71m57>>.\tmp\tstmodes.txt
echo ngxp72m57>>.\tmp\tstmodes.txt

REM ==> Nginx + PostgreSQL:
echo ngxp52pgs>>.\tmp\tstmodes.txt
echo ngxp53pgs>>.\tmp\tstmodes.txt
echo ngxp54pgs>>.\tmp\tstmodes.txt
echo ngxp55pgs>>.\tmp\tstmodes.txt
echo ngxp56pgs>>.\tmp\tstmodes.txt
echo ngxp70pgs>>.\tmp\tstmodes.txt
echo ngxp71pgs>>.\tmp\tstmodes.txt
echo ngxp72pgs>>.\tmp\tstmodes.txt

REM ==> Nginx + MariaDB:
echo ngxp52mra>>.\tmp\tstmodes.txt
echo ngxp53mra>>.\tmp\tstmodes.txt
echo ngxp54mra>>.\tmp\tstmodes.txt
echo ngxp55mra>>.\tmp\tstmodes.txt
echo ngxp56mra>>.\tmp\tstmodes.txt
echo ngxp70mra>>.\tmp\tstmodes.txt
echo ngxp71mra>>.\tmp\tstmodes.txt
echo ngxp72mra>>.\tmp\tstmodes.txt

REM ==> Nginx + No DBMS:
echo ngxp52ndb>>.\tmp\tstmodes.txt
echo ngxp53ndb>>.\tmp\tstmodes.txt
echo ngxp54ndb>>.\tmp\tstmodes.txt
echo ngxp55ndb>>.\tmp\tstmodes.txt
echo ngxp56ndb>>.\tmp\tstmodes.txt
echo ngxp70ndb>>.\tmp\tstmodes.txt
echo ngxp71ndb>>.\tmp\tstmodes.txt
echo ngxp72ndb>>.\tmp\tstmodes.txt

REM ==> Node.js + MySQL 5.5:
echo njsp52m55>>.\tmp\tstmodes.txt
echo njsp53m55>>.\tmp\tstmodes.txt
echo njsp54m55>>.\tmp\tstmodes.txt
echo njsp55m55>>.\tmp\tstmodes.txt
echo njsp56m55>>.\tmp\tstmodes.txt
echo njsp70m55>>.\tmp\tstmodes.txt
echo njsp71m55>>.\tmp\tstmodes.txt
echo njsp72m55>>.\tmp\tstmodes.txt

REM ==> Node.js + MySQL 5.7:
echo njsp52m57>>.\tmp\tstmodes.txt
echo njsp53m57>>.\tmp\tstmodes.txt
echo njsp54m57>>.\tmp\tstmodes.txt
echo njsp55m57>>.\tmp\tstmodes.txt
echo njsp56m57>>.\tmp\tstmodes.txt
echo njsp70m57>>.\tmp\tstmodes.txt
echo njsp71m57>>.\tmp\tstmodes.txt
echo njsp72m57>>.\tmp\tstmodes.txt

REM ==> Node.js + PostgreSQL:
echo njsp52pgs>>.\tmp\tstmodes.txt
echo njsp53pgs>>.\tmp\tstmodes.txt
echo njsp54pgs>>.\tmp\tstmodes.txt
echo njsp55pgs>>.\tmp\tstmodes.txt
echo njsp56pgs>>.\tmp\tstmodes.txt
echo njsp70pgs>>.\tmp\tstmodes.txt
echo njsp71pgs>>.\tmp\tstmodes.txt
echo njsp72pgs>>.\tmp\tstmodes.txt

REM ==> Node.js + MariaDB:
echo njsp52mra>>.\tmp\tstmodes.txt
echo njsp53mra>>.\tmp\tstmodes.txt
echo njsp54mra>>.\tmp\tstmodes.txt
echo njsp55mra>>.\tmp\tstmodes.txt
echo njsp56mra>>.\tmp\tstmodes.txt
echo njsp70mra>>.\tmp\tstmodes.txt
echo njsp71mra>>.\tmp\tstmodes.txt
echo njsp72mra>>.\tmp\tstmodes.txt

REM ==> Node.js + No DBMS:
echo njsp52ndb>>.\tmp\tstmodes.txt
echo njsp53ndb>>.\tmp\tstmodes.txt
echo njsp54ndb>>.\tmp\tstmodes.txt
echo njsp55ndb>>.\tmp\tstmodes.txt
echo njsp56ndb>>.\tmp\tstmodes.txt
echo njsp70ndb>>.\tmp\tstmodes.txt
echo njsp71ndb>>.\tmp\tstmodes.txt
echo njsp72ndb>>.\tmp\tstmodes.txt

REM ==> IIS Express + MySQL 5.5:
echo iisp52m55>>.\tmp\tstmodes.txt
echo iisp53m55>>.\tmp\tstmodes.txt
echo iisp54m55>>.\tmp\tstmodes.txt
echo iisp55m55>>.\tmp\tstmodes.txt
echo iisp56m55>>.\tmp\tstmodes.txt
echo iisp70m55>>.\tmp\tstmodes.txt
echo iisp71m55>>.\tmp\tstmodes.txt
echo iisp72m55>>.\tmp\tstmodes.txt

REM ==> IIS Express + MySQL 5.7:
echo iisp52m57>>.\tmp\tstmodes.txt
echo iisp53m57>>.\tmp\tstmodes.txt
echo iisp54m57>>.\tmp\tstmodes.txt
echo iisp55m57>>.\tmp\tstmodes.txt
echo iisp56m57>>.\tmp\tstmodes.txt
echo iisp70m57>>.\tmp\tstmodes.txt
echo iisp71m57>>.\tmp\tstmodes.txt
echo iisp72m57>>.\tmp\tstmodes.txt

REM ==> IIS Express + PostgreSQL:
echo iisp52pgs>>.\tmp\tstmodes.txt
echo iisp53pgs>>.\tmp\tstmodes.txt
echo iisp54pgs>>.\tmp\tstmodes.txt
echo iisp55pgs>>.\tmp\tstmodes.txt
echo iisp56pgs>>.\tmp\tstmodes.txt
echo iisp70pgs>>.\tmp\tstmodes.txt
echo iisp71pgs>>.\tmp\tstmodes.txt
echo iisp72pgs>>.\tmp\tstmodes.txt

REM ==> IIS Express + MariaDB:
echo iisp52mra>>.\tmp\tstmodes.txt
echo iisp53mra>>.\tmp\tstmodes.txt
echo iisp54mra>>.\tmp\tstmodes.txt
echo iisp55mra>>.\tmp\tstmodes.txt
echo iisp56mra>>.\tmp\tstmodes.txt
echo iisp70mra>>.\tmp\tstmodes.txt
echo iisp71mra>>.\tmp\tstmodes.txt
echo iisp72mra>>.\tmp\tstmodes.txt

REM ==> IIS Express + No DBMS:
echo iisp52ndb>>.\tmp\tstmodes.txt
echo iisp53ndb>>.\tmp\tstmodes.txt
echo iisp54ndb>>.\tmp\tstmodes.txt
echo iisp55ndb>>.\tmp\tstmodes.txt
echo iisp56ndb>>.\tmp\tstmodes.txt
echo iisp70ndb>>.\tmp\tstmodes.txt
echo iisp71ndb>>.\tmp\tstmodes.txt
echo iisp72ndb>>.\tmp\tstmodes.txt

REM ==> Test a silent startup:
echo silent a24p70pgs>>.\tmp\tstmodes.txt
echo stop -s>>.\tmp\tstmodes.txt

REM ==> "Legacy" mode standard (but yet somewhat special) test case:
echo legacy>>.\tmp\tstmodes.txt

REM ==> Test also a wrong OpMode:
echo foobar>>.\tmp\tstmodes.txt

REM ==> Test OpMode switching too. The first one will ask the user whether
REM ==> to start xtack:
echo switch a24p56m55>>.\tmp\tstmodes.txt
echo switch ngxp70m57 -s>>.\tmp\tstmodes.txt

REM ==> Special test cases with xtack STOPPED:
echo stop>>.\tmp\tstmodes.txt
echo help>>.\tmp\tstmodes.txt
echo config>>.\tmp\tstmodes.txt
echo ver>>.\tmp\tstmodes.txt
echo ver -l>>.\tmp\tstmodes.txt
echo ver -L>>.\tmp\tstmodes.txt
echo status>>.\tmp\tstmodes.txt
echo docs>>.\tmp\tstmodes.txt
echo update>>.\tmp\tstmodes.txt
echo composer diagnose>>.\tmp\tstmodes.txt
echo clean>>.\tmp\tstmodes.txt

REM ==> Special test cases with xtack UP AND RUNNING:
echo start>>.\tmp\tstmodes.txt
echo help>>.\tmp\tstmodes.txt
echo config>>.\tmp\tstmodes.txt
echo ver>>.\tmp\tstmodes.txt
echo ver -l>>.\tmp\tstmodes.txt
echo ver -L>>.\tmp\tstmodes.txt
echo status>>.\tmp\tstmodes.txt
echo docs>>.\tmp\tstmodes.txt
echo update>>.\tmp\tstmodes.txt
echo composer diagnose>>.\tmp\tstmodes.txt
echo clean>>.\tmp\tstmodes.txt
echo stop>>.\tmp\tstmodes.txt

REM ==> Reset test counters:
set xCurrentTestCounter=0
set xStandardTestCounter=0
set xSpecialTestCounter=0
set xTestPercentage=0
for /f "usebackq delims=" %%i in (`type .\tmp\tstmodes.txt^|.\tmp\gawk.exe "END{print NR}"`) do set xNoOfTotalTests=%%i

REM ==> Count and show/log the number of OpModes to be regression tested.
REM ==> Let a fictitious "foobar" OpMode pass now as standard test case
REM ==> to later assess that it fails during loop execution:
for /f "usebackq delims=" %%i in (`type .\tmp\tstmodes.txt^|.\tmp\gawk.exe "BEGIN{IGNORECASE=1;i=0};/^^(foobar|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb)) *$/{i++}END{print i}"`) do set xNumOfStandardTestCases=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\tstmodes.txt^|.\tmp\gawk.exe "BEGIN{IGNORECASE=1;i=0};!/^^(foobar|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb)) *$/{i++}END{print i}"`) do set xNumOfSpecialTestCases=%%i
call :LOG_ENTRY info "*** xtack.bat %xBatRev% regression test execution started for %xNumOfStandardTestCases% standard OpMode(s) and %xNumOfSpecialTestCases% special test case(s)."
echo Regression testing all the xtack start/stop cycles for %xNumOfStandardTestCases% standard|%xRegreLogCmd%
echo OpModes and %xNumOfSpecialTestCases% special test cases for xtack.bat %xBatRev% ...|%xRegreLogCmd%
echo.|%xRegreLogCmd%

:XREGRE_LOOP
REM ==> Execute the main regression tests loop:
REM ==> Step current OpMode counter up and check if the end of test modes
REM ==> file has been reached:
set /a xCurrentTestCounter+=1

REM ==> Get the current OpMode to test:
for /f "usebackq delims=" %%i in (`type .\tmp\tstmodes.txt^|.\tmp\gawk.exe "{if(NR==%xCurrentTestCounter%){print $0}}"`) do set xMode=%%i
for /f "usebackq delims=" %%j in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTestStart=%%j

REM ==> Check whether this is a special test case. Let a fictitious "foobar"
REM ==> OpMode pass as standard test:
echo %xMode%| .\tmp\gawk.exe "{print $1}"| .\tmp\gawk.exe "BEGIN{IGNORECASE=1;i=0}/^(foobar|legacy|(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb))$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" (
    set xTemp=Standard
) else (
    set xTemp=Special
)

REM ==> Step the corresponding counters up and perform the test (either
REM ==> standard or special):
set /a x%xTemp%TestCounter+=1
set /a xTestPercentage=x%xTemp%TestCounter*100/xNumOf%xTemp%TestCases
call :%xTemp%_TEST_CASE
if %xCurrentTestCounter% LSS %xNoOfTotalTests% goto :XREGRE_LOOP

:XREGRE_COMPLETE_LOOP_ACTIONS
REM ==> Complete loop actions:
echo **********************************************************************|%xRegreLogCmd%
echo.|%xRegreLogCmd%
.\tmp\ps.exe -d 2000 Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe mysqld.exe postgres.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul

REM ==> Complete remaining tasks:
for /f "usebackq delims=" %%i in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
call :TIME_DELTA "%xTime0%" 1
echo Regression test execution for %xNumOfStandardTestCases% standard OpModes and %xNumOfSpecialTestCases% special|%xRegreLogCmd%
echo test cases finished on %xTemp%. It took approximately|%xRegreLogCmd%
if not exist %xGawk% copy /D /V /Y .\tmp\gawk.exe %xGawk%>nul 2>nul
call :LOG_ENTRY info "*** xtack.bat %xBatRev% regression test execution finished for %xNumOfStandardTestCases% standard OpMode(s) and %xNumOfSpecialTestCases% special test case(s). It took ^~%xTookStr% to complete."
del /F /Q %xGawk%>nul 2>nul
echo %xTookStr% to complete ...|%xRegreLogCmd%
echo.|%xRegreLogCmd%
echo Your can check the complete regression test results in logfile:|%xRegreLogCmd%
echo %xLogfile%|%xRegreLogCmd%
echo.|%xRegreLogCmd%
echo Thanks for testing. Bye bye ...|%xRegreLogCmd%

:XREGRE_END
call :TIME_DELTA "%xTime0%" 1
for /f "usebackq delims=" %%i in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
if not "%xSilentMode%" == "1" (
    echo.|%xRegreLogCmd%
    echo xtack execution finished on %xTemp% ^(it took %xTookStr%^)|%xRegreLogCmd%
)

:XREGRE_END2
REM ==> Regression specific cleanup:
call :PERFORM_FINAL_REGRESSION_TESTING_CLEANUP
goto :END2

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: xtack update.
REM -------------------------------------------------------------------------

:PERFORM_XTACK_UPDATE
REM ==> Update logfile settings for a brand new installation:
if not "%xFirstRun%" == "1" goto :UPDATE_CHECK_LOGFILE_NORMAL_UPDATE
set xFunctionalityArea=Install
call :REFRESH_LOGFILE "xtack_install"
goto :UPDATE_GET_DEBUG_MODE

:UPDATE_CHECK_LOGFILE_NORMAL_UPDATE
REM ==> Skip updating the logfile if coming from xtack start or xtack switch:
if "%xUpdateFromXonOrSwitch%" == "1" goto :UPDATE_GET_DEBUG_MODE
set xFunctionalityArea=Update
call :REFRESH_LOGFILE "xtack_update"

:UPDATE_GET_DEBUG_MODE
REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Check if xtack is currently started through the presence of the
REM ==> .\bin\xtack.lck file:
if not exist .\bin\xtack.lck goto :UPDATE_CHECK_INET_CONNECTIVITY
call :SHOW_MSG "ERROR: xtack can't be updated right now as it is currently started and\nrunning. Please shut xtack down and try again. Now exiting ..." "ERROR: xtack can't be updated now as it is currently running."
call :LOG_ENTRY error "Unsuccessful xtack update attempt: xtack is currently started and running. Now exiting."
goto :UPDATE_END

:UPDATE_CHECK_INET_CONNECTIVITY
REM ==> Check Internet connectivity:
call :CHECK_INET_CONNECTIVITY 1
if "%xHostHasInetConnectivity%" == "1" goto :UPDATE_REFRESH_INSTALLED_COMPONENTS_LIST
call :SHOW_MSG "ERROR: xtack can't be updated now due to lack of Internet connectivity.\nPlease connect to the Internet and try again. Now exiting ..." "ERROR: xtack can't be updated now due to lack of Internet connectivity."
call :LOG_ENTRY error "Online update couldn't be performed due to lack of Internet connectivity. Now exiting."
goto :UPDATE_END

:UPDATE_REFRESH_INSTALLED_COMPONENTS_LIST
REM ==> Create default component folders:
if not exist .\swu md .\swu>nul 2>nul
if not exist .\bin\vcredis md .\bin\vcredis>nul 2>nul
if not exist .\bin\xdebug md .\bin\xdebug>nul 2>nul
if not exist .\bin\icons md .\bin\icons>nul 2>nul
if not exist .\www\packages md .\www\packages>nul 2>nul
if not exist .\bin\pma md .\bin\pma>nul 2>nul
if not exist .\bin\pga\conf md .\bin\pga\conf>nul 2>nul
if not exist .\bin\composer md .\bin\composer>nul 2>nul
if not exist .\bin\browscap md .\bin\browscap>nul 2>nul
if not exist .\bin\dlls md .\bin\dlls>nul 2>nul
if not exist .\bin\phpcs md .\bin\phpcs>nul 2>nul
if not exist .\bin\phalcon md .\bin\phalcon>nul 2>nul
if not exist .\bin\sendmail md .\bin\sendmail>nul 2>nul
if not exist .\bin\phpunit md .\bin\phpunit>nul 2>nul
if not exist .\bin\phpmd md .\bin\phpmd>nul 2>nul
if not exist .\prof md .\prof>nul 2>nul
if not exist .\ide md .\ide>nul 2>nul

REM ==> Rename any package.json files as xtack.json (mainly for
REM ==> old packages), to avoid eventual conflicts with npm:
call :RENAME_PACKAGE_JSON_FILES

REM ==> Create a fresh list of all components currently installed with
REM ==> its versions:
if not "%xFirstRun%" == "1" call :SHOW_MSG "Checking components currently installed. Please wait ...\n"
call :CREATE_INSTALLED_COMPONENTS_LIST
call :SHOW_MSG "Processing online update status information. Please wait ...\n"
del /F /Q .\swu\status .\swu\status.txt .\swu\rstatus.txt>nul 2>nul
call :DOWNLOAD_UCF
if "%xTemp%" == "0" goto :UPDATE_FILTER_ONLINE_CONTROL_FILE
call :SHOW_MSG "ERROR: xtack can't be updated right now as the online update status\ninformation can't be currently accessed at:\n%xDownloadBaseUrl%%xUCF%\n\nPlease check and try again later. Now exiting ..." "ERROR: xtack can't be updated now. Online update info unavailable."
call :LOG_ENTRY error "Online update can't be performed right now as the online update status information file can't be currently accessed at URL %xDownloadBaseUrl%%xUCF%. Now exiting."
goto :UPDATE_END

:UPDATE_FILTER_ONLINE_CONTROL_FILE
REM ==> Filter the just downloaded copy of the online update information
REM ==> file to make it comparable to the list of installed components.
REM ==> During the process, secure that only authorized xtack components
REM ==> are considered for download:
ren .\swu\%xUCF% rstatus.txt>nul 2>nul
if "%xSilentMode%" == "1" echo.|%xLog%

REM ==> Process the remote status file:
call :PROCESS_RSTATUS_GET_UPDATED_COMPONENTS

REM ==> Check if all components are updated:
if "%xNumberOfNewComponentsAvailable%" == "0" goto :UPDATE_ALL_COMPONENTS_ALREADY_UPDATED

REM ==> If in silent mode, directly jump to updating required components:
if "%xSilentMode%" == "1" (
    set xTemp=required
    goto :UPDATE_DOWNLOAD_UPDATED_COMPONENTS
)

REM ==> Inform the user about changed components:
call :SHOW_MSG "There are %xNumberOfNewComponentsAvailable% new xtack component updates available:\n\nNr Component             Version    Release Date  Type\n-- --------------------- ---------- ------------  ---------"
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "BEGIN{IGNORECASE=1}/^set xRootDefaultOpMode=/{gsub(/set xRootDefaultOpMode=/,\"\");db=tolower(substr($0,7,3));filter=tolower(substr($0,0,3))\"\174browscap\174phalcon\174\"tolower(substr($0,4,3));if(db ~ /(m55|m57|mra)/){filter=filter\"\174\"db\"\174mysqldbs\174mradb\174pma\"}else if(db ~ /pgs/){filter=filter\"\174\"db\"\174pgsdb\174pga\"};print filter}"`) do set xTemp=%%i
type .\swu\newcomps.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}{i++;if(i<10){n=i\" \"}else{n=i};if($1 ~ /^^(xtackbat|runtime|7za|vcredis|xdocs|xdebug|icons)$/){t=\"Core\"}else if($1 ~ /(%xTemp%)/){t=\"Required\"}else{t=\"Optional\"};if(length($3)>10){v=\"\";l=split($3,a,\".\");for(j=1;j<l;j++){v=v\".\"a[j]};v=substr(v,2)}else{v=$3};printf(\"%%-2s %%-21s %%-10s %%-13s %%-9s %%-12s\n\",n,$2,v,$4,t,$1)}">.\swu\menu.txt
type .\swu\menu.txt|%xGawk% "{printf(\"%%-2s %%-21s %%-10s %%-13s %%-9s\n\",$1,$2,$3,$4,$5)}"|%xLog%
echo.|%xLog%
if "%xFirstRun%" == "1" (
    set xUpdateOperation=install
) else (
    set xUpdateOperation=update
)
call :SHOW_MSG "NOTE: Core and Required components will be automatically downloaded\nand processed for you, even if you don't select them.\n"

REM ==> Ask user whether to proceed with the update of changed components:
call :ASK_USER_COMPONENT_RANGE_QUESTION "Please choose components to %xUpdateOperation%:" %xNumberOfNewComponentsAvailable% 1
set xRange=%xTemp%
if not "%xRange%" == "0" goto :UPDATE_CHECK_DISK_DRIVE_FREE_SPACE_UPON_INSTALLATION

REM ==> The user refused to update new xtack components:
if "%xFirstRun%" == "1" set xInstallationAborted=1
call :SHOW_MSG "\nOK thanks, no components to update. Now exiting ..."
call :LOG_ENTRY info "xtack update attempt: The user refused to %xUpdateOperation% any new xtack components. Now exiting."

REM ==> If in initial installation, delete all directories created
REM ==> except .\logs and log session end:
if not "%xFirstRun%" == "1" goto :UPDATE_CLEANUP

:UPDATE_DELETE_XTACK_INSTALLATION_FILES
echo.|%xLog%
echo Cleaning up installation files. Please wait ...|%xLog%
echo.|%xLog%
call :TIME_DELTA "%xTime0%"
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
echo xtack execution finished on %xTemp%|%xLog%
echo ^(it took %xTookStr%^)|%xLog%
if not "%xSilentMode%" == "1" echo.

REM ==> As user refused to install any xtack components, clean leftovers up:
move /Y %xLogfile% .\xtack_install.log>nul 2>nul
rd /S /Q .\ide .\prof .\tests .\cfg .\dbs .\docs .\swu .\www .\tmp .\logs .\bin>nul 2>nul
del /F /Q .\xtack.json .\LICENSE.txt>nul 2>nul
goto :END3

:UPDATE_CHECK_DISK_DRIVE_FREE_SPACE_UPON_INSTALLATION
REM ==> Check now required disk drive free space to install xtack:
if not "%xFirstRun%" == "1" goto :UPDATE_BUILD_LIST_OF_COMPONENTS_TO_UPDATE

REM ==> Check required disk drive free space to install xtack now:
if "%xRange%" == "all" (
    set xMinFreeSpace=985
) else (
    set xMinFreeSpace=600
)

:UPDATE_GET_DISKDRIVE_FREE_SPACE
call :GET_DISKDRIVE_FREE_MIB
set xAvailableSpace=%xTemp%
if %xAvailableSpace% GEQ %xMinFreeSpace% goto :UPDATE_BUILD_LIST_OF_COMPONENTS_TO_UPDATE
for /f "usebackq delims=" %%i in (`echo %CD%^|%xGawk% -F: "{print toupper($1)}"`) do set xTemp=%%i
call :SHOW_MSG "\nxtacks requires ~%xMinFreeSpace% MiB of free space on drive %xTemp%: but there are\ncurrently only %xAvailableSpace% MiB free. Please free some space to proceed.\n"
call :ASK_USER_YES_NO_QUESTION "Have you freed enough disk space to install xtack now" 0
if /i "%xTemp%" == "Y" goto :UPDATE_GET_DISKDRIVE_FREE_SPACE

:UPDATE_USER_REFUSED_TO_FREE_DISK_SPACE
REM ==> The user refused to free up disk space to install xtack:
call :SHOW_MSG "\nOK, sorry but xtack can't be installed then, now exiting ..."
call :LOG_ENTRY info "xtack update attempt: The user refused to free up disk space to %xUpdateOperation% any new xtack components. Now exiting."

REM ==> Temporary:
goto :UPDATE_CLEANUP

:UPDATE_BUILD_LIST_OF_COMPONENTS_TO_UPDATE
REM ==> The user accepted to update new xtack components now:
if "%xRange%" == "all" goto :UPDATE_BUILD_LIST_OF_ALL_COMPONENTS
if "%xRange%" == "required" goto :UPDATE_BUILD_LIST_OF_REQUIRED_COMPONENTS
if "%xRange%" == "installed" goto :UPDATE_BUILD_LIST_OF_INSTALLED_COMPONENTS

REM ==> Build list of core + required + user selected components:
for /f "usebackq delims=" %%i in (`type .\swu\menu.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0;filter=\"^^^^(%xTemp%^)$\";gsub(\" \",\"\174\",filter);list=\"\"}{if(($5 ~ /(Core|Required)/)||($1 ~ filter)){id=$6;if((id==\"m55\")||(id==\"m57\")||(id==\"mra\")){id=id\" mysqldbs mradb pma\"}else if(id==\"pgs\"){id=\"pgs pgsdb pga\"};if(i!=0){list=list\" \"id}else{list=id;i++}}}END{print list}"`) do set xTemp=%%i
goto :UPDATE_DOWNLOAD_UPDATED_COMPONENTS

:UPDATE_BUILD_LIST_OF_ALL_COMPONENTS
REM ==> Build list of all components:
for /f "usebackq delims=" %%i in (`type .\swu\menu.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0;list=\"\"}{if(i!=0){list=list\" \"$6}else{list=$6;i++}}END{print list}"`) do set xTemp=%%i
goto :UPDATE_DOWNLOAD_UPDATED_COMPONENTS

:UPDATE_BUILD_LIST_OF_REQUIRED_COMPONENTS
REM ==> Build list of core and required components:
for /f "usebackq delims=" %%i in (`type .\swu\menu.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0;list=\"\"}{if($5 ~ /(Core|Required)/){id=$6;if((id==\"m55\")||(id==\"m57\")){id=id\" mysqldbs mradb pma\"}else if(id==\"pgs\"){id=\"pgs pgsdb pga\"};if(i!=0){list=list\" \"id}else{list=id;i++}}}END{print list}"`) do set xTemp=%%i
goto :UPDATE_DOWNLOAD_UPDATED_COMPONENTS

:UPDATE_BUILD_LIST_OF_INSTALLED_COMPONENTS
REM ==> Re-process the remote status file only considering actual
REM ==> locally installed components:
for /f "usebackq delims=" %%i in (`type .\swu\installed.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0;list=\"\"}{if($3 ~ /^unavailable$/){if(i!=0){list=list\" \"$1}else{list=$1;i++}}}END{print list}"`) do set xTemp=%%i
for /f "usebackq delims=" %%i in (`type .\swu\menu.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0;list=\"\";filter=\"%xTemp%\";gsub(\" \",\"\174\",filter)}{if($6 !~ filter){if(i!=0){list=list\" \"$6}else{list=$6;i++}}}END{print list}"`) do set xTemp=%%i

:UPDATE_DOWNLOAD_UPDATED_COMPONENTS
REM ==> If xtack.bat being installed for the first time, avoid
REM ==> updating it again, as it is supposed to be a fresh copy:
for /f "usebackq delims=" %%i in (`type .\swu\menu.txt^|%xGawk% "BEGIN{IGNORECASE=1;list=\"%xTemp%\";firstrun=int(\"%xFirstRun%\");batrev=\"%xBatRev%\";gsub(\"r\",\"\",batrev);batrev=int(batrev)}{if($2 ~ /xtack.bat/){newrev=$3;gsub(\"r\",\"\",newrev);newrev=int(newrev);if((firstrun==1)&&(newrev<=batrev)){gsub(\"xtackbat \",\"\",list);gsub(\" xtackbat\",\"\",list)}}}END{print list}"`) do set xTemp=%%i

REM ==> Re-cache the online update information file to get all relevant info:
if "%xDebugMode%" == "1" echo %xDbgM%Components to %xUpdateOperation% (core, required and/or selected by the user): %xTemp%]>> %xLogfile%
type .\swu\rstatus.txt|%xGawk% "BEGIN{IGNORECASE=1}{if($0 !~ /(^^[ \t]*#|^$)/ && $5 !~ /^^Install$/ && $6 ~ /[a-f0-9]{128}/){gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(/[ \t]+/,\" \");print $0}}">.\swu\newcomps.txt
type .\swu\newcomps.txt|%xGawk% "BEGIN{IGNORECASE=1;filter=\"%xTemp%\";gsub(\" \",\"\174\",filter)}($1 ~ filter){gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(/[ \t]+/,\" \");print $0}">.\swu\available.txt
%xGawk% "FNR==NR{a[$1\" \"$2\" \"$3];next}(!($1\" \"$2\" \"$3 in a))" .\swu\installed.txt .\swu\available.txt>.\swu\newcomps.txt
for /f "usebackq delims=" %%i in (`type .\swu\newcomps.txt^|%xGawk% "END{print NR}"`) do set xNumberOfNewComponentsToProcess=%%i
if "%xNumberOfNewComponentsToProcess%" == "0" (
    call :SHOW_MSG "\nOK thanks, no components to update. Now exiting ..."
    goto :UPDATE_CLEANUP
)

call :SHOW_MSG "\nOK thanks, downloading the %xNumberOfNewComponentsToProcess% selected new updated component(s).\nThis may take some time, depending on your connection speed."
if not exist .\swu\backup md .\swu\backup>nul 2>nul
del /F /Q .\swu\*.7z .\tmp\xtacktmp1.txt>nul 2>nul
rd /S /Q .\swu\a13 .\swu\a24 .\swu\browscap .\swu\dlls .\swu\iis .\swu\m55 .\swu\m57 .\bin\mod_security .\swu\mod_security .\swu\mra .\swu\ngx .\swu\njs .\swu\p52 .\swu\p53 .\swu\p54 .\swu\p55 .\swu\p56 .\swu\p70 .\swu\p71 .\swu\p72 .\swu\pear .\swu\pga .\swu\pgs .\swu\phalcon .\swu\pma .\swu\sendmail .\swu\vcredis .\swu\xdebug>nul 2>nul

REM ==> Reset components update counters:
set xComponentsCounter=0
set xSuccessfullyDownloadedComponentsCounter=0
set xSuccessfullyDownloadedPgpSignaturesCounter=0
set xSuccessfullyUpdatedComponentsCounter=0
set xSuccessfullyInstalledComponents=empty
set xUpdateXtackbat=0

:UPDATE_LOOP
REM ==> Execute the main update loop:
set /a xComponentsCounter+=1
set xDestination=%~dp0swu\

REM ==> Get component update information:
for /f "usebackq delims=" %%i in (`type .\swu\newcomps.txt^|%xGawk% "{if(NR==%xComponentsCounter%){print $0}}"`) do set xTemp=%%i

REM ==> Reset the components title, URL, SHA512 checksum and filename:
set xComponentId=
set xTitle=
set xSha512=
set xFileName=
set xDirection=

REM ==> Get the components title and URL:
for /f "usebackq delims=" %%i in (`echo %xTemp%^|%xGawk% "{print $1}"`) do set xComponentId=%%i
for /f "usebackq delims=" %%i in (`echo %xTemp%^|%xGawk% "{print $2\" \"$3}"`) do set xTitle=%%i
for /f "usebackq delims=" %%i in (`echo %xTemp%^|%xGawk% "{print $6}"`) do set xSha512=%%i
for /f "usebackq delims=" %%i in (`echo %xTemp%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(Update|Rollback)/{i++;print $5}END{if(i=0){print \"Update\"}}"`) do set xDirection=%%i
for /f "usebackq delims=" %%i in (`echo %xComponentId%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /^^xtackbat$/){print \"xtack.bat\"}else if($0 ~ /^^7za$/){print \"7za.exe\"}else if($0 ~ /^^runtime$/){print \"runtime.7z\"}else{print \"%xSha512%.7z\"}}"`) do set xFileName=%%i
for /f "usebackq delims=" %%i in (`echo %xFileName%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(/\.(bat|exe|7z|phar)$/,\".sig\");print $0}"`) do set xPgpSignature=%%i

REM ==> Get info for components directly swappable (in terms of exchanging
REM ==> the old and the new component version), or not directly swappable:
for /f "usebackq delims=" %%i in (`echo %xComponentId%^|%xGawk% "BEGIN{IGNORECASE=1;i=1}/^^(7za|mradb|mysqldbs|pgsdb|runtime|vcredis|xdocs|xtackbat)$/{i=0}END{print i}"`) do set xSwappable=%%i

:UPDATE_DOWNLOAD_COMPONENT
REM ==> Now download the updated component's binary 7-Zip cabinet file:
if /i not "%xComponentId%" == "xtackbat" (
    call :SHOW_MSG "\nDownloading and installing %xTitle%. Please wait ..."
) else (
    call :SHOW_MSG "\nDownloading %xTitle%. Please wait ..."
)
call :DOWNLOAD_FILE "%xTitle%" "%xDownloadBaseUrl%%xFileName%" "%xDestination%" 0 1 1 "TLSv1"

REM ==> If component not successfully downloaded, jump to the loop evaluation
REM ==> code now:
if "%xTemp%" == "0" goto :UPDATE_STEP_7Z_DOWNLOAD_COUNTER
call :SHOW_MSG "ERROR: Component %xTitle% could not be downloaded. Please check!"
goto :UPDATE_LOOP_EVALUATION

:UPDATE_STEP_7Z_DOWNLOAD_COUNTER
REM ==> Otherwise step counter up and check SHA512 checksum:
set /a xSuccessfullyDownloadedComponentsCounter+=1

REM ==> Check the updated component's binary 7-Zip cabinet file
REM ==> SHA512 checksum:
if exist .\swu\%xFileName% call :GET_FILE_SHA512 "%~dp0swu\%xFileName%"
if /i "%xTemp%" == "%xSha512%" goto :UPDATE_7Z_SHA512_OK

REM ==> Show and log SHA512 checksum verification failure:
call :SHOW_MSG "WARNING: SHA512 checksum verification failed for component:\n%xTitle%\n"
if "%xDebugMode%" == "1" (
    echo.>> %xLogfile%
    echo %xDbgM%Expected SHA512 checksum: %xSha512%]>> %xLogfile%
    echo %xDbgM%Measured SHA512 checksum: %xTemp%]>> %xLogfile%
    echo.>> %xLogfile%
)
call :LOG_ENTRY warning "SHA512 checksum verification failed for component %xTitle% (expected SHA512 checksum = %xSha512%; measured SHA512 checksum = %xTemp%). Please check."
set xSha512=1

REM ==> If in silent mode, directly skip the component:
if "%xSilentMode%" == "1" goto :UPDATE_LOOP_EVALUATION

REM ==> Ask user whether to retry the download. If refused, proceed with the
REM ==> next component:
call :ASK_USER_YES_NO_QUESTION "Do you want to continue installing the new component" 0
if /i "%xTemp%" == "Y" goto :UPDATE_DOWNLOAD_PGP_SIGNATURE
goto :UPDATE_LOOP_EVALUATION

:UPDATE_7Z_SHA512_OK
set xSha512=0
if "%xDebugMode%" == "1" echo %xDbgM%SHA512 checksum verification OK for component %xTitle%]>> %xLogfile%

:UPDATE_DOWNLOAD_PGP_SIGNATURE
REM ==> Download the updated component's PGP file signature:
call :DOWNLOAD_FILE "%xTitle% PGP Signature" "%xDownloadBaseUrl%%xPgpSignature%" "%xDestination%" 0 1 1 "TLSv1"

REM ==> If signature not successfully downloaded, warn the user:
if "%xTemp%" == "0" goto :UPDATE_STEP_SIG_DOWNLOAD_COUNTER
call :SHOW_MSG "WARNING: PGP signature for component %xTitle% could not be downloaded."
call :LOG_ENTRY warning "PGP signature for component %xTitle% could not be downloaded from URL %xDownloadBaseUrl%%xPgpSignature%. Please check."
goto :UPDATE_SKIP_SPECIFIC_COMPONENTS_EXTRACTION

:UPDATE_STEP_SIG_DOWNLOAD_COUNTER
REM ==> Step up PGP signature file download counter:
set /a xSuccessfullyDownloadedPgpSignaturesCounter+=1

REM ==> Verify the updated component's binary 7-Zip cabinet file's PGP
REM ==> signature:
if not exist .\swu\%xPgpSignature% (
    call :SHOW_MSG "INFO: Skipping PGP signature verification for %xTitle%."
    call :LOG_ENTRY info "Missing PGP signature for component %xTitle%. Skipping its verification now. Please check."
) else (
    call :VERIFY_PGP_SIGNATURE "%~dp0swu\%xFileName%"
)
if /i "%xTemp%" == "0" goto :UPDATE_PGP_SIG_VERIFICATION_OK

REM ==> Show and log PGP signature verification failure:
call :SHOW_MSG "ERROR: PGP signature verification failed for component\n%xTitle%\nThis component will NOT be updated now!"
call :LOG_ENTRY error "PGP signature verification failed for component %xTitle%. The component WON'T be installed. Please check."

REM ==> If in silent mode, directly skip the component:
if "%xSilentMode%" == "1" goto :UPDATE_LOOP_EVALUATION

:UPDATE_PGP_SIG_VERIFICATION_OK
if "%xDebugMode%" == "1" echo %xDbgM%PGP signature verification OK for component %xTitle%]>> %xLogfile%
if "%xSha512%%xTemp%" == "00" call :SHOW_MSG "SHA512 and PGP signature verified OK for %xTitle%  :-)"

:UPDATE_SKIP_SPECIFIC_COMPONENTS_EXTRACTION
REM ==> Special handling for component xtackbat. Just flag it, as
REM ==> xtack.bat needs to be the last to update, but only if it
REM ==> is a normal update and not the initial installation:
if /i "%xComponentId%-%xFirstRun%" == "xtackbat-0" (
    set xUpdateXtackbat=1
    call :SHOW_MSG "New component %xTitle% will be processed after all the others."
    goto :UPDATE_LOOP_EVALUATION
)

REM ==> Skip extraction for components "7za", "runtime" and "vcredis":
if /i "%xComponentId%" == "7za" goto :UPDATE_CHECK_SPECIAL_7ZA
if /i "%xComponentId%" == "runtime" goto :UPDATE_CHECK_SPECIAL_RUNTIME
if /i "%xComponentId%" == "vcredis" goto :UPDATE_CHECK_SPECIAL_VCREDIS

REM ==> Extract the component:
.\bin\7za.exe x -aoa -y -o.\swu\ .\swu\%xFileName% *>nul 2>nul

REM ==> If new component extracted OK, proceed; otherwise show and log error:
if "%errorlevel%" == "0" goto :UPDATE_SWAP_OLD_COMPONENT_WITH_NEW
call :SHOW_MSG "ERROR: New component %xTitle% couldn't be extracted and so it's skipped."
call :LOG_ENTRY error "New component %xTitle% couldn't be extracted by 7za.exe and so it is now skipped. Please check."
goto :UPDATE_LOOP_EVALUATION

:UPDATE_SWAP_OLD_COMPONENT_WITH_NEW
REM ==> If component is non swappable, skip swapping:
if /i not "%xSwappable%" == "1" goto :UPDATE_HANDLE_NON_SWAPPABLE_COMPONENT

REM ==> Move old component to the software update backup area:
call :SWAP_UPDATED_COMPONENT ".\bin" "%xComponentId%"

:UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK
REM ==> If new component installed OK, proceed; otherwise show and log error:
if "%xTemp%" == "0" goto :UPDATE_COMPONENT_SUCCESSFULLY_UPDATED

:UPDATE_COMPONENT_INSTALLATION_NOK
call :SHOW_MSG "ERROR: New component %xTitle% couldn't be installed."
call :LOG_ENTRY error "New component %xTitle% couldn't be installed and so it is now skipped. Please check."
goto :UPDATE_LOOP_EVALUATION

:UPDATE_COMPONENT_SUCCESSFULLY_UPDATED
set /a xSuccessfullyUpdatedComponentsCounter+=1
call :SHOW_MSG "New component #%xSuccessfullyUpdatedComponentsCounter% %xTitle% successfully installed."
set xSuccessfullyInstalledComponents=%xSuccessfullyInstalledComponents%, %xTitle%
goto :UPDATE_LOOP_EVALUATION

:UPDATE_HANDLE_NON_SWAPPABLE_COMPONENT
REM ==> Handle components requiring special update operations. Applies
REM ==> to mysqldbs, pgsdb, mradb and xdocs
if /i "%xComponentId%" == "mysqldbs" goto :UPDATE_CHECK_SPECIAL_MYSQLDBS
if /i "%xComponentId%" == "pgsdb" goto :UPDATE_CHECK_SPECIAL_PGSDB
if /i "%xComponentId%" == "mradb" goto :UPDATE_CHECK_SPECIAL_MRADB
if /i "%xComponentId%" == "xdocs" goto :UPDATE_CHECK_SPECIAL_XDOCS

:UPDATE_CHECK_SPECIAL_RUNTIME
REM ==> Special handling for component runtime:
if exist .\swu\backup\runtime.7z attrib -R .\swu\backup\runtime.7z>nul 2>nul
if exist .\bin\runtime.7z attrib -R .\bin\runtime.7z>nul 2>nul
ren .\swu\%xFileName% runtime.7z>nul 2>nul
call :SWAP_UPDATED_COMPONENT ".\bin" "runtime.7z"
if exist .\bin\runtime.7z attrib +R .\bin\runtime.7z>nul 2>nul

REM ==> If any configuration files don't yet exist, copy them to .\cfg:
del /F /Q .\tmp\*.conf .\tmp\*.ini .\tmp\*.js>nul 2>nul
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\runtime.7z *.conf *.ini *.js>nul 2>nul
pushd .\tmp
setlocal enabledelayedexpansion
for %%i in (*.conf *.ini *.js) do (
    set xFileName=%%i
    if not exist ..\cfg\!xFileName! copy /D /V /Y .\!xFileName! ..\cfg\!xFileName!>nul 2>nul
)
endlocal
popd
del /F /Q .\tmp\*.conf .\tmp\*.ini .\tmp\*.js>nul 2>nul
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_CHECK_SPECIAL_VCREDIS
REM ==> Special handling for component runtime:
ren .\swu\%xFileName% vcredis.7z>nul 2>nul
call :SWAP_UPDATED_COMPONENT ".\bin\vcredis" "vcredis.7z"
if not "%xTemp%" == "0" goto :UPDATE_COMPONENT_INSTALLATION_NOK

REM ==> Find out updated VC Redistributable Packages:
del /F /Q .\tmp\vcredispkgs.*>nul 2>nul
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\vcredis\vcredis.7z vcredis\vcredispkgs.upd>nul 2>nul
if not "%errorlevel%" == "0" goto :UPDATE_VCREDIS_VCREDISPKGSUPD_FILE_ERROR

REM ==> Check VC Redistributable Packages updated in the new vcredis.7z
REM ==> container:
if not exist .\tmp\vcredispkgs.upd goto :UPDATE_VCREDIS_VCREDISPKGSUPD_FILE_ERROR
if exist .\tmp\vcredispkgs.upd attrib -R .\tmp\vcredispkgs.upd
type .\tmp\vcredispkgs.upd|%xGawk% "BEGIN{IGNORECASE=1}/vc(9|11|12|14) Updated/{gsub(\" Updated\",\"\");gsub(\"vc\",\"VC\");print $0}">.\tmp\vcredispkgs.tmp
for /f "usebackq delims=" %%i in (`type .\tmp\vcredispkgs.tmp^|%xGawk% "END{print NR}"`) do set xNumberOfUpdatedVcRedisPkgs=%%i
for /f "usebackq delims=" %%i in (`type .\tmp\vcredispkgs.tmp^|%xGawk% "BEGIN{RS=\"\"}{gsub(/\n/,\"^, \");print $0}"`) do set xUpdatedVcRedisPkgsIds=%%i

REM ==> Now check whether xtack is running as administrator/with elevated
REM ==> permissions:
.\bin\isadmin.exe -q
if "%errorlevel%" == "1" goto :UPDATE_VCREDIS_USER_HAS_ADMIN_RIGHTS

REM ==> Show and log warning informing that updated MS VC Redistributable
REM ==> packages can't be installed due to lack of admin permissions:
call :SHOW_MSG "\nWARNING: The xtack MS VC++ Redistributable Packages container file\nhas been successfully updated, but due to the fact that xtack is being\nrun within a Command Prompt window without Administrator permissions\nit's not possible to update the %xNumberOfUpdatedVcRedisPkgs% new MS Redistributable Package(s)\nthat it contains: %xUpdatedVcRedisPkgsIds%.\n"
call :LOG_ENTRY warning "xtack MS VC++ Redistributable Packages container file .\bin\vcredis\vcredis.7z has been successfully updated but it's not possible to update the %xNumberOfUpdatedVcRedisPkgs% new MS Redistributable Package(s) that it contains (%xUpdatedVcRedisPkgsIds%), as the parent Command Prompt window is running without Administrator permissions."
goto :UPDATE_COMPONENT_SUCCESSFULLY_UPDATED

:UPDATE_VCREDIS_VCREDISPKGSUPD_FILE_ERROR
REM ==> Show and log vcredispkgs.upd unavailability warning:
call :SHOW_MSG "WARNING: The xtack MS VC++ Redistributable Packages container file has\nbeen successfully updated but it wasn't possible to check whether any\nRedistributable Packages should also be updated on this system."
call :LOG_ENTRY warning "xtack MS VC++ Redistributable Packages container file .\bin\vcredis\vcredis.7z has been successfully updated but it wasn't possible to check the vcredispkgs.upd control file to verify whether any Redistributable Packages should also be updated on this system."
goto :UPDATE_COMPONENT_SUCCESSFULLY_UPDATED

:UPDATE_VCREDIS_USER_HAS_ADMIN_RIGHTS
type .\tmp\vcredispkgs.upd|%xGawk% "BEGIN{IGNORECASE=1}/vc(9|11|12|14) Updated/{gsub(\" Updated\",\"\");gsub(\"vc\",\"\");print $0}">.\tmp\vcredispkgs.tmp
del /F /Q .\tmp\vc*redispkg*.exe>nul 2>nul
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\vcredis\vcredis.7z vcredis\*.exe>nul 2>nul

REM ==> If VC Redistributable Packages couldn't be extracted, jump to inform
REM ==> the user:
if not "%errorlevel%" == "0" goto :UPDATE_UPDATED_VCREDISPKGS_NOT_INSTALLED

REM ==> Execute the main loop to install newly updated MS VC Redistributable
REM ==> Packages:
for /f "usebackq delims=" %%i in (`type .\tmp\vcredispkgs.tmp`) do (
    set xTemp=%%i

    REM ==> Install the MS VC Redistributable Package's new version:
    setlocal enabledelayedexpansion
    call :SHOW_MSG "Installing MS VC!xTemp! Redistributable Package's new version. Please wait ..."
    call :CHECK_AND_INSTALL_VC_REDISPKG "MS VC!xTemp! Redistributable Package's new version" !xTemp! 2 1
    endlocal
)
del /F /Q .\tmp\vc*redispkg*.exe .\tmp\vcredispkgs.upd .\tmp\changelog.r*>nul 2>nul
goto :UPDATE_COMPONENT_SUCCESSFULLY_UPDATED

:UPDATE_CHECK_SPECIAL_7ZA
REM ==> Special handling for component 7za:
call :SWAP_UPDATED_COMPONENT ".\bin" "7za.exe"
if exist .\bin\7za.exe attrib +R .\bin\7za.exe>nul 2>nul
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_CHECK_SPECIAL_MYSQLDBS
REM ==> Special handling for component mysqldbs:
if "%xFirstRun%" == "1" goto :UPDATE_SWAP_MYSQL_DBS
call :SHOW_MSG "\nWARNING: If you update the default MySQL Databases package, the current\nMySQL databases, including any recent changes, will be overwritten.\n"
call :ASK_USER_YES_NO_QUESTION "Are you sure you want to update it, latest changes will be lost" 0
if /i "%xTemp%" == "Y" goto :UPDATE_SWAP_MYSQL_DBS

REM ==> The user refused to update new xtack MySQL Databases package:
call :SHOW_MSG "\nOK, thanks, skipping MySQL databases update."
goto :UPDATE_LOOP_EVALUATION

:UPDATE_SWAP_MYSQL_DBS
call :SWAP_DEFAULT_DATABASE "mysqldbs"
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_CHECK_SPECIAL_PGSDB
REM ==> Special handling for component pgsdb:
if /i not "%xComponentId%" == "pgsdb" goto :UPDATE_LOOP_EVALUATION
if "%xFirstRun%" == "1" goto :UPDATE_SWAP_POSTGRESQL_DB
call :SHOW_MSG "WARNING: If you update the default PostgreSQL Database package, the\ncurrent PostgreSQL database, including any recent changes, will be\noverwritten.\n"
call :ASK_USER_YES_NO_QUESTION "Are you sure you want to update it, latest changes will be lost" 0
if /i "%xTemp%" == "Y" goto :UPDATE_SWAP_POSTGRESQL_DB

REM ==> The user refused to update the new xtack PostgreSQL Database package:
call :SHOW_MSG "\nOK, thanks, skipping PostgreSQL database update."
goto :UPDATE_LOOP_EVALUATION

:UPDATE_CHECK_SPECIAL_MRADB
REM ==> Special handling for component mradb:
if /i not "%xComponentId%" == "mradb" goto :UPDATE_LOOP_EVALUATION
if "%xFirstRun%" == "1" goto :UPDATE_SWAP_MARIADB_DB
call :SHOW_MSG "WARNING: If you update the default MariaDB Database package, the\ncurrent MariaDB database, including any recent changes, will be\noverwritten.\n"
call :ASK_USER_YES_NO_QUESTION "Are you sure you want to update it, latest changes will be lost" 0
if /i "%xTemp%" == "Y" goto :UPDATE_SWAP_MARIADB_DB

REM ==> The user refused to update the new xtack MariaDB Database package:
call :SHOW_MSG "\nOK, thanks, skipping MariaDB database update."
goto :UPDATE_LOOP_EVALUATION

:UPDATE_SWAP_POSTGRESQL_DB
call :SWAP_DEFAULT_DATABASE "pgsdb"
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_SWAP_MARIADB_DB
call :SWAP_DEFAULT_DATABASE "mradb"
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_CHECK_SPECIAL_XDOCS
REM ==> Special handling for component xdocs:
call :SWAP_XDOCS
goto :UPDATE_CHECK_IF_COMPONENT_INSTALLED_OK

:UPDATE_LOOP_EVALUATION
REM ==> Component download loop control statement:
if %xComponentsCounter% LSS %xNumberOfNewComponentsToProcess% goto :UPDATE_LOOP

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "New xtack components download/install loop" 1 0

:UPDATE_CALCULATE_SUCCESS_RATES
REM ==> Calculate rate of components successfully downloaded and updated:
set /a xPercentage=xSuccessfullyDownloadedComponentsCounter*100/xNumberOfNewComponentsToProcess
set /a xPercentage=xSuccessfullyUpdatedComponentsCounter*100/xNumberOfNewComponentsToProcess

REM ==> If xtack.bat has to be self-updated, just jump to cut the cheese:
if /i "%xUpdateXtackbat%" == "1" goto :UPDATE_START_XTACKBAT_SELF_UPDATE

REM ==> Inform the user about the number of successful component downloads:
if "%xSuccessfullyDownloadedComponentsCounter%" == "0" (
    call :SHOW_MSG "\nUnfortunately, no new components could be downloaded. Please check!"
    call :LOG_ENTRY error "xtack update run but no new components could be downloaded."
    goto :UPDATE_PROFILE_SUCCESS_RATE_CALCULATION
)
if /i "%xSuccessfullyDownloadedComponentsCounter%" == "%xNumberOfNewComponentsToProcess%" (
    call :SHOW_MSG "\nThe %xNumberOfNewComponentsToProcess% new component(s^) have been successfully downloaded!"
    call :LOG_ENTRY info "xtack update run, all the %xNumberOfNewComponentsToProcess% new component(s^) selected have been successfully downloaded."
) else if /i %xSuccessfullyDownloadedComponentsCounter% LSS %xNumberOfNewComponentsToProcess% (
    if %xSuccessfullyDownloadedComponentsCounter% GTR 0 call :SHOW_MSG "\nWARNING: Only %xSuccessfullyDownloadedComponentsCounter% component(s^) out of %xNumberOfNewComponentsToProcess% selected (~%xPercentage%\045) have been\ndownloaded OK. Please check and try again if you want ..."
    call :LOG_ENTRY warning "xtack update run, but only %xSuccessfullyDownloadedComponentsCounter% component(s^) out of %xNumberOfNewComponentsToProcess% selected (~%xPercentage% percent) have been downloaded OK. Please check."
)

REM ==> Inform the user about the number of successful component downloads:
if "%xSuccessfullyUpdatedComponentsCounter%" == "0" (
    call :SHOW_MSG "\nUnfortunately, no new components could be installed. Please check!"
    call :LOG_ENTRY error "xtack update run but no new components could be installed."
)
for /f "usebackq delims=" %%i in (`echo %xSuccessfullyInstalledComponents%^|%xGawk% "{gsub(\"empty, \",\"\");print $0}"`) do set xSuccessfullyInstalledComponents=%%i
if /i "%xSuccessfullyUpdatedComponentsCounter%" == "%xNumberOfNewComponentsToProcess%" (
    call :SHOW_MSG "The %xNumberOfNewComponentsToProcess% new component(s^) have been successfully installed!"
    call :LOG_ENTRY info "xtack update run, all the %xNumberOfNewComponentsToProcess% new component(s^) selected (%xSuccessfullyInstalledComponents%^) have been successfully installed."
) else if /i %xSuccessfullyUpdatedComponentsCounter% LSS %xNumberOfNewComponentsToProcess% (
    if %xSuccessfullyUpdatedComponentsCounter% GTR 0 call :SHOW_MSG "\nWARNING: Only %xSuccessfullyUpdatedComponentsCounter% component(s^) out of %xNumberOfNewComponentsToProcess% selected (~%xPercentage%\045) have been\ninstalled OK. Please check and try again if you want ..."
    call :LOG_ENTRY warning "xtack update run, but only %xSuccessfullyUpdatedComponentsCounter% component(s^) out of %xNumberOfNewComponentsToProcess% selected (~%xPercentage% percent) have been installed OK: %xSuccessfullyInstalledComponents%. Please check."
)

:UPDATE_PROFILE_SUCCESS_RATE_CALCULATION
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Component download success rate calculation" 1 0

REM ==> Check if xtack.bat self-update needs to be triggered now:
if /i not "%xUpdateXtackbat%" == "1" goto :UPDATE_COMPOSER_AND_SHOW_FINAL_VERSIONS_MINI_SUMMARY

:UPDATE_START_XTACKBAT_SELF_UPDATE
REM ==> Delete any older versions of xselfupd.bat eventually left over,
REM ==> if existing:
if exist xselfupd.bat del /F /Q xselfupd.bat>nul 2>nul

REM ==> Back up the original xtack.bat by copying it to the software update
REM ==> backup subdirectory:
copy /D /V /Y xtack.bat .\swu\backup\xtack.bat>nul 2>nul
if "%errorlevel%" == "0" goto :UPDATE_COPY_NEW_XTACKBAT_AS_INTERMEDIATE_FILE
call :SHOW_MSG "\nERROR: xtack.bat cannot be self updated. Error while backing up the original xtack.bat. Now exiting."
call :LOG_ENTRY error "xtack.bat couldn't be self updated. Error while backing up the original xtack.bat. Please check."
goto :UPDATE_CLEANUP

:UPDATE_COPY_NEW_XTACKBAT_AS_INTERMEDIATE_FILE
REM ==> Temporarily copy the new xtack.bat as xselfupd.bat as an
REM ==> intermediate script:
if exist .\swu\xtack.bat copy /D /V /Y .\swu\xtack.bat xselfupd.bat>nul 2>nul

REM ==> If copy successful, jump to the actual self updating kick-off:
if exist xselfupd.bat goto :UPDATE_CALL_NEW_XTACKBAT_FOR_SELFUPDATING

call :SHOW_MSG "ERROR: xtack.bat cannot be self updated. Error while copying the new xtack.bat. Now exiting."
call :LOG_ENTRY error "xtack.bat couldn't be self updated. Error while copying the new xtack.bat. Please check."
goto :UPDATE_CLEANUP

:UPDATE_CALL_NEW_XTACKBAT_FOR_SELFUPDATING
REM ==> Call the new xtack.bat to perform the actual self-update and exit
REM ==> immediately:
del /F /Q .\tmp\xUpdSilent.txt .\tmp\xUpdTime0.txt .\tmp\xUpdTime1.txt>nul 2>nul
echo ^%xSilentMode%>.\tmp\xUpdSilent.txt
echo %xTime0%>.\tmp\xUpdTime0.txt
if "%xProfiling%" == "1" echo %xTime1%>.\tmp\xUpdTime1.txt
xselfupd.bat update -selfupdate
goto :END4

:UPDATE_PERFORM_SELFUPDATE
REM ==> Update logfile settings:
set xFunctionalityArea=Update
call :REFRESH_LOGFILE "xtack_update" 1
if exist .\tmp\xUpdSilent.txt for /f "usebackq delims=" %%i in (`type .\tmp\xUpdSilent.txt`) do set xSilentMode=%%i
if exist .\tmp\xUpdTime0.txt for /f "usebackq delims=" %%i in (`type .\tmp\xUpdTime0.txt`) do set xTime0=%%i
if "%xProfiling%" == "1" if exist .\tmp\xUpdTime1.txt for /f "usebackq delims=" %%i in (`type .\tmp\xUpdTime1.txt`) do set xTime1=%%i

REM ==> Check if in post update phase:
if /i "%2" == "-postupdate" goto :UPDATE_PERFORM_POSTUPDATE

REM ==> The script now copies itself as xtack.bat (being it now the new
REM ==> version):
copy /D /V /Y xselfupd.bat xtack.bat>nul 2>nul
if "%errorlevel%" == "0" goto :UPDATE_PERFORM_SELFUPDATE2
call :SHOW_MSG "\nERROR: xtack.bat cannot complete its self update. Please manually\nrename file %~dp0xselfupd.bat as xtack.bat."
call :LOG_ENTRY error "xtack.bat couldn't complete its self update. The user was requested to manually rename file %~dp0xselfupd.bat as xtack.bat. Please check."
del /F /Q .\tmp\xUpdSilent.txt .\tmp\xUpdTime0.txt .\tmp\xUpdTime1.txt>nul 2>nul
goto :END4

:UPDATE_PERFORM_SELFUPDATE2
REM ==> Call the new xtack.bat to perform the post update:
xtack.bat update -postupdate
goto :END4

:UPDATE_PERFORM_POSTUPDATE
REM ==> Re-read self revision now:
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "BEGIN{IGNORECASE=1}/^REM Revision: r/{print $3}"`) do set xBatRev=%%i
set /a xSuccessfullyUpdatedComponentsCounter+=1
call :SHOW_MSG "\nNew component #%xComponentsCounter% xtack.bat %xBatRev% successfully installed."
call :LOG_ENTRY info "xtack.bat successfully self updated. The new version is %xBatRev% now."

REM ==> Delete intermediate xselfupd.bat, if still existing, plus other
REM ==> auxiliary files:
del /F /Q xselfupd.bat .\swu\xtack.bat .\tmp\xUpdSilent.txt .\tmp\xUpdTime0.txt .\tmp\xUpdTime1.txt>nul 2>nul
set xUpdateXtackbat=0

REM ==> Renegerate xtack.json and LICENSE.txt files in xtack root folder:
call :REGENERATE_XTACKBAT_PKGJSON_AND_LICENSE

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "xtack.bat self update" 1 0
goto :UPDATE_CALCULATE_SUCCESS_RATES

:UPDATE_COMPOSER_AND_SHOW_FINAL_VERSIONS_MINI_SUMMARY
call :SHOW_MSG "\nAdditionally updating Composer, PHPUnit and PHPMD now. Please wait ...\n"
if not exist .\bin\composer\composer.phar (
    call :DOWNLOAD_COMPOSER
) else (
    .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\composer\composer.phar selfupdate>nul 2>nul
)
if not exist .\bin\phpunit\phpunit.phar (
    call :DOWNLOAD_PHPUNIT
) else (
    .\bin\p%xBatPhp%\php.exe -c .\bin\p%xBatPhp%\php.ini .\bin\phpunit\phpunit.phar self-upgrade>nul 2>nul
)
if not exist .\bin\phpmd\phpmd.phar call :DOWNLOAD_PHPMD

REM ==> Save new overall xtack system status:
copy /D /V /Y .\swu\rstatus.txt .\swu\istatus.txt>nul 2>nul

REM ==> Show Software versions mini summary after new components updated:
if /i "%xSilentMode%" == "1" goto :UPDATE_SKIP_MINISUMMARY
call :SHOW_SW_VERSIONS_SHORT

:UPDATE_SKIP_MINISUMMARY
if "%xNumberOfNewComponentsToProcess%" == "0" goto :UPDATE_CLEANUP
if not "%xFirstRun%" == "1" goto :UPDATE_NORMAL_CLOSING_MSG
echo.|%xLog%
echo xtack has been installed on: "%CD%"|%xLog%
goto :UPDATE_CLEANUP

:UPDATE_NORMAL_CLOSING_MSG
if not "%xSuccessfullyUpdatedComponentsCounter%%xFirstRun%" == "01" (
    call :SHOW_MSG "\nThe previous versions of the components just updated are available,\nin case of need, in the following subdirectory:" "xtack update completed. Run 'xtack ver' for details."
    if /i not "%xSilentMode%" == "1" echo %~dp0swu\backup\|%xLog%
)
goto :UPDATE_CLEANUP

:UPDATE_ALL_COMPONENTS_ALREADY_UPDATED
call :SHOW_MSG "All xtack components are already up to date :-)" "All xtack components already up to date."
goto :UPDATE_COMPOSER_AND_SHOW_FINAL_VERSIONS_MINI_SUMMARY

:UPDATE_CLEANUP
REM ==> xtack update specific cleanup:
del /F /Q .\tmp\wgetitem.txt .\tmp\xtacktmp1.txt .\swu\*.7z .\swu\available.txt .\swu\newcomps.txt .\swu\menu.txt .\swu\filter.txt .\swu\xtack.json .\swu\LICENSE.txt .\tmp\vc*redispkg*.exe .\tmp\vcredispkgs.upd .\tmp\vcredispkgs.tmp .\cfg\trustdb.gpg .\cfg\trustdb.gpg.lock>nul 2>nul
if not "%xFirstRun%" == "1" goto :UPDATE_END

REM ==> xtack initial install specific cleanup:
if exist .\swu\backup\ rd /S /Q .\swu\backup\>nul 2>nul
md .\swu\backup>nul 2>nul

REM ==> If initial installation aborted, skip creating xtack's desktop icon:
if "%xInstallationAborted%" == "1" goto :UPDATE_END

REM ==> Create xtack desktop icon during xtack installation:
echo set WshShell = CreateObject("Wscript.shell")>.\tmp\shortcut.vbs
for /f "usebackq delims=" %%i in (`echo %CD%^|%xGawk% -F: "{print toupper($1)}"`) do set xTemp=%%i
echo set oLnk = WshShell.CreateShortcut(WshShell.SpecialFolders("Desktop") + "\xtack on Drive %xTemp%.lnk")>>.\tmp\shortcut.vbs
echo oLnk.TargetPath = "%windir%\system32\cmd.exe">>.\tmp\shortcut.vbs
echo oLnk.WorkingDirectory = "%~dp0">>.\tmp\shortcut.vbs
echo oLnk.WindowStyle = ^4>>.\tmp\shortcut.vbs
echo oLnk.IconLocation = "%~dp0bin\icons\xtack.ico">>.\tmp\shortcut.vbs
echo oLnk.Description = "Runs xtack, the Web Stack for Windows by xcentra!">>.\tmp\shortcut.vbs
echo oLnk.Save>>.\tmp\shortcut.vbs
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: cscript.exe .\tmp\shortcut.vbs //B //Nologo to create xtack desktop icon during xtack installation]>> %xLogfile%
cscript.exe .\tmp\shortcut.vbs //B //Nologo
del /F /Q .\tmp\shortcut.vbs>nul 2>nul

:UPDATE_END
del /F /Q .\tmp\xtacktmp1.txt .\tmp\autenticity.txt>nul 2>nul

REM ==> Rename any package.json files as xtack.json (mainly for
REM ==> old packages), to avoid eventual conflicts with npm:
call :RENAME_PACKAGE_JSON_FILES

REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Updating xtack components" 1 0

REM ==> Check if documents are also due to be updated along the very same
REM ==> update session (first run or "-d" switch):
if "%2" == "-d" goto :GETDOCS_ENTRY_POINT_FROM_XTACK_UPDATE
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: xtack pgp.
REM -------------------------------------------------------------------------

:PRINT_XTACK_PGP_INFO
REM ==> Update logfile settings:
set xFunctionalityArea=PGP
call :REFRESH_LOGFILE "xtack_pgp"

REM ==> Print xtack PGP public key information:
echo xtack PGP public key to verify xtack components:|%xLog%
echo.|%xLog%
.\bin\gpg.exe --homedir .\cfg --list-keys 2>&1|%xGawk% "/^(pub|uid|sub) /{gsub(\"uid                 \",\"uid   \");print $0}"|%xLog%
echo.|%xLog%
.\bin\gpg.exe --homedir .\cfg --armor --export "info@xtack.org" 2>&1|%xGawk% "{if($0 !~ /(iconv|gpg: keyring|: trustdb created)/){print $0}}"|%xLog%
del /F /Q .\cfg\secring.gpg .\cfg\secring.gpg.lock .\cfg\trustdb.gpg .\cfg\trustdb.gpg.lock>nul 2>nul
goto :END

REM -------------------------------------------------------------------------
REM FUNCTIONALITY AREA: Common ending for all functionalty areas.
REM -------------------------------------------------------------------------

:END
REM ==> Get the final timestamp and show total xtack execution time:
if not "%xWinCmdExtActive%" == "1" goto :END3
call :TIME_DELTA "%xTime0%"
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTemp=%%i
if not "%xSilentMode%" == "1" (
    if /i not "%xFunctionalityArea%" == "Help" echo.
    echo xtack execution finished on %xTemp%
    echo ^(it took %xTookStr%^)
)

:END2
REM ==> Session logging:
echo.>> %xLogfile%
echo xtack execution finished on %xTemp%>> %xLogfile%
echo ^(it took %xTookStr%^)>> %xLogfile%
if not "%xSilentMode%" == "1" echo.

:END3
REM ==> Mini final cleanup:
del /F /Q .\tmp\cfgcache.txt .\tmp\doccache.txt .\tmp\autenticity.txt .\tmp\sess_*.* .\logs\error.log .\cfg\trustdb.gpg .\cfg\trustdb.gpg.lock .\cfg\secring.gpg .\cfg\secring.gpg.lock .\swu\*.sig>nul 2>nul
call :DELETE_XTACK_RUNTIME_FILES
endlocal

:END4
popd
set xWinCmdExtActive=
exit /b


REM -------------------------------------------------------------------------
REM ==> Subroutines start here ...
REM -------------------------------------------------------------------------

REM -------------------------------------------------------------------------
REM ==> SUB: ABORT_BROWSER_STARTUP: Effectively disables the browser startup
REM ==> altogether by resetting all required variables.
REM -------------------------------------------------------------------------

:ABORT_BROWSER_STARTUP
set xKillExistingBrowsers=0&set xStartBrowsers=0&set xBrowserURL=Not set
set xStartFirefox=0&set xStartOpera=0&set xStartSafari=0&set xStartChrome=0&set xStartMsie=0&set xStartEdge=0
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: ASK_USER_NUMERIC_RANGE_QUESTION: Asks the use to select a
REM ==> a valid numeric range in a loop until he/she answers properly.
REM ==> Argument #1: Question text.
REM ==> Argument #2: Upper numeric limit allowed.
REM ==> Argument #3: "Add Quit option" flag (0 or 1; Quit = 0).
REM ==> Returns: 0 if error, expanded numeric range or "all" (in xTemp var).
REM -------------------------------------------------------------------------

:ASK_USER_COMPONENT_RANGE_QUESTION
setlocal enableextensions
set aunrAnswer=0
set aunrQuestion=%~1
set aunrMax=%~2
set aunrQuit=%~3

REM ==> If no question specified as argument, directly reply with a "N":
if not defined aunrQuestion goto :AUNR_END
if "%aunrQuestion%" == "" goto :AUNR_END

REM ==> Validate the upper numeric limit allowed:
if not defined aunrMax goto :AUNR_END
echo %aunrMax%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[0-9]+$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :AUNR_END
if "%aunrMax%" == "0" goto :AUNR_END

REM ==> Remaining setup:
if not defined aunrQuit set aunrQuit=0
if not "%aunrQuit%" == "1" set aunrQuit=0
set aunrReminder=Sorry, please provide a valid range (e.g. All, Required or 1-5,7,9)
if "%aunrQuit%" == "1" set aunrReminder=%aunrReminder% or Q to quit ...

:AUNR_MAIN_LOOP
REM ==> Main user question loop:
echo %aunrQuestion%|%xLog%
set /p aunrTemp=[Z] Zero, [A] All, [R] Required, [I] Installed or numeric range?
if "%xDebugMode%" == "1" echo %xDbgM%User Answer to Question: %aunrQuestion% [Z] Zero, [A] All, [R] Required, [I] Installed or numeric range?: %aunrTemp%]>> %xLogfile%
echo %aunrTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*(All|A)[ \t]*$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :AUNR_USER_ANSWERED_ALL
echo %aunrTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*(Required|Req|R)[ \t]*$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :AUNR_USER_ANSWERED_REQUIRED
echo %aunrTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*(Installed|Inst|I)[ \t]*$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :AUNR_USER_ANSWERED_INSTALLED
echo %aunrTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*(Zero|Z|Quit|Q|0|None)[ \t]*$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto AUNR_USER_ANSWERED_ZERO

REM ==> Validate the user-provided numeric range:
echo %aunrTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*(All|A|((([0-9]{1,2})([ \t]*[-,][ \t]*)*)([0-9]{1,2})*)*)[ \t]*$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :AUNR_PARSE_RANGE

REM ==> Request user to provide a valid range and start over again:
echo.|%xLog%
echo %aunrReminder%|%xLog%
echo.|%xLog%
goto :AUNR_MAIN_LOOP

:AUNR_PARSE_RANGE
REM ==> After successful validation, parse and expand the range:
echo %aunrTemp%|%xGawk% "BEGIN{max=int(\"%aunrMax%\")}{gsub(/[ \t]*/,\"\");gsub(/^^,/,\"\");gsub(/,$/,\"\");n=split($0,range,\",\")}END{error=0;for(i=1;i<=max;i++){flags[i]=0};for(i in range){m=split(range[i],token,\"-\");if((m<1)||(m>2)){error=1;break}else if(m==1){t1=int(token[1]);flags[t1]=1}else{t1=int(token[1]);t2=int(token[2]);if((t1>max)||(t2>max)){error=1;break}else{if(t1==t2){flags[t1]=1}else if(t1<t2){for(j=t1;j<=t2;j++){flags[j]=1}}else{for(j=t2;j<=t1;j++){flags[j]=1}}}}};if(error==1){print \"0\"}else{j=0;for(i in flags){if(flags[i]==1){if(j!=0){answer=answer\" \"i}else{answer=i;j++}}};print answer}}">.\tmp\aunrtmp.txt
for /f "usebackq delims=" %%i in (`type .\tmp\aunrtmp.txt`) do set aunrAnswer=%%i
del /F /Q .\tmp\aunrtmp.txt>nul 2>nul
goto :AUNR_END

:AUNR_USER_ANSWERED_ALL
set aunrAnswer=all
goto :AUNR_END

:AUNR_USER_ANSWERED_REQUIRED
set aunrAnswer=required
goto :AUNR_END

:AUNR_USER_ANSWERED_INSTALLED
set aunrAnswer=installed
goto :AUNR_END

:AUNR_USER_ANSWERED_ZERO
set aunrAnswer=0

:AUNR_END
endlocal & set "xTemp=%aunrAnswer%" & set aunrAnswer=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: ASK_USER_YES_NO_QUESTION: Asks the user a YES/NO question
REM ==> in a loop until he/she answers one way or the other.
REM ==> Argument #1: Question text.
REM ==> Argument #2: "Add Quit option" flag (0 or 1; Quit = NO in practice).
REM ==> Returns: "Y"/"N" (in xTemp variable; default = "N").
REM -------------------------------------------------------------------------

:ASK_USER_YES_NO_QUESTION
setlocal enableextensions
set auynAnswer=N
set auynQuestion=%~1
set auynQuit=%~2

REM ==> If no question specified as argument, directly reply with a "N":
if not defined auynQuestion goto :AUYN_END
if "%auynQuestion%" == "" goto :AUYN_END

REM ==> Remaining setup:
if not defined auynQuit set auynQuit=0
if not "%auynQuit%" == "1" set auynQuit=0
set auynReminder=Sorry, please answer Y/N ("Yes/No")
if "%auynQuit%" == "1" set auynReminder=%auynReminder% or Q to quit ...

:AUYN_MAIN_LOOP
REM ==> Main user question loop:
echo %auynQuestion% (Y/N)?>> %xLogfile%
set /p auynTemp=%auynQuestion% (Y/N)?
if "%xDebugMode%" == "1" echo %xDbgM%User Answer to Question: %auynQuestion%: (Y/N)? %auynTemp%]>> %xLogfile%
if /i "%auynTemp%" == "Y" goto :AUYN_USER_ANSWERED_YES
if /i "%auynTemp%" == "Yes" goto :AUYN_USER_ANSWERED_YES
if /i "%auynTemp%" == "N" goto :AUYN_END
if /i "%auynTemp%" == "No" goto :AUYN_END

if not "%auynQuit%" == "1" goto :AUYN_REMIND_USER_ABOUT_YES_NO_ANSWER

if /i "%auynTemp%" == "Q" goto :AUYN_END
if /i "%auynTemp%" == "Quit" goto :AUYN_END

:AUYN_REMIND_USER_ABOUT_YES_NO_ANSWER
echo %auynReminder%|%xLog%
goto :AUYN_MAIN_LOOP

:AUYN_USER_ANSWERED_YES
set auynAnswer=Y

:AUYN_END
endlocal & set "xTemp=%auynAnswer%" & set auynAnswer=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_AND_INSTALL_VC_REDISPKG: Checks whether a required MS VC
REM ==> Redistributable Package is installed and if not tries to download
REM ==> and install it.
REM ==> Argument #1: Component that requires the package.
REM ==> Argument #2: MS VC required version.
REM ==> Argument #3: Silent execution/installation flag:
REM ==>              If = 0: Verbosely executed and user asked to install.
REM ==>              If = 1: Silently  executed and user asked to install.
REM ==>              If = 2: Silently  executed and user NOT asked (don't.
REM ==>              offer user the chance whether to install the package)
REM ==> Argument #4: Force installation flag:
REM ==>              If = 1: Force installation even if already installed.
REM ==> Returns: 0 = package installed OK; 1 = package NOT installed OK.
REM ==>              (in xTemp variable).
REM -------------------------------------------------------------------------

:CHECK_AND_INSTALL_VC_REDISPKG
setlocal enableextensions
set vcrpResult=1

REM ==> Validate MS VC Redistributable Package required version and the
REM ==> other arguments:
set vcrpVer=%~2
if not defined vcrpVer set vcrpVer=0
echo %vcrpVer%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(9|11|12|14)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :CIVCRP_CLEANUP
set vcrpComponent=%~1
if not defined vcrpComponent set vcrpComponent=a component
set vcrpSilentFlag=%~3
if not defined vcrpSilentFlag set vcrpSilentFlag=0
for /f "usebackq delims=" %%i in (`echo %vcrpSilentFlag%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(0|1|2)$/{i++;print $0}END{if(i==0){print \"0\"}}"`) do set vcrpSilentFlag=%%i
set vcrpForceFlag=%~4
if not defined vcrpForceFlag set vcrpForceFlag=0
for /f "usebackq delims=" %%i in (`echo %vcrpForceFlag%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(0|1)$/{i++;print $0}END{if(i==0){print \"0\"}}"`) do set vcrpForceFlag=%%i

REM ==> If xtack running in silent mode, force this subroutine to run in
REM ==> full silent mode:
if "%xSilentMode%" == "1" set vcrpSilentFlag=2

if /i "%vcrpVer%" == "9" (
    set vcrpTitle=Microsoft Visual C++ 2008 v9.0 Service Pack 1 Redistributable Package MFC Security Update
    set vcrpRegPath=Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F}
    set vcrpDownloadPageId=26368
)
if /i "%vcrpVer%" == "11" (
    set vcrpTitle=Microsoft Visual C++ Redistributable Package for Visual Studio 2012 v11.0 Update 4
    set vcrpRegPath=VisualStudio\11.0\VC\Runtimes\x86
    set vcrpDownloadPageId=30679
)
if /i "%vcrpVer%" == "12" (
    set vcrpTitle=Microsoft Visual C++ Redistributable Package for Visual Studio 2013 v12.0
    set vcrpRegPath=VisualStudio\12.0\VC\Runtimes\x86
    set vcrpDownloadPageId=40784
)
if /i "%vcrpVer%" == "14" (
    set vcrpTitle=Microsoft Visual C++ 2015 v14.0 Redistributable Package Update 3
    set vcrpRegPath=VisualStudio\14.0\VC\Runtimes\x86
    set vcrpDownloadPageId=53840
)
REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> Define required messages:
set vcrpDefaultSilentError=ERROR: xtack can't run: Required MS VC Redistributable Packages missing.
set vcrpXtackCanOnly=xtack can only run %vcrpComponent% if the %vcrpTitle% is installed on this system, but it is currently missing.
set vcrpRedisContainer=xtack MS VC++ Redistributable Packages container file

REM ==> If forced package installation, skip checking if it is already
REM ==> installed:
if not "%vcrpForceFlag%" == "1" goto :CIVCRP_CHECK_IF_ALREADY_INSTALLED
REM ==> If in Debug Mode, log forced installation:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: Forcing %vcrpTitle% installation for %vcrpComponent%]>> %xLogfile%
goto :CIVCRP_CHECK_IF_ADMIN

:CIVCRP_CHECK_IF_ALREADY_INSTALLED
REM ==> If in Debug Mode, log the check:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: Checking whether required %vcrpTitle% for %vcrpComponent% is already installed on this system]>> %xLogfile%

REM ==> Poll Windows Registry to check whether required MS VC
REM ==> Redistributable Package is already installed:
call :CHECK_VC_REDISPKG_IN_WIN_REGISTRY "%vcrpRegPath%"
if "%xTemp%" == "0" goto :CIVCRP_REDISPKG_ALREADY_INSTALLED

REM ==> VC Redistributable Package not installed or forced installation.
REM ==> If not in silent mode, check whether xtack is being run as
REM ==> administrator with elevated permissions, but first, if in Debug
REM ==> Mode, log that the package is missing:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: No, required %vcrpTitle% for %vcrpComponent% is not yet installed on this system]>> %xLogfile%

:CIVCRP_CHECK_IF_ADMIN
.\bin\isadmin.exe -q
if "%errorlevel%" == "1" goto :CIVCRP_USER_HAS_ADMIN_RIGHTS

REM ==> For xtack sessions NOT being run as administrator or
REM ==> without elevated permissions, show/log error and exit:
if not "%xSilentMode%" == "1" call :SHOW_WORDWRAPPED_MSG "ERROR: Sorry, %vcrpXtackCanOnly%" 68
call :SHOW_MSG "\nxtack can install if for you, but you need to run it from an\nelevated command prompt session with administrator rights.\n\nIf you use a Windows administrator account, right click on a Command\nPrompt icon and select 'Run as administrator', then run xtack again\nand follow the instructions.\n" "%vcrpDefaultSilentError%"
call :LOG_ENTRY error "CHECK_AND_INSTALL_VC_REDISPKG Sub: %vcrpTitle% for %vcrpComponent% can't be installed on this system as xtack.bat is being run without administrator rights."

:CIVCRP_ERROR_EXIT
REM ==> If in Debug Mode, log that the required Redistributable Package
REM ==> is not present on the system:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: Required %vcrpTitle% for %vcrpComponent% is not and could not be installed on this system. Please check!]>> %xLogfile%
goto :CIVCRP_CLEANUP

:CIVCRP_USER_HAS_ADMIN_RIGHTS
REM ==> xtack is being run by an user with administrator permissions.
REM ==> If MS VC Redistributable Packages container file available at
REM ==> .\bin\vcredis\vcredis.7z, install de corresponding package from it:
set vcrpTemp=download and install
if exist .\bin\vcredis\vcredis.7z set vcrpTemp=install& goto :CIVCRP_WARN_ADMIN_USER_TO_DOWNLOAD_AND_INSTALL_REDISPKG

REM ==> MS VC Redistributable Packages container file unavailable. Check
REM ==> Internet connectivity silently:
call :CHECK_INET_CONNECTIVITY 1
if "%xDebugMode%" == "1" echo %xDbgM%Host has Internet connectivity: %xHostHasInetConnectivity%]>> %xLogfile%
if "%xHostHasInetConnectivity%" == "1" goto :CIVCRP_WARN_ADMIN_USER_TO_DOWNLOAD_AND_INSTALL_REDISPKG
if not "%xSilentMode%" == "1" call :SHOW_WORDWRAPPED_MSG "ERROR: Sorry, %vcrpXtackCanOnly%" 68
call :SHOW_MSG "\nxtack can download and install if for you from this command prompt,\nbut there is no Internet connection right now. Please turn your\nInternet connection on and try again. Now exiting ..." "%vcrpDefaultSilentError%"

:CIVCRP_LOG_AND_EXIT
call :LOG_ENTRY error "CHECK_AND_INSTALL_VC_REDISPKG Sub: xtack execution failure due to missing %vcrpTitle% required for %vcrpComponent%."
goto :CIVCRP_ERROR_EXIT

:CIVCRP_WARN_ADMIN_USER_TO_DOWNLOAD_AND_INSTALL_REDISPKG
if %vcrpSilentFlag% GTR 1 goto :CIVCRP_SKIP_ASKING_USER_IF_INSTALL
call :SHOW_WORDWRAPPED_MSG "WARNING: %vcrpXtackCanOnly%" 68
echo.|%xLog%

REM ==> Ask the user whether he/she wants to (download and) install the
REM ==> package now:
call :ASK_USER_YES_NO_QUESTION "Do you want to %vcrpTemp% the package now" 1
if /i not "%xTemp%" == "Y" echo. && goto :CIVCRP_LOG_AND_EXIT

:CIVCRP_SKIP_ASKING_USER_IF_INSTALL
REM ==> If not already available, download xtack's online update info to
REM ==> get the URL to the latest vcredis.7z container file:
if exist .\bin\vcredis\vcredis.7z goto :CIVCRP_REDISPKG_SHA512_OK
del /F /Q .\swu\status .\swu\status.txt .\swu\rstatus.txt>nul 2>nul
call :DOWNLOAD_UCF
if "%xTemp%" == "0" goto :CIVCRP_GET_VCREDIS_CONTAINER

:CIVCRP_VCREDIS_CONTAINER_CANNOT_BE_DOWNLOADED
call :SHOW_MSG "\nERROR: The %vcrpRedisContainer% could\nnot be downloaded. Please download the MS VC++ Redistributable Package\nfrom https://www.microsoft.com/en-us/download/details.aspx?id=%vcrpDownloadPageId%\nand install it manually on this system. Now exiting ...\n"
call :LOG_ENTRY error "CHECK_AND_INSTALL_VC_REDISPKG Sub: The %vcrpRedisContainer% couldn't be downloaded. Now exiting."
goto :CIVCRP_ERROR_EXIT

:CIVCRP_GET_VCREDIS_CONTAINER
REM ==> Read the URL and download the latest xtack MS VC++ Redistributable
REM ==> Packages container file:
ren .\swu\%xUCF% rstatus.txt>nul 2>nul
set vcrpTemp=0
for /f "usebackq delims=" %%i in (`type .\swu\rstatus.txt^|%xGawk% "BEGIN{IGNORECASE=1}/vcredis/{print $6}"`) do set vcrpTemp=%%i
if "%vcrpTemp%" == "0" goto :CIVCRP_VCREDIS_CONTAINER_CANNOT_BE_DOWNLOADED

:CIVCRP_DOWNLOAD_VCREDIS_CONTAINER
call :SHOW_MSG "\nDownloading %vcrpRedisContainer%.\nIt's a large file that may take some time to download. Please wait ..."
call :DOWNLOAD_FILE "%vcrpRedisContainer%" "%xDownloadBaseUrl%%vcrpTemp%.7z" ".\bin\vcredis" 0 1 1 "TLSv1"
if not "%xTemp%" == "0" goto :CIVCRP_VCREDIS_CONTAINER_CANNOT_BE_DOWNLOADED

REM ==> Move it to its intended final location:
move /Y .\bin\vcredis\%vcrpTemp%.7z .\bin\vcredis\vcredis.7z>nul 2>nul
if not "%errorlevel%" == "0" goto :CIVCRP_VCREDIS_CONTAINER_CANNOT_BE_DOWNLOADED

REM ==> Calculate and verify the just-downloaded vcredis.7z's SHA512 checksum:
for /f "usebackq delims=" %%i in (`type .\swu\rstatus.txt^|%xGawk% "BEGIN{IGNORECASE=1}/vcredis/{print $6}"`) do set vcrpTemp=%%i
call :GET_FILE_SHA512 "%~dp0bin\vcredis\vcredis.7z"
if /i "%xTemp%" == "%vcrpTemp%" goto :CIVCRP_REDISPKG_SHA512_OK

REM ==> Show and log SHA512 checksum verification failure:
call :SHOW_MSG "ERROR: SHA512 checksum verification failed for xtack MS VC++\nRedistributable Packages container file." "%vcrpDefaultSilentError%"
call :LOG_ENTRY error "CHECK_AND_INSTALL_VC_REDISPKG Sub: SHA512 checksum verification failed for %vcrpRedisContainer% at %~dp0bin\vcredis\vcredis.7z (expected SHA512 checksum = %vcrpTemp%; measured SHA512 checksum = %xTemp%). Please check. Now exiting."

REM ==> If in silent mode, exit directly:
if %vcrpSilentFlag% GTR 1 goto :CIVCRP_ERROR_EXIT

REM ==> Ask user whether to retry the download. If refused, exit directly:
call :ASK_USER_YES_NO_QUESTION "Do you want to retry downloading it" 0
if /i "%xTemp%" == "Y" goto :CIVCRP_DOWNLOAD_VCREDIS_CONTAINER
call :SHOW_MSG "" "%vcrpDefaultSilentError%"
goto :CIVCRP_ERROR_EXIT

:CIVCRP_REDISPKG_SHA512_OK
REM ==> The user accepted to download and install the package now. If VC14
REM ==> redispkg to be installed on Windows 8.1, run special pre-requisites
REM ==> installation procedure first, as per the information contained in:
REM ==> https://www.microsoft.com/en-us/download/details.aspx?id=49984
REM ==> "Additional Prerequisite: April 2014 Update (see KB 2919355) and
REM ==> Servicing Stack Update (see KB2919442 or later) for Windows 8.1 and
REM ==> Windows Server 2012 R2."
if /i not "%vcrpVer%-%xWinProduct%" == "14-Win81" goto :CIVCRP_SKIP_W81_SPECIAL_PROCEDURE

REM ==> Get QFE list of currently installed KB patches and check if special
REM ==> procedure can be skipped:
call :GET_QFE_LIST_OF_INSTALLED_KBS
type .\tmp\qfe.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(KB2975061|KB2919355|KB2999226)/{i++}END{if(i==3){exit 0}else{exit 1}}"
if "%errorlevel%" == "0" goto :CIVCRP_SKIP_W81_SPECIAL_PROCEDURE

REM ==> Windows 8.1 special procedure: If not in silent mode, ask user
REM ==> whether to install the additional W8.1 patches, otherwise just
REM ==> assume "YES" and proceed:
call :SHOW_MSG "\nWARNING: This system is running on Windows 8.1 or Windows Server\n2012 R2, which requires that some special, additional Windows feature\npacks and supporting Microsoft update patches are installed BEFORE\n%vcrpTitle%.\n" "Installing additional Windows patches needed for VC14 Redistributable."
if %vcrpSilentFlag% GTR 1 goto :CIVCRP_W81_SPECIAL_PROC_PROCEED

call :ASK_USER_YES_NO_QUESTION "Do you want to download and install those Windows patches now" 1
if /i "%xTemp%" == "Y" goto :CIVCRP_W81_SPECIAL_PROC_PROCEED

REM ==> The user refused to download and install required Windows patches.
REM ==> Now just exit:
call :SHOW_MSG "\nOK, thanks, now exiting ..."
goto :CIVCRP_LOG_AND_EXIT

:CIVCRP_W81_SPECIAL_PROC_PROCEED
REM ==> Secure that .\tmp is clean of any previous leftovers:
del /F /Q .\tmp\wgetitem.txt .\tmp\qfe.txt .\tmp\w81kbs.txt .\tmp\vc*redispkg*.exe .\tmp\*.msu .\tmp\clearcompressionflag.exe>nul 2>nul
set vcrpW81KbUrlPrefix=https://download.microsoft.com/download/
if /i not "%xWinArch%" == "x64" goto :CIVCRP_W81_SPECIAL_PROC_SET_X86_URLS

REM ==> Save list of KB download URLs (x64 versions):
echo KB2975061 2/1/E/21E26FC4-27A2-4330-90D0-938F87CD7C5D/Windows8.1-KB2975061-x64.msu 10MiB ^0>.\tmp\w81kbs.txt
echo ClearCompressionFlag D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/clearcompressionflag.exe 38KiB ^0>>.\tmp\w81kbs.txt
echo KB2919355 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2919355-x64.msu 690MiB ^1>>.\tmp\w81kbs.txt
echo KB2932046 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2932046-x64.msu 48MiB ^1>>.\tmp\w81kbs.txt
echo KB2959977 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2959977-x64.msu 3MiB ^0>>.\tmp\w81kbs.txt
echo KB2937592 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2937592-x64.msu 303KiB ^0>>.\tmp\w81kbs.txt
echo KB2938439 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2938439-x64.msu 20MiB ^1>>.\tmp\w81kbs.txt
echo KB2934018 D/B/1/DB1F29FC-316D-481E-B435-1654BA185DCF/Windows8.1-KB2934018-x64.msu 126MiB ^1>>.\tmp\w81kbs.txt
echo KB2999226 9/6/F/96FD0525-3DDF-423D-8845-5F92F4A6883E/Windows8.1-KB2999226-x64.msu 981KiB ^0>>.\tmp\w81kbs.txt
goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS

:CIVCRP_W81_SPECIAL_PROC_SET_X86_URLS
REM ==> Save list of KB download URLs (x86 versions):
echo KB2975061 0/7/C/07CBAA67-0BAC-4F1A-89B4-124E89ED0A55/Windows8.1-KB2975061-x86.msu 5MiB ^0>.\tmp\w81kbs.txt
echo ClearCompressionFlag 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/clearcompressionflag.exe 36KiB ^0>>.\tmp\w81kbs.txt
echo KB2919355 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2919355-x86.msu 319MiB ^1>>.\tmp\w81kbs.txt
echo KB2932046 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2932046-x86.msu 25MiB ^1>>.\tmp\w81kbs.txt
echo KB2959977 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2959977-x86.msu 2MiB ^0>>.\tmp\w81kbs.txt
echo KB2937592 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2937592-x86.msu 302KiB ^0>>.\tmp\w81kbs.txt
echo KB2938439 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2938439-x86.msu 10MiB ^0>>.\tmp\w81kbs.txt
echo KB2934018 4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2934018-x86.msu 72MiB ^1>>.\tmp\w81kbs.txt
echo KB2999226 E/4/6/E4694323-8290-4A08-82DB-81F2EB9452C2/Windows8.1-KB2999226-x86.msu 590KiB ^0>>.\tmp\w81kbs.txt

:CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS
REM ==> Initialize KB patch download and installation counters:
for /f "usebackq delims=" %%i in (`type .\tmp\w81kbs.txt^|%xGawk% "END{print NR}"`) do set vcrpNumberOfKbsToCheck=%%i
set vcrpCurrentKbCounter=0
set vcrpCurrentlyMissingToBeInstalledKbsCounter=0
set vcrpSuccessfullyDownloadedKbsCounter=0
set vcrpSuccessfullyInstalledKbsCounter=0
set vcrpDownloadFailedKbIds=empty
set vcrpSuccessfullyInstalledKbIds=empty
set vcrpInstallFailedKbIds=empty

:CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP
REM ==> Execute the main KB patch download loop:
set /a vcrpCurrentKbCounter+=1

REM ==> Get the current OpMode to test:
for /f "usebackq delims=" %%i in (`type .\tmp\w81kbs.txt^|%xGawk% "{if(NR==%vcrpCurrentKbCounter%){print $0}}"`) do set vcrpTemp=%%i

REM ==> Reset KB variables and populate them:
set vcrpW81KbId=
set vcrpW81KbUrl=
set vcrpW81KbSize=
set vcrpW81KbLargeKb=
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{print $1}"`) do set vcrpW81KbId=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{print $2}"`) do set vcrpW81KbUrl=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{gsub(\"MiB\",\" MiB\",$3);gsub(\"KiB\",\" KiB\",$3);print $3}"`) do set vcrpW81KbSize=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{if($4==1){print \"LARGE\"}else{print \"small\"}}"`) do set vcrpW81KbLargeKb=%%i

REM ==> Check if KB download is necessary. If not, skip it altogether:
type .\tmp\qfe.txt|%xGawk% "BEGIN{IGNORECASE=1}/%vcrpW81KbId%/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP_CHECK
set /a vcrpCurrentlyMissingToBeInstalledKbsCounter+=1

REM ==> Now perform the download:
call :SHOW_MSG "\nDownloading %vcrpW81KbLargeKb% Windows patch %vcrpW81KbId% (~%vcrpW81KbSize%). Please wait ..."
call :DOWNLOAD_FILE "%vcrpW81KbId% (~%vcrpW81KbSize%)" "%vcrpW81KbUrlPrefix%%vcrpW81KbUrl%" ".\tmp" 0 1 0

REM ==> If KB successfully downloaded, step counter and register it:
if not "%xTemp%" == "0" goto :CIVCRP_W81_SPECIAL_PROC_KB_DOWNLOAD_FAIL

set /a vcrpSuccessfullyDownloadedKbsCounter+=1
goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP_CHECK

:CIVCRP_W81_SPECIAL_PROC_KB_DOWNLOAD_FAIL
REM ==> If KB downloaded failed, register it:
set vcrpDownloadFailedKbIds=%vcrpDownloadFailedKbIds%, %vcrpW81KbId%
call :SHOW_MSG "WARNING: Windows patch %vcrpW81KbId% could not be downloaded."

:CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP_CHECK
if %vcrpCurrentKbCounter% LSS %vcrpNumberOfKbsToCheck% goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP

REM ==> If all needed KB patches have been successfully downloaded, proceed
REM ==> to installation. Otherwise exit:
if /i "%vcrpSuccessfullyDownloadedKbsCounter%" == "%vcrpCurrentlyMissingToBeInstalledKbsCounter%" goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS

REM ==> Show and log KB patches download failures:
call :SHOW_MSG "\nERROR: Not all the %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches could be successfully\ndownloaded. So, %vcrpTitle%\ncannot be installed either. Now exiting ...\n"
for /f "usebackq delims=" %%i in (`echo %vcrpDownloadFailedKbIds%^|%xGawk% "{gsub(\"empty, \",\"\");print $0}"`) do set vcrpDownloadFailedKbIds=%%i
call :LOG_ENTRY error "CHECK_AND_INSTALL_VC_REDISPKG Sub: Out the %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches, one or more failed to download (%vcrpDownloadFailedKbIds%). So, the required %vcrpTitle% cannot be installed either. Now exiting."
goto :CIVCRP_LOG_AND_EXIT

:CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS
REM ==> Initialize the KB patch installation loop:
set vcrpCurrentKbCounter=0

call :SHOW_MSG "\nThe additional Windows 8.1 feature packs and supporting patches\nwill now be installed. Please confirm any dialog boxes that may pop\nup and wait for all the installations to complete. They may take\nsome time (up to about half an hour in total) as some of these update\npackages are quite large..."

:CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS_LOOP
REM ==> Execute the main KB patch installation loop:
set /a vcrpCurrentKbCounter+=1

REM ==> Get the current OpMode to test:
for /f "usebackq delims=" %%i in (`type .\tmp\w81kbs.txt^|%xGawk% "{if(NR==%vcrpCurrentKbCounter%){print $0}}"`) do set vcrpTemp=%%i

REM ==> Reset KB variables and populate them:
set vcrpW81KbId=
set vcrpW81KbUrl=
set vcrpW81KbSize=
set vcrpW81KbLargeKb=
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{print $1}"`) do set vcrpW81KbId=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{print $2}"`) do set vcrpW81KbUrl=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{gsub(\"MiB\",\" MiB\",$3);gsub(\"KiB\",\" KiB\",$3);print $3}"`) do set vcrpW81KbSize=%%i
for /f "usebackq delims=" %%i in (`echo %vcrpTemp%^|%xGawk% "{if($4==1){print \"LARGE\"}else{print \"small\"}}"`) do set vcrpW81KbLargeKb=%%i

REM ==> Check if KB install is necessary. If not, skip it altogether:
type .\tmp\qfe.txt|%xGawk% "BEGIN{IGNORECASE=1}/%vcrpW81KbId%/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP_CHECK

REM ==> Before trying to install the KB's MSU package, check that the file
REM ==> exists. If not, jump to next iteration:
for /f "usebackq delims=" %%i in (`echo %vcrpW81KbUrl%^|%xGawk% -F^/ "{print $NF}"`) do set vcrpFilename=%%i
if not exist .\tmp\%vcrpFilename% goto :CIVCRP_W81_SPECIAL_PROC_DOWNLOAD_KBS_LOOP_CHECK

if /i not "%vcrpFilename%" == "clearcompressionflag.exe" goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_WUSA
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG/Executed Command: .\tmp\%vcrpFilename% /q]>> %xLogfile%
.\tmp\%vcrpFilename% /q>nul 2>nul
set vcrpTemp=%errorlevel%
goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_CHECK_EXIT_CODE

:CIVCRP_W81_SPECIAL_PROC_INSTALL_WUSA
REM ==> Now install the normal MSU package via wusa.exe:
call :SHOW_MSG "\nInstalling %vcrpW81KbLargeKb% Windows patch %vcrpW81KbId% (~%vcrpW81KbSize%). Please wait ..."
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG/Executed Command: start /wait wusa.exe .\tmp\%vcrpFilename% /quiet /norestart]>> %xLogfile%
start /wait wusa.exe .\tmp\%vcrpFilename% /quiet /norestart /log:"%~dp0tmp\KB2975061_xtack_installation.evtx">nul 2>nul
set vcrpTemp=%errorlevel%

:CIVCRP_W81_SPECIAL_PROC_INSTALL_CHECK_EXIT_CODE
REM ==> Check wusa.exe or clearcompressionflag.exe exit codes and
REM ==> filter out the ones reporting successful installations:
if "%vcrpTemp%" == "3010" goto :CIVCRP_W81_SPECIAL_PROC_KB_INSTALL_OK
if "%vcrpTemp%" == "2359302" goto :CIVCRP_W81_SPECIAL_PROC_KB_INSTALL_OK
if not "%vcrpTemp%" == "0" goto :CIVCRP_W81_SPECIAL_PROC_KB_INSTALL_FAIL

:CIVCRP_W81_SPECIAL_PROC_KB_INSTALL_OK
REM ==> If KB successfully installed, step counter and register it:
set /a vcrpSuccessfullyInstalledKbsCounter+=1
set vcrpSuccessfullyInstalledKbIds=%vcrpSuccessfullyInstalledKbIds%, %vcrpW81KbId%
goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS_LOOP_CHECK

:CIVCRP_W81_SPECIAL_PROC_KB_INSTALL_FAIL
set vcrpInstallFailedKbIds=%vcrpInstallFailedKbIds%, %vcrpW81KbId%
call :SHOW_MSG "WARNING: Windows patch %vcrpW81KbId% failed to properly install."

:CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS_LOOP_CHECK
if %vcrpCurrentKbCounter% LSS %vcrpNumberOfKbsToCheck% goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_KBS_LOOP

REM ==> If all needed KB patches have been successfully installed, show and
REM ==> log it, then proceed:
if /i "%vcrpSuccessfullyDownloadedKbsCounter%" == "%vcrpCurrentlyMissingToBeInstalledKbsCounter%" goto :CIVCRP_W81_SPECIAL_PROC_INSTALL_SUCCESS

REM ==> Show and log KB patches installation failures:
call :SHOW_MSG "\nWARNING: Not all %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches could be successfully\ninstalled. So, %vcrpTitle%\nmay fail to install too. Now attempting to install it anyway..."
for /f "usebackq delims=" %%i in (`echo %vcrpInstallFailedKbIds%^|%xGawk% "{gsub(\"empty, \",\"\");print $0}"`) do set vcrpInstallFailedKbIds=%%i
call :LOG_ENTRY warning "CHECK_AND_INSTALL_VC_REDISPKG Sub: Out the %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches, one or more failed to install (%vcrpInstallFailedKbIds%). So, the required %vcrpTitle% may fail to install too. Now attempting to install it anyway."
goto :CIVCRP_SKIP_W81_SPECIAL_PROCEDURE

:CIVCRP_W81_SPECIAL_PROC_INSTALL_SUCCESS
call :SHOW_MSG "\nINFO: All %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches were successfully installed.\nPlease RESTART Windows for them to take effect, so xtack runs smoothly."
for /f "usebackq delims=" %%i in (`echo %vcrpSuccessfullyInstalledKbIds%^|%xGawk% "{gsub(\"empty, \",\"\");print $0}"`) do set vcrpSuccessfullyInstalledKbIds=%%i
call :LOG_ENTRY info "CHECK_AND_INSTALL_VC_REDISPKG Sub: All the %vcrpCurrentlyMissingToBeInstalledKbsCounter% needed Windows 8.1 patches (%vcrpSuccessfullyInstalledKbIds%) were successfully installed."

:CIVCRP_SKIP_W81_SPECIAL_PROCEDURE
REM ==> Main MS VC Redistributable Package expansion and installation:
del /F /Q .\tmp\wgetitem.txt .\tmp\vc*redispkg*.exe>nul 2>nul
.\bin\7za.exe e -aos -y -o.\tmp\ .\bin\vcredis\vcredis.7z vcredis\vc%vcrpVer%redispkg*.exe>nul 2>nul
if not "%errorlevel%" == "0" goto :CIVCRP_REDISPKG_INSTALLATION_ERROR

REM ==> First install the 32 bits version of the Redistributable Package too:
call :SHOW_MSG "\n%vcrpTitle%\nwill now be installed. Please confirm any dialog boxes that may\npop up and wait for the installation to complete ..."
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG/Executed Command: .\tmp\vc%vcrpVer%redispkg86.exe /q]>> %xLogfile%
.\tmp\vc%vcrpVer%redispkg86.exe /q>nul 2>nul
if not "%errorlevel%" == "0" goto :CIVCRP_REDISPKG_INSTALLATION_ERROR

REM ==> If running on a 64 bits version of Windows, also install the 64
REM ==> bits version of the Redistributable Package:
if /i not "%xWinArch%" == "x64" goto :CIVCRP_CHECK_REDISPKG_INSTALLATION
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG/Executed Command: .\tmp\vc%vcrpVer%redispkg64.exe /q]>> %xLogfile%
.\tmp\vc%vcrpVer%redispkg64.exe /q>nul 2>nul

:CIVCRP_CHECK_REDISPKG_INSTALLATION
REM ==> Poll Windows Registry again to check whether the required MS
REM ==> VC Redistributable Package has been successfully installed now:
call :CHECK_VC_REDISPKG_IN_WIN_REGISTRY "%vcrpRegPath%"
if "%xTemp%" == "0" goto :CIVCRP_REDISPKG_SUCCESSFULLY_INSTALLED

:CIVCRP_REDISPKG_INSTALLATION_ERROR
REM ==> If error during installation, inform the user and exit:
call :SHOW_MSG "\nERROR: %vcrpTitle%\ndidn't apparently install properly ...\n" "ERROR: xtack can't run: Missing MS VC Redistributable Packages can't be installed."
goto :CIVCRP_ERROR_EXIT

:CIVCRP_REDISPKG_SUCCESSFULLY_INSTALLED
call :SHOW_MSG "\n%vcrpTitle%\nhas now been successfully installed. Now proceeding ...\n"

REM ==> If in Debug Mode, log that the required Redistributable Package has
REM ==> been successfully installed:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: Yes, required %vcrpTitle% for %vcrpComponent% has been successfully installed on the system]>> %xLogfile%
call :LOG_ENTRY info "CHECK_AND_INSTALL_VC_REDISPKG Sub: %vcrpTitle% successfully installed."
goto :CIVCRP_OK_EXIT

:CIVCRP_REDISPKG_ALREADY_INSTALLED
REM ==> If in Debug Mode, log that the required Redistributable Package is
REM ==> already installed on the system:
if "%xDebugMode%" == "1" echo %xDbgM%CHECK_AND_INSTALL_VC_REDISPKG: Yes, required %vcrpTitle% for %vcrpComponent% is already installed on this system]>> %xLogfile%

:CIVCRP_OK_EXIT
set vcrpResult=0

:CIVCRP_CLEANUP
REM ==> Clean up and return back:
if "%vcrpResult%" == "0" del /F /Q .\tmp\*.evtx .\tmp\*.evtx.dpx>nul 2>nul
endlocal & set "xTemp=%vcrpResult%" & set vcrpResult=
del /F /Q .\tmp\wgetitem.txt .\tmp\qfe.txt .\tmp\w81kbs.txt .\tmp\vc*redispkg*.exe .\tmp\*.msu .\tmp\clearcompressionflag.exe>nul 2>nul
goto :EOF


REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_FOR_AVAILABLE_UPDATES: If required, checks for new xtack
REM ==> component updates eventually available.
REM -------------------------------------------------------------------------

:CHECK_FOR_AVAILABLE_UPDATES
REM ==> Find out if check for xtack component updates required:
if not "%xRstatusDownloadedOk%" == "1" goto :CFAU_END

REM ==> Process the remote status file:
call :PROCESS_RSTATUS_GET_UPDATED_COMPONENTS

REM ==> If there are new component updates, prompt user:
if not "%xNumberOfNewComponentsAvailable%" == "0" call :SHOW_MSG "\nThere are %xNumberOfNewComponentsAvailable% new component updates available. You can run command\n'xtack update' to install them."

:CFAU_END
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_INET_CONNECTIVITY: Finds out whether the host
REM ==> has Internet connectivity and can ping itself.
REM ==> Argument #1    : Silent mode flag (1 = Silent; otherwise = normal)
REM ==> Returns flag #1: xHostHasInetConnectivity (1 = Yes; 0 = No)
REM ==> Returns flag #2: xHostCanPingItself (1 = Yes; 0 = No)
REM -------------------------------------------------------------------------

:CHECK_INET_CONNECTIVITY
setlocal enableextensions
set cicSilentMode=%~1
if not defined cicSilentMode set cicSilentMode=0

if not "%cicSilentMode%" == "1" echo Checking Internet connectivity. This may take a few seconds ...|%xLog%
REM ==> Ping Google with a 1 second timeout:
ping -n 1 -w 1000 %xPingHost%>nul 2>nul
if "%errorlevel%" == "0" goto :CIC_HOST_HAS_INET_CONNECTIVITY

if not "%cicSilentMode%" == "1" echo Still checking Internet connectivity. Please wait ...|%xLog%
REM ==> Try again with more ICMP packets and a slightly longer timeout:
ping -n 4 -w 1250 %xPingHost%>nul 2>nul
if "%errorlevel%" == "0" goto :CIC_HOST_HAS_INET_CONNECTIVITY

REM ==> The host seems to have no Internet connectivity:
set cicHostHasInetConnectivity=0
goto :CIC_CHECK_IF_HOST_CAN_PING_ITSELF

:CIC_HOST_HAS_INET_CONNECTIVITY
REM ==> The host indeed has Internet connectivity:
set cicHostHasInetConnectivity=1

:CIC_CHECK_IF_HOST_CAN_PING_ITSELF
REM ==> Ping the own host with a 1 second timeout:
ping -n 1 -w 1000 127.0.0.1>nul 2>nul
if "%errorlevel%" == "0" goto :CIC_HOST_CAN_PING_ITSELF

REM ==> Try again with more ICMP packets and a slightly longer delay:
ping -n 4 -w 1250 127.0.0.1>nul 2>nul
if "%errorlevel%" == "0" goto :CIC_HOST_CAN_PING_ITSELF

REM ==> The host can't ping itself:
set cicHostCanPingItself=0
goto :CIC_END

:CIC_HOST_CAN_PING_ITSELF
REM ==> The host can ping itself indeed:
set cicHostCanPingItself=1

:CIC_END
REM ==> Return back:
endlocal & set "xHostHasInetConnectivity=%cicHostHasInetConnectivity%" & set "xHostCanPingItself=%cicHostCanPingItself%" & set cicHostHasInetConnectivity= & set cicHostCanPingItself=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_PACKAGE_MANAGER_CONNECTIVITY: Checks whether a given
REM ==> package manager has Internet connectivity and if it doesn't it
REM ==> shows and logs a warning.
REM ==> Argument #1: Package manager name.
REM -------------------------------------------------------------------------

:CHECK_PACKAGE_MANAGER_CONNECTIVITY
REM ==> Verify Internet connectivity:
call :CHECK_INET_CONNECTIVITY 1
if "%xDebugMode%" == "1" echo %xDbgM%Host has Internet connectivity: %xHostHasInetConnectivity%]>> %xLogfile%
if "%xHostHasInetConnectivity%" == "1" goto :CPMC_END

REM ==> IF there is no Internet connectivity, show and log warning:
echo WARNING: This system has no Internet connectivity at the moment, so|%xLog%
echo %~1 won't be able to download/install/update any packages.|%xLog%
echo.|%xLog%
call :LOG_ENTRY warning "xtack %~1 will be unable to download/install/update any packages due to lack of Internet connectivity."

:CPMC_END
REM ==> Return back:
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_TARGET_OPMODE: Verifies if the specified target OpMode
REM ==> is actually OK to be used for xtack startup or switch over.
REM ==> Actually, the subroutine checks whether the requested HTTP server,
REM ==> DBMS and PHP version are installed or not.
REM ==> Argument #1: Target OpMode to test.
REM ==> Returns: Target OpMOde suitability result (in xTemp variable):
REM ==>          0 = OpMode is suitable for startup/switchover
REM ==>          1 = Unsuitable OpMode (undefined, invalid or other reason)
REM ==>          2 = Unsuitable OpMode (HTTP server)
REM ==>          3 = Unsuitable OpMode (DBMS)
REM ==>          4 = Unsuitable OpMode (PHP)
REM ==>          5 = Unsuitable OpMode (HTTP server + DBMS)
REM ==>          6 = Unsuitable OpMode (HTTP server + PHP)
REM ==>          7 = Unsuitable OpMode (DBMS + PHP)
REM ==>          8 = Unsuitable OpMode (HTTP server + DBMS + PHP)
REM -------------------------------------------------------------------------

:CHECK_TARGET_OPMODE
setlocal enableextensions
set ctoTargetOpMode=%~1

REM ==> By default, flag OpMode suitability result flag = 1
REM ==> (undefined, invalid or other reason):
set ctoResult=1

REM ==> Validate input arguments:
if not defined ctoTargetOpMode goto :CTO_END
if /i "%ctoTargetOpMode%" == "" goto :CTO_END

REM ==> Validate input target OpMode:
echo %ctoTargetOpMode%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(a13|a24|ngx|njs|iis)(p52|p53|p54|p55|p56|p70|p71|p72)(m55|m57|pgs|mra|ndb)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :CTO_END

REM ==> Get server selectors from final OpMode chosen:
for /f "usebackq delims=" %%i in (`echo %ctoTargetOpMode%^|%xGawk% "{print tolower(substr($0,0,3))}"`) do set ctoHttpSrvSelector=%%i
for /f "usebackq delims=" %%i in (`echo %ctoTargetOpMode%^|%xGawk% "{print tolower(substr($0,7,3))}"`) do set ctoDbmsSelector=%%i
for /f "usebackq delims=" %%i in (`echo %ctoTargetOpMode%^|%xGawk% "{print tolower(substr($0,4,3))}"`) do set ctoPhpSelector=%%i
set ctoHttpSrvResult=0
set ctoDbmsResult=0
set ctoPhpResult=0

REM ==> Check whether the HTTP server binary actually exists
REM ==> First, infer the HTTP server binary path and filename:
for /f "usebackq delims=" %%i in (`echo %ctoHttpSrvSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /a24/){print \"bin\\httpd.exe\"}else if($0 ~ /ngx/){print \"nginx.exe\"}else if($0 ~ /a13/){print \"Apache.exe\"}else if($0 ~ /iis/){print \"iisexpress.exe\"}else{print \"node.exe\"}}"`) do set ctoHttpSrvBinary=%%i
if not exist ".\bin\%ctoHttpSrvSelector%\%ctoHttpSrvBinary%" set ctoHttpSrvResult=1

REM ==> Check whether the DBMS binary exist:
if /i "%ctoDbmsSelector%" == "ndb" goto :CTO_CHECK_PHP

REM ==> Infer the DBMS binary path and filename:
for /f "usebackq delims=" %%i in (`echo %ctoDbmsSelector%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/pgs/{i++;print \"postgres.exe\"}END{if(i==0){print \"mysqld.exe\"}}"`) do set ctoDbmsBinary=%%i
if not exist ".\bin\%ctoDbmsSelector%\bin\%ctoDbmsBinary%" set ctoDbmsResult=1

REM ==> Check whether the DBMS auxiliary binary exist:
for /f "usebackq delims=" %%i in (`echo %ctoDbmsSelector%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/pgs/{i++;print \"pg_ctl.exe\"}END{if(i==0){print \"mysqladmin.exe\"}}"`) do set ctoDbmsBinary=%%i
if not exist ".\bin\%ctoDbmsSelector%\bin\%ctoDbmsBinary%" set ctoDbmsResult=1

:CTO_CHECK_PHP
REM ==> Check whether the PHP engine binary exists:
if not exist ".\bin\%ctoPhpSelector%\php-cgi.exe" set ctoPhpResult=1

REM ==> Make up the final result:
for /f "usebackq delims=" %%i in (`echo %ctoHttpSrvResult%%ctoDbmsResult%%ctoPhpResult%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /000/){print \"0\"}else if($0 ~ /100/){print \"2\"}else if($0 ~ /010/){print \"3\"}else if($0 ~ /001/){print \"4\"}else if($0 ~ /110/){print \"5\"}else if($0 ~ /101/){print \"6\"}else if($0 ~ /011/){print \"7\"}else if($0 ~ /111/){print \"8\"}else{print \"1\"}}"`) do set ctoResult=%%i

:CTO_END
REM ==> Return back:
endlocal & set "xTemp=%ctoResult%" & set ctoResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CHECK_VC_REDISPKG_IN_WIN_REGISTRY: Polls the Windows Registry to
REM ==> check whether a MS VC Redistributable Package is installed on the
REM ==> system or not.
REM ==> Argument #1: VC Redistributable Package Windows Registry path.
REM ==> Argument #2: String to check in the Windows Registry path.
REM ==> Returns: 0 = package installed; 1 = package NOT installed (xTemp)
REM -------------------------------------------------------------------------

:CHECK_VC_REDISPKG_IN_WIN_REGISTRY
setlocal enableextensions
set vcwrResult=1
set vcwrRegPath=%~1
if not defined vcwrRegPath goto :CVCWR_EXIT
set vcwrCheckString=%~2

REM ==> Check whether the required MS VC Redistributable Package is already
REM ==> installed (32 bit system):
.\bin\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\%vcwrRegPath%">nul 2>nul
if not "%errorlevel%" == "0" goto :CVCWR_CHECK_FOR_REDISPKG_IN_64_BIT_SYSTEM

if not defined vcwrCheckString goto :CVCWR_REDISPKG_ALREADY_INSTALLED
.\bin\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\%vcwrRegPath%"|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*%vcwrCheckString%$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :CVCWR_REDISPKG_ALREADY_INSTALLED

:CVCWR_CHECK_FOR_REDISPKG_IN_64_BIT_SYSTEM
REM ==> Second chance: Check whether it is installed on a 64 bit system
REM ==> instead:
.\bin\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\%vcwrRegPath%">nul 2>nul
if not "%errorlevel%" == "0" goto :CVCWR_EXIT

if not defined vcwrCheckString goto :CVCWR_REDISPKG_ALREADY_INSTALLED
.\bin\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\%vcwrRegPath%"|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*%vcwrCheckString%$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :CVCWR_EXIT

:CVCWR_REDISPKG_ALREADY_INSTALLED
set vcwrResult=0

:CVCWR_EXIT
endlocal & set "xTemp=%vcwrResult%" & set vcwrResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: COLLECT_SYSTEM_INFO_WITH_WMIC: Collects and logs information with
REM ==> WMIC about the system in which xtack is currently running on.
REM ==> Argument #1: If = 1, external IP address resolution check is skipped.
REM ==> Argument #2: Debug Mode active (1 or 0).
REM ==> Returned value: System information string (in xTemp variable).
REM -------------------------------------------------------------------------

:COLLECT_SYSTEM_INFO_WITH_WMIC
setlocal enableextensions

REM ==> Collect the info about the system on which xtack is running.
REM ==> First get system manufacturer, model and physical memory:
wmic COMPUTERSYSTEM GET Manufacturer,Model,TotalPhysicalMemory /format:list>.\tmp\csitmp.txt 2>nul

REM ==> Get processor make and processor cores info:
wmic CPU GET Name,NumberOfCores /format:list>>.\tmp\csitmp.txt 2>nul

REM ==> Get OS info:
wmic OS GET Caption,BuildType,Version,CSDVersion,OSArchitecture,OperatingSystemSKU /format:list>>.\tmp\csitmp.txt 2>nul
echo @echo off>.\tmp\csitmp.bat
type .\tmp\csitmp.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0;j=0}/=/{if($0 ~ /OSArchitecture=/){i++};if($0 ~ /IPAddress=/ && j==0){j++;gsub(/({|})/,\"\");gsub(/(=|,|\042)/,\" \");print \"set csiIPAddress=\" $2}else if($0 ~ /TotalPhysicalMemory=/){gsub(\"=\",\" \");mem=int($2/1048576);if(mem<1000){mem=mem \" M\"}else{mem=int(mem/1000) \" G\"};print \"set csiRam=\" mem \"B RAM\"}else if($0 !~ /IPAddress=/){gsub(/(\([Rr]\)|\([Tt][Mm]\))/,\"\");gsub(\"VistaT\",\"Vista\");gsub(\"Microsoftr\",\"Microsoft\");gsub(\"-bit\",\" bits\");gsub(\"Service Pack \",\"SP\");gsub(/( ,|, )/,\",\");print \"set csi\" $0}}END{if(i==0){print \"set csiOSArchitecture=32 bits\"}}">>.\tmp\csitmp.bat
call .\tmp\csitmp.bat
if not defined csiCSDVersion set csiCSDVersion=SP0
for /f "usebackq delims=" %%i in (`type .\tmp\csitmp.txt^|%xGawk% "BEGIN{e[1]=\"Ultimate\";e[2]=\"Home Basic\";e[3]=\"Home Premium\";e[4]=\"Enterprise\";e[5]=\"Home Basic N\";e[6]=\"Business\";e[7]=\"Standard Server\";e[8]=\"Datacenter Server\";e[9]=\"Small Business Server\";e[10]=\"Enterprise Server\";e[11]=\"Starter\";e[12]=\"Datacenter Server Core\";e[13]=\"Standard Server Core\";e[14]=\"Enterprise Server Core\";e[15]=\"Enterprise Server for Itanium-based Systems\";e[16]=\"Business N\";e[17]=\"Web Server\";e[18]=\"Cluster Server\";e[19]=\"Storage Server 2008 R2 Essentials\";e[20]=\"Storage Server Express\";e[21]=\"Storage Server Standard\";e[22]=\"Storage Server Workgroup\";e[23]=\"Storage Server Enterprise\";e[24]=\"Server 2008 for Windows Essential Server Solutions\";e[25]=\"Small Business Server Premium\";e[26]=\"Home Premium N\";e[27]=\"Enterprise N\";e[28]=\"Ultimate N\";e[29]=\"Web Server Core\";e[30]=\"Essential Business Server Management Server\";e[31]=\"Essential Business Server Security Server\";e[32]=\"Essential Business Server Messaging Server\";e[33]=\"Server Foundation\";e[34]=\"Home Server 2011\";e[35]=\"Server 2008 without Hyper-V for Windows Essential Server Solutions\";e[36]=\"Server Standard without Hyper-V\";e[37]=\"Server Datacenter without Hyper-V Full\";e[38]=\"Server Enterprise without Hyper-V Full\";e[39]=\"Server Datacenter without Hyper-V Core\";e[40]=\"Server Standard without Hyper-V Core\";e[41]=\"Server Enterprise without Hyper-V Core\";e[42]=\"Hyper-V Server\";e[43]=\"Storage Server Express Core\";e[44]=\"Storage Server Standard Core\";e[45]=\"Storage Server Workgroup Core\";e[46]=\"Storage Server Enterprise Core\";e[47]=\"Starter N\";e[48]=\"Professional\";e[49]=\"Professional N\";e[50]=\"Small Business Server 2011 Essentials\";e[51]=\"Server For SB Solutions\";e[52]=\"Server Solutions Premium\";e[53]=\"Server Solutions Premium Core\";e[54]=\"Server For SB Solutions EM\";e[55]=\"Server For SB Solutions EM\";e[56]=\"MultiPoint Server\";e[59]=\"Essential Server Solution Management\";e[60]=\"Essential Server Solution Additional\";e[61]=\"Essential Server Solution Management SVC\";e[62]=\"Essential Server Solution Additional SVC\";e[63]=\"Small Business Server Premium Core\";e[64]=\"Server Hyper Core V\";e[66]=\"Starter E\";e[67]=\"Home Basic E\";e[68]=\"Home Premium E\";e[69]=\"Professional E\";e[70]=\"Enterprise E\";e[71]=\"Ultimate E\";e[72]=\"Enterprise Evaluation\";e[76]=\"Windows MultiPoint Server Standard Full\";e[77]=\"Windows MultiPoint Server Premium Full\";e[79]=\"Server Standard Evaluation\";e[80]=\"Server Datacenter Evaluation\";e[84]=\"Enterprise N Evaluation\";e[95]=\"Storage Server Workgroup Evaluation\";e[96]=\"Storage Server Standard Evaluation\";e[97]=\"RT\";e[98]=\"Home N\";e[99]=\"Home China\";e[100]=\"Home Single Language\";e[101]=\"Home\";e[103]=\"Professional with Media Center\";e[104]=\"Mobile\";e[121]=\"Education\";e[122]=\"Education N\";e[123]=\"IoT Core\";e[125]=\"Enterprise 2015 LTSB\";e[126]=\"Enterprise 2015 LTSB N\";e[129]=\"Enterprise 2015 LTSB Evaluation\";e[130]=\"Enterprise 2015 LTSB N Evaluation\";e[131]=\"IoT Core Commercial\";e[133]=\"Mobile Enterprise\";e[143]=\"Nano Server Datacenter\";e[144]=\"NanoServer Standard\";e[147]=\"Server Datacenter Core\";e[148]=\"Server Standard Core\"}/OperatingSystemSKU=/{gsub(\"OperatingSystemSKU^=\",\"\");if(e[$0]==\"\"){print \"^(Unconfirmed^)\"}else{print e[$0]}}"`) do set csiTemp=%%i
for /f "usebackq delims=" %%i in (`echo 0^|%xGawk% "{printf(\"xtack running on a %%s %%s system with %%sx %%s core^(s^)^, %%s and %%s%%s %%s Edition %%s %%s version %%s\n\",\"%csiManufacturer%\",\"%csiModel%\",\"%csiNumberOfCores%\",\"%csiName%\",\"%csiRam%\",\"%csiCaption%\",\"%csiBuildType%\",\"%csiTemp%\",\"%csiCSDVersion%\",\"%csiOSArchitecture%\",\"%csiVersion%\")}"`) do set csiSystem=%%i

REM ==> Check if external IP address resolution check must be skipped:
if "%~1" == "1" goto :CSIWW_SKIP_IP

REM ==> Check external IP address resolution:
wmic NICCONFIG where IPEnabled=true get IPAddress /format:list>.\tmp\csitmp.txt 2>&1
type .\tmp\csitmp.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}/No Instance\(s\) Available\./{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :CSIWW_SKIP_IP
for /f "usebackq" %%i in (`type .\tmp\csitmp.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1;i=0}/{/{if(i==0){gsub(/({|}|IPAddress=)/,\"\");print $1;i++}}"`) do set csiTemp=%%i
set csiSystem=%csiSystem% and first enabled external IP Address %csiTemp:"=%

:CSIWW_SKIP_IP
REM ==> Log collected information:
call :LOG_ENTRY info "%csiSystem%." 1

REM ==> Check xtack Debug Mode and conditionally add the info to the
REM ==> script's logfile:
if "%~2" == "1" goto :CSIWW_DEBUG_MODE_ON
goto :CSIWW_CLEANUP

:CSIWW_DEBUG_MODE_ON
echo %xDbgM%System Info: %csiSystem%]>> %xLogfile%
echo.>> %xLogfile%

:CSIWW_CLEANUP
REM ==> Clean up and return back:
del /F /Q .\tmp\csitmp.txt .\tmp\csitmp.bat>nul 2>nul
endlocal & set "xTemp=%csiSystem%" & set csiSystem=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CREATE_INSTALLED_COMPONENTS_LIST: Creates an updated list of all
REM ==> xtack components currently installed with its versions, so it can be
REM ==> later compared with the online version as part of an online update.
REM -------------------------------------------------------------------------

:CREATE_INSTALLED_COMPONENTS_LIST
setlocal enableextensions

REM ==> Delete older working files:
del /F /Q .\swu\installed.txt .\swu\available.txt .\swu\newcomps.txt>nul 2>nul

REM ==> Start creating the list of component tokens and versions:
if not exist .\bin\7za.exe goto :CICL_7ZA_NOK
.\bin\7za.exe|%xGawk% "BEGIN{IGNORECASE=1}/Igor Pavlov/{gsub(/(\[32\]|\[64\]| :)/,\"\");print \"7za 7-Zip \"$3}">.\swu\installed.txt
goto :CICL_CHECK_A13

:CICL_7ZA_NOK
echo 7za 7-Zip unavailable>>.\swu\installed.txt

:CICL_CHECK_A13
if not exist .\bin\a13\Apache.exe goto :CICL_A13_NOK
.\bin\a13\Apache.exe -v|%xGawk% "BEGIN{IGNORECASE=1}/Server version: /{gsub(\"/\",\" \");print \"a13 Apache \"$4}">>.\swu\installed.txt
goto :CICL_CHECK_A24

:CICL_A13_NOK
echo a13 Apache unavailable>>.\swu\installed.txt

:CICL_CHECK_A24
if not exist .\bin\a24\bin\httpd.exe goto :CICL_A24_NOK
.\bin\a24\bin\httpd.exe -v|%xGawk% "BEGIN{IGNORECASE=1}/Server version: /{gsub(\"/\",\" \");print \"a24 Apache \"$4}">>.\swu\installed.txt
goto :CICL_CHECK_BROWSCAP

:CICL_A24_NOK
echo a24 Apache unavailable>>.\swu\installed.txt

:CICL_CHECK_BROWSCAP
if not exist .\bin\browscap\php_browscap.ini goto :CICL_BROWSCAP_NOK
type .\bin\browscap\php_browscap.ini|%xGawk% "BEGIN{i=0}/^Version=[0-9]{4,5}$/{if(i<1){gsub(\"Version=\",\"\");i++;print \"browscap php_browscap.ini \"$0}}">>.\swu\installed.txt
goto :CICL_CHECK_DLLPACK

:CICL_BROWSCAP_NOK
echo browscap php_browscap.ini unavailable>>.\swu\installed.txt

:CICL_CHECK_DLLPACK
if not exist .\bin\dlls\xtack.json goto :CICL_DLLPACK_NOK
call :DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON ".\bin\dlls\xtack.json"
goto :CICL_CHECK_ICONS

:CICL_DLLPACK_NOK
echo dlls DLLPack unavailable>>.\swu\installed.txt

:CICL_CHECK_ICONS
if not exist .\bin\icons\xtack.json goto :CICL_ICONS_NOK
call :DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON ".\bin\icons\xtack.json"
goto :CICL_CHECK_IIS

:CICL_ICONS_NOK
echo icons Icons unavailable>>.\swu\installed.txt

:CICL_CHECK_IIS
set xTemp=
if not exist .\bin\iis\iisexpress.exe goto :CICL_IIS_NOK
call :GET_BINARY_VERSION_WMIC "%~dp0bin\iis\iisexpress.exe"
if not defined xTemp goto :CICL_IIS_NOK
echo iis IIS %xTemp%>>.\swu\installed.txt
goto :CICL_CHECK_MRA

:CICL_IIS_NOK
echo iis IIS unavailable>>.\swu\installed.txt

:CICL_CHECK_MRA
if not exist .\bin\mra\bin\mysqld.exe goto :CICL_MRA_NOK
.\bin\mra\bin\mysqld.exe --version|%xGawk% "{gsub(/-MariaDB/,\"\");print \"mra MariaDB \"$3}">>.\swu\installed.txt
goto :CICL_CHECK_M55

:CICL_MRA_NOK
echo mra MariaDB unavailable>>.\swu\installed.txt

:CICL_CHECK_M55
if not exist .\bin\m55\bin\mysqld.exe goto :CICL_M55_NOK
.\bin\m55\bin\mysqld.exe --version|%xGawk% "{gsub(/-community/,\"\");print \"m55 MySQL \"$3}">>.\swu\installed.txt
goto :CICL_CHECK_M57

:CICL_M55_NOK
echo m55 MySQL unavailable>>.\swu\installed.txt

:CICL_CHECK_M57
if not exist .\bin\m57\bin\mysqld.exe goto :CICL_M57_NOK
.\bin\m57\bin\mysqld.exe --version|%xGawk% "{gsub(/-community/,\"\");print \"m57 MySQL \" $3}">>.\swu\installed.txt
goto :CICL_CHECK_MODSECURITY

:CICL_M57_NOK
echo m57 MySQL unavailable>>.\swu\installed.txt

:CICL_CHECK_MODSECURITY
if not exist .\bin\a24\modules\ReadMe_ApacheLounge_mod_security.txt goto :CICL_MODSECURITY_NOK
type .\bin\a24\modules\ReadMe_ApacheLounge_mod_security.txt|%xGawk% "BEGIN{IGNORECASE=1}/^ *mod_security-/{gsub(/^ *mod_security-/,\"\");print \"mod_security ModSecurity \"$1}">>.\swu\installed.txt
goto :CICL_CHECK_MRADB

:CICL_MODSECURITY_NOK
echo mod_security ModSecurity unavailable>>.\swu\installed.txt

:CICL_CHECK_MRADB
if not exist .\dbs\xtack_mradb.json goto :CICL_MRADB_NOK
call :DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON ".\dbs\xtack_mradb.json"
goto :CICL_CHECK_MYSQLDBS

:CICL_MRADB_NOK
echo mradb MariaDB_DB unavailable>>.\swu\installed.txt

:CICL_CHECK_MYSQLDBS
if not exist .\dbs\xtack_mysqldbs.json goto :CICL_MYSQLDBS_NOK
call :DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON ".\dbs\xtack_mysqldbs.json"
goto :CICL_CHECK_NGX

:CICL_MYSQLDBS_NOK
echo mysqldbs MySQL_DBs unavailable>>.\swu\installed.txt

:CICL_CHECK_NGX
if not exist .\bin\ngx\nginx.exe goto :CICL_NGX_NOK
.\bin\ngx\nginx.exe -v 2>&1|%xGawk% "BEGIN{IGNORECASE=1}/version: /{gsub(\"/\",\" \");print \"ngx Nginx \"$4}">>.\swu\installed.txt
goto :CICL_CHECK_NJS

:CICL_NGX_NOK
echo ngx Nginx unavailable>>.\swu\installed.txt

:CICL_CHECK_NJS
if not exist .\bin\njs\node.exe goto :CICL_NJS_NOK
.\bin\njs\node.exe -v|%xGawk% "{gsub(\"v\",\"njs Node.js \");print $0}">>.\swu\installed.txt
goto :CICL_CHECK_P52

:CICL_NJS_NOK
echo njs Node.js unavailable>>.\swu\installed.txt

:CICL_CHECK_P52
if not exist .\bin\p52\php-cgi.exe goto :CICL_P52_NOK
.\bin\p52\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p52 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P53

:CICL_P52_NOK
echo p52 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P53
if not exist .\bin\p53\php-cgi.exe goto :CICL_P53_NOK
.\bin\p53\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p53 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P54

:CICL_P53_NOK
echo p53 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P54
if not exist .\bin\p54\php-cgi.exe goto :CICL_P54_NOK
.\bin\p54\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p54 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P55

:CICL_P54_NOK
echo p54 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P55
if not exist .\bin\p55\php-cgi.exe goto :CICL_P55_NOK
.\bin\p55\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p55 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P56

:CICL_P55_NOK
echo p55 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P56
if not exist .\bin\p56\php-cgi.exe goto :CICL_P56_NOK
.\bin\p56\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p56 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P70

:CICL_P56_NOK
echo p56 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P70
if not exist .\bin\p70\php-cgi.exe goto :CICL_P70_NOK
.\bin\p70\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p70 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P71

:CICL_P70_NOK
echo p70 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P71
if not exist .\bin\p71\php-cgi.exe goto :CICL_P71_NOK
.\bin\p71\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p71 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_P72

:CICL_P71_NOK
echo p71 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_P72
if not exist .\bin\p72\php-cgi.exe goto :CICL_P72_NOK
.\bin\p72\php-cgi.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built:/{print \"p72 PHP \"$2}">>.\swu\installed.txt
goto :CICL_CHECK_PGA

:CICL_P72_NOK
echo p72 PHP unavailable>>.\swu\installed.txt

:CICL_CHECK_PGA
if not exist .\bin\pga\HISTORY goto :CICL_PGA_NOK
type .\bin\pga\HISTORY|%xGawk% "BEGIN{i=0}/Version /{if(i==0){print \"pga phpPgAdmin \"$2;i++}}">>.\swu\installed.txt
goto :CICL_CHECK_PGS

:CICL_PGA_NOK
echo pga phpPgAdmin unavailable>>.\swu\installed.txt

:CICL_CHECK_PGS
if not exist .\bin\pgs\bin\postgres.exe goto :CICL_PGS_NOK
.\bin\pgs\bin\postgres.exe --version|%xGawk% "{print \"pgs PostgreSQL \"$3}">>.\swu\installed.txt
goto :CICL_CHECK_PGSDB

:CICL_PGS_NOK
echo pgs PostgreSQL unavailable>>.\swu\installed.txt

:CICL_CHECK_PGSDB
if not exist .\dbs\xtack_pgsdb.json goto :CICL_CHECK_PGSDB_NOK
call :DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON ".\dbs\xtack_pgsdb.json"
goto :CICL_CHECK_PHALCON

:CICL_CHECK_PGSDB_NOK
echo pgsdb PostgreSQL_DB unavailable>>.\swu\installed.txt

:CICL_CHECK_PHALCON
if not exist .\bin\p%xBatPhp%\php.exe goto :CICL_PHALCON_NOK
if not exist .\bin\phalcon\php_phalcon%xBatPhp%.dll goto :CICL_PHALCON_NOK
.\bin\p%xBatPhp%\php.exe -n -d date.timezone="Europe/Paris" -d extension="%~dp0bin\phalcon\php_phalcon%xBatPhp%.dll" -i|%xGawk% "BEGIN{RS=\"\"}/Phalcon Team/{gsub(/\n/,\" \");print tolower($14)\" Phalcon \"$20}">>.\swu\installed.txt
goto :CICL_CHECK_PHPCS

:CICL_PHALCON_NOK
echo phalcon Phalcon unavailable>>.\swu\installed.txt

:CICL_CHECK_PHPCS
if not exist .\bin\phpcs\phpcs.phar goto :CICL_PHPCS_NOK
.\bin\p%xBatPhp%\php.exe -n .\bin\phpcs\phpcs.phar --version|%xGawk% "BEGIN{IGNORECASE=1}/PHP_CodeSniffer/{print \"phpcs PHP_CodeSniffer \"$3}">>.\swu\installed.txt
goto :CICL_CHECK_PMA

:CICL_PHPCS_NOK
echo phpcs PHP_CodeSniffer unavailable>>.\swu\installed.txt

:CICL_CHECK_PMA
if not exist .\bin\pma\README goto :CICL_PMA_NOK
type .\bin\pma\README|%xGawk% "BEGIN{i=0}/Version/{if(i==0){print \"pma phpMyAdmin \"$2;exit}}">>.\swu\installed.txt
goto :CICL_CHECK_RUNTIME

:CICL_PMA_NOK
echo pma phpMyAdmin unavailable>>.\swu\installed.txt

:CICL_CHECK_RUNTIME
if not exist .\bin\7za.exe goto :CICL_RUNTIME_NOK
if not exist .\bin\runtime.7z goto :CICL_RUNTIME_NOK
.\bin\7za.exe l .\bin\runtime.7z|%xGawk% "BEGIN{IGNORECASE=1}/changelog.r/{gsub(/changelog.r/,\"r\");print \"runtime Runtime \"$5}">>.\swu\installed.txt
goto :CICL_CHECK_SENDMAIL

:CICL_RUNTIME_NOK
echo runtime Runtime unavailable>>.\swu\installed.txt

:CICL_CHECK_SENDMAIL
if not exist .\bin\sendmail\sendmail.exe goto :CICL_SENDMAIL_NOK
.\bin\sendmail\sendmail.exe -h|%xGawk% "BEGIN{IGNORECASE=1}/version/{print \"sendmail FakeSendmail \"$4}">>.\swu\installed.txt
goto :CICL_CHECK_VCREDIS

:CICL_SENDMAIL_NOK
echo sendmail FakeSendmail unavailable>>.\swu\installed.txt

:CICL_CHECK_VCREDIS
if not exist .\bin\7za.exe goto :CICL_VCREDIS_NOK
if not exist .\bin\vcredis\vcredis.7z goto :CICL_VCREDIS_NOK
.\bin\7za.exe l .\bin\vcredis\vcredis.7z|%xGawk% "BEGIN{IGNORECASE=1}/changelog.r/{gsub(/changelog.r/,\"r\");gsub(/vcredis\\/,\"\");print \"vcredis MSVC_Redistributables \"$6}">>.\swu\installed.txt
goto :CICL_CHECK_XDOCS

:CICL_VCREDIS_NOK
echo vcredis MSVC_Redistributables unavailable>>.\swu\installed.txt

:CICL_CHECK_XDOCS
if not exist .\docs\index.html goto :CICL_XDOCS_NOK
type .\docs\index.html|%xGawk% "BEGIN{IGNORECASE=1}/!--  Revision: r[0-9]{1,4}/{print \"xdocs xtackDocs \"$3}">>.\swu\installed.txt
goto :CICL_CHECK_XDEBUG

:CICL_XDOCS_NOK
echo xdocs xtackDocs unavailable>>.\swu\installed.txt

:CICL_CHECK_XDEBUG
set ciclTemp=%~dp0bin\xdebug\php_xdebug56.dll
if not exist "%ciclTemp%" goto :CICL_XDEBUG_NOK
wmic datafile where name="%ciclTemp:\=\\%" get version|%xGawk% "/\./{print \"xdebug Xdebug \"$1}">>.\swu\installed.txt
goto :CICL_CHECK_XTACKBAT

:CICL_XDEBUG_NOK
echo xdebug Xdebug unavailable>>.\swu\installed.txt

:CICL_CHECK_XTACKBAT
type .\%~nx0|%xGawk% "BEGIN{IGNORECASE=1}/REM Revision: r[0-9]{1,4}/{print \"xtackbat xtack.bat \"$3}">>.\swu\installed.txt

:CICL_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CREATE_NGINX_DIRS_AND_FILES: Creates the directories and files
REM ==>      that Nginx needs to run.
REM -------------------------------------------------------------------------

:CREATE_NGINX_DIRS_AND_FILES
if not exist .\temp\client_body_temp md .\temp\client_body_temp>nul 2>nul
if not exist .\temp\fastcgi_temp md .\temp\fastcgi_temp>nul 2>nul
if not exist .\temp\proxy_temp md .\temp\proxy_temp>nul 2>nul
if not exist .\scgi_temp md .\scgi_temp>nul 2>nul
if not exist .\uwsgi_temp md .\uwsgi_temp>nul 2>nul
if not exist .\bin\ngx\temp\client_body_temp md .\bin\ngx\temp\client_body_temp>nul 2>nul
if not exist .\bin\ngx\temp\fastcgi_temp md .\bin\ngx\temp\fastcgi_temp>nul 2>nul
if not exist .\bin\ngx\temp\proxy_temp md .\bin\ngx\temp\proxy_temp>nul 2>nul
if not exist .\bin\ngx\scgi_temp md .\bin\ngx\scgi_temp>nul 2>nul
if not exist .\bin\ngx\uwsgi_temp md .\bin\ngx\uwsgi_temp>nul 2>nul
if not exist .\wwww md .\www>nul 2>nul
echo ^<!DOCTYPE html^>^<html^>^<head^>^<title^>Error^</title^>>.\www\xtack_nginx_error.html
echo ^<style^>body {width: 35em;margin: 0 auto;font-family: Arial, sans-serif;}^</style^>>>.\www\xtack_nginx_error.html
echo ^</head^>^<body^>^<h1^>An nginx error occurred!^</h1^>>>.\www\xtack_nginx_error.html
echo ^<p^>The page you are looking for is currently unavailable.^<br/^>>>.\www\xtack_nginx_error.html
echo ^<p^>To find out more, you can check xtack^&apos;s nginx error log at ^<b^>^<a href="../logs/xtack_nginx_error.log"^>/logs/xtack_nginx_error.log^</a^>^</b^>^</p^>>>.\www\xtack_nginx_error.html
echo ^<p^>You can also check nginx^&apos;s ^<a href="https://nginx.org/r/error_log"^>error log documentation^</a^> for details.^</p^>>>.\www\xtack_nginx_error.html
echo ^</body^>^</html^>>>.\www\xtack_nginx_error.html
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: CREATE_DEFAULT_XTACK_INI: Creates a default xtack.ini
REM ==>      configuration file.
REM -------------------------------------------------------------------------

:CREATE_DEFAULT_XTACK_INI
if not exist .\cfg md .\cfg>nul 2>nul
call :GET_TIMESTAMP_TZ
echo.> .\cfg\xtack.ini
type .\%~nx0|%xGawk% "{if(NR>1&&NR<24){gsub(\"REM\",\"#\");print $0}}">> .\cfg\xtack.ini
echo # Last update: %xTemp%>> .\cfg\xtack.ini
echo #>> .\cfg\xtack.ini
echo # Revision: r999>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # IMPORTANT NOTE: Only the first occurrence of each setting, in case any>> .\cfg\xtack.ini
echo # of them are repeated throughout the file, will be taken into account.>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # DebugMode: Controls xtack debugging messages:>> .\cfg\xtack.ini
echo DebugMode=Yes>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # DefaultOpMode: Defines the default xtack Operation Mode:>> .\cfg\xtack.ini
echo DefaultOpMode=%xRootDefaultOpMode%>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # Settings for DB server console verbosity and killing of existing instances:>> .\cfg\xtack.ini
echo VerboseDbServer=No>> .\cfg\xtack.ini
echo KillExistingServers=Yes>> .\cfg\xtack.ini
echo KillExistingBrowsers=Yes>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # Browser(s) configuration:>> .\cfg\xtack.ini
echo StartBrowsers=MSIE>> .\cfg\xtack.ini
echo BrowserURL="http://127.0.0.1/index_xtack.php" "http://127.0.0.1/docs/index.html">> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # IIS Express specific configuration:>> .\cfg\xtack.ini
echo IisHttpPort=80>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # URLs for the different manuals and documents to be downloaded:>> .\cfg\xtack.ini
echo PhpManual=http://de1.php.net/distributions/manual/php_enhanced_en.chm>> .\cfg\xtack.ini
echo MySql55Manual=https://downloads.mysql.com/docs/refman-5.5-en.a4.pdf>> .\cfg\xtack.ini
echo MySql57Manual=https://downloads.mysql.com/docs/refman-5.7-en.a4.pdf>> .\cfg\xtack.ini
echo PostgreSqlManual=https://www.postgresql.org/files/documentation/pdf/9.6/postgresql-9.6-A4.pdf>> .\cfg\xtack.ini
echo.>> .\cfg\xtack.ini
echo # Paths to browser executable binaries, if xtack is unable to detect them:>> .\cfg\xtack.ini
echo FirefoxPath=C:\Program Files (x86)\Mozilla Firefox\firefox.exe>> .\cfg\xtack.ini
echo MsiePath=C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE>> .\cfg\xtack.ini
echo ChromePath=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe>> .\cfg\xtack.ini
echo OperaPath=C:\Program Files (x86)\Opera\opera.exe>> .\cfg\xtack.ini
echo SafariPath=C:\Program Files (x86)\Safari\Safari.exe>> .\cfg\xtack.ini
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DELETE_NGINX_DIRS_AND_FILES: Deletes directories Nginx needs
REM ==> to run.
REM -------------------------------------------------------------------------

:DELETE_NGINX_DIRS_AND_FILES
rd /S /Q .\temp .\scgi_temp .\uwsgi_temp .\bin\ngx\temp .\bin\ngx\scgi_temp .\bin\ngx\uwsgi_temp>nul 2>nul
del /F /Q .\www\xtack_nginx_error.html>nul 2>nul
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DELETE_XTACK_RUNTIME_FILES: Deletes all the xtack Runtime files.
REM ==> Argument #1: Directory from which files must be deleted.
REM -------------------------------------------------------------------------

:DELETE_XTACK_RUNTIME_FILES
set dxcsDirectory=%~1
if /i not "%dxcsDirectory%" == "tmp" set dxcsDirectory=bin
del /F /Q .\%dxcsDirectory%\*.dll .\%dxcsDirectory%\*.man .\%dxcsDirectory%\*.conf .\%dxcsDirectory%\*.ini .\%dxcsDirectory%\*.js .\%dxcsDirectory%\changelog.r* .\%dxcsDirectory%\LICENSE.txt .\%dxcsDirectory%\xtack.json>nul 2>nul
del /F /Q .\%dxcsDirectory%\fmt.exe .\%dxcsDirectory%\gawk.exe .\%dxcsDirectory%\gpg.exe .\%dxcsDirectory%\hidec.exe .\%dxcsDirectory%\isadmin.exe .\%dxcsDirectory%\nircmdc.exe .\%dxcsDirectory%\ps.exe .\%dxcsDirectory%\reg.exe .\%dxcsDirectory%\HashConsole.exe .\%dxcsDirectory%\wget.exe .\%dxcsDirectory%\wtee.exe>nul 2>nul
set dxcsDirectory=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DOWNLOAD_COMPOSER: Downloads and saves composer.
REM ==> Returns: File download result (in xTemp variable):
REM ==>          0 = Downloaded OK and filesize check passed OK.
REM ==>          1 = Downloaded OK but filesize check NOT passed.
REM ==>          2 = Download unsuccessful (not OK).
REM -------------------------------------------------------------------------

:DOWNLOAD_COMPOSER
call :DOWNLOAD_FILE "Composer" "https://getcomposer.org/composer.phar" ".\bin\composer\" 0 1 0
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DOWNLOAD_FILE: Downloads a specified file.
REM ==> Argument #1: File caption.
REM ==> Argument #2: Source file URL.
REM ==> Argument #3: Destination directory for file saving.
REM ==> Argument #4: Expected filesize in KiB for checking. If no value or
REM ==>              (numeric) zero is provided, an automatic check will be
REM ==>              attempted.
REM ==> Argument #5: Silent mode flag (1=Silent; otherwise=normal)
REM ==> Argument #6: Add update package header flag (1=Yes; otherwise=No)
REM ==> Argument #7: [OPTIONAL] HTTPS protocol (auto|SSLv2|SSLv3|TLSv1).
REM ==> Returns: File download result (in xTemp variable):
REM ==>          0 = Downloaded OK and filesize check passed OK.
REM ==>          1 = Downloaded OK but filesize check NOT passed.
REM ==>          2 = Download unsuccessful (not OK).
REM -------------------------------------------------------------------------

:DOWNLOAD_FILE
if not defined xWgetVer for /f "usebackq delims=" %%i in (`.\bin\wget.exe --version^|%xGawk% "BEGIN{IGNORECASE=1}/^GNU Wget /{print $3}"`) do set xWgetVer=%%i
setlocal enableextensions
set dfCaption=%~1
set dfUrl=%~2
set dfDestination=%~3
set dfExpectedFilesize=%~4
set dfSilentMode=%~5
set dfAddUpdatePackageHttpHeader=%~6
set dfHttpsProtocol=%~7
if not defined dfSilentMode set dfSilentMode=0
if not defined dfAddUpdatePackageHttpHeader set dfAddUpdatePackageHttpHeader=0
if not defined dfHttpsProtocol set dfHttpsProtocol=0
set dfPreviousDownloadAttemptsCounter=0

REM ==> First of all, check that the source file isn't empty:
if not defined dfUrl goto :DF_ERROR_INVALID_URL
echo %dfUrl%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[ \t]*$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :DF_CHECK_EXPECTED_FILESIZE

:DF_ERROR_INVALID_URL
if /i "%dfCaption%" == "" (
    set dfTemp=the requested source file
) else (
    set dfTemp=%dfCaption%
)
call :LOG_ENTRY error "DOWNLOAD_FILE Sub: The URL for %dfTemp% has not been specified. Thus, it can't be downloaded. Please check."
call :SHOW_MSG "The URL for %dfTemp% has not been specified.\nThus, it can't be downloaded. Please check and try again!\n"
goto :DF_ERROR_EXIT

:DF_CHECK_EXPECTED_FILESIZE
REM ==> Check expected filesize's KiBs. Zero means "try to perform an
REM ==> automatic filesize check":
if not defined dfExpectedFilesize set dfExpectedFilesize=0
if /i "%dfExpectedFilesize%" == "" set dfExpectedFilesize=0
if /i "%dfExpectedFilesize%" == " " set dfExpectedFilesize=0
if "%dfExpectedFilesize%" == "0" goto :DF_CHECK_HTTPS

REM ==> Check that the specified filesize is purely numeric. If
REM ==> not, set it to zero to flag for automatic filesize check:
echo %dfExpectedFilesize%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[0-9]+$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set dfExpectedFilesize=0

:DF_CHECK_HTTPS
REM ==> Check HTTPS protocol eventually/optionally requested:
echo %dfHttpsProtocol%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(auto|SSLv2|SSLv3|TLSv1)$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" (
     set dfHttpsProtocol= --no-check-certificate --secure-protocol=%dfHttpsProtocol%
) else (
     set dfHttpsProtocol= --no-check-certificate
)

REM ==> Check if update package header has to be added:
if "%dfAddUpdatePackageHttpHeader%" == "1" set dfHttpsProtocol= --header="Xtack-Update-Package: %dfCaption%"%dfHttpsProtocol%

REM ==> Extract the filename from the URL:
for /f "usebackq delims=" %%i in (`echo %dfUrl%^|%xGawk% -F^/ "{print $NF}"`) do set dfFilename=%%i

REM ==> If file caption is not defined, set it equal to the filename:
if /i "%dfCaption%" == "" set dfCaption=%dfFilename%
if /i "%dfCaption%" == " " set dfCaption=%dfFilename%

REM ==> Fix and complete the destination directory:
for /f "usebackq delims=" %%i in (`echo %dfDestination%\^|%xGawk% "{gsub(/\\\\/,\"/\");gsub(/\//,\"\\\\\");print $0}"`) do set dfDestination=%%i

REM ==> Check whether the destination directory actually exists:
dir /b "%dfDestination%">nul 2>nul
if "%errorlevel%" == "0" goto :DF_PERFORM_THE_DOWNLOAD
if not "%dfSilentMode%" == "1" call :SHOW_MSG "Destination directory for %dfCaption% doesn't exist, so it's being\ncreated right now (%dfDestination%) ..."
if not exist %dfDestination% md %dfDestination%>nul 2>nul
dir /b "%dfDestination%">nul 2>nul
if "%errorlevel%" == "0" goto :DF_PERFORM_THE_DOWNLOAD
call :SHOW_MSG "ERROR: Destination directory for %dfCaption% could not be created\nPlease check and try again!"
call :LOG_ENTRY error "DOWNLOAD_FILE Sub: %dfCaption% can't be locally saved as the destination directory specified in xtack.ini (%dfDestination%) does not exist and getdocs was not able to create it."
goto :DF_ERROR_EXIT

:DF_PERFORM_THE_DOWNLOAD
REM ==> Perform the actual file download:
del /F /Q .\tmp\wgetitem.txt .\tmp\%dfFilename%>nul 2>nul
if not "%dfSilentMode%" == "1" call :SHOW_MSG "\nDownloading %dfCaption%. Please wait ..."
if "%xDebugMode%" == "1" echo %xDbgM%DOWNLOAD_FILE/Executed Command: .\bin\wget.exe -o .\tmp\wgetitem.txt --progress=dot:mega -t 4%dfHttpsProtocol% --retry-connrefused -O .\tmp\%dfFilename% %dfUrl%]>> %xLogfile%
del /F /Q .\tmp\%dfFilename%>nul 2>nul
set /a dfPreviousDownloadAttemptsCounter+=1
.\bin\wget.exe -o .\tmp\wgetitem.txt --progress=dot:mega -t 4%dfHttpsProtocol% --retry-connrefused -O .\tmp\%dfFilename% %dfUrl%
set dfTemp=%errorlevel%
title xtack
if "%dfTemp%" == "0" goto :DF_FILE_SUCCESSFULLY_DOWNLOADED

REM ==> The file could not be downloaded. Delete leftovers, prompt the user
REM ==> and log error:
del /F /Q .\tmp\%dfFilename%>nul 2>nul

REM ==> Get the error reported by wget:
for /f "usebackq delims=" %%i in (`type .\tmp\wgetitem.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/ ERROR /{$1=$2=\"\";gsub(/(^[ \t]+|[ \t]+$)/,\"\");i++;print $0}END{if(i==0){print \".\"}}"`) do set dfWgetError=%%i
if "%dfWgetError%" == "." goto :DF_LOG_FILE_DOWNLOAD_ERROR
if "%xDebugMode%" == "1" echo %xDbgM%DOWNLOAD_FILE/%dfCaption% could not be downloaded from URL %dfUrl% due to reason: %dfWgetError%]>> %xLogfile%

:DF_LOG_FILE_DOWNLOAD_ERROR
call :LOG_ENTRY error "DOWNLOAD_FILE Sub: %dfCaption% could not be downloaded from %dfUrl% %dfWgetError% Please check."
if not "%dfSilentMode%" == "1" call :SHOW_MSG "ERROR: %dfCaption% could not be downloaded from:\n%dfUrl%\n\nDue to reason:\n%dfWgetError%\n\nPlease check and try again."
goto :DF_ERROR_EXIT

:DF_FILE_SUCCESSFULLY_DOWNLOADED
if "%dfSilentMode%" == "1" goto :DF_FILE_GET_EXPECTED_FILESIZE
echo.|%xLog%
for /f "usebackq delims=" %%i in (`type .\tmp\wgetitem.txt^|%xGawk% "BEGIN{IGNORECASE=1}/ saved /{gsub(/( saved|'|\))/,\"\");gsub(\"- `\",\"as \");gsub(\"]\",\" bytes^)\");gsub(/\(/,\"at \");gsub(/\[/,\"(\");gsub(/\//,\"\\\\\");gsub(\"KB\\\\s\",\"KiB/s\");print $0}"`) do set dfTemp=%%i
if not "%dfSilentMode%" == "1" echo %dfCaption% successfully downloaded on %dfTemp%|%xGawk% "/\\[0-9]* bytes/{gsub(/\\[0-9]* bytes/,\" bytes\");gsub(/ at /,\"\nat ~\");print $0}"|%xLog%

:DF_FILE_GET_EXPECTED_FILESIZE
REM ==> If needed, read the downloaded file's actual filesize from
REM ==>.\tmp\wgetitem.txt and convert it to KiBs:
if "%dfExpectedFilesize%" == "0" for /f "usebackq delims=" %%i in (`type .\tmp\wgetitem.txt^|%xGawk% "BEGIN{IGNORECASE=1}/Length: /{print int($2/1024)}"`) do set dfExpectedFilesize=%%i

REM ==> Check the actual downloaded filesize against the expected one:
if not "%dfSilentMode%" == "1" call :SHOW_MSG "Checking downloaded file against expected filesize (%dfExpectedFilesize% KiB):"
for /f "usebackq delims=" %%i in (`dir .\tmp\%dfFilename% /-C^|%xGawk% "BEGIN{IGNORECASE=1}/%dfFilename%/{print $3}"^|%xGawk% "{gsub(\" \",\"\")};1"`) do set dfTemp=%%i
for /f "usebackq delims=" %%i in (`echo %dfTemp%^|%xGawk% "END{print int(%dfTemp%/1024)}"`) do set dfTemp=%%i
if %dfTemp% GEQ %dfExpectedFilesize% goto :DF_CHECK_IF_MOVE_DOWNLOADED_FILE_TO_FINAL_DESTINATION
if not "%dfSilentMode%" == "1" call :SHOW_MSG "\nERROR: Sorry, but apparently xtack was not able to download the\n%dfCaption% file completely ..."
if "%xDebugMode%" == "1" echo %xDbgM%DOWNLOAD_FILE/Download Check: Downloaded file %dfDestination%%dfFilename% had a filesize of %dfTemp% KiBs, below specified value (%dfExpectedFilesize%)]>> %xLogfile%

REM ==> If in silent mode, jump to evaluate whether a new download attempt
REM ==> is to be made:
if "%dfSilentMode%" == "1" goto :DF_TRY_TO_DOWNLOAD_FILE_ONCE_MORE

REM ==> Ask the user whether he/she wants to try downloading the file again:
call :ASK_USER_YES_NO_QUESTION "Do you want to try downloading %dfCaption% again" 1
if /i "%xTemp%" == "Y" goto :DF_PERFORM_THE_DOWNLOAD

REM ==> The user refused to try downloading the file again:
goto :DF_NOK_EXIT

:DF_TRY_TO_DOWNLOAD_FILE_ONCE_MORE
REM ==> If in silent mode, automatically try to download the file again just
REM ==> once more without user involvement:
if %dfPreviousDownloadAttemptsCounter% LEQ 1 goto :DF_PERFORM_THE_DOWNLOAD

REM ==> Otherwise (still in silent mode), give up and exit:
goto :DF_NOK_EXIT

:DF_CHECK_IF_MOVE_DOWNLOADED_FILE_TO_FINAL_DESTINATION
REM ==> If destination different to .\tmp\, secure deletion of any previous
REM ==> file incarnations:
if /i "%dfDestination%" == ".\tmp\" goto :DF_SKIP_MOVING_DOWNLOADED_FILE_TO_FINAL_DESTINATION
if /i "%dfDestination%" == "%~dp0tmp\" goto :DF_SKIP_MOVING_DOWNLOADED_FILE_TO_FINAL_DESTINATION
del /F /Q "%dfDestination%%dfFilename%">nul 2>nul
move /Y .\tmp\%dfFilename% "%dfDestination%">nul 2>nul

if not "%errorlevel%" == "0" goto :DF_FILE_COULDNT_BE_MOVED_TO_FINAL_DESTINATION

:DF_SKIP_MOVING_DOWNLOADED_FILE_TO_FINAL_DESTINATION
if not "%dfExpectedFilesize%" == "0" goto :DF_FILE_MOVED_OK_WITH_KIB_CHECK
if "%dfSilentMode%" == "1" goto :DF_OK_EXIT
echo The downloaded file has successfully passed the %dfExpectedFilesize% KiB check.|%xLog%
echo It is now archived as %dfDestination%%dfFilename%|%xLog%
goto :DF_OK_EXIT

:DF_FILE_MOVED_OK_WITH_KIB_CHECK
if "%dfSilentMode%" == "1" goto :DF_OK_EXIT
echo The downloaded file is now archived as:|%xLog%
echo %dfDestination%%dfFilename%|%xLog%
goto :DF_OK_EXIT

:DF_FILE_COULDNT_BE_MOVED_TO_FINAL_DESTINATION
if "%dfSilentMode%" == "1" goto :DF_ERROR_EXIT
echo WARNING: Sorry, but although the downloaded file passed the %dfExpectedFilesize% KiB|%xLog%
echo check, it could not be moved to folder %dfDestination%|%xLog%
echo However, the file is available in folder %~dp0tmp\"|%xLog%
goto :DF_ERROR_EXIT

:DF_OK_EXIT
set dfTemp=0
goto :DF_END

:DF_NOK_EXIT
set dfTemp=1
goto :DF_END

:DF_ERROR_EXIT
set dfTemp=2

:DF_END
del /F /Q .\tmp\wgetitem.txt>nul 2>nul
endlocal & set "xTemp=%dfTemp%" & set dfTemp=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DOWNLOAD_PHPMD: Downloads and saves PHPMD.
REM ==> Returns: File download result (in xTemp variable):
REM ==>          0 = Downloaded OK and filesize check passed OK.
REM ==>          1 = Downloaded OK but filesize check NOT passed.
REM ==>          2 = Download unsuccessful (not OK).
REM -------------------------------------------------------------------------

:DOWNLOAD_PHPMD
call :DOWNLOAD_FILE "PHPMD" "https://static.phpmd.org/php/latest/phpmd.phar" ".\bin\phpmd\" 0 1 0
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DOWNLOAD_PHPUNIT: Downloads and saves PHPUnit.
REM ==> Returns: File download result (in xTemp variable):
REM ==>          0 = Downloaded OK and filesize check passed OK.
REM ==>          1 = Downloaded OK but filesize check NOT passed.
REM ==>          2 = Download unsuccessful (not OK).
REM -------------------------------------------------------------------------

:DOWNLOAD_PHPUNIT
call :DOWNLOAD_FILE "PHPUnit" "https://phar.phpunit.de/phpunit.phar" ".\bin\phpunit\" 0 1 0
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DOWNLOAD_UCF: Downloads and saves xtack's Update Control File.
REM ==> Returns: File download result (in xTemp variable):
REM ==>          0 = Downloaded OK and filesize check passed OK.
REM ==>          1 = Downloaded OK but filesize check NOT passed.
REM ==>          2 = Download unsuccessful (not OK).
REM -------------------------------------------------------------------------

:DOWNLOAD_UCF
call :DOWNLOAD_FILE "xtack Update Control File" "%xDownloadBaseUrl%%xUCF%" ".\swu" 0 1 0 "TLSv1"
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON: Dumps a component's
REM ==> component, name, version and date information fields from the
REM ==> component's xtack.json file to the .\swu\installed.txt file.
REM ==> Argument #1: Full xtack.json file path surrounded by double quotes.
REM -------------------------------------------------------------------------

:DUMP_COMPONENT_INFO_FROM_PACKAGE_JSON
setlocal enableextensions
set cipjFile=%1
type %cipjFile%|%xGawk% "/^^[ \t]*\042(component|name|version|date)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");print $0}">>.\swu\installed.txt
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: FILTER_AND_CACHE_XTACK_INI: Filters and caches .\cfg\xtack.ini.
REM -------------------------------------------------------------------------

:FILTER_AND_CACHE_XTACK_INI
type .\cfg\xtack.ini|%xGawk% "!/([ \t]*#|^$)/"|%xGawk% "BEGIN{IGNORECASE=1}/^[ \t]*(DebugMode|DefaultOpMode|VerboseDbServer|KillExistingServers|KillExistingBrowsers|IisHttpPort|StartBrowsers|BrowserURL|(Firefox|Msie|Edge|Opera|Safari|Chrome)Path)[ \t]*=[ \t]*/{gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(\"[ \t]*=[ \t]*\",\"=\");gsub(/=(Yes|True|On|Enabled)$/,\"=1\");gsub(/=(No|False|Off|Disabled)$/,\"=0\");print $0}">.\tmp\cfgcache.txt
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_APACHE13_VERSION_INFO: Gets, shows and logs Apache 1.3
REM ==> version info.
REM ==> Argument #1: Short printout flag: 0 = short; 1 = long; other = longer
REM -------------------------------------------------------------------------

:GET_APACHE13_VERSION_INFO
setlocal enableextensions
set ga13Printoutlength=%~1
set ga13Ver=unavailable
if not defined ga13Printoutlength set ga13Printoutlength=1
if not exist .\bin\a13\Apache.exe set ga13Ver=Apache 1.3 is unavailable.
if /i not "%ga13Ver%" == "Apache 1.3 is unavailable." goto :GA13_CHECK_PO_LENGTH
if "%ga13Printoutlength%" == "0" goto :GA13_SHORT_ERROR
echo %ga13Ver%|%xLog%
goto :GA13_PRE_END

:GA13_SHORT_ERROR
echo %ga13Ver%|%xGawk% "/unavailable/{gsub(/\./,\"\");printf(\"%%-16s %%-12s\n\",$1\" \"$2,$4)}"|%xLog%
goto :GA13_END

:GA13_CHECK_PO_LENGTH
if "%ga13Printoutlength%" == "0" goto :GA13_SHORT_PO
if "%ga13Printoutlength%" == "1" goto :GA13_LONG_PO
.\bin\a13\Apache.exe -V|%xLog%
.\bin\a13\Apache.exe -l|%xLog%
echo.|%xLog%
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\apache13.conf" "%~dp0cfg\apache13_port.conf"
echo Checking syntax of Apache 1.3 configuration file %~dp0cfg\apache13_port.conf:|%xLog%
.\bin\a13\Apache.exe -t -f "%~dp0cfg\apache13_port.conf"|%xLog%
.\bin\a13\Apache.exe -t -f "%~dp0cfg\apache13_port.conf">nul 2>> %xLogfile%
goto :GA13_PRE_END

:GA13_SHORT_PO
.\bin\a13\Apache.exe -v|%xGawk% "/Apache\//{gsub(/\//,\" \");printf(\"%%-16s %%-12s %%-25s\n\",$3\" 1.3\",$4,$5)}"|%xLog%
goto :GA13_END

:GA13_LONG_PO
.\bin\a13\Apache.exe -v|%xLog%

:GA13_PRE_END
echo.|%xLog%

:GA13_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_APACHE24_VERSION_INFO: Gets, shows and logs Apache 2.4
REM ==> version info.
REM ==> Argument #1: Short printout flag: 0 = short; 1 = long; other = longer
REM -------------------------------------------------------------------------

:GET_APACHE24_VERSION_INFO
setlocal enableextensions
set ga24Printoutlength=%~1
set ga24Ver=unavailable
if not defined ga24Printoutlength set ga24Printoutlength=1
if not exist .\bin\a24\bin\httpd.exe set ga24Ver=Apache 2.4 is unavailable.
if /i not "%ga24Ver%" == "Apache 2.4 is unavailable." goto :GA24_CHECK_PO_LENGTH
if "%ga24Printoutlength%" == "0" goto :GA24_SHORT_ERROR
echo %ga24Ver%|%xLog%
goto :GA24_PRE_END

:GA24_SHORT_ERROR
echo %ga24Ver%|%xGawk% "/unavailable/{gsub(/\./,\"\");printf(\"%%-16s %%-12s\n\",$1\" \"$2,$4)}"|%xLog%
goto :GA24_END

:GA24_CHECK_PO_LENGTH
if not exist .\bin\a24\bin\httpd.exe set ga24OpenSSL=OpenSSL is unavailable.
if /i not "%ga24OpenSSL%" == "OpenSSL is unavailable." for /f "usebackq delims=" %%i in (`.\bin\a24\bin\openssl.exe version 2^>^&1^|%xGawk% "BEGIN{IGNORECASE=1}!/WARNING: /{print $0}"`) do set ga24OpenSSL=%%i
if "%ga24Printoutlength%" == "0" goto :GA24_SHORT_PO
if "%ga24Printoutlength%" == "1" goto :GA24_LONG_PO
.\bin\a24\bin\httpd.exe -V|%xLog%
.\bin\a24\bin\httpd.exe -l|%xLog%
echo.|%xLog%
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\apache24.conf" "%~dp0cfg\apache24_port.conf"
.\bin\a24\bin\httpd.exe -X -M -f "%~dp0cfg\apache24_port.conf">nul 2>> %xLogfile%
.\bin\a24\bin\httpd.exe -X -M -f "%~dp0cfg\apache24_port.conf"|%xLog%
echo.|%xLog%
echo Checking syntax of Apache 2.4 configuration file %~dp0cfg\apache24_port.conf:|%xLog%
.\bin\a24\bin\httpd.exe -t -f "%~dp0cfg\apache24_port.conf"|%xLog%
.\bin\a24\bin\httpd.exe -t -f "%~dp0cfg\apache24_port.conf">nul 2>> %xLogfile%
echo.|%xLog%
echo %ga24OpenSSL%|%xLog%
goto :GA24_PRE_END

:GA24_SHORT_PO
for /f "usebackq delims=" %%i in (`echo %ga24OpenSSL%^|%xGawk% "BEGIN{IGNORECASE=1}/OpenSSL /{gsub(\" is\",\"\");print $2}"`) do set ga24OpenSSL=%%i
.\bin\a24\bin\httpd.exe -v|%xGawk% "/Apache\//{gsub(/\//,\" \");gsub(\")\",\"\");if($4 ~ /^2\.4\.(25|23|20|18)$/){vc=14}else{vc=15};printf(\"%%-16s %%-12s %%-25s\",$3\" 2.4\",$4,$5\" VC\"vc\", OpenSSL %ga24OpenSSL%)\n\")}"|%xLog%
goto :GA24_END

:GA24_LONG_PO
.\bin\a24\bin\httpd.exe -v|%xLog%
echo %ga24OpenSSL%|%xLog%

:GA24_PRE_END
echo.|%xLog%

:GA24_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_BINARY_VERSION_WMIC: Returns the binary file version as
REM ==> delivered by the "wmic datafile" command.
REM ==> Note: wmic requires a full path to the binary file.
REM ==> Argument #1: Full binary path surrounded by double quotes.
REM ==> Returns: Binary file version (in xTemp variable).
REM -------------------------------------------------------------------------

:GET_BINARY_VERSION_WMIC
setlocal enableextensions
set gbvwBinary=%1

if not exist %gbvwBinary% (
    set gbvwVer=unavailable
    goto :GBVW_END
)
for /f "usebackq delims=" %%i in (`wmic datafile where name^=%gbvwBinary:\=\\% get version^|%xGawk% "/\./{print $1}"`) do set gbvwVer=%%i

:GBVW_END
endlocal & set "xTemp=%gbvwVer%" & set gbvwVer=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_COMPOSER_VERSION_INFO: Gets/shows/logs Composer version info.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_COMPOSER_VERSION_INFO
setlocal enableextensions
set gcviShortPrintout=%~1
set gcviVer=unavailable
if not defined gcviShortPrintout set gcviShortPrintout=0
if not exist .\bin\p%xBatPhp%\php.exe set gcviVer=Composer is unavailable.
if not exist .\bin\composer\composer.phar set gcviVer=Composer is unavailable.
if /i "%gcviVer%" == "Composer is unavailable." goto :GCVI_CHECK_SHORTENING
for /f "usebackq delims=" %%i in (`.\bin\p%xBatPhp%\php.exe -n .\bin\composer\composer.phar -V --no-ansi`) do set gcviVer=%%i

:GCVI_CHECK_SHORTENING
if "%gcviShortPrintout%" == "1" goto :GCVI_SHORTEN
echo %gcviVer%|%xLog%
echo.|%xLog%
goto :GCVI_END

:GCVI_SHORTEN
echo %gcviVer%|%xGawk% "BEGIN{IGNORECASE=1}/(version|unavailable)/{gsub(/-alpha/,\"a\");gsub(/-beta/,\"b\");gsub(/-dev/,\"dev\");gsub(/(\(|\))/,\"\");gsub(\"unavailable.\",\"unavailable\");if($4!=\"\"&&$5!=\"\"){v=\"(\"$4\" \"$5\")\"}else{v=\"\"};printf(\"%%-16s %%-12s %%-25s\n\",\"Composer\",$3,v)}"|%xLog%

:GCVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_CURRENT_OPMODE: Gets current Operating Mode from xtack.lck
REM ==> Returns: Current Operating Mode and Operating Mode origin.
REM -------------------------------------------------------------------------

:GET_CURRENT_OPMODE
setlocal enableextensions
REM ==> First try to get the original "from" OpMode from eventual previous
REM ==> switchovers registered in the xtack control file:
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack later switched over to OpMode/{i++;print $7}END{if(i==0){print \"Unknown\"}}"`) do set gcoCurrentOpMode=%%i
if /i not "%gcoCurrentOpMode%" == "Unknown" (
    set gcoCurrentOpModeOrigin=CLI
    goto :GCO_END
)

REM ==> If no previous switchovers detected, then get the "from" OpMode for
REM ==> the initial xtack startup:
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack started in OpMode/{i++;print $5}END{if(i==0){print \"Unknown\"}}"`) do set gcoCurrentOpMode=%%i
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack started in OpMode/{i++;gsub(/(\(|\))/,\"\");print $6}END{if(i==0){print \"Unknown\"}}"`) do set gcoCurrentOpModeOrigin=%%i

:GCO_END
REM ==> Return back:
endlocal & set "xOpMode=%gcoCurrentOpMode%" & set gcoCurrentOpMode= & set "xOpModeOrigin=%gcoCurrentOpModeOrigin%" & set gcoCurrentOpModeOrigin=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_DEBUG_MODE_FLAG_FROM_XTACKINI: Reads the xtack debug flag
REM ==> from xtack.ini and returns it in variable xDebugMode.
REM ==> Returns: xtack debug flag value in file xtack.ini.
REM ==>          (in variable xDebugMode)
REM -------------------------------------------------------------------------

:GET_DEBUG_MODE_FLAG_FROM_XTACKINI
REM ==> Parse xtack.ini for the DebugMode setting. Make sure xDebugMode is
REM ==> set to "Off" by default:
set xDebugMode=0
if exist .\cfg\xtack.ini for /f "usebackq delims=" %%i in (`type .\cfg\xtack.ini^|%xGawk% "!/([ \t]*#|^$)/"^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*DebugMode[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*DebugMode[ \t]*=[ \t]*|[ \t]*$)/,\"\");gsub(/^^(1|Yes|True|On|Enabled)$/,\"1\");gsub(/^^(0|No|False|Off|Disabled)$/,\"0\");if($0 ~ /^(1|0)$/){print $0}else{print \"0\"}}}END{if(i==0){print \"0\"}}"`) do set xDebugMode=%%i
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_DISKDRIVE_FREE_MIB: Gets the free space for the disk drive
REM ==> requested and returns it in MiB
REM ==> Argument #1: Drive letter.
REM ==> Returns: Free disk drive MiB (in xTemp):
REM -------------------------------------------------------------------------

:GET_DISKDRIVE_FREE_MIB
setlocal enableextensions
set gdfmTemp=%~1
if not defined gdfmTemp set gdfmTemp=A

REM ==> Validate input drive letter:
echo %gdfmTemp%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^([C-Z]{1})$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :GDFM_GET_BYTES

REM ==> If input drive letter invalid, get current drive:
for /f "usebackq delims=" %%i in (`echo %CD%^|%xGawk% -F: "{print toupper($1)}"`) do set gdfmTemp=%%i

:GDFM_GET_BYTES
REM ==> Get the drive's free bytes:
wmic VOLUME where DriveLetter="%gdfmTemp%:" GET FreeSpace|%xGawk% "!/FreeSpace/{m=int($0/1048576);print m}">.\tmp\gdfmtmp1.txt 2>nul
for /f "usebackq delims=" %%i in (`type .\tmp\gdfmtmp1.txt^|%xGawk% "NR==1"`) do set gdfmTemp=%%i

REM ==> Clean up and return back:
del /F /Q .\tmp\gdfmtmp1.txt>nul 2>nul
endlocal & set "xTemp=%gdfmTemp%" & set gdfmTemp=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_FAKESENDMAIL_VERSION_INFO: Gets, shows and logs Fake
REM ==> Sendmail version info.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_FAKESENDMAIL_VERSION_INFO
setlocal enableextensions
set gfviShortPrintout=%~1
set gfviVer=unavailable
if not defined gfviShortPrintout set gfviShortPrintout=0
if not exist .\bin\sendmail\sendmail.exe (
    set gfviVer=Fake Sendmail is unavailable.
    goto :GFVI_CHECK_SHORTENING
)
for /f "usebackq delims=" %%i in (`.\bin\sendmail\sendmail.exe -h^|%xGawk% "BEGIN{IGNORECASE=1}/version/{gsub(\"fake\",\"Fake\");gsub(\"sendmail\",\"Sendmail\");printf(\"%%s\n\n\",$0)}"`) do set gfviVer=%%i

:GFVI_CHECK_SHORTENING
if "%gfviShortPrintout%" == "1" goto :GFVI_SHORTEN
echo %gfviVer%|%xLog%
echo.|%xLog%
goto :GFVI_END

:GFVI_SHORTEN
echo %gfviVer%|%xGawk% "BEGIN{IGNORECASE=1}{gsub(/version /,\"v\");gsub(\"fake\",\"Fake\");gsub(\"sendmail\",\"Sendmail\");gsub(\" is\",\"\");gsub(/\./,\"\");printf(\"%%-16s %%-12s\n\",$1\" \"$2,$3)}"|%xLog%

:GFVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_FILESYSTEM_FOR_FILE: Returns file system type for given file.
REM ==> Argument #1: Full binary path surrounded by double quotes.
REM ==> Returns: Binary file version (in xTemp variable).
REM -------------------------------------------------------------------------

:GET_FILESYSTEM_FOR_FILE
set gfsffBinary=%1
for /f "usebackq delims=" %%i in (`wmic datafile where name^=%gfsffBinary:\=\\% get fsname^|%xGawk% "/\./{print $1}"`) do set xTemp=%%i
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_FILE_SHA512: Returns the SHA512 checksum of the given file.
REM ==> Argument #1: Full binary file path surrounded by double quotes.
REM ==> Returnes: The file's SHA512 checksum (in xTemp variable).
REM -------------------------------------------------------------------------

:GET_FILE_SHA512
set vpsSourceFile=%1
set xTemp=SHA512 checksum unavailable
if not exist %vpsSourceFile% goto :VPS_END
for /f "usebackq delims=" %%i in (`.\bin\gpg.exe --homedir .\cfg --print-md sha512 %vpsSourceFile% 2^>^&1^|%xGawk% "BEGIN{IGNORECASE=1;c=\"\"}{if($0 !~ /(iconv|keyring|trustdb)/){for(i=1;i<=NF;i++){if($i ~ /^^[a-f0-9]{8}$/){c=c$i}}}}END{printf(\"%%s\",tolower(c))}"`) do set xTemp=%%i
if "%xDebugMode%" == "1" echo %xDbgM%GET_FILE_SHA512: Measured SHA512 Checksum for file %vpsSourceFile%: %xTemp%]>> %xLogfile%

:VPS_END
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_ISS_VERSION_INFO: Gets, shows and logs IIS Express
REM ==> version information.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_IIS_VERSION_INFO
setlocal enableextensions
set miviShortPrintout=%~1
set miviVer=unavailable
if not defined miviShortPrintout set miviShortPrintout=0
if not exist .\bin\iis\iisexpress.exe (
    set miviVer=IIS Express is unavailable.
    goto :MIVI_CHECK_SHORTENING
)
call :GET_BINARY_VERSION_WMIC "%~dp0bin\iis\iisexpress.exe"
if defined xTemp set miviVer=%xTemp%

:MIVI_CHECK_SHORTENING
if "%miviShortPrintout%" == "1" goto :MIVI_SHORTEN
echo IIS Express %miviVer%|%xLog%
echo.|%xLog%
goto :MIVI_END

:MIVI_SHORTEN
echo %miviVer%|%xGawk% -F. "BEGIN{IGNORECASE=1}{if($0 ~ /unavailable/){v=\"unavailable\"}else{v=$1\".\"$2\".\"$3};printf(\"%%-16s %%-12s\n\",\"IIS Express\",v)}"|%xLog%

:MIVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_MYSQL_MARIADB_VERSION_INFO: Gets, shows and logs MySQL and
REM ==>      MariaDB version information.
REM ==> Argument #1: MySQL binary selector.
REM ==> Argument #2: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_MYSQL_MARIADB_VERSION_INFO
setlocal enableextensions
set gmviSel=%~1
set gmviShortPrintout=%~2
set gmviVer=unavailable
echo %gmviSel%|%xGawk% "BEGIN{IGNORECASE=1}/(m55|m57|mra)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set gmviVer=MySQL is unavailable.
if not exist .\bin\%gmviSel%\bin\mysqld.exe set gmviVer=MySQL is unavailable.
if not defined gmviShortPrintout set gmviShortPrintout=0
if /i "%gmviVer%" == "MySQL is unavailable." goto :GMVI_CHECK_SHORTENING
set gmviBin=.\bin\%gmviSel%\bin\mysqld.exe
set gmviBin=%gmviBin:\=\\%
for /f "usebackq delims=" %%i in (`.\bin\%gmviSel%\bin\mysqld.exe --version^|%xGawk% "{gsub(/%gmviBin%  Ver/,\"MySQL\");print $0}"`) do set gmviVer=%%i

:GMVI_CHECK_SHORTENING
if "%gmviShortPrintout%" == "1" goto :GMVI_SHORTEN
echo %gmviVer%|%xLog%
echo.|%xLog%
goto :GMVI_END

:GMVI_SHORTEN
echo %gmviVer%|%xGawk% "BEGIN{IGNORECASE=1;s=\"%gmviSel%\"}/(MySQL|MariaDB)/{gsub(\"unavailable.\",\"unavailable\");gsub(/(-community|-MariaDB| is)/,\"\");gsub(\"Win32\",\"(Win32)\");if(s==\"mra\"){s=\"MariaDB\"}else if(s==\"m55\"){s=\"MySQL 5.5\"}else{s=\"MySQL 5.7\"};printf(\"%%-16s %%-12s %%-25s\n\",s,$2,$4)}"|%xLog%

:GMVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_NGINX_VERSION_INFO: Gets, shows and logs Nginx version info.
REM ==> Argument #1: Short printout flag: 0 = short; 1 = long; Other = longer
REM -------------------------------------------------------------------------

:GET_NGINX_VERSION_INFO
setlocal enableextensions
set gngxPrintoutlength=%~1
set gngxVer=unavailable
if not defined gngxPrintoutlength set gngxPrintoutlength=1
if not exist .\bin\ngx\nginx.exe set gngxVer=Nginx is unavailable.
if /i not "%gngxVer%" == "Nginx is unavailable." goto :GNGX_CHECK_PO_LENGTH
if "%gngxPrintoutlength%" == "0" goto :GNGX_SHORT_ERROR
echo %gngxVer%|%xLog%
goto :GNGX_PRE_END

:GNGX_SHORT_ERROR
echo %gngxVer%|%xGawk% "/unavailable/{gsub(/\./,\"\");printf(\"%%-16s %%-12s\n\",$1,$3)}"|%xLog%
goto :GNGX_END

:GNGX_CHECK_PO_LENGTH
if "%gngxPrintoutlength%" == "0" goto :GNGX_SHORT_PO
if "%gngxPrintoutlength%" == "1" goto :GNGX_LONG_PO
.\bin\ngx\nginx.exe -V
.\bin\ngx\nginx.exe -V>nul 2>> %xLogfile%
echo.|%xLog%
call :CREATE_NGINX_DIRS_AND_FILES
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\nginx.conf" "%~dp0cfg\nginx_port.conf"
echo Checking syntax of Nginx configuration file %~dp0cfg\nginx_port.conf:|%xLog%
.\bin\ngx\nginx.exe -t -c "%~dp0cfg\nginx_port.conf"
.\bin\ngx\nginx.exe -t -c "%~dp0cfg\nginx_port.conf">nul 2>> %xLogfile%
call :DELETE_NGINX_DIRS_AND_FILES
goto :GNGX_PRE_END

:GNGX_SHORT_PO
.\bin\ngx\nginx.exe -V 2>&1|%xGawk% "BEGIN{RS=\"\"}/(nginx\/|built by|OpenSSL)/{gsub(/\//,\" \");gsub(\"built\",\"\");gsub(/(80x86|x86)/,\"Win32\");gsub(/x64/,\"Win64\");printf(\"%%-16s %%-12s %%-25s\n\",\"Nginx \",$4,\"(\"$9\", OpenSSL \"$12\")\")}"|%xLog%
goto :GNGX_END

:GNGX_LONG_PO
.\bin\ngx\nginx.exe -v
.\bin\ngx\nginx.exe -v>nul 2>> %xLogfile%

:GNGX_PRE_END
echo.|%xLog%

:GNGX_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_NODEJS_VERSION_INFO: Gets, shows and logs Node JS version
REM ==> information.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_NODEJS_VERSION_INFO
setlocal enableextensions
set gnjiShortPrintout=%~1
set gnjiVer=unavailable
if not defined gnjiShortPrintout set gnjiShortPrintout=0
if not exist .\bin\njs\node.exe (
    set gnjiVer=Node.js is unavailable.
    goto :GNJI_CHECK_SHORTENING
)
for /f "usebackq delims=" %%i in (`.\bin\njs\node.exe -p -e "'Node.js ' + process.versions.node + ' (' + process.platform.charAt(0).toUpperCase() + process.platform.slice(1) + ', V8 ' + process.versions.v8 + ', OpenSSL ' + process.versions.openssl + ')'"`) do set gnjiVer=%%i

:GNJI_CHECK_SHORTENING
if "%gnjiShortPrintout%" == "1" goto :GNJI_SHORTEN
echo %gnjiVer%|%xLog%
echo.|%xLog%
goto :GNJI_END

:GNJI_SHORTEN
echo %gnjiVer%|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\" is\",\"\");gsub(\"unavailable.\",\"unavailable\");printf(\"%%-16s %%-12s %%-25s\n\",$1,$2,$3\" \"$4\" \"$5\" \"$6\" \"$7)}"|%xLog%

:GNJI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_OTHER_COMPONENTS_INFO: Gets, shows and logs info about
REM ==> xtack components.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_OTHER_COMPONENTS_INFO
setlocal enableextensions
set gociShortPrintout=%~1
if not defined gociShortPrintout set gociShortPrintout=0
if "%gociShortPrintout%" == "1" (
    set gociExpression=%%-16s %%-12s
) else (
    set gociExpression=%%s %%s\n
)

:GOCI_CHECK_DLLPACK
if not exist .\bin\dlls\xtack.json goto :GOCI_DLLPACK_NOK
type .\bin\dlls\xtack.json|%xGawk% "/^^[ \t]*\042(name|version)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");printf(\"%gociExpression%\n\",$1,$2)}"|%xLog%
goto :GOCI_CHECK_ICONS

:GOCI_DLLPACK_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"DLLPack\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_ICONS
if not exist .\bin\icons\xtack.json goto :GOCI_ICONS_NOK
type .\bin\icons\xtack.json|%xGawk% "/^^[ \t]*\042(name|version)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");printf(\"%gociExpression%\n\",$1,$2)}"|%xLog%
goto :GOCI_CHECK_MODSECURITY

:GOCI_ICONS_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"Icons\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_MODSECURITY
if not exist .\bin\a24\modules\ReadMe_ApacheLounge_mod_security.txt goto :GOCI_MODSECURITY_NOK
type .\bin\a24\modules\ReadMe_ApacheLounge_mod_security.txt|%xGawk% "BEGIN{IGNORECASE=1}/^ *mod_security-/{gsub(/^ *mod_security-/,\"\");printf(\"%gociExpression%\n\",\"ModSecurity\",$1)}"|%xLog%
goto :GOCI_CHECK_MYSQLDBS

:GOCI_MODSECURITY_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"ModSecurity\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_MYSQLDBS
if not exist .\dbs\xtack_mysqldbs.json goto :GOCI_MYSQLDBS_NOK
type .\dbs\xtack_mysqldbs.json|%xGawk% "/^^[ \t]*\042(name|version)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");printf(\"%gociExpression%\n\",$1,$2)}"|%xLog%
goto :GOCI_CHECK_PGSDB

:GOCI_MYSQLDBS_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"MySQL DBs\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_PGSDB
if not exist .\dbs\xtack_pgsdb.json goto :GOCI_PGSDB_NOK
type .\dbs\xtack_pgsdb.json|%xGawk% "/^^[ \t]*\042(name|version)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");printf(\"%gociExpression%\n\",$1,$2)}"|%xLog%
goto :GOCI_CHECK_MRADB

:GOCI_PGSDB_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"PostgreSQL DB\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_MRADB
if not exist .\dbs\xtack_mradb.json goto :GOCI_MRADB_NOK
type .\dbs\xtack_mradb.json|%xGawk% "/^^[ \t]*\042(name|version)\042: /{gsub(\"\042\",\"\");gsub(\",\",\"\");printf $2\" \"}"|%xGawk% "END{gsub(/[ \t]*$/,\"\");printf(\"%gociExpression%\n\",$1,$2)}"|%xLog%
goto :GOCI_CHECK_VCREDIS

:GOCI_MRADB_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"PostgreSQL DB\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_VCREDIS
if not exist .\bin\7za.exe goto :GOCI_VCREDIS_NOK
if not exist .\bin\vcredis\vcredis.7z goto :GOCI_VCREDIS_NOK
.\bin\7za.exe l .\bin\vcredis\vcredis.7z|%xGawk% "BEGIN{IGNORECASE=1}/changelog.r/{gsub(/changelog.r/,\"r\");gsub(/vcredis\\/,\"\");printf(\"%gociExpression%\n\",\"MSVC Redispkgs\",$6)}"|%xLog%
goto :GOCI_CHECK_PHPUNIT

:GOCI_VCREDIS_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"MSVC Redispkgs\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_PHPUNIT
if not exist .\bin\phpunit\phpunit.phar goto :GOCI_PHPUNIT_NOK
.\bin\p%xBatPhp%\php.exe -n .\bin\phpunit\phpunit.phar --version|%xGawk% "BEGIN{IGNORECASE=1}/PHPUnit/{printf(\"%gociExpression%\n\",\"PHPUnit\",$2)}"|%xLog%
goto :GOCI_CHECK_PHPMD

:GOCI_PHPUNIT_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"PHPUnit\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_PHPMD
if not exist .\bin\phpmd\phpmd.phar goto :GOCI_PHPMD_NOK
.\bin\p%xBatPhp%\php.exe -n .\bin\phpmd\phpmd.phar --version|%xGawk% "BEGIN{IGNORECASE=1}/PHPMD/{printf(\"%gociExpression%\n\",\"PHPMD\",$2)}"|%xLog%
goto :GOCI_CHECK_NPM

:GOCI_PHPMD_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"PHPMD\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_NPM
if not exist .\bin\njs\node.exe goto :GOCI_NPM_NOK
if not exist .\bin\njs\node_modules\npm\bin\npm-cli.js goto :GOCI_NPM_NOK
.\bin\njs\node.exe "%~dp0bin\njs\node_modules\npm\bin\npm-cli.js" -v|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"npm\",$1)}"|%xLog%
goto :GOCI_CHECK_BOWER

:GOCI_NPM_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"npm\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_BOWER
if not exist .\bin\njs\node.exe goto :GOCI_BOWER_NOK
if not exist .\bin\njs\node_modules\bower\lib\bin\bower.js goto :GOCI_BOWER_NOK
.\bin\njs\node.exe "%~dp0bin\njs\node_modules\bower\lib\bin\bower.js" -v|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"Bower\",$1)}"|%xLog%
title xtack
goto :GOCI_CHECK_XDOCS

:GOCI_BOWER_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"Bower\",\"unavailable\")}"|%xLog%

:GOCI_CHECK_XDOCS
if not exist .\docs\index.html goto :GOCI_XDOCS_NOK
type .\docs\index.html|%xGawk% "BEGIN{IGNORECASE=1}/!--  Revision: r[0-9]{1,4}/{printf(\"%gociExpression%\n\",\"xtackDocs\",$3)}"|%xLog%
goto :GOCI_END

:GOCI_XDOCS_NOK
echo 0|%xGawk% "!/([ \t]*#|^$)/{printf(\"%gociExpression%\n\",\"xtackDocs\",\"unavailable\")}"|%xLog%

:GOCI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHALCON_VERSION_INFO_SHORT: Gets, shows and logs Phalcon
REM ==> version info (short format).
REM ==> Argument #1: Phalcon binary selector.
REM -------------------------------------------------------------------------

:GET_PHALCON_VERSION_INFO_SHORT
set gphsSel=%~1
set gphsVer=unavailable
if not defined gphsSel set gphsVer=Phalcon is unavailable.
echo %gphsSel%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(53|54|55|56|70)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set gphsVer=Phalcon is unavailable.
set gphsBin=%~dp0bin\phalcon\php_phalcon%gphsSel%.dll
if not exist "%gphsBin%" set gphsVer=Phalcon is unavailable.
if not exist .\bin\p%gphsSel%\php.exe set gphsVer=Phalcon is unavailable.
if /i "%gphsVer%" == "Phalcon is unavailable." goto :GPHS_UNAVAILABLE
.\bin\p%gphsSel%\php.exe -n -d date.timezone="Europe/Paris" -d extension="%~dp0bin\phalcon\php_phalcon%gphsSel%.dll" -i|%xGawk% "BEGIN{RS=\"\"}/Phalcon Team/{gsub(/-dev-(([0-9a-f])*)/,\"\",$33);if(%gphsSel% ~ /(53|54)/){d=\"^<= 5.4\"}else{d=\"^>= 5.5\"};gsub(/\n/,\" \");printf(\"%%-16s %%-12s %%-25s\n\",$14,$20,\"(for PHP \"d\", \"$30\" \"$33\")\")}"|%xLog%
goto :GPHS_END

:GPHS_UNAVAILABLE
echo Phalcon          unavailable|%xLog%
goto :GPHS_END

:GPHS_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHPBROWSCAP_VERSION_INFO: Gets, shows and logs
REM ==> php_browscap.ini version info.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_PHPBROWSCAP_VERSION_INFO
setlocal enableextensions
set gpbcShortPrintout=%~1
set gpbcVer=unavailable
if not defined gpbcShortPrintout set gpbcShortPrintout=0
if not exist .\bin\browscap\php_browscap.ini (
    set gpbcVer=php_browscap.ini is unavailable.
    goto :GPBC_CHECK_SHORTENING
)
for /f "usebackq delims=" %%i in (`type .\bin\browscap\php_browscap.ini^|%xGawk% "BEGIN{i=0}/(;;; Created on|Version=)/{if(i<2){gsub(/(,| at|(Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)day, )/,\"\");gsub(\"Version^=\",\"php_browscap.ini \");gsub(\"^;^;^; Created on \",\";^, \");gsub(\" \x2c \",\"\x2c \");print $0;i++}}"^|%xGawk% "{a[i++]=$0}END{for(j=i-1;j>=0;)print a[j--]}"^|%xGawk% -F^; "{printf $0}"`) do set gpbcVer=%%i

:GPBC_CHECK_SHORTENING
if "%gpbcShortPrintout%" == "1" goto :GPBC_SHORTEN
echo %gpbcVer%|%xLog%
echo.|%xLog%
goto :GPBC_END

:GPBC_SHORTEN
echo %gpbcVer%|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\" is\",\"\");gsub(\"unavailable.\",\"unavailable\");gsub(\",\",\"\");printf(\"%%-16s %%-12s\n\",$1,$2)}"|%xLog%

:GPBC_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHPMYADMIN_VERSION_INFO: Gets, shows and logs PMA version
REM ==> information.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_PHPMYADMIN_VERSION_INFO
setlocal enableextensions
set gpmaShortPrintout=%~1
set gpmaVer=unavailable
if not defined gpmaShortPrintout set gpmaShortPrintout=0
if not exist .\bin\pma\README (
    set gpmaVer=phpMyAdmin is unavailable.
    goto :GPMA_CHECK_SHORTENING
)
for /f "usebackq delims=" %%i in (`type .\bin\pma\README^|%xGawk% "BEGIN{i=0}/Version/{if(i==0){print $2;exit}}"`) do set gpmaVer=%%i
if exist .\bin\pma\ChangeLog for /f "usebackq delims=" %%i in (`type .\bin\pma\ChangeLog^|%xGawk% "BEGIN{i=0}/%gpmaVer%/{if(i==0){gsub(/ \(/,\"\x2c \");gsub(/\)/,\"\");print $0}}"`) do set gpmaVer=%%i
set gpmaVer=phpMyAdmin %gpmaVer%

:GPMA_CHECK_SHORTENING
if "%gpmaShortPrintout%" == "1" goto :GPMA_SHORTEN
echo %gpmaVer%|%xLog%
echo.|%xLog%
goto :GPMA_END

:GPMA_SHORTEN
echo %gpmaVer%|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\" is\",\"\");gsub(\"unavailable.\",\"unavailable\")gsub(\",\",\"\");printf(\"%%-16s %%-12s\n\",$1,$2)}"|%xLog%

:GPMA_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHPPGADMIN_VERSION_INFO: Gets, shows and logs PGA version
REM ==> information.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_PHPPGADMIN_VERSION_INFO
setlocal enableextensions
set gpgaShortPrintout=%~1
set gpgaVer=unavailable
if not defined gpgaShortPrintout set gpgaShortPrintout=0
if not exist .\bin\pga\HISTORY (
    set gpgaVer=phpPgAdmin is unavailable.
    goto :GPGA_CHECK_SHORTENING
)
for /f "usebackq delims=" %%i in (`type .\bin\pga\HISTORY^|%xGawk% "BEGIN{i=0}/(phpPgAdmin|Version|Released: )/{if(i<3){gsub(/( History|Version[ \t]*|[ \t]*$)/,\"\");gsub(/Released:[ \t]*/,\"\x2c\");printf $1 \" \" $2 \" \" $3;i++}}"^|%xGawk% "{gsub(\"[ \t]*,\",\", \");gsub(\"  \",\" \");gsub(\"[ \t]*\x2c\",\"\x2c \");gsub(\"\n\",\"\");printf(\"%%s\",$0)}"`) do set gpgaVer=%%i

:GPGA_CHECK_SHORTENING
if "%gpgaShortPrintout%" == "1" goto :GPGA_SHORTEN
echo %gpgaVer%|%xLog%
echo.|%xLog%
goto :GPGA_END

:GPGA_SHORTEN
echo %gpgaVer%|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\" is\",\"\");gsub(\"unavailable.\",\"unavailable\");gsub(\",\",\"\");printf(\"%%-16s %%-12s\n\",$1,$2)}"|%xLog%

:GPGA_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHPCODESNIFFER_VERSION_INFO: Gets/shows/logs PHP_CodeSniffer
REM ==> version info.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_PHPCODESNIFFER_VERSION_INFO
setlocal enableextensions
set gpcsviShortPrintout=%~1
set gpcsviVer=unavailable
if not defined gpcsviShortPrintout set gpcsviShortPrintout=0
if not exist .\bin\p%xBatPhp%\php.exe set gpcsviVer=PHP_CodeSniffer is unavailable.
if not exist .\bin\phpcs\phpcs.phar set gpcsviVer=PHP_CodeSniffer is unavailable.
if /i "%gpcsviVer%" == "PHP_CodeSniffer is unavailable." goto :GPCSVI_CHECK_SHORTENING
for /f "usebackq delims=" %%i in (`.\bin\p%xBatPhp%\php.exe -n .\bin\phpcs\phpcs.phar --version`) do set gpcsviVer=%%i

:GPCSVI_CHECK_SHORTENING
if "%gpcsviShortPrintout%" == "1" goto :GPCSVI_SHORTEN
echo %gpcsviVer%|%xLog%
echo.|%xLog%
goto :GPCSVI_END

:GPCSVI_SHORTEN
echo %gpcsviVer%|%xGawk% "BEGIN{IGNORECASE=1}/(version|unavailable)/{gsub(\"unavailable.\",\"unavailable\");printf(\"%%-16s %%-12s\n\",$1,$3)}"|%xLog%

:GPCSVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHP_VERSION_LONG: Gets, shows and logs full PHP version info.
REM ==> Argument #1: PHP binary selector.
REM ==> Argument #2: Include compiled-in modules info flag.
REM -------------------------------------------------------------------------

:GET_PHP_VERSION_LONG
setlocal enableextensions
set gpvlSel=%~1
if not defined gpvlSel goto :GPVL_ERROR
echo %gpvlSel%|%xGawk% "BEGIN{IGNORECASE=1}/(52|53|54|55|56|70|71|72)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :GPVL_ERROR
if exist .\bin\p%gpvlSel%\php.exe goto :GPVL_PROCEED

echo %gpvlSel%|%xGawk% "{gsub(\"5\",\"5.\");gsub(\"5.5.\",\"5.5\");gsub(\"7\",\"7.\");print \"PHP \"$0\" is unavailable.\"}"|%xLog%
echo.|%xLog%
goto :GPVL_END

:GPVL_ERROR
echo ERROR: PHP version information cannot be retrieved.|%xLog%
echo.|%xLog%
goto :GPVL_END

:GPVL_PROCEED
REM ==> Get PHP and Xdebug version info:
for /f "usebackq delims=" %%i in (`echo %gpvlSel%^|%xGawk% "{print substr($0,1,1) \".\" substr($0,2,1)}"`) do set gpvlVer=%%i
.\bin\p%gpvlSel%\php.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1};!/The PHP Group/{gsub(/( \(cli\)|, Copyright \(c\).*Zend Technologies|    with )/,\"\");print $0}"|%xLog%
if /i "%gpvlSel%" == "70" goto :GPVL_CHECK_PHALCON
if not exist .\bin\xdebug\php_xdebug%gpvlSel%.dll (
    echo Xdebug for PHP %gpvlVer% is unavailable.|%xLog%
    goto :GPVL_CHECK_PHALCON
)
set gpvlDllsVer=%~dp0bin\xdebug\php_xdebug%gpvlSel%.dll
for /f "usebackq delims=" %%i in (`wmic datafile where name^="%gpvlDllsVer:\=\\%" get version^|%xGawk% "/\./{print $1}"`) do set gpvlDllsVer=%%i
echo Xdebug %gpvlDllsVer% for PHP %gpvlVer%|%xLog%

:GPVL_CHECK_PHALCON
REM ==> If PHP selector > PHP 5.2, get also Phalcon Framework version info:
if "%gpvlSel%" == "52" goto :GPVL_MODULES
if not exist .\bin\phalcon\php_phalcon%gpvlSel%.dll (
    echo Phalcon Framework for PHP %gpvlVer% is unavailable.|%xLog%
    goto :GPVL_MODULES
)
for /f "usebackq delims=" %%i in (`.\bin\p%gpvlSel%\php.exe -n -d date.timezone^="Europe/Paris" -d extension^=.\bin\phalcon\php_phalcon%gpvlSel%.dll -i^|%xGawk% "BEGIN{RS=\"\"}/Phalcon Team and contributors/{gsub(/\n/,\" \");print $20}"`) do set gpvlDllsVer=%%i
echo Phalcon Framework %gpvlDllsVer% for PHP %gpvlVer%|%xLog%

:GPVL_MODULES
echo.|%xLog%
REM ==> If necessary, get PHP Compiled-in Modules info:
if "%~2" == "1" (
    echo Compiled-in Modules:|%xLog%
    echo.|%xLog%
    .\bin\p%gpvlSel%\php.exe -m|%xLog%
)

:GPVL_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_PHP_VERSION_SHORT: Gets, shows and logs short PHP version
REM ==> information.
REM ==> Argument #1: PHP binary selector.
REM -------------------------------------------------------------------------

:GET_PHP_VERSION_SHORT
set gpvsSel=%~1
set gpvsVer=unavailable
if not defined gpvsSel set gpvsVer=PHP is unavailable.
if not exist .\bin\p%gpvsSel%\php.exe set gpvsVer=PHP is unavailable.
echo %gpvsSel%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(52|53|54|55|56|70|71|72)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set gpvsVer=PHP is unavailable.
if /i "%gpvsVer%" == "PHP is unavailable." goto :GPVS_UNAVAILABLE
.\bin\p%gpvsSel%\php.exe -n -v|%xGawk% "BEGIN{IGNORECASE=1}/built/{v=%gpvsSel%;gsub(\"5\",\"5.\",v);gsub(\"5.5.\",\"5.5\",v);gsub(\"7\",\"7.\",v);gsub(/,/,\"\");printf(\"%%-16s %%-13s\",$1\" \"v,$2)};/Engine/{gsub(/,/,\"\");printf(\"%%-27s\n\",\"(Zend Engine \" $3 \")\")}"|%xLog%
goto :GPVS_END

:GPVS_UNAVAILABLE
echo %gpvsVer%|%xGawk% "BEGIN{IGNORECASE=1}{v=%gpvsSel%;gsub(/\./,\"\");gsub(\"5\",\"5.\",v);gsub(\"5.5.\",\"5.5\",v);gsub(\"7\",\"7.\",v);printf(\"%%-16s %%-12s\n\",$1\" \"v,$3)}"|%xLog%

:GPVS_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_POSTGRESQL_VERSION_INFO: Gets, shows and logs PostgreSQL
REM ==> version information.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_POSTGRESQL_VERSION_INFO
setlocal enableextensions
set gpviShortPrintout=%~1
set gpviVer=unavailable
if not defined gpviShortPrintout set gpviShortPrintout=0
if not exist .\bin\pgs\bin\postgres.exe (
    set gpviVer=PostgreSQL is unavailable.
    goto :GPVI_CHECK_SHORTENING
)
call :GET_BINARY_VERSION_WMIC "%~dp0bin\pgs\bin\postgres.exe"
if defined xTemp set gpviVer=%xTemp%

:GPVI_CHECK_SHORTENING
if "%gpviShortPrintout%" == "1" goto :GPVI_SHORTEN
echo PostgreSQL %gpviVer%|%xLog%
echo.|%xLog%
goto :GPVI_END

:GPVI_SHORTEN
echo %gpviVer%|%xGawk% "{gsub(/(PostgreSQL |is )/,\"\");gsub(\"unavailable.\",\"unavailable\");printf(\"%%-16s %%-12s\n\",\"PostgreSQL\",$0)}"|%xLog%

:GPVI_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_QFE_LIST_OF_INSTALLED_KBS: Gets the current list of Windows
REM ==> QFE installed KB patches and saves it to file .\tmp\qfe.txt.
REM -------------------------------------------------------------------------

:GET_QFE_LIST_OF_INSTALLED_KBS
wmic qfe get hotfixid|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\" \",\"\");print $0}">.\tmp\qfe.txt 2>nul
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_STACK_SYSTEM_INFO: Gets, shows and logs info about xtack
REM ==> system.
REM ==> Argument #1: Short printout flag: 1 = short; otherwise = long.
REM -------------------------------------------------------------------------

:GET_STACK_SYSTEM_INFO
setlocal enableextensions
set gssiShortPrintout=%~1
if not defined gssiShortPrintout set gssiShortPrintout=0
for /f "usebackq delims=" %%i in (`type .\%~nx0^|%xGawk% "/^^REM Last update: /{print $4 \" \" $5 \" \" $6}"`) do set gssiBatDate=%%i

if "%gssiShortPrintout%" == "1" (
    set gssiMainExpression=%%-16s %%-12s %%-25s
    set gssi7zaExpression=%%-16s %%-12s %%-25s
    set gssiUsing=using
) else (
    set gssiMainExpression=%%s %%s %%s
    set gssi7zaExpression=%%s %%s %%s\n
    set gssiUsing=%gssiBatDate%, using
)

if exist .\swu\istatus.txt type .\swu\istatus.txt|%xGawk% "BEGIN{IGNORECASE=1;overall=\"\";update=\"\"}/# (Overall xtack system revision|Last update): /{if($0 ~ /# Overall xtack system revision: /){overall=$6}else if($0 ~ /# Last update: /){update=$4\" \"$5\" \"$6}}END{printf(\"%gssi7zaExpression%\n\",\"Overall System\",overall,\"(\"update\")\")}
%xGawk% --version|%xGawk% "/GNU Awk/{gsub(\",\",\"\");printf(\"%gssiMainExpression%\n\",\"xtack.bat\",\"%xBatRev%\",\"(%gssiUsing% gawk \" $3 \")\")}"|%xLog%
for /f "usebackq delims=" %%i in (`.\bin\7za.exe l .\bin\runtime.7z^|%xGawk% "BEGIN{IGNORECASE=1}/changelog\.r/{gsub(/changelog\.r/,\"r\");print $5}"`) do set gssiRuntimeVer=%%i
.\bin\7za.exe -bb1 t .\bin\runtime.7z|%xGawk% "BEGIN{files=0;ok=0;result=\"\"}/(T |Everything is Ok)/{if($0 ~ /T /){files++}else if($0 ~ /Everything is Ok/){ok++}}END{if(files>0){result=files \" files, \"};result=result \"integrity check \";if(ok>0){result=result \"OK\"}else{result=result \"NOT OK. Please check!\"};printf(\"%gssiMainExpression%\n\",\"xtack Runtime\",\"%gssiRuntimeVer%\",\"(including \"result\")\")}"|%xLog%
.\bin\7za.exe|%xGawk% "BEGIN{IGNORECASE=1}/Igor Pavlov/{gsub(/(\[32\]|\[64\]| :)/,\"\");printf(\"%gssi7zaExpression%\n\",\"7-Zip 7za\",$3,\"(\"$9 \")\")}"|%xLog%
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_TIMESTAMP_TZ: Returns the current timestamp with timezone
REM ==> reference formatted as YYYY-MM-DD HH:mm:SS TZ (in xTemp variable).
REM -------------------------------------------------------------------------

:GET_TIMESTAMP_TZ
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S %%Z\")}"^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"Romance Standard Time\",\"CET\");gsub(\"Romance Daylight Time\",\"CEST\");print $0}"`) do set xTemp=%%i
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_WINDOWS_VERSION_AND_ARCHITECTURE: Gets (and validates) the
REM ==> Microsoft Windows version and architecture for the system on which
REM ==> xtack is running.
REM ==> Returns:
REM ==> Returns #1: MS Windows product version or "Unsupported" if not a
REM ==>             supported Windows version (in xWinProduct variable).
REM ==> Returns #2: Major.Minor version (in xWinVer variable).
REM ==> Returns #3: "x86" or "x64" (in xWinArch variable).
REM -------------------------------------------------------------------------

:GET_WINDOWS_VERSION_AND_ARCHITECTURE
REM ==> Get Windows version. If running on Windows Vista or higher, xtack
REM ==> indeed supports it. Otherwise it's an unsupported Windows version:
for /f "usebackq delims=" %%i in (`ver^|%xGawk% "/ /{gsub(/ /,\"\n\")};1"^|%xGawk% -F^. "/[0-9]+\.[0-9]+/{gsub(/(\[|\])/,\"\");print $1\".\"$2}"`) do set xWinVer=%%i
for /f "usebackq delims=" %%i in (`echo %xWinVer%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{if(i==0){i++;if($0 ~ /6\.0/){print \"WinVista\"}else if($0 ~ /6\.1/){print \"Win7\"}else if($0 ~ /6\.2/){print \"Win80\"}else if($0 ~ /6\.3/){print \"Win81\"}else if($0 ~ /(6\.4|10\.0)/){print \"Win10\"}}}END{if(i==0){print \"Unsupported\"}}"`) do set xWinProduct=%%i

REM ==> Get Windows architecture (aka bitness: 32 vs 64 bits;
REM ==>see: http://ss64.com/nt/syntax-64bit.html):
set xWinArch=x64
if /i "%PROCESSOR_ARCHITECTURE%" == "x86" if not defined PROCESSOR_ARCHITEW6432 set xWinArch=x86
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: GET_XDEBUG_VERSION_SHORT: Gets, shows and logs Xdebug version
REM ==> info (short format).
REM ==> Argument #1: Xdebug binary selector.
REM -------------------------------------------------------------------------

:GET_XDEBUG_VERSION_SHORT
set gxvsSel=%~1
set gxvsVer=unavailable
if not defined gxvsSel set gxvsVer=Xdebug is unavailable.
echo %gxvsSel%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(52|53|54|55|56|70|71|72)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set gxvsVer=Xdebug is unavailable.
set gxvsBin=%~dp0bin\xdebug\php_xdebug%gxvsSel%.dll
if not exist "%gxvsBin%" set gxvsVer=Xdebug is unavailable.
if /i "%gxvsVer%" == "Xdebug is unavailable." goto :GXVS_UNAVAILABLE

for /f "usebackq delims=" %%i in (`wmic datafile where name^="%gxvsBin:\=\\%" get version^|%xGawk% "/\./{print $1}"`) do set gxvsVer=%%i
if /i "%gxvsVer%" == "unavailable" goto :GXVS_UNAVAILABLE
echo %gxvsVer%|%xGawk% "{if(%gxvsSel% ~ /(52|53)/){d=\"^<= 5.3\"}else if(%gxvsSel% ~ /54/){d=\"= 5.4\"}else{d=\"^>= 5.5\"};printf(\"%%-16s %%-12s %%-25s\n\",\"Xdebug\",$0,\"(for PHP \"d\")\")}"|%xLog%
goto :GXVS_END

:GXVS_UNAVAILABLE
echo %gxvsVer%|%xGawk% "BEGIN{IGNORECASE=1}{v=%gxvsSel%;gsub(/\./,\"\");gsub(\"5\",\"5.\",v);gsub(\"5.5.\",\"5.5\",v);gsub(\"7\",\"7.\",v);printf(\"%%-16s %%-12s\n\",$1\" \"v,$3)}"|%xLog%

:GXVS_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: INSTALL_ALL_REQUIRED_VC_REDISPKGS: Executes a loop to install
REM ==> all missing required MS VC Redistributable Packages in a row from the
REM ==> local %~dp0bin\vcredis\vcredis.7z repository. It also downloads
REM ==> the online update status information file for eventually prompting
REM ==> the user about new online updates later.
REM ==> The subroutine implements a mechanism to recurrently only perform
REM ==> this check every %xPrerequisitesCheckDayInterval% days by storing
REM ==> machine-dependent info in file .\logs\xtack.prq.
REM ==> Returns #1: Number of required MS VC Redistributable Packages missing.
REM ==>             (in xNoOfMissingRedisPkgs variable).
REM ==> Returns #2: List of MS VC Redistributable Packages missing
REM ==>             (in xMissingRedisPkgs variable).
REM ==> Returns #3: rstatus.txt download OK flag
REM ==>             (in xRstatusDownloadedOk variable).
REM -------------------------------------------------------------------------

:INSTALL_ALL_REQUIRED_VC_REDISPKGS
setlocal enableextensions

REM ==> Get the hostname and the current epoch:
for /f "usebackq delims=" %%i in (`hostname`) do set iarvrHostname=%%i
for /f "usebackq delims=" %%i in (`echo 0^|%xGawk% "END{print systime()}"`) do set iarvrCurrentEpoch=%%i

REM ==> Infer the system ID to look for and try to detect the epoch and
REM ==> outcome of the previous prerequisites check, if any:
set iarvrSysId=%iarvrHostname%-%xWinProduct%-%xWinArch%

REM ==> If .\logs\xtack.prq prerequisites check/cache file doesn't exist,
REM ==> flag and proceed to check:
if not exist .\logs\xtack.prq (
    set iarvrCacheAction=create
    goto :IARVR_PROCEED_TO_CHECK
)

REM ==> In case of multiple instances for the same system ID, consider
REM ==> only the first occurrence:
for /f "usebackq delims=" %%i in (`type .\logs\xtack.prq^|%xGawk% "!/([ \t]*#|^$)/"^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*%iarvrSysId%[ \t]*=[ \t]*[0-9]{10}-[0-4]{1}-[0-1]{1}[ \t]*$/{i++;if(i<2){gsub(/([ \t]*%iarvrSysId%[ \t]*=[ \t]*|-[0-4]-[0-1]{1}[ \t]*$)/,\"\");print $0}}END{if(i==0){print \"0\"}}"`) do set iarvrPreviousCheckEpoch=%%i
for /f "usebackq delims=" %%i in (`type .\logs\xtack.prq^|%xGawk% "!/([ \t]*#|^$)/"^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*%iarvrSysId%[ \t]*=[ \t]*[0-9]{10}-[0-4]{1}-[0-1]{1}[ \t]*$/{i++;if(i<2){gsub(/([ \t]*%iarvrSysId%[ \t]*=[ \t]*[0-9]{10}-|-[0-1]{1}[ \t]*$)/,\"\");print $0}}END{if(i==0){print \"5\"}}"`) do set iarvrPreviousCheckMissingRedis=%%i
set iarvrRstatusDownloadedOk=0

REM ==> Check previous check epoch and outcome:
if "%iarvrPreviousCheckEpoch%-%iarvrPreviousCheckMissingRedis%" == "0-5" (
    REM ==> Apparently no previous check was performed for this system ID:
    set iarvrCacheAction=add
    goto :IARVR_PROCEED_TO_CHECK
)
if "%iarvrPreviousCheckEpoch%" == "0" (
    REM ==> Epoch for previous check undetermined:
    set iarvrCacheAction=add
    goto :IARVR_PROCEED_TO_CHECK
)
if %iarvrPreviousCheckMissingRedis% GTR 0 (
    REM ==> There were Redistributable Packages missing in the previous check:
    set iarvrCacheAction=update
    goto :IARVR_PROCEED_TO_CHECK
)

REM ==> Calculate number of days difference between the current and the
REM ==> previous check:
for /f "usebackq delims=" %%i in (`echo 0^|%xGawk% "END{print int((%iarvrCurrentEpoch% - %iarvrPreviousCheckEpoch%) / 86400)}"`) do set iarvrDaysDiff=%%i

REM ==> If necessary, get the DebugMode setting from xtack.ini:
if not defined xDebugMode call :GET_DEBUG_MODE_FLAG_FROM_XTACKINI

REM ==> If previous check performed %xPrerequisitesCheckDayInterval% days ago
REM ==> or less, skip the current check altogether:
if %iarvrDaysDiff% LEQ %xPrerequisitesCheckDayInterval% (
    set iarvrNoOfMissingRedisPkgs=0
    set iarvrMissingRedisPkgs=None
    if "%xDebugMode%" == "1" echo %xDbgM%INSTALL_ALL_REQUIRED_VC_REDISPKGS: Skipping Redistributable Packages prerequisites check as they were already checked %iarvrDaysDiff% days ago]>> %xLogfile%
    if "%xDebugMode%" == "1" echo.>> %xLogfile%
    goto :IARVR_EXIT
) else (
    REM ==> Previous check performed more than %xPrerequisitesCheckDayInterval% days ago. Proceed to check
    REM ==> and update .\logs\xtack.prq:
    set iarvrCacheAction=update
)

:IARVR_PROCEED_TO_CHECK
REM ==> Log new check:
set iarvrTemp=Checking xtack prerequisites apparently for the first time on host %iarvrHostname%, which is running on %xWinProduct% %xWinArch%.
if /i "%iarvrCacheAction%" == "create" call :LOG_ENTRY info "%iarvrTemp%"
if /i "%iarvrCacheAction%" == "add" call :LOG_ENTRY info "%iarvrTemp%"
if /i "%iarvrCacheAction%" == "update" call :LOG_ENTRY info "Performing a routinary every-%xPrerequisitesCheckDayInterval%-days xtack prerequisites check on host %iarvrHostname%, which is running on %xWinProduct% %xWinArch%."

REM ==> Proceed to new check:
call :SHOW_MSG "Checking prerequisites to run xtack on this system. Please wait ...\n"
set iarvrNoOfMissingRedisPkgs=0
set iarvrMissingRedisPkgs=None

:IARVR_MISSING_REDIS_PKG_INSTALLATION
REM ==> Check and eventually install VC9 Redistributable Package for
REM ==> PHP <= 5.4:
call :CHECK_AND_INSTALL_VC_REDISPKG "PHP 5.2, PHP 5.3 and PHP5.4" 9 1
if "%xTemp%" == "0" goto :IARVR_CHECK_VC11
set /a iarvrNoOfMissingRedisPkgs+=1
set iarvrMissingRedisPkgs=VC9

:IARVR_CHECK_VC11
REM ==> Check and eventually install VC11 Redistributable Package for
REM ==> Apache 2.4 + PHP 5.5 + PHP 5.6:
call :CHECK_AND_INSTALL_VC_REDISPKG "Apache 2.4 and PHP 5.5 and PHP 5.6" 11 1
if "%xTemp%" == "0" goto :IARVR_CHECK_VC12
set /a iarvrNoOfMissingRedisPkgs+=1
set iarvrMissingRedisPkgs=%iarvrMissingRedisPkgs% VC11

:IARVR_CHECK_VC12
REM ==> Check and eventually install VC12 Redistributable Package for
REM ==> PostgreSQL:
call :CHECK_AND_INSTALL_VC_REDISPKG "PostgreSQL database server" 12 1
if "%xTemp%" == "0" goto :IARVR_CHECK_VC14
set /a iarvrNoOfMissingRedisPkgs+=1
set iarvrMissingRedisPkgs=%iarvrMissingRedisPkgs% VC12

:IARVR_CHECK_VC14
REM ==> Check and eventually install VC14 Redistributable Package for
REM ==> Apache 2.4 + PHP 7.0+:
call :CHECK_AND_INSTALL_VC_REDISPKG "Apache 2.4 and PHP 7.0 or higher" 14 1
echo.>> %xLogfile%
if "%xTemp%" == "0" goto :IARVR_CHECK_COUNTER
set /a iarvrNoOfMissingRedisPkgs+=1
set iarvrMissingRedisPkgs=%iarvrMissingRedisPkgs% VC14

:IARVR_CHECK_COUNTER
REM ==> If no VC Redistributable Packages missing, just cache and exit:
for /f "usebackq delims=" %%i in (`echo %iarvrMissingRedisPkgs%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"None \",\"\");print $0}"`) do set iarvrMissingRedisPkgs=%%i

REM ==> Check Internet connectivity and try to download online update
REM ==> status information file:
if not defined xHostHasInetConnectivity call :CHECK_INET_CONNECTIVITY 1
if not "%xHostHasInetConnectivity%" == "1" goto :IARVR_CACHE_FILE

REM ==> Internet connectivity actually available; perform the download:
del /F /Q .\swu\status .\swu\status.txt>nul 2>nul
call :DOWNLOAD_UCF
if "%xTemp%" == "0" (
    set iarvrRstatusDownloadedOk=1
    del /F /Q .\swu\rstatus.txt>nul 2>nul
    ren .\swu\%xUCF% rstatus.txt>nul 2>nul
)

:IARVR_CACHE_FILE
REM ==> Cache this check on file .\logs\xtack.prq:
del /F /Q .\logs\xtack_old.prq>nul 2>nul
call :GET_TIMESTAMP_TZ
if /i "%iarvrCacheAction%" == "add" goto :IARVR_ADD_TO_XTACK_PRQ_FILE
if /i "%iarvrCacheAction%" == "update" goto :IARVR_UPDATE_XTACK_PRQ_FILE

:IARVR_CREATE_XTACK_PRQ_FILE
REM ==> Create .\logs\xtack.prq prerequisites check/cache file from scratch:
echo.> .\logs\xtack.prq
type .\%~nx0|%xGawk% "{if(NR>1&&NR<24){gsub(\"REM\",\"#\");print $0}}">> .\logs\xtack.prq
echo # Last update: %xTemp%>> .\logs\xtack.prq
echo.>> .\logs\xtack.prq
echo %iarvrSysId%=%iarvrCurrentEpoch%-%iarvrNoOfMissingRedisPkgs%-%iarvrRstatusDownloadedOk%>> .\logs\xtack.prq
goto :IARVR_EXIT

:IARVR_ADD_TO_XTACK_PRQ_FILE
REM ==> Add current check for current system to .\logs\xtack.prq:
ren .\logs\xtack.prq xtack_old.prq>nul 2>nul
type .\logs\xtack_old.prq|%xGawk% "{if($0 ~ /# Last update: /){print \"# Last update: %xTemp%\"}else{print $0}}">>.\logs\xtack.prq
echo %iarvrSysId%^=%iarvrCurrentEpoch%-%iarvrNoOfMissingRedisPkgs%-%iarvrRstatusDownloadedOk%>> .\logs\xtack.prq
goto :IARVR_EXIT

:IARVR_UPDATE_XTACK_PRQ_FILE
REM ==> Add .\logs\xtack.prq with details for the current check:
ren .\logs\xtack.prq xtack_old.prq>nul 2>nul
type .\logs\xtack_old.prq|%xGawk% "{if($0 ~ /# Last update: /){print \"# Last update: %xTemp%\"}else if($0 ~ /%iarvrSysId%/){print \"%iarvrSysId%^=%iarvrCurrentEpoch%-%iarvrNoOfMissingRedisPkgs%-%iarvrRstatusDownloadedOk%\"}else{print $0}}">>.\logs\xtack.prq

:IARVR_EXIT
REM ==> Clean up and return back:
del /F /Q .\logs\xtack_old.prq>nul 2>nul
endlocal & set "xNoOfMissingRedisPkgs=%iarvrNoOfMissingRedisPkgs%" & set "xMissingRedisPkgs=%iarvrMissingRedisPkgs%" & set "xRstatusDownloadedOk=%iarvrRstatusDownloadedOk%" & set iarvrNoOfMissingRedisPkgs= & set iarvrMissingRedisPkgs= & set iarvrRstatusDownloadedOk=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: KILL_HTTP_SERVER_PREEXISTING_INSTANCES: Detects and eventually
REM ==> kills pre-existing HTTP server instances running on the system.
REM ==> Argument #1: HTTP server binary filename, including file extension.
REM ==> Returns: Pre-existing HTTP server instances killing result (xTemp):
REM ==>          0 = Pre-existing HTTP server instances not detected
REM ==>          1 = Pre-existing HTTP server detected & successfully killed
REM ==>          2 = Pre-existing HTTP server detected but not killed
REM ==>          3 = Pre-existing HTTP server detected but killing forbidden
REM ==>              (xKillExistingServers = 0)
REM -------------------------------------------------------------------------

:KILL_HTTP_SERVER_PREEXISTING_INSTANCES
setlocal enableextensions
set khpiBinary=%~1

REM ==> Check that Apache 1.3, Apache 2.4, Nginx or Node.js have been
REM ==> specified, otherwise exit:
echo %khpiBinary%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(httpd.exe|nginx.exe|Apache.exe|node.exe|iisexpress.exe)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    set khpiResult=0
    goto :KHPI_END
)

REM ==> Check if xtack is not started but Apache 1.3, Apache 2.4, Nginx or
REM ==> Node.js pre-existing instances are running:
.\bin\ps.exe %khpiBinary%>nul 2>nul
if not "%errorlevel%" == "0" (
    set khpiResult=0
    goto :KHPI_END
)

REM ==> Infer HTTP server caption:
for /f "usebackq delims=" %%i in (`echo %khpiBinary%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{if(i==0){i++;if($0 ~ /httpd.exe/){print \"Apache 2.4\"}else if($0 ~ /nginx.exe/){print \"Nginx\"}else if($0 ~ /Apache.exe/){print \"Apache 1.3\"}else if($0 ~ /iisexpress.exe/){print \"IIS\"}else{print \"Node.js\"}}}"`) do set khpiCaption=%%i

REM ==> If KillExistingServers set to yes in xtack.ini, proceed:
if "%xKillExistingServers%" == "1" goto :KHPI_PROCEED

REM ==> If killing of pre-existing HTTP server instances not allowed in
REM ==> xtack.ini, log/flag it and exit:
call :LOG_ENTRY error "KILL_HTTP_SERVER_PREEXISTING_INSTANCES Sub: Pre-existing %khpiBinary% instance(s) running, but xKillExistingServers = 0. Please check. Now exiting."
set khpiResult=3
goto :KHPI_END

:KHPI_PROCEED
REM ==> Pre-existing HTTP server instances found running. First we try to
REM ==> figure out whether they were started via xtack or by any other means:
set khpiInstance=%~dp0
set khpiInstance=%khpiInstance:~0,-1%
set khpiInstance=%khpiInstance:\=\\%
for /f "usebackq delims=" %%i in (`.\bin\ps.exe -e Apache.exe httpd.exe nginx.exe node.exe^|%xGawk% "BEGIN{IGNORECASE=1;i=0}!/PID  PRIO     PATH/{if(i==0){i++;if($4 ~ /%khpiInstance%\\bin\\a24\\bin\\httpd.exe/){print \"Apache 2.4\"}else if($4 ~ /(%khpiInstance%\\bin\\ngx\\nginx.exe)/){print \"Nginx\"}else if($4 ~ /%khpiInstance%\\bin\\a13\\Apache.exe/){print \"Apache 1.3\"}else if($4 ~ /%khpiInstance%\\bin\\njx\\node.exe/){print \"Node.js\"}else if($4 ~ /%khpiInstance%\\bin\\iis\\iisexpress.exe/){print \"IIS\"}else if($1 ~ /(httpd.exe|Apache.exe)/){print \"nonXtackApache\"}else if($1 ~ /nginx.exe/){print \"nonXtackNginx\"}else if($1 ~ /node.exe/){print \"nonXtackNodeJs\"}else{print \"noHttpServerInstances\"}}}END{if(i==0){print \"noHttpServerInstances\"}}"`) do set khpiInstance=%%i

REM ==> Even if seemingly contradictory, check whether no instances were
REM ==> finally found:
if "%khpiInstance%" == "noHttpServerInstances" (
    set khpiResult=0
    goto :KHPI_END
)

REM ==> If HTTP server instances weren't started by xtack, jump now:
echo %khpiInstance%|%xGawk% "/(nonXtackApache|nonXtackNginx|nonXtackNodeJs)/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :KHPI_NON_XTACK_HTTP_SERVER_INSTANCES_RUNNING

REM ==> If not in silent mode, inform user and log the fact that the running
REM ==> xtack HTTP server instances will be killed now:
echo %xSilentMode%|%xGawk% "/^0$/{print \"WARNING: xtack is not currently started on this system, but there are\npre-existing %khpiInstance% running instances that were started by xtack.\nTrying to shut them down now ...\n\"}"|%xLog%
call :LOG_ENTRY notice "KILL_HTTP_SERVER_PREEXISTING_INSTANCES Sub: xtack is not currently started on this system, but there are pre-existing %khpiInstance% running instances that were started by xtack. Trying to shut them down now."

REM ==> Infer HTTP server selector for the pre-existing xtack HTTP server
REM ==> instance running:
for /f "usebackq delims=" %%i in (`echo %khpiInstance%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /Apache 2.4/){print \"a24\"}else if($0 ~ /Nginx/){print \"ngx\"}else if($0 ~ /Apache 1.3/){print \"a13\"}else if($0 ~ /IIS/){print \"iis\"}else{print \"njs\"}}"`) do set khpiTemp=%%i

REM ==> Shut down/kill the pre-existing xtack HTTP server detected:
call :SHUT_HTTP_SERVER_DOWN "%khpiTemp%"
if not "%xTemp%" == "2" goto :KHPI_HTTP_SERVER_KILLED_OK
call :SHOW_MSG "ERROR: Pre-existing %khpiCaption% instances could not be killed. Now exiting ..." "ERROR: xtack can't run: Pre-existing %khpiCaption% can't be killed."
call :LOG_ENTRY error "KILL_HTTP_SERVER_PREEXISTING_INSTANCES Sub: Pre-existing %khpiCaption% instances could not be killed. Now exiting."
set khpiResult=2
goto :KHPI_END

:KHPI_NON_XTACK_HTTP_SERVER_INSTANCES_RUNNING
REM ==> Check in the pre-existing HTTP server instances are running as
REM ==> a service:
for /f "usebackq delims=" %%i in (`net start^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{if(i==0){i++;if($0 ~ /(httpd.exe|Apache.exe)(\.exe)/){print \"Apache\"}else if($0 ~ /nginx(\.exe)/){print \"nginx\"}else if($0 ~ /node(\.exe)/){print \"Node.js\"}else if($0 ~ /iisexpress(\.exe)/){print \"IIS\"}else{print \"None\"}}}END{if(i==0){print \"None\"}}"`) do set khpiTemp=%%i
if /i not "%khpiTemp%" == "None" goto :KHPI_PREEXISTING_HTTP_SERVER_IS_RUNNING_AS_A_SERVICE

REM ==> At this point, there are non xtack HTTP server instances running,
REM ==> but not as a service, so we try to brute-kill them:
call :SHOW_MSG "WARNING: There are pre-existing non xtack %khpiCaption% running instances.\nTrying to brute kill them now ..."

REM ==> Log and try to kill pre-existing DBMS instances:
call :LOG_ENTRY notice "KILL_HTTP_SERVER_PREEXISTING_INSTANCES Sub: Trying to brute kill pre-existing non xtack %khpiCaption% running instance(s)."
.\bin\ps.exe -f -k Apache.exe httpd.exe nginx.exe node.exeiisexpress.exe>nul 2>nul
if "%errorlevel%" == "0" goto :KHPI_HTTP_SERVER_KILLED_OK

:KHPI_PREEXISTING_HTTP_SERVER_IS_RUNNING_AS_A_SERVICE
REM ==> Warn and log about pre-existing HTTP server instances running as
REM ==> a service:
call :SHOW_MSG "WARNING: There are pre-existing non xtack %khpiCaption% instance^(s^)\nrunning as a service that can't be killed by xtack ..."
call :LOG_ENTRY error "KILL_HTTP_SERVER_PREEXISTING_INSTANCES Sub: There are pre-existing non xtack %khpiCaption% instance(s) running as a service that can't be killed by xtack. Please check. Now exiting."
set khpiResult=2
goto :KHPI_END

:KHPI_HTTP_SERVER_KILLED_OK
REM ==> Pre-existing HTTP server instances successfully killed. Show message
REM ==> and proceed:
set khpiResult=1
call :SHOW_MSG "Pre-existing %khpiCaption% running instances successfully killed ...\n"

:KHPI_END
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Checking pre-existing HTTP server instances" 0 1

REM ==> Return back:
endlocal & set "xTemp=%khpiResult%" & set khpiResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: KILL_PHP_INSTANCES: Detects and eventually kills any PHP
REM ==> instances running on the system.
REM ==> Argument #1: Skip printouts flag: 0/unset = verbose, 1 = silent
REM ==> Returns: PHP instances killing result (in xTemp variable):
REM ==>                0 = PHP instances not running
REM ==>                1 = PHP instances successfully shut down/killed
REM ==>                2 = PHP instances couldn't be shut down/killed
REM -------------------------------------------------------------------------

:KILL_PHP_INSTANCES
setlocal enableextensions
set xkpiSkipPrintouts=%~1
if not defined xkpiSkipPrintouts set xkpiSkipPrintouts=0
set xkpiResult=0

REM ==> Check whether there are running PHP instances and, if any, kill them:
.\bin\ps.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if not "%errorlevel%" == "0" goto :XKPI_END

REM ==> Kill any running PHP instances:
if not "%xkpiSkipPrintouts%" == "1" call :SHOW_MSG "\nKilling all running PHP instances. Please wait ..."
if "%xDebugMode%" == "1" echo %xDbgM%Process Killing Command Executed: .\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe]>> %xLogfile%
.\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if not "%errorlevel%" == "2" goto :XKPI_RUNNING_PHP_INSTANCES_KILLED_OK

REM ==> Second attempt to kill any running PHP instances:
if not "%xkpiSkipPrintouts%" == "1" call :SHOW_MSG "Still waiting for running PHP instances to be killed"
if "%xDebugMode%" == "1" echo %xDbgM%Process Killing Command Executed: .\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe]>> %xLogfile%
.\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if not "%errorlevel%" == "2" goto :XKPI_RUNNING_PHP_INSTANCES_KILLED_OK

REM ==> Give PHP some time to die (2 seconds):
.\bin\ps.exe -d 2000 php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if "%errorlevel%" == "1" goto :XKPI_RUNNING_PHP_INSTANCES_KILLED_OK
if not "%xkpiSkipPrintouts%" == "1" call :SHOW_MSG "Running PHP instances have probably not been killed ..."
call :LOG_ENTRY warning "KILL_PHP_INSTANCES Sub: Running PHP instances have probably not been killed."
set xkpiResult=2
goto :XKPI_END

:XKPI_RUNNING_PHP_INSTANCES_KILLED_OK
if not "%xkpiSkipPrintouts%" == "1" call :SHOW_MSG "Running PHP instances successfully killed ..."
set xkpiResult=1

:XKPI_END
REM ==> Return back:
endlocal & set "xTemp=%xkpiResult%" & set xkpiResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: KILL_DBMS_PREEXISTING_INSTANCES: Detects and eventually kills
REM ==> pre-existing DBMS instances running on the system.
REM ==> Argument #1: DBMS binary filename, including file extension.
REM ==> Returns: Pre-existing DBMS instances killing result (in xTemp):
REM ==>          0 = Pre-existing DBMS instances not detected
REM ==>          1 = Pre-existing DBMS detected & successfully killed
REM ==>          2 = Pre-existing DBMS detected but not killed
REM ==>          3 = Pre-existing DBMS detected but killing forbidden
REM ==>              (xKillExistingServers = 0)
REM -------------------------------------------------------------------------

:KILL_DBMS_PREEXISTING_INSTANCES
setlocal enableextensions
set krpiBinary=%~1

REM ==> Check that MySQL or PostgreSQL have been specified, otherwise exit:
echo %krpiBinary%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(mysqld.exe|postgres.exe)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    set krpiResult=0
    goto :KRPI_END
)

REM ==> Check if xtack is not started but any pre-existing MySQL or PostgreSQL
REM ==> instances are running:
.\bin\ps.exe %krpiBinary%>nul 2>nul
if not "%errorlevel%" == "0" (
    set krpiResult=0
    goto :KRPI_END
)

REM ==> Infer DBMS caption:
for /f "usebackq delims=" %%i in (`echo %krpiBinary%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{if(i==0){i++;if($0 ~ /postgres.exe/){print \"PostgreSQL\"}else{print \"MySQL\"}}}"`) do set krpiCaption=%%i

REM ==> If KillExistingServers set to yes in xtack.ini, proceed:
if "%xKillExistingServers%" == "1" goto :KRPI_PROCEED

REM ==> If killing of pre-existing DBMS instances not allowed in xtack.ini,
REM ==> log/flag it:
call :LOG_ENTRY error "KILL_DBMS_PREEXISTING_INSTANCES Sub: Pre-existing %krpiBinary% instance(s) running, but xKillExistingServers = 0. Please check. Now exiting."
set krpiResult=3
goto :KRPI_END

:KRPI_PROCEED
REM ==> Pre-existing DBMS instances found running. Try to figure out
REM ==> whether they were started via xtack or by any other means:
set krpiInstance=%~dp0
set krpiInstance=%krpiInstance:~0,-1%
set krpiInstance=%krpiInstance:\=\\%
for /f "usebackq delims=" %%i in (`.\bin\ps.exe -e mysqld.exe postgres.exe^|%xGawk% "BEGIN{IGNORECASE=1;i=0}!/PID  PRIO     PATH/{if(i==0){i++;if($4 ~ /%krpiInstance%\\bin\\m55\\bin\\mysqld.exe/){print \"MySQL 5.5\"}else if($4 ~ /(%krpiInstance%\\bin\\m57\\bin\\mysqld.exe)/){print \"MySQL 5.7\"}else if($4 ~ /(%krpiInstance%\\bin\\mra\\bin\\mysqld.exe)/){print \"MariaDB 10.1\"}else if($4 ~ /%krpiInstance%\\bin\\pgs\\bin\\postgres.exe/){print \"PostgreSQL\"}else if($1 ~ /postgres.exe/){print \"nonXtackPostgreSQL\"}else if($1 ~ /mysqld.exe/){print \"nonXtackMySQL\"}else{print \"noDbmsInstances\"}}}END{if(i==0){print \"noDbmsInstances\"}}"`) do set krpiInstance=%%i

REM ==> Even if seemingly contradictory, check whether no instances were
REM ==> finally found:
if "%krpiInstance%" == "noDbmsInstances" (
    set krpiResult=0
    goto :KRPI_END
)

REM ==> If DBMS instances weren't started by xtack, jump now:
echo %krpiInstance%|%xGawk% "/(nonXtackMySQL|nonXtackPostgreSQL)/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :KRPI_NON_XTACK_DBMS_INSTANCES_RUNNING

REM ==> If not in silent mode, inform user and log the fact that the running
REM ==> xtack DBMS instances will be killed now:
echo %xSilentMode%|%xGawk% "/^0$/{print \"WARNING: xtack is not currently started on this system, but there are\npre-existing %krpiInstance% running instances that were started by xtack.\nTrying to shut them down now ...\n\"}"|%xLog%
call :LOG_ENTRY notice "KILL_DBMS_PREEXISTING_INSTANCES Sub: xtack is not currently started on this system, but there are pre-existing %krpiInstance% running instances that were started by xtack. Trying to shut them down now."

REM ==> Infer DBMS selector for the pre-existing xtack DBMS instance running:
for /f "usebackq delims=" %%i in (`echo %krpiInstance%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /MySQL 5.5/){print \"m55\"}else if($0 ~ /MySQL 5.7/){print \"m57\"}else if($0 ~ /MariaDB 10.1/){print \"mra\"}else{print \"pgs\"}}"`) do set krpiTemp=%%i

REM ==> Shut down/kill the pre-existing xtack DBMS detected:
call :SHUT_DBMS_DOWN "%krpiTemp%"
if not "%xTemp%" == "2" goto :KRPI_DBMS_KILLED_OK
call :SHOW_MSG "ERROR: Pre-existing %krpiCaption% instances could not be killed. Now exiting ..." "ERROR: xtack can't run: Pre-existing %krpiCaption% can't be killed."
call :LOG_ENTRY error "KILL_DBMS_PREEXISTING_INSTANCES Sub: Pre-existing %krpiCaption% instances could not be killed. Now exiting."
set krpiResult=2
goto :KRPI_END

:KRPI_NON_XTACK_DBMS_INSTANCES_RUNNING
REM ==> Check if the pre-existing DBMS instances are running as a service:
for /f "usebackq delims=" %%i in (`net start^|%xGawk% "BEGIN{IGNORECASE=1;i=0}{if(i==0){i++;if($0 ~ /mysql(d)?(\.exe)/){print \"MySQL\"}else if($0 ~ /postgres(\.exe)/){print \"PostgreSQL\"}else{print \"None\"}}}END{if(i==0){print \"None\"}}"`) do set krpiTemp=%%i
if /i not "%krpiTemp%" == "None" goto :KRPI_PREEXISTING_DBMS_IS_RUNNING_AS_A_SERVICE

REM ==> At this point, there are non xtack DBMS instances running,
REM ==> but not as a service, so we try to brute-kill them:
call :SHOW_MSG "WARNING: There are pre-existing non xtack %krpiCaption% running instances.\nTrying to brute kill them now ..."

REM ==> Log and try to kill pre-existing DBMS instances:
call :LOG_ENTRY notice "KILL_DBMS_PREEXISTING_INSTANCES Sub: Trying to brute kill pre-existing non xtack %krpiCaption% running instance(s)."
.\bin\ps.exe -f -k mysqld.exe postgres.exe>nul 2>nul
if "%errorlevel%" == "0" goto :KRPI_DBMS_KILLED_OK

:KRPI_PREEXISTING_DBMS_IS_RUNNING_AS_A_SERVICE
REM ==> Warn and log about pre-existing DBMS instances running as a service:
call :SHOW_MSG "WARNING: There are pre-existing non xtack %krpiCaption% instance^(s^)\nrunning as a service that can't be killed by xtack ..."
call :LOG_ENTRY error "KILL_DBMS_PREEXISTING_INSTANCES Sub: There are pre-existing non xtack %krpiCaption% instance(s) running as a service that can't be killed by xtack. Please check. Now exiting."
set krpiResult=2
goto :KRPI_END

:KRPI_DBMS_KILLED_OK
REM ==> Pre-existing DBMS instances successfully killed. Show message
REM ==> and proceed:
set krpiResult=1
call :SHOW_MSG "Pre-existing %krpiCaption% running instances successfully killed ...\n"

:KRPI_END
REM ==> xtack profiling item:
if "%xProfiling%" == "1" call :PROFILING "Checking pre-existing DBMS instances" 0 1

REM ==> Return back:
endlocal & set "xTemp=%krpiResult%" & set krpiResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: LOG_HISTORY_ENTRY: Formats and logs an entry into logs\xtack.log
REM ==> Argument #1: Severity. Can be "info" (default), "notice",
REM ==>              "warning" or "error".
REM ==> Argument #2: Message to log.
REM -------------------------------------------------------------------------

:LOG_ENTRY
setlocal enableextensions
REM ==> If Windows Command Extensions disabled, skip the standard entry header
REM ==> preparation:
if not "%xWinCmdExtActive%" == "1" goto :LE_VERIFY_SEVERITY

REM ==> Get the timestamp:
if exist %xGawk% (
    REM ==> Get the full timestamp:
    for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set leTimestamp=%%i
) else (
    REM ==> Fallback to date /t and time /t:
    for /f "usebackq delims=" %%i in (`time /t`) do set leHostname=%%i
    for /f "usebackq delims=" %%i in (`date /t`) do set leTimestamp=%%i
    set leTimestamp=%leTimestamp%%leHostname%
)

REM ==> Get hostname and username:
for /f "usebackq delims=" %%i in (`hostname`) do set leHostname=%%i
if defined USERNAME (
    for /f "usebackq delims=" %%i in (`echo %USERNAME%`) do set leWhoami=%%i@
) else (
    set leWhoami=unknown-user
)

REM ==> Verify whether the input severity is an allowed value or default it to
REM ==> info level otherwise:
:LE_VERIFY_SEVERITY
set leSeverity=%~1
if /i "%leSeverity%" == "info" goto :LE_SEVERITY_OK
if /i "%leSeverity%" == "notice" goto :LE_SEVERITY_OK
if /i "%leSeverity%" == "warning" goto :LE_SEVERITY_OK
if /i "%leSeverity%" == "error" goto :LE_SEVERITY_OK
set leSeverity=info

:LE_SEVERITY_OK
REM ==> Get the message, removing any surrounding double quotes:
set leMessage=%~2

if not "%xWinCmdExtActive%" == "1" goto :LE_ROUGHER

REM ==> Use the standard entry header:
echo %leTimestamp% %leWhoami%%leHostname% xtack.bat %xBatRev%/%xFunctionalityArea% [%leSeverity%] %leMessage%>> .\logs\xtack_history.log
goto :LE_END

:LE_ROUGHER
REM ==> Use a rougher, unprocessed entry header:
echo %DATE% %TIME% %USERNAME%@%COMPUTERNAME% xtack.bat %xBatRev%/%xFunctionalityArea% [%leSeverity%] %leMessage%>> .\logs\xtack_history.log

:LE_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: LOG_SILENT_MODE_STATUS: Logs the current silent mode status.
REM -------------------------------------------------------------------------

:LOG_SILENT_MODE_STATUS
REM ==> If debug mode enabled, log it:
if "%xSilentModeStatusLogged%" == "1" goto :LSMS_END
echo %xSilentMode%|%xGawk% "{gsub(\"1\",\"ENABLED\");gsub(\"0\",\"DISABLED\");print \"[Silent Mode status: \" $0 \"]\"}">> %xLogfile%
echo.>> %xLogfile%
set xSilentModeStatusLogged=1

:LSMS_END
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: PERFORM_FINAL_CLEANUP: Deletes all temporary files possibly
REM ==> created during xtack startup.
REM -------------------------------------------------------------------------

:PERFORM_FINAL_CLEANUP
del /F /Q .\cfg\*_port.* .\tmp\xtackprc.txt .\tmp\xtacktmp1.txt .\tmp\cfgcache.txt .\tmp\doccache.txt .\logs\*.pid .\tmp\sess_* .\tmp\redispkg.exe .\tmp\vc*redispkg.exe .\dbs\m57\auto.cnf .\tmp\xdbstemp*.txt>nul 2>nul
del /F /Q .\bin\p52\php.ini .\bin\p53\php.ini .\bin\p54\php.ini .\bin\p55\php.ini .\bin\p56\php.ini .\bin\p70\php.ini .\bin\p71\php.ini .\bin\p72\php.ini .\dbs\pgs\postgresql.conf .\bin\pma\config.inc.php .\bin\pga\conf\config.inc.php>nul 2>nul
del /F /Q .\dbs\m55\*.err .\dbs\m55\*.pid .\dbs\m57\*.err .\dbs\m57\*.pid .\xtack.log>nul 2>nul
call :DELETE_NGINX_DIRS_AND_FILES
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: PERFORM_FINAL_REGRESSION_TESTING_CLEANUP: Deletes all temporary
REM ==> files possibly created during xtack regression.
REM -------------------------------------------------------------------------

:PERFORM_FINAL_REGRESSION_TESTING_CLEANUP
call :DELETE_XTACK_RUNTIME_FILES "tmp"
del /F /Q .\tmp\*.pdf .\tmp\*.chm .\tmp\wgetitem.txt .\tmp\tstmodes.txt .\tmp\xtackprc.txt .\tmp\xtacktmp1.txt .\tmp\cfgcache.txt .\tmp\doccache.txt>nul 2>nul
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: PORTABILIZE_XTACK_CONFIG_FILE: Replaces relative paths in config-
REM ==> uration file and generates a new temporary file with absolute paths.
REM ==> Argument #1: Source configuration file absolute path+filename.
REM ==> Argument #2: Destination configuration file absolute path+filename.
REM ==> Returns: 0 = Destination file successfully created; 1 = otherwise.
REM ==>              (in xTemp variable).
REM -------------------------------------------------------------------------

:PORTABILIZE_XTACK_CONFIG_FILE
setlocal enableextensions
set pxcfResult=1
set pxcfSourceFile=%~1
if not defined pxcfSourceFile goto :PXCF_EXIT

REM ==> If source file doesn't exist, exit now:
if not exist "%pxcfSourceFile%" (
    call :LOG_ENTRY error "PORTABILIZE_XTACK_CONFIG_FILE Sub: Requested source configuration file %pxcfSourceFile% doesn't exist. Please check."
    goto :PXCF_EXIT
)
set pxcfDestFile=%~2
if not defined pxcfDestFile goto :PXCF_EXIT
del /F /Q "%pxcfDestFile%">nul 2>nul

REM ==> Get xtack's base path:
set pxcfBasePath=%~dp0
set pxcfBasePath=%pxcfBasePath:~0,-1%
set pxcfBasePath=%pxcfBasePath:\=\\%

REM ==> Perform the actual portabilization via Gawk.
REM ==> WARNING: Gawk portabilization logic is quite complex!!
REM ==> Please DON'T TOUCH IT UNLESS YOU KNOW WHAT YOU'RE DOING:
type "%pxcfSourceFile%"|%xGawk% "BEGIN{IGNORECASE=1;headerLines=28}{if(NR<headerLines){if($0 ~ / Last update: 20[0-9]{2}-[0-1]{1}[0-9]{1}-[0-3]{1}[0-9]{1}/){print $0 \" - Cached: \" strftime(\"%%Y-%%m-%%d %%H:%%M %%z.\")}else{gsub(\" Revision: r\",\" Cached from revision r\");print $0}}else if(NF>0 && $0 !~ /(^[ \t]*(#|;|\/\/|(\/)?\*)+)/){gsub(/\\\\xtack\\\\bin\\\\pgs\\\\bin\\\\/,\"\\xtack\\bin\\pgs\\bin\\\\\");gsub(/\.\.\\browscap\\/,\"/xtack/bin\\browscap\\\\\");gsub(/\.\.\\dlls\\/,\"/xtack/bin\\dlls\\\\\");gsub(/\.\.\\mod_security\\/,\"/xtack/bin\\modules\\\\\");gsub(/\.\.\\packages\\/,\"/xtack/www\\packages\\\\\");gsub(/\.\.\\phalcon\\/,\"/xtack/bin\\phalcon\\\\\");gsub(/\.\.\\xdebug\\/,\"/xtack/bin\\xdebug\\\\\");gsub(/(\.\.)?((\\|\/)xtack)?(\\|\/)?logs(\\\\|\/)?/,\"/xtack/logs\\\\\");gsub(/((\\|\/)xtack)?(\\|\/){1}tmp(\\\\|\/)?/,\"/xtack/tmp\\\\\");gsub(/((\\|\/)xtack)?(\\|\/)?bin(\\\\|\/){1}/,\"/xtack/bin\\\\\");gsub(\"conf/extra/\",\"/xtack/bin/a24\\conf\\extra\\\\\");gsub(\"conf/magic\",\"/xtack/bin/a13\\conf\\magic\");gsub(/\/+xtack\042+/,\"%pxcfBasePath%\042\");gsub(/(\\|\/)+xtack(\\|\/)+/,\"%pxcfBasePath%\\\\\");gsub(/\\{1}bin\\{1};/,\"\\bin;\");gsub(\"/modules/\",\"\\modules\\\\\");gsub(/(\\|\/){1}conf(\\|\/){1}/,\"\\conf\\\\\");gsub(/(\\|\/){1}dbs(\\|\/){1}/,\"\\dbs\\\\\");gsub(/(\\|\/){1}www\042{1}/,\"\\www\042\");gsub(/(\\|\/){1}users\042{1}/,\"\\users\042\");gsub(/(\\|\/){1}m55(\\|\/)?/,\"\\m55\\\\\");gsub(/(\\|\/){1}m57(\\|\/)?/,\"\\m57\\\\\");gsub(/(\\|\/){1}mra(\\|\/)?/,\"\\mra\\\\\");gsub(/(\\|\/){1}pma\042{1}/,\"\\pma\042\");gsub(/(\\|\/){1}pga\042{1}/,\"\\pga\042\");gsub(/(\\|\/){1}docs\042{1}/,\"\\docs\042\");gsub(/(\\|\/){1}ide\042{1}/,\"\\ide\042\");gsub(/(\\|\/){1}icons\042{1}/,\"\\icons\042\");gsub(/(\\|\/){1}icons\/{1}/,\"\\icons\\\\\");gsub(/(\\|\/){1}cgi-bin\042{1}/,\"\\cgi-bin\042\");gsub(/(\\|\/){1}njs\/node_modules\/{1}/,\"\\njs\\node_modules\\\\\");if($0 ~ /(\\(bin|dbs)\\(m55|m57)\\|logs\\(xtack_nginx_|nginx\.pid))/){gsub(/\\/,\"\\\\\\\\\")};if($0 ~ /^[ \t]*(opcache\.)*error_log[ \t]*=/){gsub(/logs\\\\/,\"logs\\\\\")};if($0 ~ /^[ \t]*root.*\\;$/){gsub(/\\;/,\";\")};print $0}}"|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /^[ \t]*root.*\\;$/){gsub(/\\;/,\";\")};print $0}">"%pxcfDestFile%" 2>nul

REM ==> If the new temporary destination configuration file exists,
REM ==> flag success:
if exist "%pxcfDestFile%" (
    set pxcfResult=0
) else (
    call :LOG_ENTRY error "PORTABILIZE_XTACK_CONFIG_FILE Sub: Requested temporary destination configuration file %pxcfDestFile% could not be created. Please check."
)

:PXCF_EXIT
endlocal & set "xTemp=%pxcfResult%" & set pxcfResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: POSTGRESQL_INIT_CLUSTER: Initialises the PostgreSQL cluster.
REM ==> Argument #1: PostgreSQL version (optional).
REM ==> Returns: PostgreSQL cluster initialisation result (in xTemp):
REM ==>          0 = Cluster successfully initialised
REM ==>          1 = Cluster DB couldn't be initialised
REM -------------------------------------------------------------------------

:POSTGRESQL_INIT_CLUSTER
setlocal enableextensions
set pgicDbmsVer=%~1
if /i "%pgicDbmsVer%" == "" set pgicDbmsVer

REM ==> Inform the user that the PostgreSQL cluster needs to be initialized:
call :SHOW_MSG "The %pgicDbmsVer% database cluster needs to be initialized.\nThis typically doesn't take longer than 3 mins. Please wait ..."
del /F /Q .\tmp\pgictmp1.txt .\tmp\pgictmp2.txt>nul 2>nul

REM ==> Check whether the PHP engine binary actually exists:
if exist .\bin\pgs\bin\initdb.exe goto :PGIC_EXECUTE_INITDB
set pgicResult=1
echo ERROR: The %pgicDbmsVer% cluster can't be created as initdb.exe|%xLog%
echo is missing in directory %~dp0bin\pgs\bin\|%xLog%
call :LOG_ENTRY error "POSTGRESQL_INIT_CLUSTER Sub: The %pgicDbmsVer% cluster can't be created as initdb.exe is missing in directory %~dp0bin\pgs\bin\. Please check!"
goto :PGIC_END

:PGIC_EXECUTE_INITDB
REM ==> Session logging and initdb execution:
echo root>.\tmp\pgicpw.txt
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\pgs\bin\initdb.exe --pgdata="%~dp0dbs\pgs" --encoding=UTF8 --username=root --auth=md5 --pwfile=.\tmp\pgicpw.txt --locale="English_United States.1252" --text-search-config=english]>> %xLogfile%
.\bin\pgs\bin\initdb.exe --pgdata="%~dp0dbs\pgs" --encoding=UTF8 --username=root --auth=md5 --pwfile=%~dp0tmp\pgicpw.txt --locale="English_United States.1252" --text-search-config=english>.\tmp\pgictmp1.txt 2>.\tmp\pgictmp2.txt
if "%errorlevel%" == "0" goto :PGIC_POSTGRESQL_INITDB_SUCCESSFULLY_EXECUTED

REM ==> Log the reason of initdb's failure upon initialization of the
REM ==> PostgreSQL cluster:
for /f "usebackq delims=" %%i in (`type .\tmp\pgictmp2.txt^|%xGawk% "BEGIN{IGNORECASE=1}/initdb: /{gsub(\"initdb: \",\"\");print $0}"`) do set pgicTemp=%%i
call :LOG_ENTRY error "POSTGRESQL_INIT_CLUSTER Sub: %pgicDbmsVer% cluster could not be created due to reason: %pgicTemp%. Now exiting."
set pgicResult=1
if "%xSilentMode%" == "1" goto :PGIC_SILENT_POSTGRESQL_INITDB_FAILURE

REM ==> Show the error and exit:
echo ERROR: The %pgicDbmsVer% cluster could not be created due to:|%xLog%
echo.|%xLog%
type .\tmp\pgictmp2.txt|%xLog%
echo.|%xLog%
echo Now exiting ...|%xLog%
goto :PGIC_END

:PGIC_SILENT_POSTGRESQL_INITDB_FAILURE
echo ERROR: xtack can't run: %pgicDbmsVer% cluster can't be created.|%xLog%
goto :PGIC_END

:PGIC_POSTGRESQL_INITDB_SUCCESSFULLY_EXECUTED
REM ==> If file system type = NTFS, try to set ownership of the cluster
REM ==> directory to the current user. First of all check whether icacls
REM ==> is available on this system:
icacls.exe /?>nul 2>nul
if not "%errorlevel%" == "0" goto :PGIC_END

REM ==> If file system type = NTFS, try to set ownership
REM ==> of the cluster directory to the current user:
call :POSTGRESQL_GRANT_ACCESS_TO_CLUSTER
if "%errorlevel%" == "0" (
    call :LOG_ENTRY info "POSTGRESQL_INIT_CLUSTER Sub: %pgicDbmsVer% cluster successfully created on %~dp0dbs\pgs with full access for the current user %USERNAME%."
    call :SHOW_MSG "\n%pgicDbmsVer% cluster successfully created with full access for\nthe current user ^(%USERNAME%^).\n"
) else (
    call :LOG_ENTRY error "POSTGRESQL_INIT_CLUSTER Sub: icacls failed, at least partially, to grant access to the PostgreSQL root DBs directory for the current user %USERNAME%. This could cause PostgreSQL startup to fail."
    call :SHOW_MSG "\nWARNING: Although the %pgicDbmsVer% cluster has been successfully,\ninitialised, it has not been possible to completely grant full access\nfor the current user ^(%USERNAME%^). This could cause PostgreSQL startup\nto fail.\n"
)

:PGIC_END
REM ==> Clean up and return back:
del /F /Q .\tmp\pgicpw.txt .\tmp\pgictmp1.txt .\tmp\pgictmp2.txt .\tmp\pgicpw.txt">nul 2>nul
endlocal & set "xTemp=%pgicResult%" & set pgicResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: POSTGRESQL_GRANT_ACCESS_TO_CLUSTER: Grants access and sets
REM ==> ownership of the PostgreSQL cluster directory (by using icacls) to
REM ==> the current user.
REM ==> Returns: PostgreSQL cluster grant result (in xTemp):
REM ==>          0 = Cluster successfully initialised
REM ==>          Otherwise = Cluster DB couldn't be initialised
REM -------------------------------------------------------------------------

:POSTGRESQL_GRANT_ACCESS_TO_CLUSTER
setlocal enableextensions

REM ==> First of all, confirm that the system variable %USERNAME% exists:
if not "%USERNAME%" == "" goto :PGAC_GRANT_ACCESS_TO_CLUSTER_DIR
call :LOG_ENTRY error "POSTGRESQL_GRANT_ACCESS_TO_CLUSTER Sub: icacls cannot be run to grant full access for the current user to the PostgreSQL cluster directory as system variable USERNAME is empty. This could cause PostgreSQL startup to fail."
call :SHOW_MSG "\nWARNING: It has not been possible to grant full access for the current user to\nthe PostgreSQL cluster directory. This could cause PostgreSQL startup\nto fail.\n"
set pgacTemp=1
goto :PGAC_END

:PGAC_GRANT_ACCESS_TO_CLUSTER_DIR
REM ==> Check whether icacls is available:
icacls.exe /?>nul 2>nul
if not "%errorlevel%" == "0" goto :PGAC_END
if not "%USERNAME%" == "" goto :PGAC_GET_FILESYSTE_TYPE
call :LOG_ENTRY error "POSTGRESQL_GRANT_ACCESS_TO_CLUSTER Sub: icacls cannot be run to grant full access for the current user to the PostgreSQL cluster directory as system variable USERNAME is empty. This could cause PostgreSQL startup to fail."
call :SHOW_MSG "\nWARNING: It has not been possible to grant full access for the current user to\nthe PostgreSQL cluster directory. This could cause PostgreSQL startup\nto fail.\n"
goto :PGAC_END

:PGAC_GET_FILESYSTE_TYPE
REM ==> Find out whether the file system type is NTFS or not:
for /f "usebackq delims=" %%i in (`echo %CD%^|%xGawk% -F: "{print toupper($1)}"`) do set pgacTemp=%%i
wmic VOLUME where DriveLetter="%pgacTemp%:" GET FileSystem|%xGawk% "!/FileSystem/{print toupper($0)}">.\tmp\pgactmp1.txt 2>nul
for /f "usebackq delims=" %%i in (`type .\tmp\pgactmp1.txt^|%xGawk% "NR==1"`) do set pgacTemp=%%i
if /i not "%pgacTemp%" == "NTFS" goto :PGAC_ICACLS_POSTGRESQL_SETOWNER

REM ==> Execute icacls on the cluster directory to secure that PostgreSQL
REM ==> will run OK:
call :SHOW_MSG "Granting NTFS full access to the %pgacDbmsVer% cluster to the\ncurrent user (%USERNAME%)."

REM ==> Execute icacls /grant for the current user:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: icacls "%~dp0dbs\pgs" /inheritance:e /grant:r %USERNAME%:(OI)(CI)(F) /T /C /L /Q]>> %xLogfile%
icacls "%~dp0dbs\pgs" /inheritance:e /grant:r %USERNAME%:(OI)(CI)(F) /T /C /L /Q>.\tmp\pgactmp1.txt

:PGAC_ICACLS_POSTGRESQL_SETOWNER
call :SHOW_MSG "\nSetting ownership of the %pgicDbmsVer% cluster to the current\nuser (%USERNAME%)."

REM ==> Execute icacls /setowner for the current user:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: icacls "%~dp0dbs\pgs" /setowner %USERNAME% /T /C /L /Q]>> %xLogfile%
icacls "%~dp0dbs\pgs" /setowner %USERNAME% /T /C /L /Q>>.\tmp\pgactmp1.txt
type .\tmp\pgactmp1.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}/Failed processing 0 files/{i++}END{if(i==0){exit 1}}"
set pgacTemp=%errorlevel%

:PGAC_END
REM ==> Clean up and return back:
del /F /Q .\tmp\pgactmp1.txt>nul 2>nul
endlocal & set "xTemp=%pgacTemp%" & set pgacTemp=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: PROCESS_RSTATUS_GET_UPDATED_COMPONENTS: Processes the remote
REM ==> status file (.\swu\rstatus.txt) after it has been successfully
REM ==> downloaded and compares the output with list of currently installed
REM ==> components, generating a file with the list of such components
REM ==> (file .\swu\newcomps.txt) and returning the # of new components.
REM ==> Returns: Number of new components available
REM ==>          (in xNumberOfNewComponentsAvailable variable).
REM ==>          List of new remote components available for installation in
REM ==>          file .\swu\newcomps.txt
REM -------------------------------------------------------------------------

:PROCESS_RSTATUS_GET_UPDATED_COMPONENTS
type .\swu\rstatus.txt|%xGawk% "BEGIN{IGNORECASE=1}{if($0 !~ /(^^[ \t]*#|^$)/ && $5 !~ /^^Install$/ && $6 ~ /[a-f0-9]{128}/){gsub(/(^[ \t]*|[ \t]*$)/,\"\");gsub(/[ \t]+/,\" \");if(($1\" \"$2) ~ /(7za 7-Zip|(a13|a24) Apache|browscap php_browscap.ini|dlls DLLPack|iis IIS|icons Icons|(m55|m57) MySQL|mra MariaDB|mradb MariaDB_DB|mysqldbs MySQL_DBs|ngx nginx|njs Node.js|(p52|p53|p54|p55|p56|p70|p71|p72) PHP|pga phpPgAdmin|pgs PostgreSQL|pgsdb PostgreSQL_DB|phalcon Phalcon|phpcs PHP_CodeSniffer|pma phpMyAdmin|runtime Runtime|sendmail FakeSendmail|vcredis MSVC_Redistributables|xdocs xtackDocs|xdebug Xdebug|xtackbat xtack\.bat)/){print $1\" \"$2\" \"$3\" \"$4}}}">.\swu\available.txt

REM ==> Compare both lists to get the differences:
%xGawk% "FNR==NR{a[$1\" \"$2\" \"$3];next}(!($1\" \"$2\" \"$3 in a))" .\swu\installed.txt .\swu\available.txt>.\swu\newcomps.txt

REM ==> Count the total number of new components available:
for /f "usebackq delims=" %%i in (`type .\swu\newcomps.txt^|%xGawk% "END{print NR}"`) do set xNumberOfNewComponentsAvailable=%%i
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: PROFILING: Performs a profiling checkpoint: Calculates
REM ==> delta time since last checkpoint, shows the profiling message and
REM ==> captures the new timestamp to be used in the next one.
REM ==> Argument #1: Profiling message.
REM ==> Argument #2: Initial blank line flag: Yes = 1; otherwise 0.
REM ==> Argument #3: Intermediate blank line flag: Yes = 1; otherwise 0.
REM ==> Returns: Current system time stamp (in variable xTime1).
REM -------------------------------------------------------------------------

:PROFILING
if "%xSilentMode%" == "1" goto :PROF_END
call :TIME_DELTA "%xTime1%"
if "%~2" == "1" echo.|%xLog%
echo PROFILING: %~1 took %xTookStr%.|%xLog%
if "%~3" == "1" echo.|%xLog%
for /f "usebackq delims=" %%i in (`%xGawk% "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTime1=%%i

:PROF_END
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: REFRESH_LOGFILE: Updates logfile setting and the file itself.
REM ==> Argument #1: New logfile name (without file extension).
REM ==> Argument #2: Avoid replacing old logfile: 1 = Yes; otherwise = No.
REM -------------------------------------------------------------------------

:REFRESH_LOGFILE
set rlOldFilename=%xLogfile%
set xLogfile=%~1
set xLogfile=%xLogfile%.log
set rlSkipReplacingOldLogfile=%~2
if not defined rlSkipReplacingOldLogfile set rlSkipReplacingOldLogfile=0

REM ==> Check if replacing of old logfile is to be skipped:
if "%rlSkipReplacingOldLogfile%" == "1" goto :RL_SKIP_REPLACING_OLD_LOGFILE

REM ==> If an older script's backup logfile exists, delete it:
del /F /Q .\logs\%xLogfile%.bak>nul 2>nul

REM ==> If a previous script's logfile exists, rename it:
if exist .\logs\%xLogfile% ren .\logs\%xLogfile% %xLogfile%.bak>nul 2>nul

REM ==> Now rename the current logfile:
if exist "%rlOldFilename%" ren "%rlOldFilename%" %xLogfile%>nul 2>nul

:RL_SKIP_REPLACING_OLD_LOGFILE
REM ==> Provide a full path to the script's logfile onwards:
set xLogfile=.\logs\%xLogfile%

REM ==> Update the log command:
set xLog= .\bin\wtee.exe -a %xLogfile%

REM ==> Clean up and exit:
set rlOldFilename=
set rlSkipReplacingOldLogfile=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: REGENERATE_XTACKBAT_PKGJSON_AND_LICENSE: Regenerates xtack.bat
REM ==>      xtack.json and license files.
REM -------------------------------------------------------------------------

:REGENERATE_XTACKBAT_PKGJSON_AND_LICENSE
if exist .\xtack.json (
    del /F /Q .\swu\xtack.json>nul 2>nul
    move /Y .\xtack.json .\swu\>nul 2>nul
)

echo {>.\xtack.json
echo   "component": "xtackbat",>>.\xtack.json
echo   "name": "xtack.bat",>>.\xtack.json
echo   "version": "%xBatRev%",>>.\xtack.json
echo   "date": "%xBatLastUpdate%",>>.\xtack.json
echo   "description": "The xtack.bat main script is the core of the xtack Web Stack. This is a xtack system file. Please DO NOT remove it!",>>.\xtack.json
echo   "license": "GPL-3.0",>>.\xtack.json
echo   "author": "xcentra, 2014-2017 - xtack.org - www.xcentra.com <info@xtack.org> (https://xtack.org)",>>.\xtack.json
echo   "contributors": ["xcentra, 2014-2017 - xtack.org - www.xcentra.com <info@xtack.org> (https://xtack.org)"],>>.\xtack.json
echo   "homepage": "https://xtack.org",>>.\xtack.json
echo   "repository": {"type": "url", "url": "https://xtack.org"},>>.\xtack.json
echo   "changes": "See the xtack changelog for full details: https://xtack.org/changelog.html",>>.\xtack.json
echo   "bugs": {"email": "info@xtack.org"},>>.\xtack.json
echo   "keywords": ["xtack", "xtack.bat", "xtack.bat main script"],>>.\xtack.json
echo   "dependencies": [],>>.\xtack.json
echo   "files" : [>>.\xtack.json
echo     "xtack.bat",>>.\xtack.json
echo     "LICENSE.txt",>>.\xtack.json
echo     "xtack.json"]>>.\xtack.json
echo }>>.\xtack.json

if exist .\xtack.json (
    del /F /Q .\swu\LICENSE.txt>nul 2>nul
    move /Y .\LICENSE.txt .\swu\>nul 2>nul
    .\bin\7za.exe e -aos -y -o.\ .\bin\runtime.7z LICENSE.txt>nul 2>nul
)
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: RENAME_PACKAGE_JSON_FILES: Renames all package.json files to
REM ==> xtack.json (mainly for old packages), to avoid conflicts with npm.
REM -------------------------------------------------------------------------

:RENAME_PACKAGE_JSON_FILES
setlocal enabledelayedexpansion
for %%i in (a13 a24 browscap dlls icons iis m55 m57 mra ngx njs p52 p53 p54 p55 p56 p70 p71 p72 pga pgs phalcon phpcs pma sendmail xdebug) do (
    set rpjfDirName=%%i
    if exist .\bin\!rpjfDirName!\package.json ren .\bin\!rpjfDirName!\package.json xtack.json>nul 2>nul
)
endlocal
if exist .\package.json ren .\package.json xtack.json>nul 2>nul
if exist .\docs\package.json ren .\docs\package.json xtack.json>nul 2>nul
if exist .\dbs\package.json ren .\dbs\package.json xtack.json>nul 2>nul
if exist .\dbs\package_mradb.json ren .\docs\package.json xtack_mradb.json>nul 2>nul
if exist .\dbs\package_mysqldbs.json ren .\docs\package.json xtack_mysqldbs.json>nul 2>nul
if exist .\dbs\package_pgsdb.json ren .\docs\package.json xtack_pgsdb.json>nul 2>nul
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SWAP_DEFAULT_DATABASE: Swaps the former default databases for
REM ==>      any of the supported DBMSs with new, updated one(s), saving the
REM ==>      former ones to the .\swu\backup subdirectory.
REM ==> Argument #1: Database ID ("mysqldbs", "pgsdb" on "mradb").
REM ==> Returns: 0 = Databases swapped OK; 1 = Databases NOT swapped OK.
REM ==>              (in xTemp variable).
REM -------------------------------------------------------------------------

:SWAP_DEFAULT_DATABASE
setlocal enableextensions
set sddbResult=1

REM ==> Get the DB ID and validate it before proceeding to swap:
set sddbDbId=%~1
if not defined sddbDbId goto :SDDB_END
echo %sddbDbId%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^(mysqldbs|pgsdb|mradb)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :SDDB_END

REM ==> Infer DB directory:
for /f "usebackq delims=" %%i in (`echo %sddbDbId%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /mysqldbs/){print \"m55\"}else if($0 ~ /pgsdb/){print \"pgs\"}else{print \"mra\"}}"`) do set sddbDbDir=%%i

REM ==> Delete any pre-existing backup copies of the MySQL databases
REM ==> in the software update backup subdirectory:
rd /S /Q .\swu\backup\dbs\%sddbDbDir%>nul 2>nul
if /i "%sddbDbId%" == "mysqldbs" rd /S /Q .\swu\backup\dbs\m57>nul 2>nul
del /F /Q .\swu\backup\dbs\package_%sddbDbId%.json .\swu\backup\dbs\package.json .\swu\backup\dbs\xtack_%sddbDbId%.json .\swu\backup\dbs\xtack.json>nul 2>nul
md .\swu\backup\dbs>nul 2>nul

REM ==> Move old databases to the software update backup subdirectory:
move /Y .\dbs\xtack_%sddbDbId%.json .\swu\backup\dbs\xtack_%sddbDbId%.json>nul 2>nul
move /Y .\dbs\%sddbDbDir% .\swu\backup\dbs>nul 2>nul
set sddbResult=%errorlevel%
if /i "%sddbDbId%" == "mysqldbs" move /Y .\dbs\m57 .\swu\backup\dbs\m57>nul 2>nul
set /a sddbResult=sddbResult+%errorlevel%>nul 2>nul

REM ==> Now move the new databases to their original and intended final path:
move /Y .\swu\dbs\xtack.json .\dbs\xtack_%sddbDbId%.json>nul 2>nul
set /a sddbResult=sddbResult+%errorlevel%>nul 2>nul
move /Y .\swu\dbs\%sddbDbDir% .\dbs>nul 2>nul
set /a sddbResult=sddbResult+%errorlevel%>nul 2>nul
if /i "%sddbDbId%" == "mysqldbs" move /Y .\swu\dbs\m57 .\dbs>nul 2>nul
set /a sddbResult=sddbResult+%errorlevel%>nul 2>nul
rd /S /Q .\swu\dbs>nul 2>nul

:SDDB_END
REM ==> Normalize returned result and exit:
if not "%sddbResult%" == "0" set sddbResult=1
endlocal & set "xTemp=%sddbResult%" & set sddbResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SWAP_UPDATED_COMPONENT: Swaps an old component with an updated,
REM ==> new component, saving the old one to the .\swu\backup subdirectory.
REM ==> Argument #1: Component original path.
REM ==> Argument #2: Component ID.
REM ==> Returns: 0 = Component swapped OK; 1 = Component NOT swapped OK.
REM ==>              (in xTemp variable).
REM -------------------------------------------------------------------------

:SWAP_UPDATED_COMPONENT
setlocal enableextensions
set sucResult=1
set sucComponentPath=%~1
set sucComponent=%~2
if not defined sucComponentPath goto :SUC_END
if "%sucComponentPath%" == "" goto :SUC_END
if not defined sucComponent goto :SUC_END
if "%sucComponent%" == "" goto :SUC_END

REM ==> Delete any pre-existing backup copies of the component in the
REM ==> software update backup subdirectory:
rd /S /Q .\swu\backup\%sucComponent%>nul 2>nul
del /S /F /Q .\swu\backup\%sucComponent%>nul 2>nul

REM ==> Move old component to the software update backup subdirectory:
if not exist %sucComponentPath%\%sucComponent% md %sucComponentPath%\%sucComponent%>nul 2>nul
move /Y %sucComponentPath%\%sucComponent% .\swu\backup>nul 2>nul
set sucResult=%errorlevel%

REM ==> Now move the new component to its intended final path:
move /Y .\swu\%sucComponent% %sucComponentPath%>nul 2>nul
set /a sucResult=sucResult+%errorlevel%>nul 2>nul

REM ==> Normalize returned result:
if not "%sucResult%" == "0" set sucResult=1

:SUC_END
endlocal & set "xTemp=%sucResult%" & set sucResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SWAP_XDOCS: Swaps xtack documents in the old .\docs
REM ==>      subdirectories with the new, updated ones, saving the old ones
REM ==>      to the .\swu\backup subdirectory.
REM ==> Returns: 0 = Documents swapped OK; 1 = Documents NOT swapped OK.
REM ==>              (in xTemp variable).
REM -------------------------------------------------------------------------

:SWAP_XDOCS
setlocal enableextensions
set swwdResult=0

REM ==> Delete any pre-existing backup copies of the .\docs files:
rd /S /Q .\swu\backup\docs>nul 2>nul
md .\swu\backup\docs>nul 2>nul

REM ==> Move the old .\docs and files to the software update backup subfolder:
if exist .\docs\assets move /Y .\docs\assets .\swu\backup\docs\assets>nul 2>nul
set /a swwdResult=swwdResult+%errorlevel%>nul 2>nul
setlocal enabledelayedexpansion
for %%i in (.\docs\*.html .\docs\phpinfo.php .\docs\xtack.json .\docs\sitemap.xml) do (
    set xFileName=%%i
    if exist !xFileName! move /Y !xFileName! .\swu\backup\docs>nul 2>nul & set /a swwdResult=swwdResult+!errorlevel!>nul 2>nul
)
endlocal

REM ==> Now move the new files to their intended final paths:
if exist .\swu\docs\assets move /Y .\swu\docs\assets .\docs\assets>nul 2>nul
set /a swwdResult=swwdResult+%errorlevel%>nul 2>nul
setlocal enabledelayedexpansion
for %%i in (.\swu\docs\*.html .\swu\docs\phpinfo.php .\swu\docs\xtack.json .\swu\docs\sitemap.xml) do (
    set xFileName=%%i
    if exist !xFileName! move /Y !xFileName! .\docs>nul 2>nul & set /a swwdResult=swwdResult+!errorlevel!>nul 2>nul
)
endlocal

REM ==> Normalize returned result, clean up and exit:
if not "%swwdResult%" == "0" (
    set swwdResult=1
) else (
    rd /S /Q .\swu\docs>nul 2>nul
)
endlocal & set "xTemp=%swwdResult%" & set swwdResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_MSG: Detects whether xtack is running in silent mode and
REM ==> and depending on it shows and logs a full-length message provided as
REM ==> first parameter or a shorter message provided in the second parameter.
REM ==> Argument #1: Full-length message for non silent execution mode.
REM ==> Argument #2: Alternative shorter message for silent execution mode.
REM -------------------------------------------------------------------------

:SHOW_MSG
setlocal enableextensions
if "%xSilentMode%" == "1" goto :SM_SILENT_MODE_MSG

set smMsg=%~1
if not "%smMsg%" == "" echo 0|%xGawk% "{print \"%smMsg%\"}"|%xLog%
goto :SCLM_END

:SM_SILENT_MODE_MSG
set smMsg=%~2
if not "%smMsg%" == "" echo 0|%xGawk% "{print \"%smMsg%\"}"|%xLog%

:SCLM_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_SW_VERSIONS_LONGER: Shows a longer, detailed view of the
REM ==> current software versions included in xtack.
REM -------------------------------------------------------------------------

:SHOW_SW_VERSIONS_LONGER
REM ==> Show longer, detailed software versions info:
echo The following software versions are included in xtack %xBatRev% (%xBatLastUpdate%):|%xLog%
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo xtack System:|%xLog%
echo =============|%xLog%
call :GET_STACK_SYSTEM_INFO 0
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Apache 1.3:|%xLog%
echo ===========|%xLog%
call :GET_APACHE13_VERSION_INFO 2
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Apache 2.4:|%xLog%
echo ===========|%xLog%
call :GET_APACHE24_VERSION_INFO 2
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Nginx:|%xLog%
echo ======|%xLog%
call :GET_NGINX_VERSION_INFO 2
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo IIS Express:|%xLog%
echo ============|%xLog%
call :GET_IIS_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Node.js:|%xLog%
echo ========|%xLog%
call :GET_NODEJS_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo MySQL 5.5:|%xLog%
echo ==========|%xLog%
call :GET_MYSQL_MARIADB_VERSION_INFO "m55"
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo MySQL 5.7:|%xLog%
echo ==========|%xLog%
call :GET_MYSQL_MARIADB_VERSION_INFO "m57"
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo MariaDB:|%xLog%
echo ========|%xLog%
call :GET_MYSQL_MARIADB_VERSION_INFO "mra"
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PostgreSQL:|%xLog%
echo ===========|%xLog%
call :GET_POSTGRESQL_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 5.2:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 52 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 5.3:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 53 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 5.4:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 54 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 5.5:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 55 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 5.6:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 56 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 7.0:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 70 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 7.1:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 71 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP 7.2:|%xLog%
echo ========|%xLog%
call :GET_PHP_VERSION_LONG 72 1
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo phpMyAdmin:|%xLog%
echo ===========|%xLog%
call :GET_PHPMYADMIN_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo phpPgAdmin:|%xLog%
echo ===========|%xLog%
call :GET_PHPPGADMIN_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo php_browscap.ini:|%xLog%
echo =================|%xLog%
call :GET_PHPBROWSCAP_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Fake Sendmail:|%xLog%
echo ==============|%xLog%
call :GET_FAKESENDMAIL_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Composer:|%xLog%
echo =========|%xLog%
call :GET_COMPOSER_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo PHP_CodeSniffer:|%xLog%
echo ================|%xLog%
call :GET_PHPCODESNIFFER_VERSION_INFO
echo -----------------------------------------------------------------------|%xLog%
echo.|%xLog%
echo Other Components:|%xLog%
echo =================|%xLog%
call :GET_OTHER_COMPONENTS_INFO
echo -----------------------------------------------------------------------|%xLog%
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_SW_VERSIONS_LONG: Shows a long summary of the current
REM ==> software versions included in xtack.
REM -------------------------------------------------------------------------

:SHOW_SW_VERSIONS_LONG
REM ==> Show long software versions summary:
echo The following software versions are included in xtack %xBatRev% (%xBatLastUpdate%):|%xLog%
echo -----------------------------------------------------------------------|%xLog%
call :GET_STACK_SYSTEM_INFO 0
call :GET_APACHE13_VERSION_INFO 1
call :GET_APACHE24_VERSION_INFO 1
call :GET_NGINX_VERSION_INFO 1
call :GET_IIS_VERSION_INFO
call :GET_NODEJS_VERSION_INFO
call :GET_MYSQL_MARIADB_VERSION_INFO "m55"
call :GET_MYSQL_MARIADB_VERSION_INFO "m57"
call :GET_MYSQL_MARIADB_VERSION_INFO "mra"
call :GET_POSTGRESQL_VERSION_INFO
call :GET_PHP_VERSION_LONG 52 0
call :GET_PHP_VERSION_LONG 53 0
call :GET_PHP_VERSION_LONG 54 0
call :GET_PHP_VERSION_LONG 55 0
call :GET_PHP_VERSION_LONG 56 0
call :GET_PHP_VERSION_LONG 70 0
call :GET_PHP_VERSION_LONG 71 0
call :GET_PHP_VERSION_LONG 72 0
call :GET_PHPMYADMIN_VERSION_INFO
call :GET_PHPPGADMIN_VERSION_INFO
call :GET_PHPBROWSCAP_VERSION_INFO
call :GET_FAKESENDMAIL_VERSION_INFO
call :GET_COMPOSER_VERSION_INFO
call :GET_PHPCODESNIFFER_VERSION_INFO
call :GET_OTHER_COMPONENTS_INFO
echo -----------------------------------------------------------------------|%xLog%
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_SW_VERSIONS_SHORT: Shows a short view of the current
REM ==> software versions included in xtack.
REM -------------------------------------------------------------------------

:SHOW_SW_VERSIONS_SHORT
setlocal enableextensions

REM ==> Show software versions mini summary:
echo Software versions mini summary:|%xLog%
echo ----------------------------------------------------------------------|%xLog%
call :GET_STACK_SYSTEM_INFO 1
call :GET_APACHE13_VERSION_INFO 0
call :GET_APACHE24_VERSION_INFO 0
call :GET_NGINX_VERSION_INFO 0
call :GET_IIS_VERSION_INFO 1
call :GET_NODEJS_VERSION_INFO 1
call :GET_MYSQL_MARIADB_VERSION_INFO "m55" 1
call :GET_MYSQL_MARIADB_VERSION_INFO "m57" 1
call :GET_MYSQL_MARIADB_VERSION_INFO "mra" 1
call :GET_POSTGRESQL_VERSION_INFO 1
call :GET_PHP_VERSION_SHORT 52
call :GET_PHP_VERSION_SHORT 53
call :GET_PHP_VERSION_SHORT 54
call :GET_PHP_VERSION_SHORT 55
call :GET_PHP_VERSION_SHORT 56
call :GET_PHP_VERSION_SHORT 70
call :GET_PHP_VERSION_SHORT 71
call :GET_PHP_VERSION_SHORT 72
call :GET_XDEBUG_VERSION_SHORT 70
call :GET_XDEBUG_VERSION_SHORT 54
call :GET_XDEBUG_VERSION_SHORT 53
call :GET_PHALCON_VERSION_INFO_SHORT %xBatPhp%
call :GET_PHALCON_VERSION_INFO_SHORT 54
call :GET_PHPMYADMIN_VERSION_INFO 1
call :GET_PHPPGADMIN_VERSION_INFO 1
call :GET_COMPOSER_VERSION_INFO 1
call :GET_PHPCODESNIFFER_VERSION_INFO 1
call :GET_PHPBROWSCAP_VERSION_INFO 1
call :GET_FAKESENDMAIL_VERSION_INFO 1
call :GET_OTHER_COMPONENTS_INFO 1
echo ----------------------------------------------------------------------|%xLog%
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_WORDWRAPPED_MSG: Shows and logs the message provided as
REM ==> first parameter word wrapped at a prefixed characters length.
REM ==> Argument #1: Message to show.
REM ==> Argument #2: OPTIONAL. Character word wrap length.
REM -------------------------------------------------------------------------

:SHOW_WORDWRAPPED_MSG
setlocal enableextensions
set swwmMsg=%~1
if not defined swwmMsg goto :SWWM_END
if /i "%swwmMsg%" == "" goto :SWWM_END

REM ==> Get or default word wrap length:
set swwmlength=%~2
if not defined swwmlength set swwmlength=68

REM ==> Word wrap original message around the provided line length:
echo %swwmMsg%|.\bin\fmt.exe -w %swwmlength%|%xLog%

:SWWM_END
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_XTACK_HEADER: Shows and logs xtack.bat standard header.
REM -------------------------------------------------------------------------

:SHOW_XTACK_HEADER
setlocal enableextensions
set xH1=Welcome to xtack %xBatRev% - Web Development Stack for Windows, by xcentra!
set xH2=This is free software under the terms of the GNU GPLv3 License. You're
set xH3=welcome to redistribute and/or modify it under certain conditions. It
set xH4=comes with ABSOLUTELY NO WARRANTY. More info at www.fsf.org/licensing/

echo %xH1%
echo %xCR%
echo.
echo %xH2%
echo %xH3%
echo %xH4%
echo.

echo %xH1%>> %xLogfile%
echo %xCR%>> %xLogfile%
echo.>> %xLogfile%
echo %xH2%>> %xLogfile%
echo %xH3%>> %xLogfile%
echo %xH4%>> %xLogfile%
echo.>> %xLogfile%

endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_XTACK_PROCESS_LIST: If file .\bin\xtack.lck exists, this
REM ==> subroutine shows the list of processes started up by xtack during its
REM ==> last startup, plus any other eventual xtack processes unexpectedly
REM ==> running. If file .\bin\xtack.lck does not exist, then it just shows
REM ==> eventual xtack processes unexpectedly running.
REM -------------------------------------------------------------------------

:SHOW_XTACK_PROCESS_LIST
setlocal enableextensions

REM ==> Build the caption for the WMIC query to get all the xtack
REM ==> processes that should be checked:
set sxplTemp=Caption="Apache.exe" or Caption="httpd.exe" or Caption="nginx.exe" or Caption="node.exe" or Caption="iisexpress.exe" or Caption="mysqld.exe" or Caption="postgres.exe" or Caption="php.exe" or Caption="php-cgi.exe" or Caption="php-win.exe" or Caption="phpdbg.exe"

REM ==> Check if xtack control file exists:
if exist .\bin\xtack.lck goto :SXPL_SHOW_LASTEST_EXECUTION_PROCESSES

REM ==> xtack is apparently not started up. Check if there are any xtack
REM ==> processes unexpectedly running via WMIC:
wmic PROCESS where (%sxplTemp%) get Caption,ExecutablePath,Processid,CreationDate,WindowsVersion /format:csv 2>&1|%xGawk% "BEGIN{IGNORECASE=1}/\.exe/{print $0}">.\tmp\xtackprc.txt 2>nul
type .\tmp\xtackprc.txt|%xGawk% "BEGIN{IGNORECASE=1}/(Apache|httpd|nginx|node|iisexpress|mysqld|postgres|php|php-cgi|php-win|phpdbg)+(\.exe)?/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :SXPL_END
goto :SXPL_UNEXPECTED_PROCESSES

:SXPL_SHOW_LASTEST_EXECUTION_PROCESSES
REM ==> Check whether any browsers were started upon the latest xtack
REM ==> execution:
REM ==> Get the full list of xtack processes originally started by xtack
REM ==> upon its last execution from .\bin\xtack.lck:
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% -F^: "/PIDs.*:/{printf \" \" $2}"^|%xGawk% "{$1=$1};1"`) do set sxplPids=%%i
for /f "usebackq delims=" %%i in (`echo %sxplPids%^|%xGawk% "BEGIN{IGNORECASE=1}/ /{gsub(/ /,\" or ProcessId^=\");print $0}"`) do set sxplTemp=%%i
wmic PROCESS where (ProcessId=%sxplTemp%) get Caption,ExecutablePath,Processid,CreationDate,WindowsVersion /format:csv 2>&1|%xGawk% "BEGIN{IGNORECASE=1}/\.exe/{print $0}">.\tmp\xtackprc.txt 2>nul

REM ==> Count the total number of xtack processes currently running:
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% "END{print NR}"`) do set sxplCount=%%i
if not "%sxplCount%" == "0" goto :SXPL_LIST_PROCESSES

:SXPL_XTACK_STARTED_BUT_NO_XTACK_PROCESSES_RUNNING
REM ==> Although xtack is apparently started up (as per existence of
REM ==> .\bin\xtack.lck), no xtack processes have been found running.
REM ==> Inform/log and exit:
set sxplTemp=xtack is apparently started up but no xtack processes are running
call :LOG_ENTRY warning "SHOW_XTACK_PROCESS_LIST Sub: %sxplTemp% (file .\bin\xtack.lck exists)."
echo.|%xLog%
echo %sxplTemp%.|%xLog%
echo.|%xLog%
goto :SXPL_END

:SXPL_LIST_PROCESSES
REM ==> Count the total number of xtack processes originally started
REM ==> by xtack upon its last execution:
for /f "usebackq delims=" %%i in (`echo %sxplPids%^|%xGawk% "END{print NF}"`) do set sxplTemp=%%i
if "%xDebugMode%" == "1" echo %xDbgM%PIDs for the %sxplTemp% processes originally started by xtack: %sxplPids%]>> %xLogfile%

REM ==> Count number of xtack processes originally started upon the
REM ==> latest xtack execution that are still running:
if not defined sxplCount for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% "END{print NR}"`) do set sxplCount=%%i

REM ==> Show the list of processes originally started by xtack upon
REM ==> its last execution:
echo The following %sxplCount% process(es) out of the %sxplTemp% originally launched by|%xLog%
echo xtack upon its last startup or switchover are still running:|%xLog%

:SXPL_SHOW_XTACK_PROCESSES_LIST
echo.|%xLog%
echo Process            PID     Full Path|%xLog%
set sxplTemp=%~dp0
set sxplTemp=%sxplTemp:\=\\%
type .\tmp\xtackprc.txt|%xGawk% -F, "{if($2 ~ /iisexpress\.exe/ && $4 ~ /^$/){b=\"%sxplTemp%bin\\iis\\iisexpress.exe\"}else if($2 ~ /php-cgi\.exe/ && $4 ~ /^$/){b=\"%sxplTemp%bin\\%xPhpSelector%\\php-cgi.exe\"}else{b=$4};printf(\"%%-19s%%-8s%%-90s\n\",$2,$5,b);}"|%xLog%
goto :SXPL_END

:SXPL_UNEXPECTED_PROCESSES
REM ==> Check if other xtack processes are unexpectedly running, probably
REM ==> from previous executions:
set sxplTemp=%~dp0bin\
set sxplTemp=%sxplTemp:\=\\%
for /f "usebackq delims=" %%i in (`type .\tmp\xtackprc.txt^|%xGawk% -F^, "BEGIN{IGNORECASE=1;i=0};{if(($4 ~ /%sxplTemp%/) || (($2 ~ /(iisexpress\.exe|php-cgi\.exe)/) && ($4 ~ /^$/))){i++}}END{print i}"`) do set sxplCount=%%i
if "%sxplCount%" == "0" goto :SXPL_END

REM ==> Show the list of xtack processes unexpectedly running:
echo.|%xLog%
if "%sxplCount%" == "1" (
    set sxplTemp=xtack process is
) else (
    set sxplTemp=%sxplCount% xtack processes are
)
echo WARNING: The following %sxplTemp% unexpectedly running:|%xLog%
goto :SXPL_SHOW_XTACK_PROCESSES_LIST

:SXPL_END
REM ==> Clean up and return back:
del /F /Q .\tmp\xtackprc.txt>nul 2>nul
endlocal
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHOW_XTACK_STATUS: Shows the current xcentra status.
REM ==> Argument #1: Caller ID (stop/status)
REM ==> Returns: 0 if xtack running; 1 if xtack not running
REM ==>          (in xTemp variable).
REM -------------------------------------------------------------------------

:SHOW_XTACK_STATUS
setlocal enableextensions

REM ==> Get and/or set the "caller ID" (which functionality module has called
REM ==> this subroutine):
set sxsCaller=%~1
if /i "%sxsCaller%" == "stop" goto :SXS_SHOW_GATHERING_INFO_MESSAGE
if /i "%sxsCaller%" == "status" goto :SXS_SHOW_GATHERING_INFO_MESSAGE

REM ==> If caller ID invalid, default it to "status":
set sxsCaller=status

:SXS_SHOW_GATHERING_INFO_MESSAGE
call :SHOW_MSG "Gathering info and checking xtack status. Please wait ...\n"

REM ==> Check if xtack is currently running on this system. It is
REM ==> detected through the presence of the .\bin\xtack.lck file:
if exist .\bin\xtack.lck (
    set sxsXtackRunning=0
    goto :SXS_CHECK_IF_XTACK_LCK_CONTAINS_OPMODE_INFO
) else (
    set sxsXtackRunning=1
)
if /i "%sxsCaller%" == "stop" (
    call :SHOW_MSG "Sorry, but xtack is not running on this system, so there's nothing to\nshut down ..." "xtack not running on this system. Nothing to shut down."
) else (
    call :SHOW_MSG "xtack is not running on this system ..." "xtack not running on this system."
)
REM ==> If there are any xtack processes unexpectedly running, show them now:
call :SHOW_XTACK_PROCESS_LIST
goto :SXS_END

:SXS_CHECK_IF_XTACK_LCK_CONTAINS_OPMODE_INFO
type .\bin\xtack.lck|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack (later switched over to|started in) OpMode/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SXS_XTACK_EXTRACT_INFO_FROM_THE_XTACK_LCK_FILE
set xOpMode=unknown
set xOpModeOrigin=unknown
goto :SXS_END

:SXS_XTACK_EXTRACT_INFO_FROM_THE_XTACK_LCK_FILE
REM ==> Extract and format startup info from the xtack control file. First
REM ==> try to get the original "from" OpMode and OpMode origin from eventual
REM ==> previous switchovers registered in the xtack control file:
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack later switched over to OpMode/{i++;print $7}END{if(i==0){print \"Unknown\"}}"`) do set xOpMode=%%i
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack later switched over to OpMode/{i++;gsub(/(\(|\))/,\"\");print $8}END{if(i==0){print \"Unknown\"}}"`) do set xOpModeOrigin=%%i

REM ==> If no previous switchovers detected, then get the "from" OpMode and
REM ==> OpMode origin for the initial xtack startup:
if /i "%xOpMode%" == "Unknown" for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/xtack started in OpMode/{i++;print $5}END{if(i==0){print \"Unknown\"}}"`) do set xOpMode=%%i
if /i "%xOpModeOrigin%" == "Unknown" for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1}/xtack started in OpMode/{gsub(/(\(|\))/,\"\");print $6}"`) do set xOpModeOrigin=%%i
for /f "usebackq delims=" %%i in (`type .\bin\xtack.lck^|%xGawk% "BEGIN{IGNORECASE=1}/xtack startup completed on /{gsub(\"xtack startup completed on \",\"\");print $0}"`) do set xTemp=%%i
call :SHOW_MSG "xtack was started in %xOpModeOrigin% OpMode %xOpMode% on %xTemp%.\n"
if /i "%sxsCaller%" == "stop" (
    REM ==> If in silent mode, skip showing the process list altogether:
    if "%xSilentMode%" == "1" goto :SXS_END
)

REM ==> Show the list of processes started by xtack:
call :SHOW_XTACK_PROCESS_LIST

:SXS_END
REM ==> Clean up and return back:
endlocal & set "xTemp=%sxsXtackRunning%" & set sxsXtackRunning=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHUT_DBMS_DOWN: Detects and eventually kills xtack DBMS
REM ==> instances running on the system.
REM ==> Argument #1: DBMS selector.
REM ==> Returns: xtack DBMS shutdown result (in xTemp variable):
REM ==>                0 = xtack DBMS not running
REM ==>                1 = xtack DBMS successfully shut down/killed
REM ==>                2 = xtack DBMS couldn't be shut down/killed
REM -------------------------------------------------------------------------

:SHUT_DBMS_DOWN
setlocal enableextensions
set xdbsdSelector=%~1

REM ==> Check that a correct DBMS selector have been specified,
REM ==> otherwise exit:
echo %xdbsdSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(m55|m57|pgs|mra)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    set xdbsdResult=0
    goto :XDBSD_END
)

REM ==> Infer DBMS binary filename version:
for /f "usebackq delims=" %%i in (`echo %xdbsdSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(m55|m57|mra)/){print \"mysqld.exe\"}else{print \"postgres.exe\"}}"`) do set xdbsdBinary=%%i

REM ==> Check whether the DBMS server binary actually exists:
if not exist .\bin\%xdbsdSelector%\bin\%xdbsdBinary% (
    set xdbsdResult=2
    call :LOG_ENTRY error "SHUT_DBMS_DOWN Sub: DBMS %xdbsdSelector% binary %~dp0bin\%xdbsdSelector%\bin\%xdbsdBinary% does not exist. Now exiting."
    goto :XDBSD_END
)

REM ==> Infer DBMS binary version:
for /f "usebackq delims=" %%i in (`.\bin\%xdbsdSelector%\bin\%xdbsdBinary% --version^|%xGawk% "BEGIN{IGNORECASE=1;s=\"%xdbsdSelector%\"}{if(s ~ /(m55|m57)/){c=\"MySQL\"}else if(s ~ /mra/){c=\"MariaDB\"}else{c=\"PostgreSQL\"};gsub(/(-community|-MariaDB|\(|\))/,\"\");print c\" \"$3}"`) do set xdbsdDbmsVer=%%i
if not "%xSilentMode%" == "1" echo Trying to gracefully shut down xtack %xdbsdDbmsVer% instances ...|%xLog%
if /i "%xdbsdSelector%" == "pgs" goto :XDBSD_POSTGRESQL_SHUTDOWN

REM ==> Check whether the mysqladmin.exe mysqld administration
REM ==> program actually exists:
if not exist .\bin\%xdbsdSelector%\bin\mysqladmin.exe (
    set xdbsdResult=2
    call :LOG_ENTRY error "SHUT_DBMS_DOWN Sub: mysqld administration program binary %~dp0bin\%xdbsdSelector%\bin\mysqladmin.exe does not exist. Now exiting."
    goto :XDBSD_END
)

REM ==> Try to gracefully shut down xtack MySQL instances:
.\bin\%xdbsdSelector%\bin\mysqladmin.exe --user=root --password=root shutdown>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\%xdbsdSelector%\bin\mysqladmin.exe --user=root --password=root shutdown]>> %xLogfile%
goto :XDBSD_CHECK_GRACEFUL_SHUT_DBMS_DOWN

:XDBSD_POSTGRESQL_SHUTDOWN
REM ==> Check whether the pg_ctl.exe utility binary actually exists:
if not exist .\bin\pgs\bin\pg_ctl.exe (
    set xdbsdResult=2
    call :LOG_ENTRY error "SHUT_DBMS_DOWN Sub: pg_ctl utility binary %~dp0bin\pgs\bin\pg_ctl.exe does not exist. Now exiting."
    goto :XDBSD_END
)

REM ==> Try to gracefully shut down xtack PostgreSQL instances:
.\bin\pgs\bin\pg_ctl.exe stop -D "%~dp0dbs\pgs" -s -l "%~dp0logs\xtack_postgresql.log" -m fast>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\pgs\bin\pg_ctl.exe stop -D "%~dp0dbs\pgs" -s -l "%~dp0logs\xtack_postgresql.log" -m fast]>> %xLogfile%

:XDBSD_CHECK_GRACEFUL_SHUT_DBMS_DOWN
REM ==> Wait for the DBMS to shut down:
call :WAIT_FOR_PROCESS "xtack %xdbsdDbmsVer%" "%xdbsdBinary%" "stop" 2000 4 "first"
if "%xTemp%" == "0" goto :XDBSD_XTACK_DBMS_INSTANCES_GRACEFUL_SHUTDOWN_OK

REM ==> RDSBM couldn't be gracefully shut down. Now try to brute kill it:
if not "%xSilentMode%" == "1" echo Now trying to brute kill xtack %xdbsdDbmsVer% instances ...|%xLog%
.\bin\ps.exe -f -k %xdbsdBinary%>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Process Brute Killing Command Executed: .\bin\ps.exe -f -k %xdbsdBinary%]>> %xLogfile%

REM ==> Wait for DBMS to die:
call :WAIT_FOR_PROCESS "xtack %xdbsdDbmsVer%" "%xdbsdBinary%" "stop" 2000 3 "first"
if "%xTemp%" == "0" goto :XDBSD_XTACK_DBMS_INSTANCES_BRUTE_KILLED_OK

REM ==> Inform the user that xtack DBMS instances could not be killed:
echo ERROR: xtack %xdbsdDbmsVer% instances could not be killed ...|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "SHUT_DBMS_DOWN Sub: xtack %xdbsdDbmsVer% instances could not be killed."
set xdbsdResult=2
goto :XDBSD_END

:XDBSD_XTACK_DBMS_INSTANCES_GRACEFUL_SHUTDOWN_OK
REM ==> xtack MySQL instances successfully shut down. Show message and
REM ==> proceed:
set xdbsdResult=1
call :SHOW_MSG "xtack %xdbsdDbmsVer% instances successfully shut down ...\n"
goto :XDBSD_END

:XDBSD_XTACK_DBMS_INSTANCES_BRUTE_KILLED_OK
REM ==> xtack MySQL instances successfully brute killed. Show message
REM ==> and proceed:
set xdbsdResult=1
call :SHOW_MSG "xtack %xdbsdDbmsVer% instances successfully brute killed ...\n"
call :LOG_ENTRY notice "SHUT_DBMS_DOWN Sub: xtack %xdbsdDbmsVer% instances had to be brute killed. Please check."

:XDBSD_END
REM ==> Return back:
endlocal & set "xTemp=%xdbsdResult%" & set xdbsdResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SHUT_HTTP_SERVER_DOWN: Detects and eventually kills xtack HTTP
REM ==> server instances running on the system.
REM ==> Argument #1: HTTP server selector.
REM ==> Returns: xtack HTTP server shutdown result (in xTemp variable).
REM ==>          0 = xtack HTTP server not running
REM ==>          1 = xtack HTTP server successfully shut down/killed
REM ==>          2 = xtack HTTP server couldn't be shut down/killed
REM -------------------------------------------------------------------------

:SHUT_HTTP_SERVER_DOWN
setlocal enableextensions
set xhssSelector=%~1

REM ==> Check that a correct HTTP server selector have been specified,
REM ==> otherwise exit:
echo %xhssSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(a24|ngx|a13|njs|iis)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    set xhssResult=0
    goto :XHSS_END
)

REM ==> Infer HTTP server binary filename, directory and version:
for /f "usebackq delims=" %%i in (`echo %xhssSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /a24/){print \"httpd.exe\"}else if($0 ~ /ngx/){print \"nginx.exe\"}else if($0 ~ /a13/){print \"Apache.exe\"}else if($0 ~ /iis/){print \"iisexpress.exe\"}else{print \"node.exe\"}}"`) do set xhssBinary=%%i
set xhssBinDir=.\bin\%xhssSelector%
if /i "%xhssSelector%" == "a24" set xhssBinDir=%xhssBinDir%\bin
for /f "usebackq delims=" %%i in (`echo %xhssSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(a24|a13)/){print \"Apache \"}else if($0 ~ /ngx/){print \"Nginx \"}else if($0 ~ /iis/){print \"IIS \"}else{print \"Node.js \"}}"`) do set xhssHttpSrvVer=%%i
set xhssSupervision=2000 3

REM ==> Get HTTP server version:
if /i "%xhssSelector%" == "iis" goto :XHSS_GET_IIS_VERSION
for /f "usebackq delims=" %%i in (`%xhssBinDir%\%xhssBinary% -v 2^>^&1^|%xGawk% "/\./{gsub(/(\/|Server version:|nginx version:)/,\" \");gsub(\"v\",\" - \");print \"%xhssHttpSrvVer%\" $2}"`) do set xhssHttpSrvVer=%%i
goto :XHSS_GRACEFULLY

:XHSS_GET_IIS_VERSION
REM ==> IIS Express requires special handling:
set xTemp=
set xhssHttpSrvVer=IIS Express
call :GET_BINARY_VERSION_WMIC "%~dp0bin\iis\iisexpress.exe"
if defined xTemp set xhssHttpSrvVer=%xhssHttpSrvVer%%xTemp%

:XHSS_GRACEFULLY
REM ==> Conditionally add the term "gracefully" for Nginx and Node JS:
for /f "usebackq delims=" %%i in (`echo %xhssSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(a24|a13|iis)/){print \" \"}else{print \" gracefully \"}}"`) do set xhssGracefully=%%i

REM ==> Select shutdown method based on the HTTP server selector:
if not "%xSilentMode%" == "1" echo Trying to%xhssGracefully%shut down xtack %xhssHttpSrvVer% instances ...|%xLog%
if /i "%xhssSelector%" == "ngx" goto :XHSS_NGINX_SHUTDOWN
if /i "%xhssSelector%" == "a13" goto :XHSS_APACHE13_SHUTDOWN
if /i "%xhssSelector%" == "njs" goto :XHSS_NODEJS_SHUTDOWN
if /i "%xhssSelector%" == "iis" goto :XHSS_ISS_SHUTDOWN

REM ==> Try to shut down stack Apache 2.4 instances. According to the Apache
REM ==> 2.4 documentation, if it was started as a console application, the
REM ==> only way to shut it down is by sending it a REM ==> Control-C keyboard
REM ==> sequence. See https://httpd.apache.org/docs/2.4/platform/windows.html
REM ==> This means that for Apache 2.4 we won't do the effort of trying to
REM ==> gracefully shut it down, as it is unfeasible and only causes an
REM ==> undesired delay:
.\bin\ps.exe -f -k httpd.exe>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\ps.exe -f -k httpd.exe]>> %xLogfile%
goto :XHSS_CHECK_HTTP_SRV_SHUTDOWN

:XHSS_NGINX_SHUTDOWN
REM ==> If ngnix binary doesn't exist, jump to brute kill it directly
REM ==> instead:
if not exist .\bin\ngx\nginx.exe goto :XHSS_BRUTE_KILL_HTTP_SRV

REM ==> Try to gracefully shut down xtack ngnix instances:
.\bin\ngx\nginx.exe -c "%~dp0cfg\nginx.conf" -s quit>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\ngx\nginx.exe -c "%~dp0cfg\nginx.conf" -s quit]>> %xLogfile%
goto :XHSS_CHECK_HTTP_SRV_SHUTDOWN

:XHSS_APACHE13_SHUTDOWN
REM ==> If Apache 1.3 binary doesn't exist, jump to brute kill it
REM ==> directly instead:
set xhssSupervision=2000 6
if not exist .\bin\a13\Apache.exe goto :XHSS_BRUTE_KILL_HTTP_SRV

REM ==> Try to gracefully shut down xtack Apache 1.3 instances
REM ==> (Apache.exe -k works for Apache 1.3, contrary to Apache 2.4):
.\bin\a13\Apache.exe -k shutdown -f "%~dp0cfg\apache13.conf">nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\a13\Apache.exe -k shutdown -f "%~dp0cfg\apache13.conf"]>> %xLogfile%
goto :XHSS_CHECK_HTTP_SRV_SHUTDOWN

:XHSS_NODEJS_SHUTDOWN
REM ==> Node.js always needs to be killed with ps.exe:
.\bin\ps.exe -f -k node.exe>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Process Killing Command Executed: .\bin\ps.exe -f -k node.exe]>> %xLogfile%
goto :XHSS_CHECK_HTTP_SRV_SHUTDOWN

:XHSS_ISS_SHUTDOWN
REM ==> Check whether xtack is running as administrator/with elevated
REM ==> permissions (for IIS Express):
set xTemp=0
.\bin\isadmin.exe -q
if "%errorlevel%" == "1" set xTemp=1

REM ==> Check if IIS Express was originally started on HTTP port 80,
REM ==> and so requiring to be killed using elevated permissions:
type .\cfg\iis_port.config|%xGawk% "BEGIN{IGNORECASE=1;i=0}/binding protocol=\042http\042 bindingInformation=\042:80:/{i++}END{if(i==0){exit 1}}"

REM ==> Check if IIS Express requires elevation of permissions to be
REM ==> killed. This happens when xtack.bat not started with admin
REM ==> permissions and HTTP port 80 used upon IIS Express startup:
if /i not "%xTemp%-%errorlevel%" == "0-0" goto :XHSS_BRUTE_KILL_HTTP_SRV

REM ==> Elevated killing required:
set xhssSupervision=3000 20
.\bin\nircmdc.exe elevate .\bin\hidec.exe .\bin\ps.exe -f -k iisexpress.exe>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: .\bin\nircmdc.exe elevate .\bin\hidec.exe .\bin\ps.exe -f -k iisexpress.exe]>> %xLogfile%

:XHSS_CHECK_HTTP_SRV_SHUTDOWN
REM ==> Wait for the HTTP server to shut down:
call :WAIT_FOR_PROCESS "xtack %xhssHttpSrvVer%" "%xhssBinary%" "stop" %xhssSupervision% "first"
if "%xTemp%" == "0" goto :XHSS_XTACK_HTTP_SERVER_INSTANCES_SHUTDOWN_OK
if /i "%xhssSelector%" == "iis" goto :XHSS_HTTP_SRV_COULD_NOT_BE_KILLED

:XHSS_BRUTE_KILL_HTTP_SRV
REM ==> HTTP server couldn't be (gracefully) shut down. Now try to brute
REM ==> kill it (standard way, non elevated permissions):
if not "%xSilentMode%" == "1" echo Now trying to brute kill xtack %xhssHttpSrvVer% instances ...|%xLog%
.\bin\ps.exe -f -k %xhssBinary%>nul 2>nul
if "%xDebugMode%" == "1" echo %xDbgM%Process Brute Killing Command Executed: .\bin\ps.exe -f -k %xhssBinary%]>> %xLogfile%

REM ==> Wait for HTTP server to die:
call :WAIT_FOR_PROCESS "xtack %xhssHttpSrvVer%" "%xhssBinary%" "stop" 2000 3 "first"
if "%xTemp%" == "0" goto :XHSS_XTACK_HTTP_SERVER_INSTANCES_BRUTE_KILLED_OK

:XHSS_HTTP_SRV_COULD_NOT_BE_KILLED
REM ==> Inform the user that xtack HTTP server instances could not be killed:
echo ERROR: xtack %xhssHttpSrvVer% instances could not be killed ...|%xLog%
echo.|%xLog%
call :LOG_ENTRY error "SHUT_HTTP_SERVER_DOWN Sub: xtack %xhssHttpSrvVer% instances could not be killed."
set xhssResult=2
goto :XHSS_END

:XHSS_XTACK_HTTP_SERVER_INSTANCES_SHUTDOWN_OK
REM ==> xtack HTTP server instances successfully shut down. Show message and
REM ==> proceed:
set xhssResult=1
call :SHOW_MSG "xtack %xhssHttpSrvVer% instances successfully shut down ...\n"
goto :XHSS_END

:XHSS_XTACK_HTTP_SERVER_INSTANCES_BRUTE_KILLED_OK
REM ==> xtack HTTP server instances successfully brute killed. Show message
REM ==> and proceed:
set xhssResult=1
call :SHOW_MSG "xtack %xhssHttpSrvVer% instances successfully brute killed ...\n"
call :LOG_ENTRY notice "SHUT_HTTP_SERVER_DOWN Sub: xtack %xhssHttpSrvVer% instances had to be brute killed. Please check."

:XHSS_END
REM ==> Return back:
endlocal & set "xTemp=%xhssResult%" & set xhssResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: SPECIAL_TEST_CASE: Performs a special regression test case.
REM -------------------------------------------------------------------------
:SPECIAL_TEST_CASE

REM ==> Log special regression test info:
echo **********************************************************************|%xRegreLogCmd%
echo Special test case ^"%xMode%^" started on %xTestStart%|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo Launching xtack execution for ^"%xMode%^"|%xRegreLogCmd%
echo Special test case %xSpecialTestCounter% of %xNumOfSpecialTestCases% (^~%xTestPercentage%^%% done). Please wait ...|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo.|%xRegreLogCmd%

REM ==> Launch the special test case:
setlocal
call .\%~nx0 %xMode% -regression
endlocal

REM ==> Perform translation from special test case/xtack command to source
REM ==> logfile:
set stcSourceLogfile=xtack
echo %xMode%| .\tmp\gawk.exe "{print $1}"| .\tmp\gawk.exe "BEGIN{IGNORECASE=1;i=0}/(clean|composer|config|docs|silent|start|status|stop|switch|update|ver)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :STC_SET_LOGFILE
for /f "usebackq delims=" %%i in (`echo %xMode%^|.\tmp\gawk.exe "BEGIN{IGNORECASE=1}{gsub(\"silent\",\"start\");print $1}"`) do set stcSourceLogfile=%%i
set stcSourceLogfile=xtack_%stcSourceLogfile%

:STC_SET_LOGFILE
set stcSourceLogfile=.\logs\%stcSourceLogfile%.log

REM ==> xtack log addition:
if exist %stcSourceLogfile% (
    type %stcSourceLogfile%>> %xLogfile%
) else (
    echo.>> %xLogfile%
    echo ERROR: xtack execution logfile ^(%stcSourceLogfile%^) could not be found!>> %xLogfile%
    echo.>> %xLogfile%
)

REM ==> Get special test case finish timestamp:
for /f "usebackq delims=" %%j in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTestFinish=%%j

REM ==> Calculate the time difference between the start and end of the current
REM ==> OpMode test:
call :TIME_DELTA "%xTestStart%" 1
echo.|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo Special test case for ^"%xMode%^" finished on %xTestFinish%|%xRegreLogCmd%
echo The special test case cycle took %xTookStr%|%xRegreLogCmd%

REM ==> Return back:
set stcSourceLogfile=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: STANDARD_TEST_CASE: Performs a standard regression test case.
REM -------------------------------------------------------------------------

:STANDARD_TEST_CASE
REM ==> First of all, capitalize the standard OpMode requested:
for /f "usebackq delims=" %%j in (`echo %xMode%^|.\tmp\gawk.exe "{gsub(/(^[ \t]*|[ \t]*$)/,\"\");print toupper($0)}"`) do set xMode=%%j

REM ==> Log standard regression test info:
echo **********************************************************************|%xRegreLogCmd%
echo Regression test for OpMode %xMode% started on %xTestStart%|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo Launching xtack start execution for OpMode %xMode%|%xRegreLogCmd%
echo Standard test case %xStandardTestCounter% of %xNumOfStandardTestCases% (^~%xTestPercentage%^%% done). Please wait ...|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo.|%xRegreLogCmd%
.\tmp\ps.exe -d 2000 Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe mysqld.exe postgres.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul

REM ==> Kick off the xtack start/stop cycle:
setlocal
call .\%~nx0 start %xMode% -regression
endlocal

REM ==> Give some additional time for all xtack processes to start up before
REM ==> executing shut down:
.\tmp\ps.exe -d 4000 Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe mysqld.exe postgres.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul

REM ==> xtack startup log addition:
if exist .\logs\xtack_start.log (
    type .\logs\xtack_start.log>> %xLogfile%
) else (
    echo.>> %xLogfile%
    echo ERROR: xtack execution logfile ^(%~dp0log\xtack_start.log^) could not be found%>> %xLogfile%
    echo.>> %xLogfile%
)

REM ==> Log standard regression test info:
echo **********************************************************************|%xRegreLogCmd%
echo Launching xtack stop execution for OpMode %xMode%|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo.|%xRegreLogCmd%
.\tmp\ps.exe -d 2000 Apache.exe httpd.exe nginx.exe node.exe iisexpress.exe mysqld.exe postgres.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul

REM ==> Now we shut down xtack:
setlocal
call .\%~nx0 stop -regression
endlocal

REM ==> xtack shutdown log addition:
if exist .\logs\xtack_stop.log (
    type .\logs\xtack_stop.log>> %xLogfile%
) else (
    echo.>> %xLogfile%
    echo ERROR: Shutdown execution logfile ^(%~dp0log\xtack_stop.log^) could not be found!>> %xLogfile%
    echo.>> %xLogfile%
)

REM ==> Get test cycle finish timestamp:
for /f "usebackq delims=" %%j in (`.\tmp\gawk.exe "BEGIN{print strftime(\"%%Y-%%m-%%d %%H:%%M:%%S\")}"`) do set xTestFinish=%%j

REM ==> Calculate the time difference between the start and end of the
REM ==> current OpMode test:
call :TIME_DELTA "%xTestStart%" 1

echo.|%xRegreLogCmd%
echo **********************************************************************|%xRegreLogCmd%
echo Regression test for OpMode %xMode% finished on %xTestFinish%|%xRegreLogCmd%
echo The xtack start/stop test cycle took %xTookStr%|%xRegreLogCmd%
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: START_BROWSER_UP: Starts a browser up end to end.
REM ==> Argument #1: Browser caption. Valid values are "Firefox", "Chrome",
REM ==>              "Msie", "Edge", "Opera" and "Safari".
REM ==> Argument #2: Download URL to install browser from Internet.
REM ==> Returns: Browser started up OK = 0; otherwise 1 (in xTemp).
REM -------------------------------------------------------------------------

:START_BROWSER_UP
set sbuBrowserCaption=%~1

REM ==> By default report a browser startup error:
set sbuResult=1

REM ==> Check that the requested browser is valid:
echo %sbuBrowserCaption%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(Firefox|Chrome|Msie|Edge|Opera|Safari)/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :SBU_VALID_BROWSER_REQUESTED
echo ERROR: %sbuBrowserCaption% is not a valid browser. It won't be started ...|%xLog%
call :LOG_ENTRY warning "START_BROWSER_UP Sub: Requested browser (%sbuBrowserCaption%) is not valid and cannot be started."
goto :SBU_END

:SBU_VALID_BROWSER_REQUESTED
set sbuBrowserDownloadUrl=%~2

REM ==> Check if Microsoft Edge browser requested on non Windows 10 version:
if /i not "%sbuBrowserCaption%" == "Edge" goto :SBU_GET_BINARY
if /i not "%xWinProduct%" == "Win10" goto :SBU_BROWSER_CANNOT_BE_DETECTED

:SBU_GET_BINARY
REM ==> Infer the browser binary filename from the browser caption:
for /f "usebackq delims=" %%i in (`echo %sbuBrowserCaption%^|%xGawk% "BEGIN{IGNORECASE=1};{gsub(\"Firefox\",\"firefox\");gsub(\"Chrome\",\"chrome\");gsub(\"MSIE\",\"iexplore\");gsub(\"Edge\",\"MicrosoftEdge\");gsub(\"Opera\",\"launcher\");gsub(\"Safari\",\"Safari\");print $0 \".exe\"}"`) do set sbuBrowserBin=%%i

REM ==> Microsoft Edge on Windows 10 has been requested, so skip the
REM ==> binary's detection:
if /i "%sbuBrowserCaption%" == "Edge" goto :SBU_CHECK_IF_KILLING_PREEXISTING_BROWSER_INSTANCES_REQUIRED

REM ==> Infer the registry query to get the full browser binary path:
set sbuRegQuery="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%sbuBrowserBin%"
if /i "%sbuBrowserCaption%" == "Opera" set sbuRegQuery="HKCU\Software\Opera Software"
if /i "%sbuBrowserCaption%" == "Safari" set sbuRegQuery="HKLM\SOFTWARE\Apple Computer, Inc.\Safari"

REM ==> Check whether the browser at least seems to be installed on
REM ==> the system:
.\bin\reg.exe QUERY %sbuRegQuery%>nul 2>nul
if not "%errorlevel%" == "0" goto :SBU_GET_BROWSER_PATH_FROM_XTACK_INI

REM ==> The browser seems to be indeed installed. Get its full path
REM ==> from the Windows registry:
for /f "usebackq delims=" %%i in (`.\bin\reg.exe QUERY %sbuRegQuery% /s^|%xGawk% "/(NO NAME|Last Install Path|BrowserExe)/{gsub(/[ \t]*(\x3cNO NAME\x3e|Last Install Path|BrowserExe)[ \t]*REG_SZ[ \t]*/,\"\");print $0}"`) do set sbuBrowserFullBin=%%i

REM ==> For Opera, the browser binary filename needs to be added:
if "%sbuBrowserCaption%" == "Opera" set sbuBrowserFullBin=%sbuBrowserFullBin%launcher.exe

REM ==> Check whether the binary path extracted from the registry looks valid:
echo %sbuBrowserFullBin%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/.*\\%sbuBrowserBin%/{i++}END{if(i==0){exit 1}}"

REM ==> If not valid, try to get it from xtack.ini:
if "%errorlevel%" == "0" goto :SBU_CHECK_WHETHER_BROWSER_BINARY_ACTUALLY_EXISTS

:SBU_GET_BROWSER_PATH_FROM_XTACK_INI
REM ==> Try to get the browser's full binary path from xtack.ini:
set sbuBrowserFullBin=none
if not exist .\tmp\cfgcache.txt call :FILTER_AND_CACHE_XTACK_INI
type .\tmp\cfgcache.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}/ *%sbuBrowserCaption%Path *= */{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" for /f "usebackq delims=" %%i in (`type .\tmp\cfgcache.txt^|%xGawk% "BEGIN{IGNORECASE=1}/ *%sbuBrowserCaption%Path *= */{gsub(/ *%sbuBrowserCaption%Path *= */,\"\");print $0}"`) do set sbuBrowserFullBin=%%i
if /i "%sbuBrowserFullBin%" == "none" goto :SBU_BROWSER_CANNOT_BE_DETECTED

:SBU_CHECK_WHETHER_BROWSER_BINARY_ACTUALLY_EXISTS
REM ==> Check whether the browser binary actually exists:
dir /b "%sbuBrowserFullBin%">nul 2>nul
if "%errorlevel%" == "0" goto :SBU_CHECK_IF_KILLING_PREEXISTING_BROWSER_INSTANCES_REQUIRED

:SBU_BROWSER_CANNOT_BE_DETECTED
REM ==> The browser could not be detected/started. Show error message and
REM ==> proceed with the next browser:
echo ERROR: %sbuBrowserCaption% cannot be detected or started on this system. You can|%xLog%
echo install it from:|%xLog%
echo %sbuBrowserDownloadUrl%|%xLog%
echo.|%xLog%
call :LOG_ENTRY warning "START_BROWSER_UP Sub: %sbuBrowserCaption% browser not detected or installed on this system."
goto :SBU_END

:SBU_CHECK_IF_KILLING_PREEXISTING_BROWSER_INSTANCES_REQUIRED
REM ==> Check if killing pre-existing browser instances is required
REM ==> (previously checked):
if "%xKillExistingBrowsers%" == "0" goto :SBU_GET_BROWSER_FULLBIN_AND_VER

REM ==> Log and kill pre-existing browser instances:
.\bin\ps.exe %sbuBrowserBin%>nul 2>nul
if not "%errorlevel%" == "0" goto :SBU_GET_BROWSER_FULLBIN_AND_VER
echo Trying to kill pre-existing %sbuBrowserCaption% instances ...|%xLog%
call :LOG_ENTRY notice "START_BROWSER_UP Sub: Trying to close down pre-existing %sbuBrowserCaption% instance(s)."
if /i not "%sbuBrowserCaption%" == "Edge" (
    .\bin\ps.exe -f -c %sbuBrowserBin%>nul 2>nul
) else (
    taskkill /f /im %sbuBrowserBin%>nul 2>nul
)
if "%errorlevel%" == "0" goto :SBU_PREVIOUS_BROWSER_INSTANCES_KILLED_OK

echo ERROR: Pre-existing %sbuBrowserCaption% instances could not be killed ...|%xLog%
goto :SBU_GET_BROWSER_FULLBIN_AND_VER

:SBU_PREVIOUS_BROWSER_INSTANCES_KILLED_OK
REM ==> Pre-existing %sbuBrowserCaption% instances successfully killed. Show
REM ==> message and proceed:
echo Pre-existing %sbuBrowserCaption% instances successfully killed ...|%xLog%
echo.|%xLog%
call :WAIT_FOR_PROCESS "%sbuBrowserCaption%" "%sbuBrowserBin%" "stop" 2000 2 "none"

:SBU_GET_BROWSER_FULLBIN_AND_VER
REM ==> Get the browser full binary path and browser version:
if /i "%sbuBrowserCaption%" == "Edge" goto :SBU_GET_EDGE_FULLBIN_AND_VER
set sbuBrowserFullBin="%sbuBrowserFullBin%"
call :GET_BINARY_VERSION_WMIC %sbuBrowserFullBin%
set sbuBrowserVer=%xTemp%
goto :SBU_EXEC_BROWSER_STARTUP

:SBU_GET_EDGE_FULLBIN_AND_VER
set sbuBrowserFullBin=microsoft-edge:
set sbuBrowserVer=for Windows 10

:SBU_EXEC_BROWSER_STARTUP
REM ==> Show the browser startup message:
echo Starting %sbuBrowserCaption% %sbuBrowserVer%. Please wait ...|%xLog%

REM ==> Check whether a new temporary file with each URL split
REM ==> in a separate line is needed (MSIE, Edge and Safari):
echo %sbuBrowserCaption%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(Msie|Edge|Safari)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :SBU_SKIP_URL_SPLIT_FILE

REM ==> Generate the new temporary file with each URL split in separate lines:
echo %xBrowserURL%|%xGawk% "{gsub(\" \","\"\n\"")};1">.\tmp\sbutmp.txt

:SBU_SKIP_URL_SPLIT_FILE
REM ==> Check if MSIE requested (it requires an especial startup procedure):
if /i not "%sbuBrowserCaption%" == "Msie" goto :SBU_START_NON_MSIE_BROWSER

REM ==> Get the first line:
for /f "usebackq delims=" %%i in (`type .\tmp\sbutmp.txt^|%xGawk% "NR==1"`) do set xTemp=%%i

REM ==> Write the heading of the temporary IE launch VBS file:
echo navOpenInBackgroundTab = ^&h1000>.\tmp\sbuie.vbs
echo set oIE = CreateObject("InternetExplorer.Application")>>.\tmp\sbuie.vbs

REM ==> Print the first URL to the temporary Internet Explorer launch VBS file
REM ==> (first IE tab):
echo oIE.Navigate2 %xTemp%>>.\tmp\sbuie.vbs

REM ==> Print all the remaining URLs to the temporary IE launch VBS file:
for /f "usebackq delims=" %%i in (`type .\tmp\sbutmp.txt^|%xGawk% "NR>1"`) do echo oIE.Navigate2 %%i, navOpenInBackgroundTab>>.\tmp\sbuie.vbs
echo oIE.Visible = true>>.\tmp\sbuie.vbs

REM ==> Run Windows Scripting Host to launch IE in batch mode:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: cscript.exe .\tmp\sbuie.vbs //B //Nologo after %~dp0tmp\sbuie.vbs preparation for xtack start]>> %xLogfile%
cscript.exe .\tmp\sbuie.vbs //B //Nologo
goto :SBU_WAIT_FOR_BROWSER_STARTUP

:SBU_START_NON_MSIE_BROWSER
REM ==> Check if Edge or Safari requested (they require yet another especial
REM ==> startup procedure):
echo %sbuBrowserCaption%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(Edge|Safari)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :SBU_START_FIREFOX_CHROME_OPERA

REM ==> Write the heading of the temporary Edge/Safari launch batch file:
echo @echo off>.\tmp\sbusafedge.bat

REM ==> Print all the start commands to the temporary Edge/Safari launch
REM ==> batch file:
for /f "usebackq delims=" %%i in (`type .\tmp\sbutmp.txt`) do echo start "%sbuBrowserCaption% %sbuBrowserVer%" /D"%~dp0www\" /MAX %sbuBrowserFullBin% %%i|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"microsoft-edge: \",\"microsoft-edge:\");print $0}">>.\tmp\sbusafedge.bat

REM ==> Run the temporary Edge/Safari launch batch file:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: call .\tmp\sbusafedge.bat after %~dp0tmp\sbusafedge.bat preparation]>> %xLogfile%
call .\tmp\sbusafedge.bat
goto :SBU_WAIT_FOR_BROWSER_STARTUP

:SBU_START_FIREFOX_CHROME_OPERA
REM ==> Start the browser:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: start "%sbuBrowserCaption% %sbuBrowserVer%" /D"%~dp0www\" /MAX %sbuBrowserFullBin% %xBrowserURL%]>> %xLogfile%
start "%sbuBrowserCaption% %sbuBrowserVer%" /D"%~dp0www\" /MAX %sbuBrowserFullBin% %xBrowserURL%>nul 2>nul

:SBU_WAIT_FOR_BROWSER_STARTUP
REM ==> Wait for the browser to start up:
call :WAIT_FOR_PROCESS "%sbuBrowserCaption% "%sbuBrowserBin%" "start" 3000 2 "first"
if "%xTemp%" == "0" goto :SBU_BROWSER_STARTED_OK

REM ==> Apparently the browser could not be started. Show error message:
echo ERROR: Apparently %sbuBrowserCaption% %sbuBrowserVer% could not be started!|%xLog%
echo.|%xLog%
call :LOG_ENTRY notice "START_BROWSER_UP Sub: Browser %sbuBrowserCaption% %sbuBrowserVer% could not be started or it took too long to start up."
goto :SBU_END

:SBU_BROWSER_STARTED_OK
REM ==> Show successful browser's startup message:
set sbuResult=0
if /i "%sbuBrowserCaption%" == "Msie" .\bin\nircmdc.exe win max class "IEFrame">nul 2>nul
echo %sbuBrowserCaption% %sbuBrowserVer% started OK ...|%xLog%
echo.|%xLog%

:SBU_END
REM ==> Clean up subroutine temporary files:
del /F /Q .\tmp\sbutmp.txt .\tmp\sbuie.vbs .\tmp\sbusafedge.bat>nul 2>nul

REM ==> Return back:
endlocal & set "xTemp=%sbuResult%" & set sbuResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: START_DBMS_UP: Starts a xtack DBMS.
REM ==> Argument #1: DBMS selector.
REM ==> Returns: xtack DBMS startup result (in xTemp variable):
REM ==>          0 = DBMS successfully started up
REM ==>          1 = DBMS couldn't be started up (server binary unexisting
REM ==>              or unstartable).
REM ==>          2 = DBMS couldn't be started up (essential auxiliary DBMS
REM ==>              binary/utility missing).
REM ==>          3 = DBMS successfully started up but additional tasks could
REM ==>              not be performed due to auxiliary DBMS binary/utility
REM ==>              missing, which could render DBMS unusable.
REM -------------------------------------------------------------------------

:START_DBMS_UP
setlocal enableextensions
set xdbsuDbmsSelector=%~1

REM ==> By default, flag DBMS startup result flag = 1 (DBMS couldn't be
REM ==> started up):
if /i "%xdbsuDbmsSelector%" == "ndb" (
    set xdbsuResult=0
    goto :XDBSU_END
) else (
    set xdbsuResult=1
)

REM ==> Check that a correct DBMS selector has been specified, otherwise exit
REM ==> with error code:
echo %xdbsuDbmsSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(m55|m57|pgs|mra)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    goto :XDBSU_END
)

REM ==> Set default DBMS options as per xtack.ini VerboseDbServer setting:
for /f "usebackq delims=" %%i in (`echo %xdbsuDbmsSelector%-%xVerboseDbServer%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(m55-0|m57-0|mra-0)/){print \"--standalone\"}else if($0 ~ /(m55-1|m57-1|mra-1)/){print \"--standalone --console\"}else if($0 ~ /pgs-1/){print \"-s -l\"}else{print \"-l\"}}"`) do set xdbsuDbmsOptions=%%i

REM ==> Infer DBMS binary filename and directory:
for /f "usebackq delims=" %%i in (`echo %xdbsuDbmsSelector%^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/pgs/{i++;print \"postgres.exe\"}END{if(i==0){print \"mysqld.exe\"}}"`) do set xdbsuDbmsBinary=%%i
set xdbsuBinDir=%~dp0bin\%xdbsuDbmsSelector%\bin

REM ==> Check whether the DBMS server binary actually exists:
if not exist "%xdbsuBinDir%\%xdbsuDbmsBinary%" (
    call :LOG_ENTRY error "START_DBMS_UP Sub: DBMS %xdbsuDbmsSelector% binary %xdbsuBinDir%\%xdbsuDbmsBinary% does not exist. Now exiting."
    goto :XDBSU_END
)

REM ==> Get DBMS version:
for /f "usebackq delims=" %%i in (`echo^|.\bin\%xdbsuDbmsSelector%\bin\%xdbsuDbmsBinary% --version^|%xGawk% "BEGIN{IGNORECASE=1;s=\"%xdbsuDbmsSelector%\"}{if(s ~ /(m55|m57)/){c=\"MySQL\"}else if(s ~ /mra/){c=\"MariaDB\"}else{c=\"PostgreSQL\"};gsub(/(-community|-MariaDB|\(|\))/,\"\");print c\" \"$3}"`) do set xdbsuDbmsVer=%%i

REM ==> If starting PostgreSQL, jump now:
if /i "%xdbsuDbmsSelector%" == "pgs" goto :XDBSU_START_POSTGRESQL_UP

REM ==> Inform the user that MySQL is starting up:
if not "%xSilentMode%" == "1" echo Starting %xdbsuDbmsVer%. Please wait ...|%xLog%

REM ==> Infer MySQL configuration filename to be used:
for /f "usebackq delims=" %%i in (`echo %xdbsuDbmsSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{gsub(\"m5\",\"mysql5\");gsub(\"mra\",\"mariadb\");{print $0}}"`) do set xdbsuTemp=%%i

REM ==> Portabilize MySQL configuration file. If portabilization fails, try
REM ==> a plain copy as fallback:
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\%xdbsuTemp%.ini" "%~dp0cfg\%xdbsuTemp%_port.ini"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\%xdbsuTemp%.ini .\cfg\%xdbsuTemp%_port.ini>nul 2>nul
if /i "%xdbsuDbmsSelector%" == "mra" type .\cfg\%xdbsuTemp%_port.ini|%xGawk% "{gsub(/\\/,\"\\\\\\\\\");print $0}">.\cfg\%xdbsuTemp%_port2.ini & move /Y .\cfg\%xdbsuTemp%_port2.ini .\cfg\%xdbsuTemp%_port.ini>nul 2>nul

REM ==> Execute MySQL startup:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: start "%xdbsuDbmsVer%" /B "%xdbsuBinDir%\%xdbsuDbmsBinary%" --defaults-file=.\cfg\%xdbsuTemp%_port.ini %xdbsuDbmsOptions%]>> %xLogfile%
start "%xdbsuDbmsVer%" /B "%xdbsuBinDir%\%xdbsuDbmsBinary%" --defaults-file=.\cfg\%xdbsuTemp%_port.ini %xdbsuDbmsOptions% 2^>^&1|%xGawk% "BEGIN{IGNORECASE=1;i=0}!/ (starting as process|\[Warning\] Insecure configuration for --secure-file-priv)/{print $0}"
goto :XDBSU_WAIT_FOR_DBMS_TO_START_UP

:XDBSU_START_POSTGRESQL_UP
REM ==> Check whether the pg_ctl.exe utility binary actually exists:
if not exist .\bin\pgs\bin\pg_ctl.exe (
    set xdbsuResult=2
    call :LOG_ENTRY error "START_DBMS_UP Sub: pg_ctl utility binary %~dp0bin\pgs\bin\pg_ctl.exe does not exist. Now exiting."
    goto :XDBSU_END
)

REM ==> Check and initialize PostgreSQL cluster if required:
if not exist .\dbs\pgs md .\dbs\pgs>nul 2>nul
for /f "usebackq delims=" %%i in (`dir /b .\dbs\pgs\^|%xGawk% "BEGIN{i=0} !/.conf/{i++} END{print i}"`) do set xdbsuTemp=%%i
if "%xdbsuTemp%" == "0" call :POSTGRESQL_INIT_CLUSTER "%xdbsuDbmsVer%"

REM ==> Inform the user that the PostgreSQL is starting up:
if not "%xSilentMode%" == "1" echo Starting %xdbsuDbmsVer%. Please wait ...|%xLog%

REM ==> Portabilize PostgreSQL configuration file. If portabilization fails,
REM ==> try a plain copy as fallback:
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\postgresql.conf" "%~dp0dbs\pgs\postgresql.conf"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\postgresql.conf .\dbs\pgs\postgresql.conf>nul 2>nul

REM ==> Execute PostgreSQL startup:
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: "%xdbsuBinDir%\pg_ctl.exe" start -w -t 7 -D "%~dp0dbs\pgs" %xdbsuDbmsOptions% "%~dp0logs\xtack_postgresql.log"]>> %xLogfile%
"%xdbsuBinDir%\pg_ctl.exe" start -w -t 7 -D "%~dp0dbs\pgs" %xdbsuDbmsOptions% "%~dp0logs\xtack_postgresql.log">nul 2>nul

REM ==> If necessary, handle PostgreSQL startup errors:
if "%errorlevel%" == "0" goto :XDBSU_WAIT_FOR_DBMS_TO_START_UP
for /f "usebackq delims=" %%i in (`type .\logs\xtack_postgresql.log^|%xGawk% "/ (FATAL|DETAIL|PANIC):  /{gsub(/\042/,\"\");if($0 ~ / (FATAL|PANIC):  /){fatalLineNo=NR;fatalText=$0}else if($0 ~ / DETAIL:  /){detailLineNo=NR;detailText=$0}} END{gsub(/^^.* (FATAL|DETAIL|PANIC):  /,\"\",fatalText);if(detailLineNo==(fatalLineNo+1)){gsub(/^^.* (FATAL|DETAIL|PANIC):  /,\"\",detailText);printf(\"%%s\n\n\",fatalText \". \n\" detailText)}else{printf(\"%%s\n\n\",fatalText \".\")}}"`) do set xdbsuTemp=%%i

REM ==> If there has been an error while starting PostgreSQL up, warn/log
REM ==> it now:
call :LOG_ENTRY warning "START_DBMS_UP Sub: There were errors while starting up %xdbsuDbmsVer%. The error message is: %xdbsuTemp% Please check."
call :SHOW_MSG "ERROR: There were errors while starting up %xdbsuDbmsVer%."
if not "%xSilentMode%" == "1" call :SHOW_WORDWRAPPED_MSG "%xdbsuDbmsVer% says: %xdbsuTemp% Please google it, fix it and try again ..." 68
goto :XDBSU_END

:XDBSU_WAIT_FOR_DBMS_TO_START_UP
REM ==> Wait for the DBMS to start up:
call :WAIT_FOR_PROCESS "%xdbsuDbmsVer%" "%xdbsuDbmsBinary%" "start" 2000 4 "first"
if "%xTemp%" == "0" goto :XDBSU_DBMS_STARTED_UP_OK

REM ==> DBMS could not be started. Show and log error message and exit:
call :SHOW_MSG "ERROR: %xdbsuDbmsVer% could not be started. Now exiting ..." "ERROR: xtack can't run: %xdbsuDbmsVer% can't be started."
call :LOG_ENTRY error "START_DBMS_UP Sub: %xdbsuDbmsVer% could not be started during xtack startup. Now exiting."
goto :XDBSU_END

:XDBSU_DBMS_STARTED_UP_OK
call :SHOW_MSG "%xdbsuDbmsVer% started OK ...\n"
set xdbsuResult=0

call :SHOW_MSG "Refreshing xtack %xdbsuDbmsVer% users. Please wait ...\n"
if /i "%xdbsuDbmsSelector%" == "pgs" goto :XDBSU_REDEFINE_PGS_ROLES

REM ==> Check whether MySQL's mysql.exe CLI binary actually exists:
if not exist .\bin\%xdbsuDbmsSelector%\bin\mysql.exe (
    set xdbsuResult=3
    call :LOG_ENTRY error "START_DBMS_UP Sub: MySQL CLI binary %~dp0bin\%xdbsuDbmsSelector%\bin\mysql.exe does not exist. Now exiting."
    goto :XDBSU_DBMS_USERS_REDEFINITION_ERROR
)

REM ==> Reset and redefine MySQL password and privileges for the 'root' and
REM ==> 'xtack' users:
if /i "%xdbsuDbmsSelector%" == "m57" goto :XDBSU_MYSQL57_USERS_REDEFINITION_SQL
if /i "%xdbsuDbmsSelector%" == "mra" goto :XDBSU_MARIADB_USERS_REDEFINITION_SQL
echo UPDATE mysql.User SET Password=PASSWORD('root') WHERE User='root';FLUSH PRIVILEGES;DELETE FROM mysql.User WHERE User='xtack';DELETE FROM mysql.User where User='';INSERT INTO mysql.User (Host, User, Password, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections) VALUES('localhost', 'xtack', PASSWORD('xtack123'), 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'N', 'Y', 'Y', 'N', 'N', 'Y', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', '', '', '', 0, 0, 0, 0);FLUSH PRIVILEGES;>.\tmp\xdbstemp1.txt
goto :XDBSU_REDEFINE_MYSQL_USERS

:XDBSU_MYSQL57_USERS_REDEFINITION_SQL
echo CREATE TABLE IF NOT EXISTS mysql.servers (Server_name char(64) NOT NULL DEFAULT '',Host char(64) NOT NULL DEFAULT '',Db char(64) NOT NULL DEFAULT '',Username char(64) NOT NULL DEFAULT '',Password char(64) NOT NULL DEFAULT '',Port int(4) NOT NULL DEFAULT '0',Socket char(64) NOT NULL DEFAULT '',Wrapper char(64) NOT NULL DEFAULT '',Owner char(64) NOT NULL DEFAULT '',PRIMARY KEY (Server_name)) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='MySQL Foreign Servers table';UPDATE mysql.user SET authentication_string=PASSWORD('root'), password_expired='N' WHERE User='root' AND Host='localhost';FLUSH PRIVILEGES;DELETE FROM mysql.User WHERE User='xtack';DELETE FROM mysql.User where User='';INSERT INTO mysql.User (Host, User, authentication_string, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections) VALUES('localhost', 'xtack', PASSWORD('xtack123'), 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'N', 'Y', 'Y', 'N', 'N', 'Y', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', '', '', '', 0, 0, 0, 0);FLUSH PRIVILEGES;>.\tmp\xdbstemp1.txt
goto :XDBSU_REDEFINE_MYSQL_USERS

:XDBSU_MARIADB_USERS_REDEFINITION_SQL
echo UPDATE mysql.User SET Password=PASSWORD('root') WHERE User='root';FLUSH PRIVILEGES;DELETE FROM mysql.User WHERE User='xtack';DELETE FROM mysql.User where User='';INSERT INTO mysql.User (Host, User, Password, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections, authentication_string) VALUES('localhost', 'xtack', PASSWORD('xtack123'), 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'N', 'Y', 'Y', 'N', 'N', 'Y', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', '', '', '', '', 0, 0, 0, 0, '');FLUSH PRIVILEGES;>.\tmp\xdbstemp1.txt

:XDBSU_REDEFINE_MYSQL_USERS
REM ==> First attempt to reset MySQL password using user 'root' with an
REM ==> empty password:
.\bin\%xdbsuDbmsSelector%\bin\mysql.exe --host=localhost --default-character-set=utf8 --verbose --user=root --password= --database=mysql --silent < .\tmp\xdbstemp1.txt>nul 2>.\tmp\xdbstemp2.txt

REM ==> If first attempt unsuccessful, try now using user 'root' with 'root'
REM ==> password. This should work:
if not "%errorlevel%" == "0" (
    del /F /Q .\tmp\xdbstemp2.txt>nul 2>nul
    .\bin\%xdbsuDbmsSelector%\bin\mysql.exe --host=localhost --default-character-set=utf8 --verbose --user=root --password=root --database=mysql --silent < .\tmp\xdbstemp1.txt>nul 2>.\tmp\xdbstemp2.txt
)

REM ==> If there has been an error while refreshing xtack users in DBMS jump
REM ==> to warn/log it now:
if "%errorlevel%" == "0" goto :XDBSU_END

REM ==> Get MySQL error info:
set xdbsuTemp=
for /f "usebackq delims=" %%i in (`type .\tmp\xdbstemp2.txt^|%xGawk% "BEGIN{i=0}/^^ERROR [0-9]{4} .*: /{i++;if(i<2){gsub(/^^ERROR [0-9]{4} .*: /,\"\");print $0}}"`) do set xdbsuTemp=%%i
if not defined xdbsuTemp set xdbsuTemp=noinfo
goto :XDBSU_DBMS_USERS_REDEFINITION_ERROR

:XDBSU_REDEFINE_PGS_ROLES
REM ==> Check whether PostgreSQL's interactive terminal binary actually
REM ==> exists:
if not exist .\bin\pgs\bin\psql.exe (
    set xdbsuResult=3
    call :LOG_ENTRY error "START_DBMS_UP Sub: PostgreSQLs interactive terminal binary %~dp0bin\pgs\bin\psql.exe does not exist. Now exiting."
    goto :XDBSU_DBMS_USERS_REDEFINITION_ERROR
)

REM ==> Check if PostgreSQL 'xtack' role already exists:
set PGPASSWORD=root
.\bin\pgs\bin\psql.exe --dbname=template1 --username=root --command="SELECT * FROM pg_user WHERE usename = 'xtack'"|%xGawk% "BEGIN{IGNORECASE=1;i=0}/\(0 rows\)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    REM ==> Role 'xtack' already exists. Use ALTER command:
    set xdbsuTemp=ALTER
) else (
    REM ==> Role 'xtack' doesn't exist yet. Use CREATE command:
    set xdbsuTemp=CREATE
)

REM ==> Now create or alter the 'xtack' role on the 'template1' and 'postgres' DBs for future use/inheritance:
echo %xdbsuTemp% ROLE xtack WITH PASSWORD 'xtack123' LOGIN CREATEDB;GRANT CREATE, CONNECT, TEMPORARY ON DATABASE template1 to xtack;GRANT CREATE, USAGE ON SCHEMA public TO xtack;GRANT SELECT, UPDATE, INSERT, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public TO xtack;ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, UPDATE, INSERT, DELETE, TRUNCATE ON TABLES TO xtack;>.\tmp\xdbstemp1.txt
echo ^\c postgres root>>.\tmp\xdbstemp1.txt
echo GRANT CREATE, CONNECT, TEMPORARY ON DATABASE postgres to xtack;GRANT CREATE, USAGE ON SCHEMA public TO xtack;GRANT SELECT, UPDATE, INSERT, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public TO xtack;ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, UPDATE, INSERT, DELETE, TRUNCATE ON TABLES TO xtack;>>.\tmp\xdbstemp1.txt
.\bin\pgs\bin\psql.exe --dbname=template1 --username=root --file="%~dp0tmp\xdbstemp1.txt" --quiet 2>.\tmp\xdbstemp2.txt
set PGPASSWORD=

REM ==> If no PostgreSQL errors detected during execution exit, otherwise handle errors:
for /f "usebackq delims=" %%i in (`type .\tmp\xdbstemp2.txt^|%xGawk% "END{print NR}"`) do set xdbsuTemp=%%i
if "%xdbsuTemp%" == "0" goto :XDBSU_END
if "%xSilentMode%" == "1" goto :XDBSU_END

REM ==> Get PostgreSQL error info:
set xdbsuTemp=
for /f "usebackq delims=" %%i in (`type .\tmp\xdbstemp2.txt^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/ ERROR:  /{i++;if(i<2){gsub(/^^.* ERROR:  /,\"\");print $0}}"`) do set xdbsuTemp=%%i
if not defined xdbsuTemp set xdbsuTemp=noinfo

:XDBSU_DBMS_USERS_REDEFINITION_ERROR
REM ==> If there has been an error while refreshing xtack users in DBMS, warn/log it now:
call :LOG_ENTRY warning "START_DBMS_UP Sub: There were errors while refreshing xtack %xdbsuDbmsVer% users. This could render %xdbsuDbmsVer% unusable. Please check."
call :SHOW_MSG "WARNING: There were errors while refreshing %xdbsuDbmsVer% users."
if /i not "%xdbsuTemp%" == "noinfo" call :SHOW_WORDWRAPPED_MSG "%xdbsuDbmsVer% says: %xdbsuTemp%" 68 & echo.|%xLog%

:XDBSU_END
REM ==> Clean up and return back:
del /F /Q .\tmp\xdbstemp1.txt .\tmp\xdbstemp2.txt>nul 2>nul
endlocal & set "xTemp=%xdbsuResult%" & set xdbsuResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: START_HTTP_SERVER_UP: Starts a xtack HTTP server and associated
REM ==> PHP instances.
REM ==> Argument #1: HTTP server selector.
REM ==> Argument #2: PHP version selector.
REM ==> Returns: xtack HTTP server startup result (in xTemp variable):
REM ==>          0 = xtack HTTP server successfully started up
REM ==>          1 = xtack HTTP server couldn't be started up (due to HTTPsrv)
REM ==>          2 = xtack HTTP server couldn't be started up (due to PHP)
REM -------------------------------------------------------------------------

:START_HTTP_SERVER_UP
setlocal enableextensions
set xhsuHttpSrvSelector=%~1
set xhsuPhpSelector=%~2
set xhsuIisHttpPort=80

REM ==> By default, flag HTTP server startup result flag = 1 (HTTP server
REM ==> couldn't be started up):
set xhsuResult=1

REM ==> Check that a correct HTTP server selector has been specified,
REM ==> otherwise exit with error code:
echo %xhsuHttpSrvSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(a24|ngx|a13|njs|iis)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    goto :XHSU_END
)

REM ==> Check that a correct PHP version selector has been specified,
REM ==> otherwise exit with error code:
echo %xhsuPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(p52|p53|p54|p55|p56|p70|p71|p72)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" (
    set xhsuResult=2
    goto :XHSU_END
)

REM ==> Check whether the PHP engine binary actually exists:
if not exist .\bin\%xhsuPhpSelector%\php-cgi.exe (
    set xhsuResult=2
    call :LOG_ENTRY error "START_HTTP_SERVER_UP Sub: PHP %xhsuPhpSelector% binary %~dp0bin\%xhsuPhpSelector%\php-cgi.exe does not exist. Now exiting."
    goto :XHSU_END
)

REM ==> If there are any pre-existing PHP instances, kill them now:
.\bin\ps.exe php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if not "%errorlevel%" == "0" goto :XHSU_INFER_HTTP_SERVER_INFO

REM ==> Try to kill pre-existing PHP instances now:
call :SHOW_MSG "WARNING: There are pre-existing PHP instances running on the system.\nTrying to kill them now ..."
.\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
if "%errorlevel%" == "0" (
    call :SHOW_MSG "Pre-existing PHP instances successfully killed ...\n"
) else (
    call :SHOW_MSG "ERROR: Pre-existing PHP instances could not be killed ...\n"
)

:XHSU_INFER_HTTP_SERVER_INFO
REM ==> Infer HTTP server binary filename, directory and configuration
REM ==> file directive:
for /f "usebackq delims=" %%i in (`echo %xhsuHttpSrvSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /a24/){print \"httpd.exe\"}else if($0 ~ /ngx/){print \"nginx.exe\"}else if($0 ~ /a13/){print \"Apache.exe\"}else if($0 ~ /iis/){print \"iisexpress.exe\"}else{print \"node.exe\"}}"`) do set xhsuHttpSrvBinary=%%i
set xhsuHttpSrvConfig=%~dp0
set xhsuHttpSrvConfig=%xhsuHttpSrvConfig:~0,-1%
set xhsuHttpSrvConfig=%xhsuHttpSrvConfig:\=\\%
for /f "usebackq delims=" %%i in (`echo %xhsuHttpSrvSelector%^|%xGawk% "BEGIN{IGNORECASE=1}{if($0 ~ /(a24|a13)/){gsub(\"a\",\"apache\");print \" -f \042%xhsuHttpSrvConfig%\\cfg\\\\\" $0 \"_port.conf\042 -D PH\" toupper(\"%xhsuPhpSelector%\") \"CGI\"}else if($0 ~ /ngx/){print \" -c \042%xhsuHttpSrvConfig%\\cfg\\nginx_port.conf\042\"}else if($0 ~ /iis/){print \" /trace:error /systray:false /config:\042%xhsuHttpSrvConfig%\\cfg\\iis_port.config\042\"}else{print \" \042%xhsuHttpSrvConfig%\\cfg\\nodejs.js\042\"}}"`) do set xhsuHttpSrvConfig=%%i
set xhsuBinDir=bin\%xhsuHttpSrvSelector%
if /i "%xhsuHttpSrvSelector%" == "a24" set xhsuBinDir=%xhsuBinDir%\bin

REM ==> Check whether the HTTP server binary actually exists:
if not exist "%~dp0%xhsuBinDir%\%xhsuHttpSrvBinary%" (
    call :LOG_ENTRY error "START_HTTP_SERVER_UP Sub: HTTP server %xhsuHttpSrvSelector% binary %~dp0%xhsuBinDir%\%xhsuHttpSrvBinary% does not exist. Now exiting."
    goto :XHSU_END
)

REM ==> Portabilize Apache, Nginx and/or IIS Express configuration file
REM ==> (not necessary for xtack's default NodeJS default application
REM ==> file): If the corresponding configuration file wasn't properly
REM ==> portabilized, try a plain copy as fallback.

REM ==> Portabilize Apache 2.4 configuration file:
if /i not "%xhsuHttpSrvSelector%" == "a24" goto :XHSU_PORT_NGX
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\apache24.conf" "%~dp0cfg\apache24_port.conf"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\apache24.conf .\cfg\apache24_port.conf"
echo %xhsuPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(p71|p72)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XHSU_GET_HTTP_SERVER_VERSION

REM ==> Workaround for PHP 7.1 bug #73885 on Apache 2.4.
REM ==> See https://bugs.php.net/bug.php?id=73885 for details:
echo.>>.\cfg\apache24_port.conf
echo # Workaround for PHP 7.1 bug #73885 on Apache 2.4.>>.\cfg\apache24_port.conf
echo # See https://bugs.php.net/bug.php?id=73885 for details ...>>.\cfg\apache24_port.conf
echo SetEnv TEMP "%TEMP%">>.\cfg\apache24_port.conf
echo SetEnv TMP "%TEMP%">>.\cfg\apache24_port.conf
goto :XHSU_GET_HTTP_SERVER_VERSION

:XHSU_PORT_NGX
REM ==> Portabilize Nginx configuration file:
if /i not "%xhsuHttpSrvSelector%" == "ngx" goto :XHSU_PORT_ISS
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\nginx.conf" "%~dp0cfg\nginx_port.conf"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\nginx.conf .\cfg\nginx_port.conf>nul 2>nul
goto :XHSU_GET_HTTP_SERVER_VERSION

:XHSU_PORT_ISS
REM ==> Portabilize IIS Express configuration file:
if /i not "%xhsuHttpSrvSelector%" == "iis" goto :XHSU_PORT_A13
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\iis.config" "%~dp0tmp\iis.config"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\iis.config .\tmp\iis.config>nul 2>nul
for /f "usebackq delims=" %%i in (`type .\cfg\xtack.ini^|%xGawk% "!/([ \t]*#|^$)/"^|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^[ \t]*IisHttpPort[ \t]*=[ \t]*.*[ \t]*$/{i++;if(i<2){gsub(/([ \t]*IisHttpPort[ \t]*=[ \t]*|[ \t]*$)/,\"\");if($0 ~ /^[0-9]+$/){print $0}else{print \"80\"}}}END{if(i==0){print \"80\"}}"`) do set xhsuIisHttpPort=%%i
type .\tmp\iis.config|%xGawk% "BEGIN{IGNORECASE=1}{gsub(/(\\|\/)(p52|p53|p54|p55|p56|p70|p71|p72)(\\|\/)php-cgi.exe/,\"\\%xhsuPhpSelector%\\php-cgi.exe\");gsub(/virtualDirectory path=\042\\/,\"virtualDirectory path=\042/\");gsub(/binding protocol=\042http\042 bindingInformation=\042:80:/,\"binding protocol=\042http\042 bindingInformation=\042:%xhsuIisHttpPort%:\");print $0}">.\cfg\iis_port.config
del /F /Q .\tmp\iis.config>nul 2>nul
goto :XHSU_GET_HTTP_SERVER_VERSION

:XHSU_PORT_A13
REM ==> Portabilize Apache 1.3 configuration file:
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\apache13.conf" "%~dp0cfg\apache13_port.conf"
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\apache13.conf .\cfg\apache13_port.conf">nul 2>nul
echo %xhsuPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(p71|p72)$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XHSU_GET_HTTP_SERVER_VERSION

REM ==> Workaround for PHP 7.1 bug #73885 on Apache 1.3.
REM ==> See https://bugs.php.net/bug.php?id=73885 for details:
echo.>>.\cfg\apache13_port.conf
echo # Workaround for PHP 7.1 bug #73885 on Apache 1.3.>>.\cfg\apache13_port.conf
echo # See https://bugs.php.net/bug.php?id=73885 for details ...>>.\cfg\apache13_port.conf
echo SetEnv TEMP "%TEMP%">>.\cfg\apache13_port.conf
echo SetEnv TMP "%TEMP%">>.\cfg\apache13_port.conf

:XHSU_GET_HTTP_SERVER_VERSION
REM ==> Get HTTP server version:
if /i "%xhsuHttpSrvSelector%" == "iis" goto :XHSU_GET_IIS_VERSION
for /f "usebackq delims=" %%i in (`.\%xhsuBinDir%\%xhsuHttpSrvBinary% -v 2^>^&1^|%xGawk% "/\./{gsub(/(\/|Server version:|nginx version:)/,\" \");gsub(\"nginx\",\"Nginx\");gsub(\"v\",\" Node.js \");print $1 \" \" $2}"`) do set xhsuHttpSrvVer=%%i
goto :XHSU_PORTABILIZE_PHP_INI

:XHSU_GET_IIS_VERSION
REM ==> IIS Express requires special handling:
set xTemp=
set xhsuHttpSrvVer=IIS Express
call :GET_BINARY_VERSION_WMIC "%~dp0bin\iis\iisexpress.exe"
if defined xTemp set xhsuHttpSrvVer=%xhsuHttpSrvVer%%xTemp%

:XHSU_PORTABILIZE_PHP_INI
REM ==> Secure that all copies of required files are deleted, then
REM ==> portabilize/copy php.ini, phpMyAdmin and phpPgAdmin configuration
REM ==> files:
del /F /Q .\logs\apache??.pid .\logs\nginx.pid .\bin\p52\php.ini .\bin\p53\php.ini .\bin\p54\php.ini .\bin\p55\php.ini .\bin\p56\php.ini .\bin\p70\php.ini .\bin\p71\php.ini .\bin\p72\php.ini .\bin\pma\config.inc.php .\bin\pga\conf\config.inc.php>nul 2>nul

call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\ph%xhsuPhpSelector%.ini" "%~dp0bin\%xhsuPhpSelector%\php.ini"
REM ==> If corresponding php.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y ".\cfg\ph%xhsuPhpSelector%.ini" ".\bin\%xhsuPhpSelector%\php.ini">nul 2>nul

REM ==> Copy DLL required by php_libsodiumXX.dll if PHP >= PHP 5.5 && PHP < PHP 7.2:
echo %xhsuPhpSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/(p55|p56|p70|p71)/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" goto :XHSU_PORTABILIZE_PMA_INI
for /f "usebackq delims=" %%i in (`echo %xhsuPhpSelector%^|%xGawk% "{gsub(/p/,\"\");print $0}"`) do set xTemp=%%i
if not exist .\bin\dlls\libsodium%xTemp%.dll goto :XHSU_PORTABILIZE_PMA_INI
copy /D /V /Y .\bin\dlls\libsodium%xTemp%.dll .\bin\%xhsuPhpSelector%\ext\libsodium.dll>nul 2>nul

:XHSU_PORTABILIZE_PMA_INI
call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\pma.ini" "%~dp0bin\pma\config.inc.php"
REM ==> If corresponding pma.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\pma.ini .\bin\pma\config.inc.php>nul 2>nul

call :PORTABILIZE_XTACK_CONFIG_FILE "%~dp0cfg\pga.ini" "%~dp0bin\pga\conf\config.inc.php"
REM ==> If corresponding pga.ini file not properly portabilized, try a plain
REM ==> copy as fallback:
if not "%xTemp%" == "0" copy /D /V /Y .\cfg\pga.ini .\bin\pga\conf\config.inc.php>nul 2>nul

REM ==> Get PHP binary full version:
for /f "usebackq delims=" %%i in (`.\bin\%xhsuPhpSelector%\php-cgi.exe -v^|%xGawk% "/PHP (5|7)/{print $1 \" \" $2}"`) do set xhsuPhpVer=%%i
if not "%xSilentMode%" == "1" echo Starting %xhsuHttpSrvVer% with %xhsuPhpVer%. Please wait ...|%xLog%
echo %xhsuHttpSrvSelector%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^^(a24|a13|iis)$/{i++}END{if(i==0){exit 1}}"
if "%errorlevel%" == "0" goto :XHSU_START_HTTP_SERVER_UP

REM ==> If starting Nginx or Node.js up, start xtack's php-cgi.exe first:
start "%xhsuPhpVer%" /D"%~dp0" .\bin\hidec.exe .\bin\%xhsuPhpSelector%\php-cgi.exe -b 9000 -c ".\bin\%xhsuPhpSelector%\php.ini">nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: start "%xhsuPhpVer%" /D"%~dp0" .\bin\hidec.exe .\bin\%xhsuPhpSelector%\php-cgi.exe -b 9000 -c ".\bin\%xhsuPhpSelector%\php.ini"]>> %xLogfile%

REM ==> If xtack's php-cgi.exe didn't start properly, exit with error code:
call :WAIT_FOR_PROCESS "%xhsuPhpVer%" "php-cgi.exe" "start" 2000 3 "none"
if "%xTemp%" == "0" goto :XHSU_PHP_CGI_STARTED_OK
set xhsuResult=2

REM ==> php-cgi.exe could not be started. Show and log error message and exit:
call :SHOW_MSG "ERROR: %xhsuPhpVer% for %xhsuHttpSrvVer% could not be started! Now exiting ...\n" "ERROR: xtack can't run: %xhsuPhpVer% for %xHttpSrvVer% can't be started."
call :LOG_ENTRY error "START_HTTP_SERVER_UP Sub: %xhsuPhpVer% for %xhsuHttpSrvVer% could not be started during xtack startup. Now exiting."
goto :XHSU_END

:XHSU_PHP_CGI_STARTED_OK
REM ==> If starting Nginx, first create the temporary directories it requires:
if /i "%xhsuHttpSrvSelector%" == "ngx" call :CREATE_NGINX_DIRS_AND_FILES

:XHSU_START_HTTP_SERVER_UP
REM ==> And now try to start the xtack HTTP server up, but first check whether
REM ==> xtack is running as administrator/with elevated permissions (for IIS Express):
set xTemp=0
.\bin\isadmin.exe -q
if "%errorlevel%" == "1" set xTemp=1

REM ==> Check if IIS Express requires elevation of permissions:
if /i "%xhsuHttpSrvSelector%-%xTemp%-%xhsuIisHttpPort%" == "iis-0-80" (
    set xTemp=/MIN .\bin\nircmdc.exe elevate "%~dp0bin\hidec.exe"
    set xhsuSupervision=3000 20
) else (
    set xTemp=.\bin\hidec.exe
    set xhsuSupervision=2000 4
)
start "%xhsuHttpSrvVer% with %xhsuPhpVer%" /D"%~dp0" %xTemp% "%~dp0%xhsuBinDir%\%xhsuHttpSrvBinary%"%xhsuHttpSrvConfig%>nul
if "%xDebugMode%" == "1" echo %xDbgM%Executed Command: start "%xhsuHttpSrvVer% with %xhsuPhpVer%" /D"%~dp0" %xTemp% "%~dp0%xhsuBinDir%\%xhsuHttpSrvBinary%"%xhsuHttpSrvConfig%]>> %xLogfile%

REM ==> Wait for the HTTP server to start up:
call :WAIT_FOR_PROCESS "%xhsuHttpSrvVer%" "%xhsuHttpSrvBinary%" "start" %xhsuSupervision% "first"
if "%xTemp%" == "0" goto :XHSU_HTTP_SERVER_STARTED_UP_OK
set xhsuResult=1

REM ==> The HTTP server or PHP could not be started. Show and log error
REM ==> message, kill PHP and exit:
call :SHOW_MSG "ERROR: %xhsuHttpSrvVer% could not be started! Now exiting ...\n" "ERROR: xtack can't run: %xHttpSrvVer% can't be started."
call :LOG_ENTRY error "START_HTTP_SERVER_UP Sub: %xhsuHttpSrvVer% could not be started during xtack startup. Now exiting."
.\bin\ps.exe -f -k php.exe php-cgi.exe php-win.exe phpdbg.exe>nul 2>nul
goto :XHSU_END

:XHSU_HTTP_SERVER_STARTED_UP_OK
call :SHOW_MSG "%xhsuHttpSrvVer% with %xhsuPhpVer% started OK ...\n"
set xhsuResult=0

:XHSU_END
REM ==> Return back:
endlocal & set "xTemp=%xhsuResult%" & set xhsuResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: TIME_DELTA: Calculates the time delta between two timestamps.
REM ==> Argument #1: Initial timestamp.
REM ==> Argument #2: If = 1, run gawk.exe from the "tmp" folder instead.
REM -------------------------------------------------------------------------

:TIME_DELTA
setlocal enableextensions
set tdTimestamp1=%~1
set tdGawkDir=%~2
if not defined tdGawkDir set tdGawkDir=0
if not "%tdGawkDir%" == "1" (
    set tdGawkDir=bin
) else (
    set tdGawkDir=tmp
)

REM ==> Get the epoch (number of seconds) difference between the initial
REM ==> and current timestamps:
for /f "usebackq delims=" %%i in (`echo %tdTimestamp1%^|.\%tdGawkDir%\gawk.exe "{gsub(/(-|:)/,\" \");tdDiff=int(systime() - mktime($0));tdTookM=int(tdDiff/60);tdTookS=tdDiff%%60;if(tdTookM==0&&tdTookS>1){print tdTookS \" seconds\"}else if(tdTookM==1&&tdTookS > 1){print \"1 minute and \" tdTookS \" seconds\"}else if(tdTookM > 1&&tdTookS > 1){print tdTookM \" minutes and \" tdTookS \" seconds\"}else if(tdTookM==1&&tdTookS==0){print \"1 minute\"}else if(tdTookM==1&&tdTookS==1){print \"1 minute and 1 second\"}else if(tdTookM > 1&&tdTookS==0){print tdTookM \" minutes\"}else if(tdTookM > 1&&tdTookS==1){print tdTookM \" minutes and 1 second\"}else if(tdTookM==0&&tdTookS==0){print \"0 seconds\"}else if(tdTookM==0&&tdTookS==1){print \"1 second\"}}"`) do set tdTookStr=%%i

REM ==> Clean up and return back:
endlocal & set "xTookStr=%tdTookStr%" & set tdTookStr=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: VERIFY_PGP_SIGNATURE: Verifies a file's PGP signature.
REM ==> Argument #1: Full source file path surrounded by double quotes.
REM ==> Returns: PGP signature verified OK = 0; otherwise 1 (in xTemp).
REM -------------------------------------------------------------------------

:VERIFY_PGP_SIGNATURE
setlocal enableextensions
set vpsSourceFile=%~1

REM ==> Flag verification result as not OK by default:
set vpsResult=1
if not exist "%vpsSourceFile%" goto :VPS_END

REM ==> Infer the signature file name to use in the verification:
set vpsTemp=%vpsSourceFile:\=\\%
for /f "usebackq delims=" %%i in (`echo %vpsTemp%^|%xGawk% -F^. "BEGIN{IGNORECASE=1}{{$NF=\"\"}1;gsub(/[ \t]*$/,\"\");print $0\".sig\"}"`) do set vpsSignatureFile=%%i
set vpsSignatureFile=%vpsSignatureFile:\\=\%
if exist "%vpsSignatureFile%" goto :VPS_CHECK_PUBRING
if "%xDebugMode%" == "1" echo %xDbgM%VERIFY_PGP_SIGNATURE: ERROR: Cannot verify, missing PGP signature for file: "%vpsSourceFile%", which is expected at: "%vpsSignatureFile%"]>> %xLogfile%
goto :VPS_END

:VPS_CHECK_PUBRING
REM ==> Check if GnuPG public keyring file exists:
if exist .\cfg\pubring.gpg goto :VPS_VERIFY

REM ==> Try to recreate the GnuPG public keyring file from the Runtime:
if "%xDebugMode%" == "1" echo %xDbgM%VERIFY_PGP_SIGNATURE: Trying to recreate the GnuPG public keyring file from xtack Runtime to %~dp0cfg\pubring.gpg]>> %xLogfile%
.\bin\7za.exe e -aos -y -o.\cfg\ .\bin\runtime.7z pubring.gpg>nul 2>nul

REM ==> If xtack Runtime expansion successful, proceed:
if "%errorlevel%" == "0" goto :VPS_VERIFY
if "%xDebugMode%" == "1" echo %xDbgM%VERIFY_PGP_SIGNATURE: ERROR: GnuPG public keyring file could not be recreated from xtack Runtime to %~dp0cfg\pubring.gpg]>> %xLogfile%
call :LOG_ENTRY error "VERIFY_PGP_SIGNATURE Sub: GnuPG public keyring file could not be recreated from xtack Runtime to %~dp0cfg\pubring.gpg. Please check."
goto :VPS_END

:VPS_VERIFY
REM ==> Perform PGP signature verification:
if "%xDebugMode%" == "1" echo %xDbgM%VERIFY_PGP_SIGNATURE/Executed Command: .\bin\gpg.exe --homedir .\cfg --verify "%vpsSignatureFile%" "%vpsSourceFile%"]>> %xLogfile%
.\bin\gpg.exe --homedir .\cfg --verify "%vpsSignatureFile%" "%vpsSourceFile%" 2>&1|%xGawk% "{if($0 !~ /(iconv|\.7z)/){gsub(\" \",\"\");printf(\"%s\",tolower($0))}}">nul 2>nul
set vpsTemp=%errorlevel%
if not "%vpsTemp%" == "0" goto :VPS_VERIFICATION_ERROR
set vpsResult=0
if "%xDebugMode%" == "1" echo %xDbgM%VERIFY_PGP_SIGNATURE/SUCCESS: PGP signature verification OK for file "%vpsSourceFile%"]>> %xLogfile%

:VPS_VERIFICATION_ERROR
if "%xDebugMode%%vpsTemp%" == "11" echo %xDbgM%VERIFY_PGP_SIGNATURE/ERROR: PGP signature verification NOK for file "%vpsSourceFile%", GnuPG exit code %vpsTemp%: Bad PGP signature (file incomplete, corrupted or not legitimate)]>> %xLogfile%
if "%xDebugMode%%vpsTemp%" == "12" echo %xDbgM%VERIFY_PGP_SIGNATURE/ERROR: PGP signature verification NOK for file "%vpsSourceFile%", GnuPG exit code %vpsTemp%: CRC error, no signature file found, file doesn't contain a valid PHP signature or the signature could not be verified]>> %xLogfile%
call :LOG_ENTRY error "VERIFY_PGP_SIGNATURE Sub: PGP signature verification NOK for file %vpsSourceFile%, GnuPG exit code %vpsTemp%. Please check."

:VPS_END
endlocal & set "xTemp=%vpsResult%" & set vpsResult=
goto :EOF

REM -------------------------------------------------------------------------
REM ==> SUB: WAIT_FOR_PROCESS: Waits for a process startup/shutdown by going
REM ==> through a defined delay loop.
REM ==> Argument #1: Process caption.
REM ==> Argument #2: Process binary.
REM ==> Argument #3: Wait for operation: "start" or "stop" (default "start")
REM ==> Argument #4: Delay per loop iteration (milliseconds, default 2000)
REM ==> Argument #5: Number of loop iterations (default 1)
REM ==> Argument #6: Show informative message: "all", "first", "none"
REM ==>              (default "none")
REM ==> Returns: Process startup/shutdown OK = 0; otherwise 1 (in xTemp).
REM -------------------------------------------------------------------------

:WAIT_FOR_PROCESS
setlocal enableextensions
set wfpsProcessCaption=%~1
set wfpsProcessBinary=%~2
set wfpsOperation=%~3
set wfpsDelay=%~4
set wfpsIterations=%~5
set wfpsMessageFlag=%~6
set wfpsResult=0
set wfpsLoopCounter=0

REM ==> Verify delay and number of iterations. If not numeric, default them to
REM ==> 2 seconds and 1 iteration:
echo %wfpsDelay%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[0-9]+$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set wfpsDelay=2000
echo %wfpsIterations%|%xGawk% "BEGIN{IGNORECASE=1;i=0}/^[0-9]+$/{i++}END{if(i==0){exit 1}}"
if not "%errorlevel%" == "0" set wfpsIterations=1

REM ==> Validate operation and informative message flag:
if /i not "%wfpsOperation%" == "stop" (
    set wfpsOperation=start
    set wfpsAction=start up
) else (
    set wfpsAction=shut down
)
if /i "%wfpsMessageFlag%" == "all" goto :WFPS_ADJUST_DELAY
if /i "%wfpsMessageFlag%" == "first" goto :WFPS_ADJUST_DELAY
set wfpsMessageFlag=none

:WFPS_ADJUST_DELAY
REM ==> If possible, adjust delay by subtracting 2000 ms to compensate for
REM ==> ps.exe's & WMIC's own delays:
if %wfpsDelay% GEQ 2000 for /f "usebackq delims=" %%i in (`echo %wfpsDelay%^|%xGawk% "END{print %wfpsDelay%-2000}"`) do set wfpsDelay=%%i

:WFPS_DELAY_LOOP
REM ==> Main process startup/shut down check loop. First, delay as requested:
.\bin\ps.exe -d %wfpsDelay% %wfpsProcessBinary%>nul 2>nul

REM ==> Build the caption for the WMIC query to check startup of the
REM ==> requested process:
wmic PROCESS where (Caption="%wfpsProcessBinary%" or Caption="svchost.exe") get Caption|%xGawk% "BEGIN{IGNORECASE=1}/\.exe/"|%xGawk% "a !~ $0;{a=$0}">.\tmp\wfpstemp.txt 2>nul
type .\tmp\wfpstemp.txt|%xGawk% "BEGIN{IGNORECASE=1;i=0}/%wfpsProcessBinary%/{i++}END{if(i==0){exit 1}}"
set wfpsResult=%errorlevel%
del /F /Q .\tmp\wfpstemp.txt>nul 2>nul

if /i "%wfpsOperation%" == "stop" goto :WFPS_CHECK_PROCESS_SHUTDOWN

REM ==> Verify whether the process started up properly:
if "%wfpsResult%" == "0" goto :WFPS_END
goto :WFPS_CHECK_WHETHER_INFO_MESSAGE_HAS_TO_BE_SHOWN

:WFPS_CHECK_PROCESS_SHUTDOWN
REM ==> Verify whether the process shut down properly:
if "%wfpsResult%" == "1" (
    set wfpsResult=0
    goto :WFPS_END
)

:WFPS_CHECK_WHETHER_INFO_MESSAGE_HAS_TO_BE_SHOWN
REM ==> Check and if needed show/log informative message:
if "%xSilentMode%" == "1" goto :WFPS_SKIP_INFO_MESSAGE
if /i "%wfpsMessageFlag%" == "none" goto :WFPS_SKIP_INFO_MESSAGE
if /i "%wfpsMessageFlag%" == "all" goto :WFPS_SHOW_INFO_MESSAGE

REM ==> At this point, the informative message flag is set to first, so check
REM ==> the loop counter:
if not "%wfpsLoopCounter%" == "0" goto :WFPS_SKIP_INFO_MESSAGE

:WFPS_SHOW_INFO_MESSAGE
echo Still waiting for %wfpsProcessCaption% to %wfpsAction%. Please wait ...|%xLog%

:WFPS_SKIP_INFO_MESSAGE
set /a wfpsLoopCounter+=1
if %wfpsLoopCounter% LSS %wfpsIterations% goto :WFPS_DELAY_LOOP

REM ==> The process could not be acted upon (either started up or shut down).
REM ==> Flag and exit:
set wfpsResult=1

:WFPS_END
REM ==> Clean up and return back:
endlocal & set "xTemp=%wfpsResult%" & set wfpsResult=
goto :EOF

REM ==> Do NOT add any further custom code or text beyond the next line! ----
REM ---------- xtack.bat file completeness boundary -------------------------
