; Define the output file name for the installer and set it to require admin privileges
OutFile "osdag_installer.exe"
RequestExecutionLevel user

; Include necessary libraries for Modern UI and dialogs
!include "MUI2.nsh"   ; Include Modern UI 2 library for enhanced GUI
!include "nsDialogs.nsh" ; Include dialogs library for custom dialogs

; Define installer information
!define MUI_WELCOMEPAGE_TITLE "This Setup will guide you through the installation of Osdag  $\r$\n$\r$\nIt will also install some python dependencies that are required to run Osdag$\r$\n $\r$\nPLEASE UNINSTALL ANY EARLIER VERSION OF OSDAG on your system before going ahead (See README.txt for reference)$\r$\n $\r$\nPlease click Next only after uninstalling the earlier version" ; Title for the welcome page
!define MUI_FINISHPAGE_TITLE "Thank You for Installing Osdag"        ; Title for the finish page
!define MUI_ABORTWARNING                ; Display a warning if the user tries to abort installation
!define MUI_ICON "Osdag.ico"            ; Set a custom installer icon 
!define MUI_UNICON "Osdag.ico"          ; Set a custom uninstaller icon 
!define MUI_HEADERIMAGE                 ; Enable a header image for the installer
!define MUI_HEADERIMAGE_BITMAP "Osdag_header.bmp" ; Set the header image file 

; Add Modern UI pages
!insertmacro MUI_PAGE_WELCOME           ; Welcome page
!insertmacro MUI_PAGE_LICENSE "license.txt" ; License agreement page

; Define custom messages for directory page
!define MUI_DIRECTORYPAGE_TEXT_TOP "Select Miniconda Installation Directory"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Choose the folder where Miniconda is/will be installed:"

; Add directory selection page before installation files page
!define MUI_PAGE_CUSTOMFUNCTION_PRE DirectoryPagePre
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES         ; Installation progress page
!insertmacro MUI_PAGE_FINISH            ; Finish page

; Set the installer language to English
!insertmacro MUI_LANGUAGE "English"

; Define the installer name and branding text
Name "Osdag"

; Declare variables for storing paths
Var /GLOBAL condaPath  
Var /GLOBAL miktexPath 
Var /GLOBAL env_name   
Var /GLOBAL osdagIconPath 
Var /GLOBAL osdagShortcutPath
; Custom variables for directory selection
Var CONDA_INSTALL_TYPE


; Define custom messages
!define MINICONDA_DIALOG_TITLE "Miniconda Installation"
!define MINICONDA_DIALOG_TEXT "Do you already have Miniconda or Anaconda installed on your system?$\n$\nIf you're not sure, choose No and we'll install it for you."

; Custom function to set up directory page
Function DirectoryPagePre
    ; Ask if Miniconda is already installed
    MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "${MINICONDA_DIALOG_TEXT}" /SD IDNO IDYES +3 IDNO +4
    
    ; ExistingInstall (IDYES)
    StrCpy $CONDA_INSTALL_TYPE "existing"
    ${If} ${FileExists} "$PROFILE\miniconda3"
        StrCpy $INSTDIR "$PROFILE\miniconda3"
    ${EndIf}
    Goto done
    
    ; NewInstall (IDNO)
    StrCpy $CONDA_INSTALL_TYPE "new"
    StrCpy $INSTDIR "$PROFILE\miniconda3"
    
    done:
FunctionEnd

; Section to handle Miniconda installation
Section "Miniconda Installation"
    SetOutPath "$TEMP"
    File /oname=MinicondaInstaller.exe "Miniconda3-latest-Windows-x86_64.exe"

    StrCpy $condaPath $INSTDIR

    ${If} $CONDA_INSTALL_TYPE == "new"
        DetailPrint "Installing Miniconda. It may take some time..."
        ExecWait '"$TEMP\MinicondaInstaller.exe" /InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /D=$condaPath'
        ${If} ${Errors}
            MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to install Miniconda.$\n$\nPossible reasons:$\n- Insufficient system permissions$\n- Corrupted installer$\n- Antivirus blocking installation$\n$\nPlease try running the installer as administrator or contact support."
            Quit
        ${EndIf}
    ${EndIf}

    DetailPrint "Miniconda Found at: $condaPath"
SectionEnd

; Section to install Osdag using the Miniconda environment
Section "install osdag"
    ; Print a message indicating the creation of a Conda environment
    DetailPrint "Creating environment for osdag"
    StrCpy $1 "$condaPath\Scripts\conda.exe" ; Path to the Conda executable

    ${If} ${FileExists} "$1"
        ; Assign a name for the Conda environment
        StrCpy $env_name "osdag_env"   

        ; Create Osdag env
        DetailPrint "Creating Osdag environment..."
        nsExec::ExecToStack /TIMEOUT=3600000 'cmd.exe /C ""$1" create -n $env_name -y >nul 2>&1"'
        Pop $R0
        ${If} $R0 != "0"
            MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to create Conda environment.$\n$\nPlease try again or contact support."
            Quit
        ${EndIf}
        DetailPrint "Osdag environment created successfully"
        
        ; Install Osdag in the created Conda environment
        DetailPrint "Installing Osdag (this may take several minutes)..."
        nsExec::ExecToStack /TIMEOUT=3600000 'cmd.exe /C ""$1" install -n $env_name osdag::osdag -c conda-forge -y >nul 2>&1"'
        Pop $R0
        ${If} $R0 != "0"
            MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to install Osdag.$\n$\nPlease check your internet connection and try again."
            Quit
        ${EndIf}
        DetailPrint "Osdag installed successfully"
    ${Else}
        MessageBox MB_ICONSTOP|MB_TOPMOST "Error: Conda executable not found at $1.$\n$\nPlease ensure Miniconda is properly installed."
        Quit
    ${EndIf}

