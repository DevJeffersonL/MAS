@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==============================================================================
:: CYBER-ORBIT : ADVANCED ZERO-FLICKER ANSI ANIMATION ENGINE
:: Compatible with Windows 10 & 11 (Command Prompt & Windows Terminal)
:: ==============================================================================

:: --- 1. CONSOLE CONFIGURATION & ESCAPE CODE INITIALIZATION ---
chcp 65001 >nul 2>&1
mode con: cols=82 lines=32
title CYBER-ORBIT // DEEP SPACE RECONNAISSANCE ENGINE

:: Capture true ANSI Escape character via Command Prompt execution
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Define ANSI Styling & Color Codes
set "RESET=%ESC%[0m"
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[2m"
set "HOME=%ESC%[H"
set "HIDE=%ESC%[?25l"
set "SHOW=%ESC%[?25h"
set "CLEAR=%ESC%[2J"

:: 8-Bit & 24-Bit Color Channels
set "C_TEAL=%ESC%[38;2;0;255;220m"
set "C_BLUE=%ESC%[38;2;40;120;255m"
set "C_DARKBLUE=%ESC%[38;2;15;30;70m"
set "C_ORANGE=%ESC%[38;2;255;135;0m"
set "C_AMBER=%ESC%[38;2;255;190;0m"
set "C_RED=%ESC%[38;2;255;50;50m"
set "C_WHITE=%ESC%[38;2;255;255;255m"
set "C_GRAY=%ESC%[38;2;110;110;120m"
set "C_PURPLE=%ESC%[38;2;180;70;255m"

:: Hide console cursor for cinematic playback
<nul set /p "=%HIDE%%CLEAR%"

:: --- 2. EXECUTION PIPELINE ---
call :Scene_BiosBoot
call :Scene_Countdown
call :Scene_IgnitionAndLaunch
call :Scene_DeepSpaceCruise
call :Scene_HyperdriveWarp
call :Scene_MissionHUD
call :ShutdownEngine
exit /b

:: ==============================================================================
:: SCENE 1: BIOS INITIALIZATION & TELEMETRY BOOT
:: ==============================================================================
:Scene_BiosBoot
<nul set /p "=%HOME%%CLEAR%"
echo %C_TEAL%
echo  ==============================================================================
echo   QUANTUM VECTOR PROPULSION OS v9.4.2 [INITIALIZING AVIONICS]
echo  ==============================================================================%RESET%
echo.

call :TypeWriter " [OK] MOUNTING CRYOGENIC MANIFOLDS..." 15
call :TypeWriter " [OK] CHARGING MAGNETIC CONFINEMENT COILS (45,000 TESLA)..." 15
call :TypeWriter " [OK] ESTABLISHING LOW-EARTH ORBIT UPLINK..." 15
call :TypeWriter " [OK] CALIBRATING REACTION CONTROL THRUSTERS..." 15
echo.

:: Animated Loading Bar
set "BAR_TOTAL=50"
for /l %%i in (1,1,%BAR_TOTAL%) do (
    set "BAR="
    for /l %%j in (1,1,%%i) do set "BAR=!BAR!#"
    set /a "PCT=(%%i * 100) / BAR_TOTAL"
    <nul set /p "=%ESC%[10;1H%C_BLUE% CORE SYNCHRONIZATION: [%C_TEAL%!BAR!%ESC%[38;2;60;60;80m"
    for /l %%k in (%%i,1,%BAR_TOTAL%) do <nul set /p "=."
    <nul set /p "=%C_BLUE%] %C_WHITE%!PCT!%%%RESET%"
    powershell -nop -c "Start-Sleep -Milliseconds 25" >nul 2>&1
)

powershell -nop -c "[console]::beep(880, 120); [console]::beep(1760, 180)" >nul 2>&1
powershell -nop -c "Start-Sleep -Milliseconds 600" >nul 2>&1
exit /b

:: ==============================================================================
:: SCENE 2: TERMINAL COUNTDOWN
:: ==============================================================================
:Scene_Countdown
for /l %%c in (3,-1,1) do (
    <nul set /p "=%HOME%%CLEAR%"
    echo %C_DARKBLUE%
    echo  ..............................................................................
    echo  .  ORBITAL LAUNCH SYSTEM :: T-MINUS METRICS                                    .
    echo  ..............................................................................%RESET%
    echo.
    echo.
    echo                  %C_ORANGE%     .---------------------------.
    echo                       ^|   T-MINUS SYSTEM CLOCK    ^|
    echo                       ^|                           ^|
    if "%%c"=="3" (
        echo                       ^|           %C_WHITE%[ 03 ]%C_ORANGE%           ^|
    )
    if "%%c"=="2" (
        echo                       ^|           %C_AMBER%[ 02 ]%C_ORANGE%           ^|
    )
    if "%%c"=="1" (
        echo                       ^|           %C_RED%[ 01 ]%C_ORANGE%           ^|
    )
    echo                       ^|                           ^|
    echo                       ^|   STAGE 1 COUPLERS LOCKED ^|
    echo                       '---------------------------'%RESET%
    echo.
    powershell -nop -c "[console]::beep(600, 150)" >nul 2>&1
    powershell -nop -c "Start-Sleep -Milliseconds 850" >nul 2>&1
)
exit /b

:: ==============================================================================
:: SCENE 3: THRUSTER IGNITION & GANTRY ASCENT
:: ==============================================================================
:Scene_IgnitionAndLaunch
<nul set /p "=%HOME%%CLEAR%"

:: 8 Ignition flicker cycles before lift-off
for /l %%f in (1,1,10) do (
    <nul set /p "=%HOME%"
    set /a "FLICKER=%%f %% 2"
    call :RenderRocketBase 12 !FLICKER!
    powershell -nop -c "Start-Sleep -Milliseconds 80" >nul 2>&1
)

:: Lift-off ascent sequence (rocket climbs up as screen offsets shift)
for /l %%y in (12,-1,-8) do (
    <nul set /p "=%HOME%"
    call :RenderAscentFrame %%y
    powershell -nop -c "Start-Sleep -Milliseconds 70" >nul 2>&1
)
exit /b

:: Sub-renderer: Rocket on Launch Pad
:RenderRocketBase
set "L_OFFSET=%~1"
set "STATE=%~2"

echo %C_GRAY%
echo             ^|   ^|                                                  ^|   ^|
echo             ^|===^|                      %C_WHITE%/ \                         %C_GRAY%^|===^|
echo             ^|   ^|                     %C_WHITE%/   \                        %C_GRAY%^|   ^|
echo             ^|   ^|                    %C_TEAL%^|  *  ^|                       %C_GRAY%^|   ^|
echo             ^|   ^|                    %C_WHITE%^| [X] ^|                       %C_GRAY%^|   ^|
echo             ^|===^|---[GANTRY]        %C_WHITE%^|  ^|  ^|       [GANTRY]---%C_GRAY%^|===^|
echo             ^|   ^|                   %C_BLUE%/^|  ^|  ^|\                      %C_GRAY%^|   ^|
echo             ^|   ^|                  %C_WHITE%/_^|  ^|  ^|_\                     %C_GRAY%^|   ^|
echo             ^|   ^|                    %C_GRAY%/ === \                       ^|   ^|
echo             ^|===^|                   %C_GRAY%^|_______^|                      %C_GRAY%^|===^|

if "%STATE%"=="0" (
    echo    %C_RED%         ^|   ^|                     %C_ORANGE%(  ( )  )%C_RED%                     ^|   ^|
    echo             ^|   ^|                    %C_AMBER%(   *   )%C_RED%                    ^|   ^|
    echo    %C_GRAY%=========%C_ORANGE%( ( ( ) ) )%C_GRAY%==============%C_AMBER%( ( * ) )%C_GRAY%=========================%C_ORANGE%( ( ) )%C_GRAY%===
    echo   ##############################################################################
) else (
    echo    %C_ORANGE%         ^|   ^|                    %C_AMBER%( ( * ) )%C_ORANGE%                    ^|   ^|
    echo             ^|   ^|                   %C_RED%( ( *** ) )%C_ORANGE%                   ^|   ^|
    echo    %C_GRAY%=========%C_AMBER%( ( * ) )%C_GRAY%================%C_RED%( ( ( ) ) )%C_GRAY%========================%C_AMBER%( ( * ) )%C_GRAY%===
    echo   ##############################################################################
)
exit /b

:: Sub-renderer: Ascent frame displacement
:RenderAscentFrame
set "POS=%~1"
for /l %%s in (1,1,%POS%) do echo.
echo                                %C_WHITE%/ \
echo                               %C_WHITE%/   \
echo                              %C_TEAL%^|  *  ^|
echo                              %C_WHITE%^| [X] ^|
echo                             %C_BLUE%/^|  ^|  ^|\
echo                            %C_WHITE%/_^|  ^|  ^|_\
echo                              %C_GRAY%/ === \
echo                             %C_GRAY%^|_______^|
echo                              %C_ORANGE%(  ( )  )
echo                             %C_AMBER%(   *   )
echo                            %C_RED%( ( *** ) )
echo                             %C_ORANGE%\  *  /
echo                              %C_RED%\ V /
echo                               %C_AMBER%V
for /l %%c in (%POS%,1,16) do (
    echo %C_GRAY%           :                 :                     :                 :
)
exit /b

:: ==============================================================================
:: SCENE 4: DEEP SPACE PARALLAX CRUISE
:: ==============================================================================
:Scene_DeepSpaceCruise
<nul set /p "=%HOME%%CLEAR%"

for /l %%t in (1,1,30) do (
    <nul set /p "=%HOME%"
    set /a "STEP=%%t %% 4"
    call :RenderSpaceFrame !STEP!
    powershell -nop -c "Start-Sleep -Milliseconds 70" >nul 2>&1
)
exit /b

:: Sub-renderer: Parallax star generation with dynamic spaceship
:RenderSpaceFrame
set "F=%~1"

echo %C_DARKBLUE%================================================================================%RESET%
echo %C_TEAL% [CRUISE PHASE: EXOSPHERE STABILIZED]                     SECTOR: 0x88-CYGNUS%RESET%
echo %C_DARKBLUE%--------------------------------------------------------------------------------%RESET%

if "%F%"=="0" (
    echo %C_GRAY%      .                      *                         +                .    %RESET%
    echo %C_WHITE%                +                                  .                            %RESET%
    echo %C_GRAY%  *                                   .                        *             %RESET%
)
if "%F%"=="1" (
    echo %C_WHITE%           +                                 .                      *         %RESET%
    echo %C_GRAY%  .                     *                                    +                %RESET%
    echo %C_GRAY%                                     +              *                    .    %RESET%
)
if "%F%"=="2" (
    echo %C_GRAY%               *                                            .                 %RESET%
    echo %C_GRAY%  +                         .                 *                          +    %RESET%
    echo %C_WHITE%        .                                              +                      %RESET%
)
if "%F%"=="3" (
    echo %C_GRAY%   .                   +                           .                     *    %RESET%
    echo %C_WHITE%        *                                 *                                   %RESET%
    echo %C_GRAY%                               .                                 +            %RESET%
)

echo.
echo                               %C_WHITE%   /^\
echo                               %C_WHITE%  /   \
echo                              %C_TEAL%  ^|  *  ^|
echo                              %C_WHITE%  ^| [X] ^|
echo                             %C_BLUE%  /^|  ^|  ^|\
echo                            %C_WHITE%  /_^|  ^|  ^|_\
echo                              %C_GRAY%  / === \
echo                             %C_GRAY%  ^|_______^|
if "%F%"=="0" (
    echo                              %C_TEAL%   ^|^|   ^|^|
    echo                             %C_BLUE%   /===\ /===\
    echo                            %C_TEAL%   ( ( ) ) ( ) )
) else if "%F%"=="1" (
    echo                              %C_BLUE%   ^|^|   ^|^|
    echo                             %C_TEAL%   /===\ /===\
    echo                            %C_WHITE%    ( * ) ( * )
) else if "%F%"=="2" (
    echo                              %C_TEAL%   ^|^|   ^|^|
    echo                             %C_BLUE%   /===\ /===\
    echo                            %C_BLUE%   ( ( * ) ( * ) )
) else (
    echo                              %C_BLUE%   ^|^|   ^|^|
    echo                             %C_TEAL%   /===\ /===\
    echo                            %C_TEAL%    ( : ) ( : )
)
echo.
echo %C_GRAY%  .                                            *                         +   %RESET%
echo %C_WHITE%        +                     .                                                 %RESET%
echo %C_GRAY%                     *                                    .            *     %RESET%
echo %C_DARKBLUE%================================================================================%RESET%
exit /b

