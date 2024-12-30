; Define the output file name for the installer and set it to require admin privileges
OutFile "osdag_installer.exe"
RequestExecutionLevel admin

; Include necessary libraries for Modern UI and dialogs
!include "MUI2.nsh"   ; Include Modern UI 2 library for enhanced GUI
!include "nsDialogs.nsh" ; Include dialogs library for custom dialogs

; Define installer information
!define MUI_WELCOMEPAGE_TITLE "Welcome to the Osdag Installer Wizard" ; Title for the welcome page
!define MUI_FINISHPAGE_TITLE "Thank You for Installing Osdag"        ; Title for the finish page
!define MUI_ABORTWARNING                ; Display a warning if the user tries to abort installation
!define MUI_ICON "Osdag.ico"            ; Set a custom installer icon (optional)
!define MUI_HEADERIMAGE                 ; Enable a header image for the installer
!define MUI_HEADERIMAGE_BITMAP "Osdag_header.bmp" ; Set the header image file (optional)

; Add Modern UI pages
!insertmacro MUI_PAGE_WELCOME           ; Welcome page
!insertmacro MUI_PAGE_LICENSE "license.txt" ; License agreement page
; !insertmacro MUI_PAGE_DIRECTORY         ; Commented out directory selection page
!insertmacro MUI_PAGE_INSTFILES         ; Installation progress page
!insertmacro MUI_PAGE_FINISH            ; Finish page

; Set the installer language to English
!insertmacro MUI_LANGUAGE "English"

; Define the installer name and branding text
Name "Osdag"

; Declare variables for storing paths
Var condaPath       

; Section to handle Miniconda installation
Section "Miniconda Installation"
    ; Set the output path for temporary files
    SetOutPath "$TEMP"
    
    ; Copy the Miniconda installer to the temporary directory
    File /oname=MinicondaInstaller.exe "c:\Users\1hasa\Downloads\Miniconda3-latest-Windows-x86_64.exe"

    ; Ask the user if Miniconda/Anaconda is already installed
    MessageBox MB_YESNO|MB_ICONQUESTION "Is Miniconda/Anaconda already installed on your system?" IDYES YesMiniconda IDNO NoMiniconda

    YesMiniconda:
        ; Create a dialog to let the user select the existing installation folder
        nsDialogs::Create
        nsDialogs::SelectFolderDialog "Select the folder where Miniconda/Anaconda is installed" "" $condaPath
        Pop $condaPath
        ${If} $condaPath == ""
            ; Abort installation if no directory is selected
            MessageBox MB_ICONEXCLAMATION "No directory selected. Installation will not continue."
            Abort
        ${EndIf}
        
        ; Go to the section that verifies the installation path
        Goto PathFound

    NoMiniconda:
        ; Set the default installation path if Miniconda is not already installed
        StrCpy $condaPath "$PROFILE\Miniconda3"
        DetailPrint "Installing Miniconda. It may take some time..."
        
        ; Perform a silent installation of Miniconda
        ExecWait '"$TEMP\MinicondaInstaller.exe" /InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /S /D=$condaPath'
        
        ; Go to the section that verifies the installation path
        Goto PathFound
        
    PathFound:
        ; Print the detected or installed Miniconda path
        DetailPrint "Miniconda Found at: $condaPath"

SectionEnd

; Section to install Osdag using the Miniconda environment
Section "install osdag"
    ; Print a message indicating the creation of a Conda environment
    DetailPrint "Creating environment for osdag"
    StrCpy $1 "$condaPath\Scripts\conda.exe" ; Path to the Conda executable

    ${If} ${FileExists} "$1"
        ; Declare and assign a name for the Conda environment
        Var /GLOBAL env_name
        StrCpy $env_name "osdag_env"  

        ; Create the Conda environment
        DetailPrint "Creating Conda environment $env_name..."
        nsExec::ExecToLog 'cmd.exe /C ""$1" create -y -n $env_name"'

        ; Install Osdag in the created Conda environment
        DetailPrint "Installing osdag..."
        nsExec::ExecToLog 'cmd.exe /C ""$1" install -n $env_name -y osdag::osdag"'

        MessageBox MB_OK "Conda environment $env_name successfully created and osdag installed."
    ${Else}
        ; Display an error message if Conda executable is not found
        MessageBox MB_ICONSTOP "Error: Conda executable not found at $1. Please check the path."
        Abort
    ${EndIf}

SectionEnd

; Section to create shortcuts for Osdag
Section "Create Desktop and Start Menu Shortcuts"
    ; Define the path for the desktop shortcut
    Var /GLOBAL osdagShortcutPath
    StrCpy $osdagShortcutPath "$DESKTOP\Osdag.lnk"

    ; Define the path for App icon
    Var /GLOBAL osdagIconPath 
    StrCpy $osdagIconPath "$condaPath\envs\$env_name\Lib\site-packages\osdag\data\ResourceFiles\images\Osdag_App_icon.ico"
    CopyFiles "Osdag_App_icon.ico" "$condaPath\envs\$env_name\Lib\site-packages\osdag\data\ResourceFiles\images"

    ; Create a desktop shortcut for Osdag
    DetailPrint "Creating Desktop Shortcut for Osdag..."
    CreateShortcut "$osdagShortcutPath" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag" "$osdagIconPath"

    ; Create a Start Menu shortcut for Osdag
    DetailPrint "Creating Start Menu Shortcut for Osdag..."
    CreateDirectory "$SMPROGRAMS\Osdag"
    CreateShortcut "$SMPROGRAMS\Osdag\Run Osdag.lnk" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag" "$osdagIconPath"

    ; Notify the user that the shortcuts have been created
    MessageBox MB_OK "Desktop and Start Menu shortcuts for Osdag have been created."
SectionEnd
