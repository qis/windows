# Settings.
$hostname = ""
$username = "name"
$userfull = "Name Surname"

If ($hostname -eq "") {
  Error 'Read this script and assign meaningful strings to the variables $hostname, $username, and $userfull.'
}

# Import utility functions.
Import-Module -Name "$PSScriptRoot\utility"

# Restart script as administrator.
If ((IsAdmin) -eq $False) {
  If ($args[0] -eq "-elevated") {
    Error "Could not execute script as administrator."
  }
  Write-Output "Executing script as Administrator..."
  Start-Process powershell.exe -Verb RunAs -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "{0}" -elevated' -f ($MyInvocation.MyCommand.Definition))
  Exit
}

# Initialize helper objects.
$Kernel32 = Add-Type -MemberDefinition @'
[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
public static extern bool SetComputerName(String name);

[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
public static extern bool GetComputerName(System.Text.StringBuilder buffer, ref uint size);
'@ -Name 'Kernel32' -Namespace 'Win32' -PassThru

# Set computer name.
If ($env:ComputerName -ne $hostname) {
  Write-Output "Setting computer name..."
  Rename-Computer -NewName "$hostname" -Force
  Reboot
}

# Set netbios name.
function Get-NetbiosName {
  $data = New-Object System.Text.StringBuilder 64
  $size = $data.Capacity
  If (!$Kernel32::GetComputerName($data, [ref] $size)) {
    Error "Could not get netbios name."
  }
  return $data.ToString();
}

If ((Get-NetbiosName) -cne "$hostname") {
  Write-Output "Setting NetBios name..."
  $Kernel32::SetComputerName("$hostname");
  Reboot
}

# Change user name.
If ($env:UserName -cne $username) {
  Write-Output "Setting User name..."
  Rename-LocalUser -Name "$env:UserName" -NewName "$username"
  Set-LocalUser -Name "$username" -FullName "$userfull"
  Reboot
}

# Schedule reboot.
$rebootRequired = $False

# Disable hibernation.
function Get-Hibernation {
  $found = $False
  $parsing = $False
  powercfg /a | % {
    If ($_ -ceq "The following sleep states are available on this system:") {
      $parsing = $True
      return
    }
    If ($_ -ceq "The following sleep states are not available on this system:") {
      $parsing = $False
      return
    }
    If ($parsing) {
      If ($_ | Select-String "Hibernate") {
        $found = $True
      }
    }
  }
  return $found
}

If ((Get-Hibernation) -eq $True) {
  Write-Output "Disabling Hibernation..."
  Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Type DWord -Value 0
  If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Force | Out-Null
  }
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type DWord -Value 0
  powercfg /HIBERNATE OFF 2>&1 | Out-Null
  $rebootRequired = $True
}

# Disable virtual memory.
$ComputerSystem = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
If ($ComputerSystem.AutomaticManagedPagefile) {
  Write-Output "Switching to manual Pagefile management..."
  $ComputerSystem.AutomaticManagedPagefile = $False
  $ComputerSystem.Put()
  $rebootRequired = $True
}

$PageFileSetting = Get-WmiObject -Query "SELECT * FROM Win32_PageFileSetting WHERE Name LIKE '%pagefile.sys'"
If ($PageFileSetting) {
  Write-Output "Setting Pagefile sizes..."
  $PageFileSetting.InitialSize = 0
  $PageFileSetting.MaximumSize = 0
  $PageFileSetting.Put()
  $rebootRequired = $True
}

$PageFile = Get-WmiObject -Query "SELECT * FROM Win32_PageFile WHERE Name LIKE '%pagefile.sys'"
If ($PageFile) {
  Write-Output "Deleting Pagefile..."
  $PageFile.Delete()
  wmic pagefileset delete
  $rebootRequired = $True
}

# Disable system restore.
function Get-SystemRestoreInterval {
  $SystemRestoreConfig = Get-CimInstance -Namespace root\default -ClassName SystemRestoreConfig
  return $SystemRestoreConfig.RPSessionInterval
}

If ((Get-SystemRestoreInterval) -ne 0) {
  Write-Output "Disabling System Restore..."
  Disable-ComputerRestore "$env:SYSTEMDRIVE"
  $rebootRequired = $True
}

# Set system volume label.
function Get-VolumeLabel {
  $LogicalDisk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$($args[0]):'"
  return $LogicalDisk.VolumeName
}

If ((Get-VolumeLabel "C") -ne "System") {
  Write-Output "Setting System volume label..."
  Set-Volume -DriveLetter "C" -NewFileSystemLabel "System"
  $rebootRequired = $True
}

If ($rebootRequired -eq $True) {
  Reboot
}

# ===========================================================================================================
# https://github.com/Disassembler0/Win10-Initial-Setup-Script
# ===========================================================================================================

Import-Module -Name "$PSScriptRoot\..\script\Win10"

# ===========================================================================================================
# Privacy Tweaks
# ===========================================================================================================

DisableTelemetry
DisableWiFiSense
DisableSmartScreen
EnableWebSearch  # NOTE: This breaks the Windows Start Menu search in 1903 Build 18362.329
DisableAppSuggestions
DisableActivityHistory
DisableLocationTracking
DisableMapUpdates
DisableFeedback
DisableTailoredExperiences
DisableAdvertisingID
EnableWebLangList
DisableCortana
DisableErrorReporting
SetP2PUpdateDisable
DisableDiagTrack
DisableWAPPush
EnableClearRecentFiles
DisableRecentFiles

# ===========================================================================================================
# Security Tweaks
# ===========================================================================================================

DisableSharingMappedDrives
DisableAdminShares
DisableLLMNR
EnableNCSIProbe
SetCurrentNetworkPrivate
SetUnknownNetworksPrivate
DisableNetDevicesAutoInst
EnableFirewall
HideDefenderTrayIcon
DisableDefender
DisableDefenderCloud
DisableCIMemoryIntegrity
DisableDefenderAppGuard
HideAccountProtectionWarn
DisableDownloadBlocking
EnableScriptHost
EnableDotNetStrongCrypto
SetDEPOptOut

# gpedit.msc > Local Computer Policy > Computer Configuration > Administrative Templates
#   Windows Components > Windows Update > Configure Automatic Updates: Enabled
#     Configure automatic updating: 2 - Notify for download and auto install
#     [v] Install updates for other Microsoft products
Write-Output "Configuring Windows Update..."
If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
  New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 2
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AutomaticMaintenanceEnabled" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallDay" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallTime" -Type DWord -Value 3
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallEveryWeek" -Type DWord -Value 1

# ===========================================================================================================
# Service Tweaks
# ===========================================================================================================

DisableUpdateMSRT
DisableUpdateRestart
DisableSharedExperiences
DisableRemoteAssistance
DisableAutoplay
DisableAutorun
DisableDefragmentation
DisableSuperfetch
DisableSwapFile
DisableNTFSLastAccess
DisableFastStartup
DisableAutoRebootOnCrash

Write-Output "Setting display and sleep mode timeouts..."
powercfg /X monitor-timeout-ac 30
powercfg /X monitor-timeout-dc 10
powercfg /X standby-timeout-ac 0
powercfg /X standby-timeout-dc 300

# ===========================================================================================================
# UI Tweaks
# ===========================================================================================================

DisableAeroShake
DisableStickyKeys
ShowTaskManagerDetails
ShowFileOperationsDetails
ShowTaskbarSearchIcon
ShowSmallTaskbarIcons
HideTaskbarPeopleIcon
ShowTrayIcons
DisableSearchAppInStore
HideRecentlyAddedApps
HideMostUsedApps
DisableShortcutInName
EnableEnhPointerPrecision
SetSoundSchemeNone
DisableStartupSound

Write-Output "Setting custom visual effects..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 400
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](150,62,7,128,18,0,0,0))
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 1