:: ==============================================================================
:: SCENE 5: HYPERDRIVE WARP-SPEED STRETCH
:: ==============================================================================
:Scene_HyperdriveWarp
<nul set /p "=%HOME%%CLEAR%"
echo %C_PURPLE%
echo  >>> CHARGING ALCUBIERRE WARP DRIVE...
echo  >>> DILATING SPACETIME TENSOR METRICS...%RESET%
powershell -nop -c "[console]::beep(440, 100); [console]::beep(880, 150); [console]::beep(1760, 300)" >nul 2>&1

:: Warp Streaks Transition
for /l %%w in (1,1,16) do (
    <nul set /p "=%HOME%"
    set /a "MODE=%%w %% 3"
    call :RenderWarpVectors !MODE!
    powershell -nop -c "Start-Sleep -Milliseconds 55" >nul 2>&1
)
exit /b

:: Sub-renderer: High speed directional vector lines
:RenderWarpVectors
set "M=%~1"
echo %C_BLUE%
if "%M%"=="0" (
    echo %C_PURPLE%  =================   =====================   ===============   ==============
    echo %C_WHITE%  ------------   ---------------------   ---------------   --------------
    echo %C_TEAL%  ==============================================================================
    echo %C_WHITE%        ^| ^|                       /^\                       ^| ^|
    echo %C_WHITE%        ^| ^|                      /   \                      ^| ^|
    echo %C_TEAL%  ======================      ^| [X] ^|      ================================
    echo %C_WHITE%  ----------------------     / ^| ^| \     --------------------------------
    echo %C_WHITE%  ======================    /_^|_^|_^/    ================================
    echo %C_PURPLE%  ------------------------------------------------------------------------------
    echo %C_TEAL%  =================   =====================   ===============   ==============
) else if "%M%"=="1" (
    echo %C_WHITE%  ------------------------------------------------------------------------------
    echo %C_TEAL%  =================   =====================   ===============   ==============
    echo %C_PURPLE%  ------------------------------------------------------------------------------
    echo %C_WHITE%        ^| ^|                       /^\                       ^| ^|
    echo %C_WHITE%        ^| ^|                      /   \                      ^| ^|
    echo %C_WHITE%  ----------------------      ^| [X] ^|      --------------------------------
    echo %C_PURPLE%  ======================     / ^| ^| \     ================================
    echo %C_TEAL%  ----------------------    /_^|_^|_^/    --------------------------------
    echo %C_WHITE%  ==============================================================================
    echo %C_PURPLE%  -----------------   ---------------------   ---------------   --------------
) else (
    echo %C_TEAL%  ==============================================================================
    echo %C_PURPLE%  -----------------   ---------------------   ---------------   --------------
    echo %C_WHITE%  =================   =====================   ===============   ==============
    echo %C_WHITE%        ^| ^|                       /^\                       ^| ^|
    echo %C_WHITE%        ^| ^|                      /   \                      ^| ^|
    echo %C_PURPLE%  ======================      ^| [X] ^|      ================================
    echo %C_WHITE%  ----------------------     / ^| ^| \     --------------------------------
    echo %C_TEAL%  ======================    /_^|_^|_^/    ================================
    echo %C_WHITE%  ------------------------------------------------------------------------------
    echo %C_PURPLE%  ==============================================================================
)
exit /b

