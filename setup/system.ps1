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

function Get-NetbiosName {
  $data = New-Object System.Text.StringBuilder 64
  $size = $data.Capacity
  If (!$Kernel32::GetComputerName($data, [ref] $size)) {
    Error "Could not get netbios name."
  }
  return $data.ToString();
}

# Set computer name.
$hostname = Read-Host -Prompt "Set hostname [$env:ComputerName]"
If ($hostname -ne "" -and $env:ComputerName -ne $hostname) {
  Write-Output "Setting computer name..."
  Rename-Computer -NewName "$hostname" -Force
  Reboot
}

# Set netbios name.
If ($env:ComputerName -ne (Get-NetbiosName)) {
  Write-Output "Setting NetBios name..."
  $Kernel32::SetComputerName("$env:ComputerName");
  Reboot
}

# Set user name.
$username = Read-Host -Prompt "Set username [$env:UserName]"
If ($username -ne "" -and $env:UserName -cne $username) {
  $fullname = Read-Host -Prompt "Full Name"
  Write-Output "Setting User name..."
  Rename-LocalUser -Name "$env:UserName" -NewName "$username"
  Set-LocalUser -Name "$username" -FullName "$fullname"
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
DisableAppSuggestions
DisableActivityHistory
DisableSensors
DisableLocation
DisableMapUpdates
DisableFeedback
DisableTailoredExperiences
DisableAdvertisingID
DisableBiometrics
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
HideAccountProtectionWarn
HideDefenderTrayIcon
DisableDefenderAppGuard
DisableDefenderCloud
DisableDefender
DisableDownloadBlocking
EnableDotNetStrongCrypto
SetDEPOptOut

# ===========================================================================================================
# Network Tweaks
# ===========================================================================================================

SetUnknownNetworksPrivate
DisableSMBServer
DisableLLMNR
DisableLLDP
DisableLLTD
DisableMSNetClient
DisableQoS
DisableConnectionSharing
DisableRemoteAssistance
DisableRemoteDesktop

# ===========================================================================================================
# Service Tweaks
# ===========================================================================================================

DisableUpdateMSRT
EnableUpdateMSProducts
DisableUpdateAutoDownload
DisableMaintenanceWakeUp
DisableSharedExperiences
DisableClipboardHistory
DisableAutoplay
DisableAutorun
DisableRestorePoints

vssadmin Delete Shadows /For=$env:SYSTEMDRIVE /Quiet

DisableStorageSense
DisableDefragmentation
DisableSuperfetch
DisableSwapFile
EnableNTFSLongPaths
DisableNTFSLastAccess
DisableHibernation
DisableSleepButton

Write-Output "Setting display and sleep mode timeouts..."
powercfg /X monitor-timeout-ac 30
powercfg /X monitor-timeout-dc 10
powercfg /X standby-timeout-ac 0
powercfg /X standby-timeout-dc 360

DisableAutoRebootOnCrash

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

DisableActionCenter
HideNetworkFromLockScreen
DisableLockScreenBlur
DisableAeroShake
DisableAccessibilityKeys
ShowTaskManagerDetails
ShowFileOperationsDetails
HideTaskbarSearch
ShowSmallTaskbarIcons
SetTaskbarCombineAlways
HideTaskbarPeopleIcon
ShowTrayIcons
DisableSearchAppInStore
DisableNewAppPrompt
HideRecentlyAddedApps
HideMostUsedApps
DisableShortcutInName
EnableDarkTheme
EnableEnhPointerPrecision
DisableStartupSound
SetSoundSchemeNone
DisableF1HelpKey

SetVisualFXAppearance

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
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0

# ===========================================================================================================
# Explorer UI Tweaks
# ===========================================================================================================

ShowKnownExtensions
ShowHiddenFiles
HideSuperHiddenFiles
ShowEmptyDrives
HideFolderMergeConflicts
DisableRestoreFldrWindows
DisableSharingWizard
HideSelectCheckboxes
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
DisableThumbsDBOnNetwork

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
Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage
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
Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage
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
Get-AppxPackage "Microsoft.Advertising.Xaml" | Remove-AppxPackage

UninstallThirdPartyBloat
DisableXboxFeatures
DisableEdgePreload
DisableEdgeShortcutCreation

DisableMediaSharing
UninstallMediaPlayer

DisableIEFirstRun
UninstallInternetExplorer

UninstallWorkFolders
UninstallPowerShellV2

SetPhotoViewerAssociation
AddPhotoViewerOpenWith

UninstallXPSPrinter
RemoveFaxPrinter
UninstallFaxAndScan

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

Write-Output "Uninstalling Windows Capabilities..."
Get-WindowsCapability -Online | % {
  $remove = $False
  If ($_.Name | Select-String "App.Support.QuickAssist") {
    $remove = $True
  }
  If ($_.Name | Select-String "Browser.InternetExplorer") {
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
# Manual Tweaks
# ===========================================================================================================

Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output "Open a new PowerShell window as Administrator and enter the script directory."
Write-Output ""
Write-Output "  cd $PSScriptRoot\script"
Write-Output ""
Write-Output ""
Write-Output "Run the following command to unpin all start menu icons."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 UnpinStartMenuTiles"
Write-Output ""
Write-Output ""
Write-Output "Run the following command to unpin all tarkbar icons."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 UnpinTaskbarIcons"
Write-Output ""
Write-Output ""
Write-Output "Run the following command after configuring a lock screen wallpaper."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 DisableLockScreen"
Write-Output ""
Write-Output ""
Write-Output "Run the following commands after installing Windows 10 1903 Update KB4515384."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 DisableWebSearch"
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 DisableCortana"
Write-Output ""
Write-Output ""
Write-Output "Run the following commands after connecting to the internet and installing all updates."
Write-Output ""
Write-Output "  powershell -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 InstallLinuxSubsystem"
Write-Output ""

Done

# ===========================================================================================================

# Modify group policies.
#
# See https://www.thewindowsclub.com/group-policy-settings-reference-windows for spreadsheet.
#
# All settings can be verified in gpedit.msc > Computer Configuration > Administrative Templates
#
Write-Output "Modifying group policies..."

# Control Panel > Personalization > Do not display the lock screen: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f

# Windows Components > Cloud Content > Turn off Microsoft consumer experiences: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f

# Windows Components > Data Collection and Preview Builds > Allow Telemetry: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

# Windows Components > Data Collection and Preview Builds > Do not show feedback notifications: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f

# Windows Components > OneDrive > Prevent OneDrive from generating network traffic until the user signs in to OneDrive: Enabled
reg add "HKLM\SOFTWARE\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /t REG_DWORD /d 1 /f

# Windows Components > OneDrive > Prevent the usage of OneDrive for file storage: Enabled
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f

# Windows Components > OneDrive > Save documents to OneDrive by default: Disabled
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d 0 /f

# Windows Components > Search > Allow Cloud Search: Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f

# Windows Components > Search > Allow Cortana: Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f

# Windows Components > Search > Allow Cortana above lock screen: Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d 0 /f

# Windows Components > Search > Allow search and Cortana to use location: Disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f

# Windows Components > Search > Do not allow locations on removable drives to be added to libraries: Enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d 1 /f

# Windows Components > Search > Do not allow web search: Enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f

# Windows Components > Search > Don't search the web or display web results in Search: Enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 1 /f

# Windows Components > Search > Prevent automatically adding shared folders to the Windows Search index: Enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AutoIndexSharedFolders" /t REG_DWORD /d 1 /f

# Windows Components > Search > Prevent clients from querying the index remotely: Enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventRemoteQueries" /t REG_DWORD /d 1 /f

# Windows Components > Speech > Allow Automatic Update of Speech Data: Disabled
reg add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d 0 /f

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

# Windows Components > Windows Update > Configure Automatic Updates: Enabled
#   Configure automatic updating: 2 - Notify for download and auto install
#   [v] Install updates for other Microsoft products
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutomaticMaintenanceEnabled" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallTime" /t REG_DWORD /d 3 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallEveryWeek" /t REG_DWORD /d 1 /f

# System > Device Installation > Prevent device metadata retrieval from the Internet: Enabled
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d 1 /f

Done