SectionEnd

Section "LaTeX Installation"
    ; Clear any existing errors
    ClearErrors

    ; Copy the MikTeX installer to the temporary directory
    SetOutPath $TEMP
    File /oname=MiKTeX.exe "basic-miktex-24.1-x64.exe"

    ; Check for existing MiKTeX installation by checking default path and pdflatex command
    DetailPrint "Checking for existing MiKTeX installation..."
    ${If} ${FileExists} "$PROFILE\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe"
        DetailPrint "MiKTeX executable found at: $PROFILE\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe"
        StrCpy $miktexPath "$PROFILE\AppData\Local\Programs\MiKTeX"
    ${Else}
        ; Try to get path using where command without redirecting output
        nsExec::ExecToStack 'cmd.exe /C "where pdflatex"'
        Pop $R0  
        Pop $R1  
        ${If} $R1 != ""
            DetailPrint "MiKTeX found executable at: $R1"
            StrCpy $miktexPath $R1
        ${Else}
            DetailPrint "MiKTeX not found, starting installation..."
            StrCpy $miktexPath "$PROFILE\AppData\Local\Programs\MiKTeX"
            ExecWait '"$TEMP\MiKTeX.exe" /D=$miktexPath'
            ${If} ${Errors}
                MessageBox MB_ICONSTOP|MB_TOPMOST "Failed to install MiKTeX.$\n$\nPossible reasons:$\n- Insufficient system permissions$\n- Corrupted installer$\n- Antivirus blocking installation$\n$\nPlease try running the installer as administrator or contact support."
                Quit
            ${EndIf}
            DetailPrint "MiKTeX installed successfully"
            MessageBox MB_ICONINFORMATION|MB_TOPMOST "MiKTeX has been installed successfully.$\n$\nImportant:$\n- Please run MiKTeX Console to check for updates$\n- Updates are required for proper functioning of Osdag"
        ${EndIf}
    ${EndIf}
SectionEnd

; Section to create shortcuts for Osdag
Section "Create Desktop and Start Menu Shortcuts"
    ; Path for the desktop shortcut
    StrCpy $osdagShortcutPath "$DESKTOP\Osdag.lnk"

    SetOutPath $TEMP
    File /oname=Osdag_App_icon.ico "C:\Users\1hasa\Osdag\installer\Osdag_App_icon.ico"

    CopyFiles "$TEMP\Osdag_App_icon.ico" "$condaPath\envs\$env_name\Lib\site-packages\osdag\data\ResourceFiles\images"
    StrCpy $osdagIconPath "$condaPath\envs\$env_name\Lib\site-packages\osdag\data\ResourceFiles\images\Osdag_App_icon.ico"
    
    ; Create a desktop shortcut for Osdag
    DetailPrint "Creating Desktop Shortcut for Osdag..."
    CreateShortcut "$osdagShortcutPath" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag" "$osdagIconPath"

    ; Create a Start Menu shortcut for Osdag
    DetailPrint "Creating Start Menu Shortcut for Osdag..."
    CreateDirectory "$SMPROGRAMS\Osdag"
    CreateShortcut "$SMPROGRAMS\Osdag\Osdag.lnk" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag" "$osdagIconPath"

    ; Add uninstaller script
    WriteUninstaller "$SMPROGRAMS\Osdag\Uninstall.exe"

    # Add to Control Panel/Registry Keys
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayName" "Osdag"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "UninstallString" "$SMPROGRAMS\Osdag\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "InstallLocation" "$condaPath\envs\$env_name"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayIcon" $osdagIconPath

    ; Need to be coonfirmed
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "Publisher" "Osdag"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayVersion" "1.0"
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "NoModify" 1
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "NoRepair" 1

    ; Notify the user that the shortcuts have been created
    DetailPrint "Desktop and Start Menu shortcuts for Osdag have been created."
SectionEnd


Section "Cleanup Temporary Files"
    DetailPrint "Cleaning up temporary files..."
    
    ; Delete Miniconda installer
    Delete "$TEMP\MinicondaInstaller.exe"
    ${If} ${FileExists} "$TEMP\MinicondaInstaller.exe"
        DetailPrint "Failed to delete MinicondaInstaller.exe"
    ${Else}
        DetailPrint "Deleted MinicondaInstaller.exe"
    ${EndIf}

    ; Delete MikTeX installer
    Delete "$TEMP\MiKTeX.exe"
    ${If} ${FileExists} "$TEMP\MiKTeX.exe"
        DetailPrint "Failed to delete MiKTeX.exe"
    ${Else}
        DetailPrint "Deleted MiKTeX.exe"
    ${EndIf}

    ; Delete any other temporary files
    Delete "$TEMP\pdflatex_check.txt"
    Delete "$TEMP\Osdag_App_icon.ico"
    


    DetailPrint "Temporary files cleanup completed."
SectionEnd



; Uninstaller Section
Section "Uninstall"

    ; remove osdag conda environment
    Var /GLOBAL condaEnvPath
    ReadRegStr $condaEnvPath HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "InstallLocation"
    RMDir /r "$condaEnvPath"

    ; remove app shortcuts
    Delete "$DESKTOP\Osdag.lnk"
    Delete "$SMPROGRAMS\Osdag\Osdag.lnk"

    ; remove uninstaller
    Delete "$SMPROGRAMS\Osdag\Uninstall.exe"
    RMDir /r "$SMPROGRAMS\Osdag"

    # Remove registry keys
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag"

    MessageBox MB_OK|MB_TOPMOST "Osdag Unistalled. You can remove MikTeX and Conda mannually" 

SectionEnd