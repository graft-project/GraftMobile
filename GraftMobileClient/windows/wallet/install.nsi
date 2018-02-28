    !include "MUI2.nsh"
	!include "WinVer.nsh"

	!define APPNAME "GraftWallet"
	!define COMPANYNAME "GRAFT Payments, LLC"
	!define DESCRIPTION "Graft Wallet"
	!define VERSIONMAJOR 1
	!define VERSIONMINOR 6
        !define VERSIONBUILD 2
        !define VERSION "1.6.2"
    !define APPICON "icon.ico"
    !define ABOUTURL "https://www.graft.network"
	!define LIC_NAME "license.rtf"
	!define ARPPATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
    !define INSTALLSIZE 33727070

    Name "${DESCRIPTION}"
	Caption "${APPNAME} ${VERSION}"
	OutFile "${APPNAME} ${VERSION}.exe"

	BrandingText "${APPNAME}"

	VIProductVersion "${VERSION}.0"
    VIAddVersionKey ProductName "${DESCRIPTION}"
    VIAddVersionKey CompanyName "${COMPANYNAME}"
    VIAddVersionKey LegalCopyright "2018 ${COMPANYNAME}"
    VIAddVersionKey FileDescription "${DESCRIPTION}"
    VIAddVersionKey FileVersion "${VERSION}"
    VIAddVersionKey ProductVersion "${VERSION}"
    VIAddVersionKey InternalName "${APPNAME}"
    VIAddVersionKey OriginalFilename "${APPNAME} ${VERSION}.exe"

    InstallDir "$PROGRAMFILES\${APPNAME}"

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
	!insertmacro MUI_PAGE_LICENSE "${LIC_NAME}"
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

!include "nsProcess.nsh"

Section "!${APPNAME} ${VERSION}" SecGraftWallet

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
	SetOutPath "$INSTDIR"
	File "${APPNAME}.exe"
    File "vcredist_x64.exe"
	File "d3dcompiler_47.dll"
	File "libeay32.dll"
	File "libEGL.dll"
	File "libGLESV2.dll"
	File "opengl32sw.dll"
	File "Qt5Core.dll"
	File "Qt5Gui.dll"
	File "Qt5Multimedia.dll"
	File "Qt5MultimediaQuick_p.dll"
	File "Qt5Network.dll"
	File "Qt5Qml.dll"
	File "Qt5Quick.dll"
	File "Qt5QuickControls2.dll"
	File "Qt5QuickTemplates2.dll"
	File "Qt5Svg.dll"
	File "Qt5Widgets.dll"
	File "ssleay32.dll"

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
	WriteRegStr HKLM "${ARPPATH}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteRegStr HKLM "${ARPPATH}" "QuietUninstallString" "$INSTDIR\uninstall.exe"
	WriteRegStr HKLM "${ARPPATH}" "DisplayIcon" "$INSTDIR\${APPICON}.ico"
	WriteRegStr HKLM "${ARPPATH}" "Publisher" "${COMPANYNAME}"
	WriteRegDWORD HKLM "${ARPPATH}" "EstimatedSize" ${INSTALLSIZE}
	WriteRegStr HKLM "${ARPPATH}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
	WriteRegDWORD HKLM "${ARPPATH}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "${ARPPATH}" "VersionMinor" ${VERSIONMINOR}
	
	SetShellVarContext all
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\${APPNAME}.lnk" "$INSTDIR\${APPNAME}.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall ${APPNAME}.lnk" "$INSTDIR\Uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
	
	Call check_Visual_C++_Redistributable

SectionEnd

Function LaunchLink
  ExecShell "" "$INSTDIR\${APPNAME}.exe"
FunctionEnd

Function CreateShortcutIcon
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\${APPNAME}.exe"
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

Function check_Visual_C++_Redistributable
    
!include x64.nsh

${If} ${RunningX64}
        ReadRegStr $1 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" "Installed"
        StrCmp $1 1 installed
${EndIf}

MessageBox MB_YESNO "Couldn't find a Microsoft Visual C++ 2017 Redistributable package.$\nDo you want to install it now?" IDYES InstallRedistributablePackage IDNO installed

InstallRedistributablePackage:
	ExecWait "vc_redist.x64.exe"

installed:
	WriteUninstaller "$INSTDIR\uninstall.exe"

FunctionEnd