# Disable transparency in Windows.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0

# Disable transparency during Login.
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\System" -Name "DisableAcrylicBackgroundOnLogon" -Type DWord -Value 1

# ===========================================================================================================
# Explorer UI Tweaks
# ===========================================================================================================

ShowKnownExtensions
ShowHiddenFiles
HideRecentShortcuts
SetExplorerQuickAccess
HideDesktopFromThisPC
HideDesktopFromExplorer
HideDocumentsFromThisPC
HideDocumentsFromExplorer
HideDownloadsFromThisPC
HideDownloadsFromExplorer
HideMusicFromThisPC
HideMusicFromExplorer
HidePicturesFromThisPC
HidePicturesFromExplorer
HideVideosFromThisPC
HideVideosFromExplorer
Hide3DObjectsFromThisPC
Hide3DObjectsFromExplorer
HideIncludeInLibraryMenu
HideGiveAccessToMenu
HideShareMenu
DisableThumbnailCache
DisableThumbsDBOnNetwork

# Make the "HKCR:" drive available.
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

# Remove "Edit with Paint 3D" from Explorer context menus.
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "3D Edit" /s /k /e
("3mf", "bmp", "fbx", "gif", "glb", "jfif", "jpe", "jpeg", "jpg", "obj", "ply", "png", "stl", "tif", "tiff") | ForEach-Object {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\3D Edit" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

# Remove "Set as desktop background" from Explorer context menus.
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "setdesktopwallpaper" /s /k /e
("bmp", "dib", "gif", "jfif", "jpe", "jpeg", "jpg", "png", "tif", "tiff", "wdp") | ForEach-Object {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\setdesktopwallpaper" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

# Remove "AMD Radeon Software" from Explorer context menus.
Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\ACE" -Name "(Default)" -Type String -Value "--"

# ===========================================================================================================
# Application Tweaks
# ===========================================================================================================

DisableOneDrive
UninstallOneDrive
UninstallMsftBloat
UninstallThirdPartyBloat
DisableXboxFeatures
#DisableAdobeFlash
DisableEdgePreload
DisableEdgeShortcutCreation
DisableIEFirstRun
#UninstallWorkFolders
InstallLinuxSubsystem
InstallNET23
#SetPhotoViewerAssociation
UninstallXPSPrinter
RemoveFaxPrinter
UninstallFaxAndScan

Write-Output "Uninstalling Microsoft Internet Printing..."
Disable-WindowsOptionalFeature -Online -FeatureName "Printing-Foundation-InternetPrinting-Client" -NoRestart -WarningAction SilentlyContinue | Out-Null

Write-Output "Uninstalling Windows Capabilities..."
Get-WindowsCapability -Online | % {
  $remove = $False
  If ($_.Name | Select-String "App.Support.QuickAssist") {
    $remove = $True
  }
  If ($_.Name | Select-String "Media.WindowsMediaPlayer") {
    $remove = $True
  }
  If ($_.Name | Select-String "Hello.Face") {
    $remove = $True
  }
  If ($remove -eq $True) {
    If ($_.State -eq "Installed") {
      Write-Output "Removing windows capability:" $_.Name "..."
      Remove-WindowsCapability -Online -Name $_.Name
    }
  }
}

# ===========================================================================================================
# Unpinning
# ===========================================================================================================

Write-Output "Open a new PowerShell window as Administrator and enter the script directory."
Write-Output ""
Write-Output "  cd $PSScriptRoot\script"
Write-Output ""
Write-Output "Run the following command to unpin all start menu icons."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 UnpinStartMenuTiles"
Write-Output ""
Write-Output "Run the following command after configuring a lock screen wallpaper."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 DisableLockScreen"
Write-Output ""

# ===========================================================================================================

# Modify group policies.
#
# See https://www.thewindowsclub.com/group-policy-settings-reference-windows for spreadsheet.
#
# All settings can be verified in gpedit.msc > Computer Configuration > Administrative Templates
#
Write-Output "Modifying group policies..."

# Windows Components > Data Collection and Preview Builds > Do not show feedback notifications: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f

# Windows Components > Windows Defender Antivirus > Turn off Windows Defender Antivirus: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f

# Windows Components > Windows Defender Antivirus > MAPS > Join Microsoft MAPS: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender Antivirus > Network Inspection System > Turn on definition retirement: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "DisableSignatureRetirement" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender Antivirus > Network Inspection System > Turn on protocol recognition: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS" /v "DisableProtocolRecognition" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender Antivirus > Real-time Protection > Turn off real-time protection: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

# Windows Components > Windows Defender Antivirus > Signature Updates > Allow definition updates from Microsoft Update: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender Antivirus > Signature Updates > Check for the latest virus and spyware definitions on startup: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "UpdateOnStartUp" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender SmartScreen > Explorer > Configure Windows Defender SmartScreen: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f

# Windows Components > Windows Defender SmartScreen > Microsoft Edge > Configure Windows Defender SmartScreen: Disabled
reg add "HKCU\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f

# Windows Components > Windows Error Reporting > Disable Windows Error Reporting: Enabled
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f

Done
