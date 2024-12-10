@echo off
REM Activate the Osdag Conda environment
CALL "%~dp0Miniconda3\Scripts\activate.bat" osdag

REM Launch the Osdag application
osdag

REM Keep the command prompt open if the Osdag command fails
IF ERRORLEVEL 1 (
    echo.
    echo Failed to launch Osdag. Please check your Conda environment or installation.
    echo Press any key to exit...
    pause >nul
)
