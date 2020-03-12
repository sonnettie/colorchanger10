@echo off
ver | find " 10.0." >NUL
if %ERRORLEVEL% NEQ 0 goto :NOT_SUPPORTED

if "%1" NEQ "" if "%2" NEQ "" call :SET_COLOR %1 %2 & exit /b

echo Windows 10 Color Changer v0.1.0
echo.
echo Current color configuration:
call :GET_COLORS
call :PRINT_COLORS
echo.
echo To change one of the following colors use:
echo %~nx0 ^<color_num^> ^<desired_color^>
exit /b

:GET_COLORS
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" ^| findstr AccentPalette') do set "_colors=%%i"
if "%_colors%" == "" set "_colors=A6D8FF0076B9ED00429CE3000078D700005A9E000042750000264200F7630C00"

set "_color1=%_colors:~0,6%"
set "_color2=%_colors:~8,6%"
set "_color3=%_colors:~16,6%"
set "_color4=%_colors:~24,6%"
set "_color5=%_colors:~32,6%"
set "_color6=%_colors:~40,6%"
set "_color7=%_colors:~48,6%"
set "_color8=%_colors:~56,6%"
exit /b

:PRINT_COLORS
call :GET_COLORS
echo Color 1: %_color1%
echo Color 2: %_color2%
echo Color 3: %_color3%
echo Color 4: %_color4%
echo Color 5: %_color5%
echo Color 6: %_color6%
echo Color 7: %_color7%
echo Color 8: %_color8%
exit /b

:SET_COLOR
call :GET_COLORS
set "_colorNum=%1"
if %_colorNum% LSS 1 echo Incorrect color number & exit /b 1
if %_colorNum% GTR 8 echo Incorrect color number & exit /b 1

set "_newColor=%2"
set "_newColor=%_newColor%000000"
set "_color%_colorNum%=%_newColor:~0,6%"

set "_colors=%_color1%00%_color2%00%_color3%00%_color4%00%_color5%00%_color6%00%_color7%00%_color8%00"
set "_colorMenu=ff%_color4:~4,2%%_color4:~2,2%%_color4:~0,2%
set "_colorStart=ff%_color5:~4,2%%_color5:~2,2%%_color5:~0,2%


reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v AccentPalette /t REG_BINARY /d "%_colors%" /f >NUL 2>&1
if %ERRORLEVEL% NEQ 0 echo Failed to set color %_colorNum% to %_newColor:~0,6%. Check if specified color is correct. & exit /b 1

reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v AccentColorMenu /t REG_DWORD /d 0 /f >NUL 2>&1
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent /v AccentColorMenu /t REG_DWORD /d 0x%_colorMenu% /f >NUL 2>&1

echo Set color %_colorNum% to %_newColor:~0,6%!
exit /b

:NOT_SUPPORTED
echo This script is compatible with Windows 10 only.
exit /b
