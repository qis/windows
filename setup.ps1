# Execute the following command in powershell as Administrator.
#
#   Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted
#
# Execute the following command in powershell as Administrator when finished.
#
#   Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
#

# Settings.
$hostname = ""
$username = ""
$userfull = "First Last"

# Initialize helper functions.
function Confirm {
  If ($Host.Name -eq "ConsoleHost") {
    Write-Output $args
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") | Out-Null
  }
}

function Done {
  Confirm "Press any key to exit..."
  Exit
}

function Reboot {
  Confirm "Press any key to reboot the system..."
  Restart-Computer -Force
  Exit
}

function Error {
  Write-Output "Error: $args"
  Done
}

If ($hostname -eq "") {
  Error 'Read this script and assign meaningful strings to the variables $hostname, $username, and $userfull.'
}

# Restart script as administrator.
function Is-Admin {
  $identity = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  return $identity.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

If ((Is-Admin) -eq $False) {
  If ($args[0] -eq "-elevated") {
    Error "Could not execute script as administrator."
  }
  Write-Output "Executing script as Administrator..."
  Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($MyInvocation.MyCommand.Definition))
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
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
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
  $LogicalDisk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$($args[0])'"
  return $LogicalDisk.VolumeName
}

If ((Get-VolumeLabel "$env:SYSTEMDRIVE") -ne "System") {
  Write-Output "Setting System volume label..."
  Set-Volume -DriveLetter "$env:SYSTEMDRIVE" -NewFileSystemLabel "System"
  $rebootRequired = $True
}

If ($rebootRequired -eq $True) {
  Reboot
}

# ===========================================================================================================
# https://github.com/Disassembler0/Win10-Initial-Setup-Script
# ===========================================================================================================

Write-Output "Disabling Telemetry..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Name "NoGenTicket" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

# ===========================================================================================================

Write-Output "Disabling Wi-Fi Sense..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "WiFISenseAllowed" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling SmartScreen Filter..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Bing Search in Start Menu..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Application suggestions..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current"
Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $key.Data[0..15]
Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Disabling Activity History..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Location Tracking..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0

# ===========================================================================================================
Write-Output "Disabling automatic Maps updates..."
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Feedback..."
If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
  New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

# ===========================================================================================================

Write-Output "Disabling Tailored Experiences..."
If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent")) {
  New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Advertising ID..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Cortana..."
