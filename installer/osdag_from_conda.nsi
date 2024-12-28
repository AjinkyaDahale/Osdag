OutFile "osdag_installer.exe"
RequestExecutionLevel admin

!include "MUI2.nsh"   ; Include Modern UI 2
!include "nsDialogs.nsh"


; Define installer information
!define MUI_WELCOMEPAGE_TITLE "Welcome to the Osdag Installer Wizard" ; Title for the welcome page
!define MUI_FINISHPAGE_TITLE "Thank You for Installing Osdag"        ; Title for the finish page
!define MUI_ABORTWARNING                ; Warn the user if they attempt to abort the installation
!define MUI_ICON "Osdag.ico"        ; Set installer icon (optional)
!define MUI_HEADERIMAGE                 ; Enable header image
!define MUI_HEADERIMAGE_BITMAP "Osdag_header.bmp" ; Header image file (optional)

; Modern UI Pages
!insertmacro MUI_PAGE_WELCOME           ; Welcome page
!insertmacro MUI_PAGE_LICENSE "license.txt" ; License agreement page
; !insertmacro MUI_PAGE_DIRECTORY         ; Installation directory selection page
!insertmacro MUI_PAGE_INSTFILES         ; Installation progress page
!insertmacro MUI_PAGE_FINISH            ; Finish page

; Language selection
!insertmacro MUI_LANGUAGE "English"


Name "Osdag"
BrandingText "Osdag Wizard"
Var condaPath
; Var miktexPath

Section "Miniconda Installation"
    SetOutPath "$TEMP"
    File /oname=MinicondaInstaller.exe "c:\Users\1hasa\Downloads\Miniconda3-latest-Windows-x86_64.exe"

    MessageBox MB_YESNO|MB_ICONQUESTION "Is Miniconda/Anaconda already installed on your system?" IDYES YesMiniconda IDNO NoMiniconda

    YesMiniconda:
        nsDialogs::Create
        nsDialogs::SelectFolderDialog "Select the folder where Miniconda/Anaconda is installed" "" $condaPath
        Pop $condaPath
        ${If} $condaPath == ""
            MessageBox MB_ICONEXCLAMATION "No directory selected. Installation will not continue."
            Abort
        ${EndIf}
        
        Goto PathFound

    NoMiniconda:
        StrCpy $condaPath "$PROFILE\Miniconda3"
        DetailPrint "Installing Miniconda. It may take some time..."
        ExecWait '"$TEMP\MinicondaInstaller.exe" /InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /S /D=$condaPath'
        
        Goto PathFound
        
    PathFound:
        DetailPrint "Miniconda Found at: $condaPath"

   
SectionEnd


Section "install osdag"

    DetailPrint "Creating environment for osdag"
    StrCpy $1 "$condaPath\Scripts\conda.exe"
    ${If} ${FileExists} "$1"
        Var /GLOBAL env_name
        StrCpy $env_name "osdag_inst"  

        DetailPrint "Creating Conda environment $env_name..."
        nsExec::ExecToLog 'cmd.exe /C ""$1" create -y -n $env_name"'

        DetailPrint "Installing osdag..."
        nsExec::ExecToLog 'cmd.exe /C ""$1" install -n $env_name -y osdag::osdag"'
        MessageBox MB_OK "Conda environment $env_name successfully created and osdag installed."
    ${Else}
       
        MessageBox MB_ICONSTOP "Error: Conda executable not found at $1. Please check the path."
        Abort
    ${EndIf}

SectionEnd

; Section "MiKTeX Installation"
;     SetOutPath "$TEMP"
;     File /oname=MiKTeXInstaller.exe "c:\Users\1hasa\Downloads\basic-miktex-24.1-x64.exe"

;     MessageBox MB_YESNO|MB_ICONQUESTION "Is MiKTeX already installed on your system?" IDYES YesMiKTeX IDNO NoMiKTeX

;     YesMiKTeX:
;         nsExec::ExecToStack 'cmd.exe /C "where miktex-console.exe"'
;         Pop $miktexPath
;         ${If} $miktexPath == ""
;             MessageBox MB_ICONSTOP "Error: MiKTeX console executable not found. Please verify the installation."
;             Abort
;         ${EndIf}
;         Goto MikTexConfigured

;     NoMiKTeX:
;         StrCpy $miktexPath "$PROGRAMFILES64\MiKTeX"
;         DetailPrint "Installing MiKTeX. It may take some time..."
;         ExecWait '"$TEMP\MiKTeXInstaller.exe" /silent /S /D=$miktexPath'
;         Goto MikTexConfigured

;     MikTexConfigured:
;         DetailPrint "Configuring MiKTeX to handle package installations..."
;         MessageBox MB_OK "MiKTeX successfully installed and configured for on-the-fly package installation."
; SectionEnd



Section "Create Desktop and Start Menu Shortcuts"
    Var /GLOBAL osdagShortcutPath
    StrCpy $osdagShortcutPath "$DESKTOP\Osdag.lnk"

    DetailPrint "Creating Desktop Shortcut for Osdag..."
    CreateShortcut "$osdagShortcutPath" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag"

    DetailPrint "Creating Start Menu Shortcut for Osdag..."
    CreateDirectory "$SMPROGRAMS\Osdag"
    CreateShortcut "$SMPROGRAMS\Osdag\Run Osdag.lnk" "$SYSDIR\cmd.exe" "/C call $condaPath\Scripts\activate.bat $env_name && osdag"

    MessageBox MB_OK "Desktop and Start Menu shortcuts for Osdag have been created."
SectionEnd