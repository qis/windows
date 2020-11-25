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

# Schedule reboot.
$rebootRequired = $False

# Set computer name.
$hostname = $env:ComputerName
$hostname = Read-Host -Prompt "Set computer name [$hostname]"
If ($hostname -ne "") {
  Write-Output "Setting computer name..."
  Rename-Computer -NewName "tmp-$hostname" -Force
  Rename-Computer -NewName "$hostname" -Force
  $rebootRequired = $True
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

$biosname = Get-NetbiosName
$biosname = Read-Host -Prompt "Set netbios name [$biosname]"
If ($biosname -ne "") {
  Write-Output "Setting netbios name..."
  $Kernel32::SetComputerName("$biosname");
  $rebootRequired = $True
}

# Set user name.
$username = $env:UserName
$username = Read-Host -Prompt "Set username [$username]"
If ($username -ne "") {
  $fullname = Read-Host -Prompt "Full Name"
  Write-Output "Setting User name..."
  Rename-LocalUser -Name "$env:UserName" -NewName "$username"
  Set-LocalUser -Name "$username" -FullName "$fullname"
  $rebootRequired = $True
}

# Perform reboot.
If ($rebootRequired -eq $True) {
  Reboot
}

# Schedule reboot.
$rebootRequired = $False

# Disable virtual memory.
$ComputerSystem = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$PhysicalMemory = [math]::Ceiling($ComputerSystem.TotalPhysicalMemory / 1024 / 1024 / 1024)
If ($PhysicalMemory -ge 16) {
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

# Perform reboot.
If ($rebootRequired -eq $True) {
  Reboot
}

# ===========================================================================================================
# https://github.com/Disassembler0/Win10-Initial-Setup-Script
# ===========================================================================================================

Import-Module -Name "$PSScriptRoot\system"

# ===========================================================================================================
# Privacy Tweaks
# ===========================================================================================================

DisableActivityHistory
DisableAdvertisingID
DisableAppSuggestions
DisableCortana
DisableDiagTrack
DisableErrorReporting
DisableFeedback
DisableMapUpdates
DisableRecentFiles
DisableSmartScreen
DisableTailoredExperiences
DisableTelemetry
DisableWAPPush
DisableWebSearch
DisableWiFiSense
EnableClearRecentFiles
SetP2PUpdateDisable

# ===========================================================================================================
# Security Tweaks
# ===========================================================================================================

DisableAdminShares
DisableCIMemoryIntegrity
DisableDefender
DisableDefenderAppGuard
DisableDefenderCloud
DisableDownloadBlocking
DisableSharingMappedDrives
HideAccountProtectionWarn
HideDefenderTrayIcon
SetDEPOptOut

# ===========================================================================================================
# Network Tweaks
# ===========================================================================================================

DisableConnectionSharing
DisableLLDP
DisableLLMNR
DisableLLTD
DisableMSNetClient
DisableNetBIOS
DisableNetDevicesAutoInst
DisableQoS
DisableRemoteAssistance
DisableSMB1
DisableSMBServer
SetCurrentNetworkPrivate
SetUnknownNetworksPrivate

# ===========================================================================================================
# Service Tweaks
# ===========================================================================================================

DisableAutoplay
DisableAutorun
DisableClipboardHistory
DisableDefragmentation
DisableHibernation
DisableMaintenanceWakeUp
DisableNTFSLastAccess
DisableSharedExperiences
DisableSleepButton
DisableStorageSense
DisableSuperfetch
DisableSwapFile
DisableUpdateAutoDownload
DisableUpdateMSRT
EnableNTFSLongPaths
EnableUpdateMSProducts
SetBIOSTimeUTC

DisableRestorePoints
vssadmin Delete Shadows /For=$env:SYSTEMDRIVE /Quiet

Write-Output "Setting display and sleep mode timeouts..."
powercfg /X monitor-timeout-ac 30
powercfg /X monitor-timeout-dc 10
powercfg /X standby-timeout-ac 0
powercfg /X standby-timeout-dc 360

DisableAutoRebootOnCrash
DisableFastStartup

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
# UI Tweaks
# ===========================================================================================================

DisableAccessibilityKeys
DisableActionCenter
DisableAeroShake
DisableF1HelpKey
DisableLockScreenBlur
DisableNewAppPrompt
DisableSearchAppInStore
DisableShortcutInName
DisableStartupSound
DisableTitleBarColor
EnableEnhPointerPrecision
HideMostUsedApps
HideNetworkFromLockScreen
HideRecentlyAddedApps
HideTaskbarPeopleIcon
HideTaskbarSearch
SetAppsDarkMode
SetSoundSchemeNone
SetSystemDarkMode
SetTaskbarCombineAlways
SetWinXMenuCmd
ShowFileOperationsDetails
ShowSmallTaskbarIcons
ShowTaskManagerDetails
ShowTrayIcons

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

# Enable transparency.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 1

# Enable dark title bars.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "ColorPrevalence" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -Type DWord -Value 0x282828
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColorInactive" -Type DWord -Value 0x282828

# ===========================================================================================================
# Explorer UI Tweaks
# ===========================================================================================================

DisableRestoreFldrWindows
DisableSharingWizard
DisableThumbsDBOnNetwork
Hide3DObjectsFromExplorer
Hide3DObjectsFromThisPC
HideDesktopFromExplorer
HideDesktopFromThisPC
HideDocumentsFromExplorer
HideDocumentsFromThisPC
HideDownloadsFromExplorer
HideDownloadsFromThisPC
HideFolderMergeConflicts
HideGiveAccessToMenu
HideIncludeInLibraryMenu
HideMusicFromExplorer
HideMusicFromThisPC
HideNavPaneAllFolders
HidePicturesFromExplorer
HidePicturesFromThisPC
HideRecentShortcuts
HideRecycleBinFromDesktop
HideSelectCheckboxes
HideShareMenu
HideSuperHiddenFiles
HideVideosFromExplorer
HideVideosFromThisPC
SetExplorerQuickAccess
ShowEmptyDrives
ShowHiddenFiles
ShowKnownExtensions

# ===========================================================================================================
# Application Tweaks
# ===========================================================================================================
DisableOneDrive
UninstallOneDrive

Write-Output "Uninstalling default Microsoft applications..."
Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage
Get-AppxPackage "Microsoft.AppConnector" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingFoodAndDrink" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingHealthAndFitness" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingTranslator" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingTravel" | Remove-AppxPackage
Get-AppxPackage "Microsoft.CommsPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ConnectivityStore" | Remove-AppxPackage
Get-AppxPackage "Microsoft.FreshPaint" | Remove-AppxPackage
Get-AppxPackage "Microsoft.GetHelp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage
Get-AppxPackage "Microsoft.HelpAndTips" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Media.PlayReadyClient.2" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Messaging" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Microsoft3DViewer" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftPowerBIForWindows" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MinecraftUWP" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MixedReality.Portal" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MoCamera" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MSPaint" | Remove-AppxPackage
Get-AppxPackage "Microsoft.NetworkSpeedTest" | Remove-AppxPackage
Get-AppxPackage "Microsoft.OfficeLens" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.OneNote" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Office.Sway" | Remove-AppxPackage
Get-AppxPackage "Microsoft.OneConnect" | Remove-AppxPackage
Get-AppxPackage "Microsoft.People" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Print3D" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Reader" | Remove-AppxPackage
Get-AppxPackage "Microsoft.RemoteDesktop" | Remove-AppxPackage
Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Todos" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Wallet" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WebMediaExtensions" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Whiteboard" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsAlarms" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsReadingList" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsScan" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WinJS.1.0" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WinJS.2.0" | Remove-AppxPackage
Get-AppxPackage "Microsoft.YourPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage

Get-AppxPackage "Microsoft.Windows.Photos" | Remove-AppxPackage  # Photos
Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage  # Mail and Calendar
Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage  # Weather
Get-AppxPackage "Microsoft.Advertising.Xaml" | Remove-AppxPackage  # Dependency for Mail and Calendar, Weather

DisableAdobeFlash
DisableEdgePreload
DisableEdgeShortcutCreation
DisableFullscreenOptims
DisableMediaSharing
DisableXboxFeatures
InstallSSHClient
InstallTelnetClient
RemoveFaxPrinter
RemovePhotoViewerOpenWith
UninstallFaxAndScan
UninstallHelloFace
UninstallMathRecognizer
UninstallMediaPlayer
UninstallPowerShellV2
UninstallThirdPartyBloat
UninstallWorkFolders
UninstallXPSPrinter
EnableDeveloperMode

# ===========================================================================================================
# Custom Tweaks
# ===========================================================================================================

# Make the "HKCR:" registry drive available.
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

Write-Output 'Removing "Edit with Paint 3D" from Explorer context menu.'
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "3D Edit" /s /k /e
("3mf", "bmp", "fbx", "gif", "glb", "jfif", "jpe", "jpeg", "jpg", "obj", "ply", "png", "stl", "tif", "tiff") | ForEach {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\3D Edit" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

Write-Output 'Removeing "Set as desktop background" from Explorer context menu.'
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "setdesktopwallpaper" /s /k /e
("bmp", "dib", "gif", "jfif", "jpe", "jpeg", "jpg", "png", "tif", "tiff", "wdp") | ForEach {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\setdesktopwallpaper" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

Write-Output 'Removing "AMD Radeon Software" from Explorer context menu...'
Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\ACE" -Name "(Default)" -Type String -Value "--"

Write-Output "Uninstalling Microsoft Internet Printing..."
Disable-WindowsOptionalFeature -Online -FeatureName "Printing-Foundation-InternetPrinting-Client" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================
# Destructive Tweaks
# ===========================================================================================================

$doUnpinStartMenuTiles = Read-Host -Prompt "Unpin all Start Menu tiles [no]"
If ($doUnpinStartMenuTiles -like "yes") {
  UnpinStartMenuTiles
  $rebootRequired = $True
}

$doUnpinTaskbarIcons = Read-Host -Prompt "Unpin all Taskbar icons [no]"
If ($doUnpinTaskbarIcons -like "yes") {
  UnpinTaskbarIcons
  $rebootRequired = $True
}

$doDisableLockScreen = Read-Host -Prompt "Disable Lock screen [no]"
If ($doDisableLockScreen -like "yes") {
  DisableLockScreen
  $rebootRequired = $True
}

If ($rebootRequired -eq $True) {
  Reboot
}

Wait-Event
Exit