If (!(Test-Path "HKCU:\Software\Microsoft\Personalization\Settings")) {
  New-Item -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
If (!(Test-Path "HKCU:\Software\Microsoft\InputPersonalization")) {
  New-Item -Path "HKCU:\Software\Microsoft\InputPersonalization" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
If (!(Test-Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore")) {
  New-Item -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Error reporting..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null

# ===========================================================================================================

Write-Output "Disabling Windows Update P2P optimization..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Type DWord -Value 100

# ===========================================================================================================

Write-Output "Stopping and disabling Diagnostics Tracking Service..."
Stop-Service "DiagTrack" -WarningAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled

# ===========================================================================================================

Write-Output "Stopping and disabling WAP Push Service..."
Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
Set-Service "dmwappushservice" -StartupType Disabled

# ===========================================================================================================

Write-Output "Disabling recent files lists..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRecentDocsHistory" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling implicit administrative shares..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0

# ===========================================================================================================

#Write-Output "Enabling SMB 1.0 protocol..."
#Set-SmbServerConfiguration -EnableSMB1Protocol $true -Force

# ===========================================================================================================

Write-Output "Disabling LLMNR..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Setting current network profile to private..."
Set-NetConnectionProfile -NetworkCategory Private

# ===========================================================================================================

Write-Output "Setting unknown networks profile to private..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24" -Name "Category" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding Windows Defender SysTray icon..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" -Name "HideSystray" -Type DWord -Value 1
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Disabling Windows Defender..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Disabling Windows Defender Cloud..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type DWord -Value 2

# ===========================================================================================================

Write-Output "Disabling Core Isolation Memory Integrity..."
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Disabling Windows Defender Application Guard..."
Disable-WindowsOptionalFeature -online -FeatureName "Windows-Defender-ApplicationGuard" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================

Write-Output "Hiding Account Protection warning..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows Security Health\State")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Force | Out-Null
}
Set-ItemProperty "HKCU:\Software\Microsoft\Windows Security Health\State" -Name "AccountProtection_MicrosoftAccount_Disconnected" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling blocking of downloaded files..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -Name "SaveZoneInformation" -Type DWord -Value 1

# ===========================================================================================================

Write-output "Enabling .NET strong cryptography..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Setting Data Execution Prevention (DEP) policy to OptOut..."
bcdedit /set `{current`} nx OptOut | Out-Null

# ===========================================================================================================

Write-Output "Disabling Malicious Software Removal Tool offering..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Windows Update automatic restart..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Shared Experiences..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" -Name "RomeSdkChannelUserAuthzPolicy" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Autoplay..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Autorun for all drives..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

# ===========================================================================================================

Write-Output "Disabling Modern UI swap file..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl" -Type Dword -Value 0

# ===========================================================================================================

Write-Output "Setting display and sleep mode timeouts..."
powercfg /X monitor-timeout-ac 30
powercfg /X monitor-timeout-dc 10
powercfg /X standby-timeout-ac 0
powercfg /X standby-timeout-dc 300

# ===========================================================================================================

Write-Output "Disabling Fast Startup..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling automatic reboot on crash (BSOD)..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "AutoReboot" -Type DWord -Value 0

# ===========================================================================================================

#Write-Output "Disabling Lock screen..."
#If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
#  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
#}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Aero Shake..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisallowShaking" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Sticky keys prompt..."
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

# ===========================================================================================================

Write-Output "Showing task manager details..."
$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
$timeout = 30000
$sleep = 100
Do {
  Start-Sleep -Milliseconds $sleep
  $timeout -= $sleep
  $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
} Until ($preferences -or $timeout -le 0)
Stop-Process $taskmgr
If ($preferences) {
  $preferences.Preferences[28] = 0
  Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
}

# ===========================================================================================================

Write-Output "Showing file operations details..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding Taskbar Search icon / box..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Showing small icons in taskbar..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding People icon..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Showing all tray icons..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
  New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAutoTrayNotify" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling search for app in store for unknown extensions..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoUseStoreOpenWith" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling 'How do you want to open this file?' prompt..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoNewAppAlert" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding 'Recently added' list from the Start Menu..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding 'Most used' apps list from the Start Menu..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling adding '- shortcut' to shortcut name..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "link" -Type Binary -Value ([byte[]](0,0,0,0))

# ===========================================================================================================

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

# ===========================================================================================================

Write-Output "Setting sound scheme to No Sounds..."
$SoundScheme = ".None"
Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps\*\*" | ForEach-Object {
  # If scheme keys do not exist in an event, create empty ones (similar behavior to Sound control panel).
  If (!(Test-Path "$($_.PsPath)\$($SoundScheme)")) {
    New-Item -Path "$($_.PsPath)\$($SoundScheme)" | Out-Null
  }
  If (!(Test-Path "$($_.PsPath)\.Current")) {
    New-Item -Path "$($_.PsPath)\.Current" | Out-Null
  }
  # Get a regular string from any possible kind of value, i.e. resolve REG_EXPAND_SZ, copy REG_SZ or empty from non-existing.
  $Data = (Get-ItemProperty -Path "$($_.PsPath)\$($SoundScheme)" -Name "(Default)" -ErrorAction SilentlyContinue)."(Default)"
  # Replace any kind of value with a regular string (similar behavior to Sound control panel).
  Set-ItemProperty -Path "$($_.PsPath)\$($SoundScheme)" -Name "(Default)" -Type String -Value $Data
  # Copy data from source scheme to current.
  Set-ItemProperty -Path "$($_.PsPath)\.Current" -Name "(Default)" -Type String -Value $Data
}
Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "(Default)" -Type String -Value $SoundScheme

# ===========================================================================================================

Write-Output "Disabling Windows Startup sound..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Showing known file extensions..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Showing hidden files..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Hiding sync provider notifications..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Hiding recent shortcuts in Explorer..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Changing default Explorer view to This PC..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

Write-Output "Hiding Desktop icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Desktop icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding Documents icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Documents icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding Downloads icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Downloads icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding Music icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Music icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding Pictures icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Pictures icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding Videos icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding Videos icon from Explorer namespace..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding 3D Objects icon from This PC..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

Write-Output "Hiding 3D Objects icon from Explorer namespace..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
If (!(Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
  New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"

Write-Output "Hiding 'Include in library' context menu item..."
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
}
Remove-Item -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -ErrorAction SilentlyContinue

Write-Output "Hiding 'Give access to' context menu item..."
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
}
Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -ErrorAction SilentlyContinue

Write-Output "Hiding 'Share' context menu item..."
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
}
Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\ModernSharing" -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Disabling creation of thumbnail cache files..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbnailCache" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling creation of Thumbs.db on network folders..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbsDBOnNetworkFolders" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling OneDrive..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Uninstalling OneDrive..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 2
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
If (!(Test-Path $onedrive)) {
  $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
}
Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
Start-Sleep -s 2
Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 2
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Uninstalling default Microsoft applications..."
Get-AppxPackage -AllUsers "Microsoft.3DBuilder" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.AppConnector" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.BingFinance" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.BingNews" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.BingSports" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.BingTranslator" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.BingWeather" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.CommsPhone" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.ConnectivityStore" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.GetHelp" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Getstarted" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Messaging" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Microsoft3DViewer" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MicrosoftPowerBIForWindows" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MinecraftUWP" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MSPaint" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.NetworkSpeedTest" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Office.OneNote" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Office.Sway" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.OfficeLens" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.OneConnect" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.People" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Print3D" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.RemoteDesktop" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.SkypeApp" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Todos" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Wallet" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Whiteboard" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsAlarms" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsCamera" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "microsoft.windowscommunicationsapps" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsMaps" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsPhone" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Windows.Photos" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.ZuneMusic" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.ZuneVideo" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.WebMediaExtensions" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.MixedReality.Portal" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.YourPhone" | Remove-AppxPackage -AllUsers

