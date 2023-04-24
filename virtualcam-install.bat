@echo off
@cd /d "%~dp0"
goto checkAdmin

:checkAdmin
	net session >nul 2>&1
	if %errorLevel% == 0 (
		echo.
	) else (
		echo Administrative rights are required, please re-run this script as Administrator.
		goto end
	)

:checkDLL
	echo Checking for 32-bit Virtual Cam registration...
	reg query "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{2B6D7CB2-0E0D-48CC-AF5E-50FC982CE7CF}" >nul 2>&1
	if %errorLevel% == 0 (
		echo 32-bit Virtual Cam found, skipping install...
		echo.
	) else (
		echo 32-bit Virtual Cam not found, installing...
		goto install32DLL
	)

:CheckDLLContinue
	echo Checking for 64-bit Virtual Cam registration...
	reg query "HKLM\SOFTWARE\Classes\CLSID\{2B6D7CB2-0E0D-48CC-AF5E-50FC982CE7CF}" >nul 2>&1
	if %errorLevel% == 0 (
		echo 64-bit Virtual Cam found, skipping install...
		echo.
	) else (
		echo 64-bit Virtual Cam not found, installing...
		goto install64DLL
	)
	goto endSuccess

:install32DLL
	echo Installing 32-bit Virtual Cam...
	if exist "%~dp0\data\obs-plugins\win-dshow\hyper-virtualcam-module32.dll" (
		regsvr32.exe /i /s "%~dp0\data\obs-plugins\win-dshow\hyper-virtualcam-module32.dll"
	) else (
		regsvr32.exe /i /s hyper-virtualcam-module32.dll
	)
	reg query "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{2B6D7CB2-0E0D-48CC-AF5E-50FC982CE7CF}" >nul 2>&1
	if %errorLevel% == 0 (
		echo 32-bit Virtual Cam successfully installed
		echo.
	) else (
		echo 32-bit Virtual Cam installation failed
		echo.
		goto end
	)
	goto checkDLLContinue

:install64DLL
	echo Installing 64-bit Virtual Cam...
	if exist "%~dp0\data\obs-plugins\win-dshow\hyper-virtualcam-module64.dll" (
		regsvr32.exe /i /s "%~dp0\data\obs-plugins\win-dshow\hyper-virtualcam-module64.dll"
	) else (
		regsvr32.exe /i /s hyper-virtualcam-module64.dll
	)
	reg query "HKLM\SOFTWARE\Classes\CLSID\{2B6D7CB2-0E0D-48CC-AF5E-50FC982CE7CF}" >nul 2>&1
	if %errorLevel% == 0 (
		echo 64-bit Virtual Cam successfully installed
		echo.
		goto endSuccess
	) else (
		echo 64-bit Virtual Cam installation failed
		echo.
		goto end
	)

:endSuccess
	echo Virtual Cam installed!
	echo.

:end
	pause
	exit
