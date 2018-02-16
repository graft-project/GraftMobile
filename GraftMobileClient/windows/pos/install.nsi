    !include "MUI2.nsh"
	!include "WinVer.nsh"

	!define APPNAME "GraftPointOfSale"
	!define COMPANYNAME "GRAFT Payments"
	!define DESCRIPTION "Graft Point-Of-Sale"
	!define VERSIONMAJOR 1
	!define VERSIONMINOR 6
	!define VERSIONBUILD 0
	!define VERSION "1.6.0"
    !define APPICON "icon.ico"
    !define ABOUTURL "https://www.graft.network"
	; !define LIC_NAME "license.rtf"
	!define ARPPATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
    !define INSTALLSIZE 33727070

    Name "${DESCRIPTION}"
	Caption "${APPNAME} ${VERSION}"
	OutFile "${APPNAME} ${VERSION}.exe"

	BrandingText "${APPNAME}"

    InstallDir "$PROGRAMFILES"

    RequestExecutionLevel none
	SetCompress force
	SetCompressor /SOLID /FINAL lzma
	CRCCheck force
	AutoCloseWindow false
	AllowRootDirInstall false
	Var StartMenuFolder

	!define MUI_ICON "${APPICON}"
    !define MUI_UNICON "${APPICON}"
	!define MUI_HEADERIMAGE
	!define MUI_HEADERIMAGE_BITMAP "header.bmp"
	!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
	!define MUI_ABORTWARNING

	!insertmacro MUI_PAGE_WELCOME
	; !insertmacro MUI_PAGE_LICENSE "${LIC_NAME}"
    !insertmacro MUI_PAGE_DIRECTORY

    !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder 
	
	!insertmacro MUI_PAGE_INSTFILES	
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES
	
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_TEXT "Start ${APPNAME}"
    !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
	!define MUI_FINISHPAGE_SHOWREADME ""
	!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
	!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateShortcutIcon

	!insertmacro MUI_PAGE_FINISH
	!insertmacro MUI_LANGUAGE "English"
	!insertmacro MUI_RESERVEFILE_LANGDLL

	!include WinMessages.nsh

InstType "Standart"

!include "FileFunc.nsh"
 
Section "Install"
 
${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
IntFmt $0 "0x%08X" $0

SectionEnd

Section "!${APPNAME} ${VERSION}" SecGraftWAllet

    !include "nsProcess.nsh"

	nsProcess::FindProcess "${APPNAME}.exe" $R0
	StrCmp $R0 "1" Finded ContinueInstall
	Finded:
	MessageBox MB_YESNO "Can not proceed installation because another copy of application is running. Please close application if you want to continue. Do you want to close it now?" IDYES Close
	Abort
	Close: 
	nsProcess::KillProcess "${APPNAME}.exe" $R0
	nsProcess::FindProcess "${APPNAME}.exe" $R0
	StrCmp $R0 "1" Close
	
	ContinueInstall:
	SectionIn 1 2
	AddSize 1024
	SetOutPath "$INSTDIR\${APPNAME}"
	File "${APPNAME}.exe"
    File "vcredist_x64.exe"
	; File "${LIC_NAME}"
	File "*.dll"
    File "*.ico"
    File "*.bmp"

    File /r "bearer"
    File /r "iconengines"
    File /r "imageformats"
    File /r "mediaservice"
    File /r "platforms"
    File /r "qmltooling"
    File /r "QtGraphicalEffects"
    File /r "QtMultimedia"
    File /r "QtQml"
    File /r "QtQuick"
    File /r "QtQuick.2"
    File /r "scenegraph"
	
	WriteRegStr HKLM "${ARPPATH}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "${ARPPATH}" "UninstallString" "$INSTDIR\${APPNAME}\uninstall.exe"
	WriteRegStr HKLM "${ARPPATH}" "QuietUninstallString" "$INSTDIR\${APPNAME}\uninstall.exe"
	WriteRegStr HKLM "${ARPPATH}" "DisplayIcon" "$INSTDIR\${APPNAME}\${APPICON}.ico"
	WriteRegStr HKLM "${ARPPATH}" "Publisher" "${COMPANYNAME}"
	WriteRegDWORD HKLM "${ARPPATH}" "EstimatedSize" ${INSTALLSIZE}
	WriteRegStr HKLM "${ARPPATH}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
	WriteRegDWORD HKLM "${ARPPATH}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "${ARPPATH}" "VersionMinor" ${VERSIONMINOR}
	
	SetShellVarContext all
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\${APPNAME}.lnk" "$INSTDIR\${APPNAME}\${APPNAME}.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall ${APPNAME}.lnk" "$INSTDIR\${APPNAME}\Uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
	
	WriteUninstaller "$INSTDIR\${APPNAME}\uninstall.exe"

SectionEnd

Function LaunchLink
  ExecShell "" "$INSTDIR\${APPNAME}\${APPNAME}.exe"
FunctionEnd

Function CreateShortcutIcon
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\${APPNAME}\${APPNAME}.exe"
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"	
	nsProcess::FindProcess "${APPNAME}.exe" $R0
	StrCmp $R0 "1" Find ContinueUninstall
	Find:
	MessageBox MB_YESNO "Can not uninstall application while it is running. Please close application if you want to continue. Do you want to close it now?" IDYES CloseNow
	Abort

	CloseNow: 
	nsProcess::KillProcess "${APPNAME}.exe" $R0
	nsProcess::FindProcess "${APPNAME}.exe" $R0
	StrCmp $R0 "1" CloseNow

	ContinueUninstall:

	RMDir /r "$INSTDIR"

	SetShellVarContext all
	!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
	Delete "$DESKTOP\${APPNAME}.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\${APPNAME}.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall ${APPNAME}.lnk"
	RMDir "$SMPROGRAMS\$StartMenuFolder"
	Delete "$LOCALAPPDATA\${APPNAME}\csi.dat"
	Delete "$LOCALAPPDATA\${APPNAME}\cun.dat"
	RMDir "$LOCALAPPDATA\${APPNAME}"

	; Remove app settings
	SetShellVarContext current
	RMDir /r "$APPDATA\${APPNAME}"
	
SectionEnd