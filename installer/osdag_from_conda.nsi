; Define the output file name for the installer and set it to require admin privileges
OutFile "osdag_installer.exe"
RequestExecutionLevel admin

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

; Section to handle Miniconda installation
Section "Miniconda Installation"
    ; Set the output path for temporary files
    SetOutPath "$TEMP"
    
    ; Copy the Miniconda installer to the temporary directory
    File /oname=MinicondaInstaller.exe "C:\Users\1hasa\Downloads\Miniconda3-latest-Windows-x86_64.exe"

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
            Quit
        ${EndIf}
        
        ; Go to the section 
        Goto PathFound

    NoMiniconda:
        ; Create a dialog to let the user select the existing installation folder
        nsDialogs::Create
        nsDialogs::SelectFolderDialog "Select installational directory" "$PROFILE" $condaPath
        Pop $condaPath
        StrCpy $condaPath "$condaPath\Miniconda3"

        DetailPrint "Installing Miniconda. It may take some time...,"

        ; Perform a silent installation of Miniconda
        ExecWait '"$TEMP\MinicondaInstaller.exe" /InstallationType=JustMe /AddToPath=1 /RegisterPython=0 /S /D=$condaPath'
        ${If} ${Errors}
            MessageBox MB_ICONSTOP "Error: Failed to install Miniconda. Please check the installer or your system permissions."
            Quit
        ${EndIf}
        ; Go to the section 
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
        ; Assign a name for the Conda environment
        StrCpy $env_name "osdag_env"   

        ; Create the Conda environment
        nsExec::ExecToLog 'cmd.exe /C ""$1" create -y -n $env_name"'

        ; Install Osdag in the created Conda environment
        DetailPrint "Installing osdag..."
        nsExec::ExecToLog 'cmd.exe /C ""$1" install -n $env_name -y osdag::osdag"'

    ${Else}
        ; Display an error message if Conda executable is not found
        MessageBox MB_ICONSTOP "Error: Conda executable not found at $1. Please check the path."
        Quit
    ${EndIf}

SectionEnd

Section "LaTeX Installation"
    ; Clear any existing errors
    ClearErrors

    ; Copy the MikTeX installer to the temporary directory
    SetOutPath $TEMP
    File /oname=MiKTeX.exe "C:\Users\1hasa\Downloads\basic-miktex-24.1-x64.exe"

    ; Define a temporary file to store the output
    SetOutPath $TEMP
    FileOpen $1 "$TEMP\pdflatex_check.txt" w
    FileClose $1

    ; Run the "where pdflatex" command and redirect output to the file
    ExecWait 'cmd.exe /C "where pdflatex > $TEMP\pdflatex_check.txt"'
 
    ; Read the output from the file
    FileOpen $1 "$TEMP\pdflatex_check.txt" r
    FileRead $1 $miktexPath
    FileClose $1
    

    ${If} $miktexPath == ""
        Goto install

    ${Else}
        ; Retrieve Latex installation directory
        StrLen $R0 $miktexPath  ; Get the length of the full string

        ; Find the position of "\condabin\conda.bat"
        StrCpy $R1 "\miktex\bin\x64\pdflatex.exe"
        StrLen $R2 $R1  ; Length of "\condabin\conda.bat"

        ; Subtract 1 to avoid including the trailing backslash before condabin
        IntOp $R3 $R0 - $R2
        IntOp $R3 $R3 - 2  ; Subtract 1 more to exclude the last backslash before condabin

        ; Copy everything before "\condabin\conda.bat"
        StrCpy $miktexPath $miktexPath $R3

        DetailPrint "LaTeX found at: $miktexPath"
        Goto End
    ${EndIf}

    install:
        MessageBox MB_ICONEXCLAMATION "LaTex not found (pdflatex is missing). Please install MikTeX before continuing."

        ; Run the MiKTeX installer silently
        DetailPrint "Installing MikTeX, please wait..."
        MessageBox MB_ICONEXCLAMATION "Install for Current User. Do not change the default installation path for MikTeX."
        ExecWait '"$TEMP\MiKTeX.exe"'
        ${If} ${Errors}
            MessageBox MB_ICONSTOP "Error: Failed to install Miniconda. Please check the installer or your system permissions."
            Quit
        ${EndIf}

        ; Run the "where pdflatex" command and redirect output to the file
        StrCpy $miktexPath "$PROFILE\AppData\Local\Programs\MiKTeX\"
        DetailPrint "MikTeX Installated at $miktexPath"
        MessageBox MB_ICONEXCLAMATION "Make sure to check updates for MikTeX before launching Osdag"

        Goto End
    End:
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

    MessageBox MB_OK "Osdag Unistalled. You can remove MikTeX and Conda mannually" 

SectionEnd