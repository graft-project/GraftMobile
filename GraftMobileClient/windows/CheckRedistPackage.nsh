!ifndef CHECKREDISTPACKAGE_NSH
!define CHECKREDISTPACKAGE_NSH

; See http://nsis.sourceforge.net/Check_if_a_file_exists_at_compile_time for documentation
!macro !defineifexist _VAR_NAME _FILE_NAME
    !tempfile _TEMPFILE
    !ifdef NSIS_WIN32_MAKENSIS
        ; Windows - cmd.exe
        !system 'if exist "${_FILE_NAME}" echo !define ${_VAR_NAME} > "${_TEMPFILE}"'
    !else
        ; Posix - sh
        !system 'if [ -e "${_FILE_NAME}" ]; then echo "!define ${_VAR_NAME}" > "${_TEMPFILE}"; fi'
    !endif
    !include '${_TEMPFILE}'
    !delfile '${_TEMPFILE}'
    !undef _TEMPFILE
!macroend
!define !defineifexist "!insertmacro !defineifexist"

Section
    ${!defineifexist} vcredist_x64 vcredist_x64.exe
    ${!defineifexist} vcredist_x86 vcredist_x86.exe
    ${!defineifexist} vc_redist_x64 vc_redist.x64.exe
    ${!defineifexist} vc_redist_x86 vc_redist.x86.exe
SectionEnd

Function IncludeRedistPackage
    !ifdef vcredist_x64
        File "vcredist_x64.exe"
    !endif
    !ifdef vcredist_x86
        File "vcredist_x86.exe"
    !endif
    !ifdef vc_redist_x64
        File "vc_redist.x64.exe"
    !endif
    !ifdef vc_redist_x86
        File "vc_redist.x86.exe"
    !endif
FunctionEnd

!endif