# ===========================================================================================================

Write-Output "Uninstalling default third party applications..."
Get-AppxPackage -AllUsers "2414FC7A.Viber" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "41038Axilesoft.ACGMediaPlayer" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "46928bounde.EclipseManager" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "4DF9E0F8.Netflix" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "64885BlueEdge.OneCalendar" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "7EE7776C.LinkedInforWindows" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "828B5831.HiddenCityMysteryofShadows" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "89006A2E.AutodeskSketchBook" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "9E2F88E3.Twitter" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "A278AB0D.DisneyMagicKingdoms" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "A278AB0D.MarchofEmpires" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "ActiproSoftwareLLC.562882FEEB491" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "AD2F1837.HPJumpStart" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "AdobeSystemsIncorporated.AdobePhotoshopExpress" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Amazon.com.Amazon" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "C27EB4BA.DropboxOEM" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "CAF9E577.Plex" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "CyberLinkCorp.hs.PowerMediaPlayer14forHPConsumerPC" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "D52A8D61.FarmVille2CountryEscape" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "D5EA27B7.Duolingo-LearnLanguagesforFree" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "DB6EA5DB.CyberLinkMediaSuiteEssentials" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "DolbyLaboratories.DolbyAccess" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Drawboard.DrawboardPDF" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "E046963F.LenovoCompanion" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Facebook.Facebook" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Fitbit.FitbitCoach" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "flaregamesGmbH.RoyalRevolt2" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "GAMELOFTSA.Asphalt8Airborne" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "KeeperSecurityInc.Keeper" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "king.com.BubbleWitch3Saga" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "king.com.CandyCrushSodaSaga" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "LenovoCorporation.LenovoID" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "LenovoCorporation.LenovoSettings" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "PandoraMediaInc.29680B314EFC2" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "PricelinePartnerNetwork.Booking.comBigsavingsonhot" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "SpotifyAB.SpotifyMusic" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "WinZipComputing.WinZipUniversal" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "XINGAG.XING" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "king.com.CandyCrushSaga" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Nordcurrent.CookingFever" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "A278AB0D.DragonManiaLegends" | Remove-AppxPackage -AllUsers

# ===========================================================================================================

Write-Output "Disabling Xbox features..."
Get-AppxPackage -AllUsers "Microsoft.XboxApp" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.XboxIdentityProvider" | Remove-AppxPackage  -AllUsers -ErrorAction SilentlyContinue
Get-AppxPackage -AllUsers "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.XboxGameOverlay" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.XboxGamingOverlay" | Remove-AppxPackage -AllUsers
Get-AppxPackage -AllUsers "Microsoft.Xbox.TCUI" | Remove-AppxPackage -AllUsers
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Edge preload..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" -Name "AllowPrelaunch" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -Name "AllowTabPreloading" -Type DWord -Value 0

# ===========================================================================================================

Write-Output "Disabling Edge shortcut creation..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "DisableEdgeDesktopShortcutCreation" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Disabling Internet Explorer first run wizard..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Type DWord -Value 1

# ===========================================================================================================

Write-Output "Uninstalling Windows Media Player..."
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================

Write-Output "Installing Linux Subsystem..."
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================

Write-Output "Installing .NET Framework 2.0, 3.0 and 3.5 runtimes..."
If ((Get-CimInstance -Class "Win32_OperatingSystem").ProductType -eq 1) {
  Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart -WarningAction SilentlyContinue | Out-Null
} Else {
  Install-WindowsFeature -Name "NET-Framework-Core" -WarningAction SilentlyContinue | Out-Null
}

# ===========================================================================================================

Write-Output "Setting Photo Viewer association for bmp, gif, jpg, png and tif..."
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
  New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
  New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
  Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
  Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
}

# ===========================================================================================================

Write-Output "Uninstalling Microsoft XPS Document Writer..."
Disable-WindowsOptionalFeature -Online -FeatureName "Printing-XPSServices-Features" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================

Write-Output "Removing Default Fax Printer..."
Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue

# ===========================================================================================================

Write-Output "Uninstalling Windows Fax and Scan Services..."
Disable-WindowsOptionalFeature -Online -FeatureName "FaxServicesClientPackage" -NoRestart -WarningAction SilentlyContinue | Out-Null

# ===========================================================================================================

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
