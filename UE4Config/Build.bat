@echo off
setlocal enabledelayedexpansion

REM Pablo: Modification to play audio cues outside UE4 editor and color build screen:
nircmd mediaplay 1000 "%~dp0\..\..\Content\EditorSounds\Notifications\CompileStart_Cue.wav"
powershell write-host -fore Cyan "BUILD START"
REM Pablo: Modification end

REM The %~dp0 specifier resolves to the path to the directory where this .bat is located in.
REM We use this so that regardless of where the .bat file was executed from, we can change to
REM directory relative to where we know the .bat is stored.
pushd "%~dp0\..\..\Source"

REM %1 is the game name
REM %2 is the platform name
REM %3 is the configuration name

IF EXIST ..\..\Engine\Binaries\DotNET\UnrealBuildTool.exe (
        ..\..\Engine\Binaries\DotNET\UnrealBuildTool.exe %*
		popd

		REM Ignore exit codes of 2 ("ECompilationResult.UpToDate") from UBT; it's not a failure.
		if "!ERRORLEVEL!"=="2" (
			EXIT /B 0
		)

		REM Pablo: Modification to play audio cues outside of UE4 editor:
		if "!ERRORLEVEL!"=="0" (
			powershell write-host -fore Green "SUCCESS"
			nircmd mediaplay 1000 "%~dp0\..\..\Content\EditorSounds\Notifications\CompileSuccess_Cue.wav"
			EXIT /B 0
		)
		powershell write-host -fore Red "BUILD FAILED - See above errors ^"
		nircmd mediaplay 1000 "%~dp0\..\..\Content\EditorSounds\Notifications\CompileFailed_Cue.wav"
		REM Pablo: Modification end

		EXIT /B !ERRORLEVEL!
) ELSE (
	ECHO UnrealBuildTool.exe not found in ..\..\Engine\Binaries\DotNET\UnrealBuildTool.exe 
	popd
	EXIT /B 999
)


