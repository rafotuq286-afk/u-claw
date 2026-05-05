; ============================================================
; U-Claw NSIS customizations — install onto USB drive
; ============================================================
;
; Goal: when Setup.exe is double-clicked from a USB drive, the
; installer should default to installing into that same USB drive
; and provision a portable/ data directory so the Electron app
; stores all user data (config, OpenClaw state, xiapan apiKey)
; on the USB — not in %APPDATA%.
;
; This makes the resulting install fully portable and license-bound
; to the physical USB device.

; --------------------------------------------------------------
; preInit: runs before the install directory page is shown.
; Override $INSTDIR so the wizard's default path = the directory
; where Setup.exe is sitting (the USB root) + a U-Claw subfolder.
;
; $EXEDIR is the directory containing the running Setup.exe. If a
; user drops Setup.exe on E:\, default install path becomes E:\U-Claw\
; --------------------------------------------------------------
!macro preInit
  SetRegView 64
  WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "$EXEDIR\U-Claw"
  WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "$EXEDIR\U-Claw"
  SetRegView 32
  WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "$EXEDIR\U-Claw"
  WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "$EXEDIR\U-Claw"
!macroend

; --------------------------------------------------------------
; customInstall: runs at the end of the install step.
; Create the portable/ marker directory inside $INSTDIR (same dir
; as U-Claw.exe) so main.js getPortableDataPath() finds it via
; path.dirname(app.getPath('exe')) + '/portable'.
; --------------------------------------------------------------
!macro customInstall
  CreateDirectory "$INSTDIR\portable"
  CreateDirectory "$INSTDIR\portable\.openclaw"
  CreateDirectory "$INSTDIR\portable\memory"
  CreateDirectory "$INSTDIR\portable\backups"
!macroend