:: ==============================================================================
:: SCENE 6: INTERACTIVE MISSION HUD TERMINAL
:: ==============================================================================
:Scene_MissionHUD
<nul set /p "=%HOME%%CLEAR%"
powershell -nop -c "[console]::beep(1318, 120); [console]::beep(1567, 120); [console]::beep(2093, 250)" >nul 2>&1

echo %C_TEAL%
echo  ==============================================================================
echo   MISSION STATUS: HYPERSPACE INSERTION COMPLETE               COORDINATES: ALPHA
echo  ==============================================================================%RESET%
echo.
echo %C_WHITE%       .---.
echo       ^|   ^|           %C_TEAL%TELEMETRY TELEMETRICS DASHBOARD%C_WHITE%
echo       ^|===^|           --------------------------------------------------
echo       ^|   ^|           %C_BLUE%VELOCITY     :%C_WHITE%  0.94c (RELATIVISTIC SPEED)
echo      / \ / \          %C_BLUE%HULL SHIELDS :%C_TEAL%  100%% INTACT [MAGNETIC DEFLECTION ON]
echo     ^|  * *  ^|         %C_BLUE%REACTOR TEMP :%C_AMBER%  3,410 K [STABLE]
echo     ^|  [X]  ^|         %C_BLUE%DESTINATION  :%C_WHITE%  PROXIMA CENTAURI B
echo     ^|_______^|         %C_BLUE%EST. ARRIVAL :%C_WHITE%  4.24 SOLAR YEARS
echo      ^|     ^|
echo     /       \         %C_TEAL%AVIONICS SYSTEM CORE READY FOR COMMAND INPUT.%C_WHITE%
echo    /_       _\        --------------------------------------------------
echo.
echo  ==============================================================================%RESET%
echo %C_GRAY%  [ESC] Clean Shutdown   ^|   [R] Replay Sequence   ^|   Press ANY KEY to Exit
echo  ==============================================================================%RESET%
echo.

:: Interactive selection
set /p "USER_INPUT= %C_TEAL%OPERATOR COMMAND %> %C_WHITE%"
if /i "%USER_INPUT%"=="R" goto :Scene_Countdown
exit /b

:: ==============================================================================
:: ENGINE CORE UTILITIES
:: ==============================================================================

:: Print characters with dynamic micro-delay (Typewriter effect)
:TypeWriter
set "STR=%~1"
set "SPEED=%~2"
for /l %%i in (0,1,80) do (
    set "CHAR=!STR:~%%i,1!"
    if defined CHAR (
        <nul set /p "=%C_TEAL%!CHAR!%RESET%"
        powershell -nop -c "Start-Sleep -Milliseconds %SPEED%" >nul 2>&1
    )
)
echo.
exit /b

:: Safe cleanup for cursor and display terminal
:ShutdownEngine
<nul set /p "=%SHOW%%RESET%%CLEAR%"
echo %C_TEAL%[+] CYBER-ORBIT Terminal Engine safely terminated.%RESET%
echo.
exit /b