!include "LogicLib.nsh"

# Define installer output name
Outfile "OsdagInstaller.exe"

# Installation directory
InstallDir "$PROGRAMFILES\osdag"

# Request admin privileges for the installer
RequestExecutionLevel admin

# Variable to hold Miniconda installation directory
Var MinicondaPath

# Function to find Miniconda installation path using the environment variable and registry
Function FindMinicondaPath
    # Check if Miniconda is in the system PATH using System::Call
    System::Call 'kernel32::GetEnvironmentVariableA(t "Miniconda3", t .r0, i ${NSIS_MAX_STRLEN}) ?e'
    StrCpy $MinicondaPath $0
    ${If} $MinicondaPath == ""
        MessageBox MB_OK "Miniconda not found in PATH. Checking registry..."
        ReadRegStr $MinicondaPath HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Miniconda3" "InstallLocation"
        ${If} $MinicondaPath == ""
            ReadRegStr $MinicondaPath HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Miniconda3" "InstallLocation"
        ${EndIf}
    ${EndIf}

    ${If} $MinicondaPath == ""
        MessageBox MB_OK "Miniconda is not installed. Installing Miniconda..."
        StrCpy $MinicondaPath "$INSTDIR\Miniconda3"
        File "C:\Users\1hasa\Downloads\Miniconda3-latest-Windows-x86_64.exe"
        ExecWait '"$INSTDIR\Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=$MinicondaPath' $0
        ${If} $0 != "0"
            MessageBox MB_OK "Failed to install Miniconda. Installation aborted."
            Abort
        ${EndIf}
    ${EndIf}
FunctionEnd

# Define installation steps
Section "Install"
    # Find Miniconda installation path (from PATH or registry)
    Call FindMinicondaPath

    # Set the installation directory for OSdag
    SetOutPath $INSTDIR

    # Bundle the batch file for launching OSdag
    File "launch_osdag.bat"

    # Ensure Conda is usable by setting up the environment
    ExecWait '"$MinicondaPath\Scripts\conda.exe" init powershell' $0
    ExecWait '"$MinicondaPath\Scripts\conda.exe" init cmd.exe' $0

    # Add conda-forge channel and prioritize it
    ExecWait '"$MinicondaPath\Scripts\conda.exe" config --add channels conda-forge' $0
    ExecWait '"$MinicondaPath\Scripts\conda.exe" config --set channel_priority strict' $0

    # Create the Conda environment and install the package from ajinkyadahale channel
    ExecWait '"$MinicondaPath\Scripts\conda.exe" create -y -n osdag -c ajinkyadahale osdag > $INSTDIR\installation.log' $0
    ${If} $0 != "0"
        MessageBox MB_OK "Failed to create Conda environment. Check installation.log for details."
        Abort
    ${EndIf}

    # Create a desktop shortcut for the batch file
    CreateShortCut "$DESKTOP\Launch Osdag.lnk" "$INSTDIR\launch_osdag.bat"

    # Write uninstaller executable
    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

# Define uninstallation steps
Section "Uninstall"
    MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to remove Miniconda as well?" IDNO SkipMinicondaRemoval
        ; Safely remove Miniconda directory
        RMDir /r "$MinicondaPath"
        MessageBox MB_OK "Miniconda has been removed."
    SkipMinicondaRemoval:
        ; Continue with the rest of the uninstall or cleanup process

    # Remove the batch script and shortcut
    Delete "$INSTDIR\launch_osdag.bat"
    Delete "$DESKTOP\Launch Osdag.lnk"

    # Remove installation directory
    RMDir /r $INSTDIR
SectionEnd
