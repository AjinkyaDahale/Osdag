Var InstallPath

Function CheckDirectory
    IfFileExists "$InstallPath\*" 0 +2
    MessageBox MB_OK "Anaconda/Miniconda found at: $InstallPath"
    Return
FunctionEnd

Function CheckCondaInstalled
    ClearErrors
    ; Check for Miniconda/Anaconda in HKLM (all users)
    ReadRegStr $InstallPath HKLM "Software\Python\ContinuumAnalytics" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; Check alternate registry path in HKLM
    ReadRegStr $InstallPath HKLM "Software\Anaconda" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; Check for Miniconda/Anaconda in HKCU (current user)
    ReadRegStr $InstallPath HKCU "Software\Python\ContinuumAnalytics" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; Check alternate registry path in HKCU
    ReadRegStr $InstallPath HKCU "Software\Anaconda" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; Check for 32-bit installations on 64-bit systems (HKLM\Wow6432Node)
    ReadRegStr $InstallPath HKLM "Software\Wow6432Node\Python\ContinuumAnalytics" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; Check alternate 32-bit path in Wow6432Node
    ReadRegStr $InstallPath HKLM "Software\Wow6432Node\Anaconda" "InstallPath"
    IfErrors +2
    Call CheckDirectory

    ; If no registry path is found
    MessageBox MB_OK "Anaconda or Miniconda is not installed."
    Return
FunctionEnd

; Call the function in the installer script
Section "Check Anaconda/Miniconda Installation"
    Call CheckCondaInstalled
SectionEnd
