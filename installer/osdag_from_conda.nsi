OutFile "osdag_installer.exe"
RequestExecutionLevel admin

!include "nsDialogs.nsh"  

Var condaPath

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
        StrCpy $condaPath "%USERPROFILE%\Miniconda3"
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
        ; nsExec::ExecToLog 'cmd.exe /C ""$1" install -n myenv -y requests"'

        ; Success message
        MessageBox MB_OK "Conda environment $env_name successfully created and osdag installed."
    ${Else}
        ; Conda not found: Show error
        MessageBox MB_ICONSTOP "Error: Conda executable not found at $1. Please check the path."
        Abort
    ${EndIf}

SectionEnd