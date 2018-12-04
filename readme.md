# Windows
Installation and configuration instructions for Windows 10 (Version 1803).


## Installation
Download the latest [Windows 10](https://www.microsoft.com/en-us/software-download/windows10) image and create a USB stick.

Create the file `\sources\ei.cfg` on the USB stick.

```ini
[EditionID]
Professional
[Channel]
Retail
[VL]
0
```

Create the file `\sources\pid.txt` on the USB stick.

```ini
[PID]
Value={windows key}
```

Set the BIOS date and time to the current local time.

Keep the system disconnected from the network.

Perform a clean install.

<!--
Language to install: English (United States)<br/>
Time and currency format: {current time zone country}<br/>
Keyboard or input method: {current hardware keyboard}<br/>

Choose 131700 MB when creating the first partition and 102400 MB when creating
the second partition on a 256 GiB drive.
-->

Create a single word username starting with a capital letter to keep the `%UserProfile%` path free from spaces.

## System
Configure display scaling and resolution.

```
Settings > System > Display
```

Change the hostname.

```
Settings > System > About > Rename PC
```

Reboot the system.

Change the NetBIOS name as **Administrator**.

```ps
$MemberDefinition = @'
[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
public static extern bool SetComputerName(string name);
'@
$Kernel32 = Add-Type -MemberDefinition $MemberDefinition -Name 'Kernel32' -Namespace 'Win32' -PassThru
$Kernel32::SetComputerName("{hostname}");
shutdown -r -t 0
```

Set the full user name.

```cmd
lusrmgr.msc > Users
{User} context menu "Rename": {user}
{user} context menu "Properties":
+ Full Name: {Full Name}
```

Reboot the system.

Disable system restore.

```cmd
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f
```

Disable hibernation (not recommended for mobile computers).

```cmd
powercfg -h off
```

Disable virtual memory.

```
Control Panel > "System" > Advanced system settings > Advanced > Performance [Settings...] > Advanced > [Change...]
```

Reboot the system.


## Cortana
Disable Cortana as **User**

```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
```

Disable Cortana as **Administrator**.

```cmd
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
```


## Apps
Disable consumer apps as **Administrator**.

```cmd
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
```

Uninstall unwanted apps as *Administrator*.

```ps
Get-AppxPackage -allusers 'Microsoft.GetHelp' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Getstarted' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Messaging' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Microsoft3DViewer' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.MicrosoftOfficeHub' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.MicrosoftSolitaireCollection' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.MicrosoftStickyNotes' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.MSPaint' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Office.OneNote' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.OneConnect' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Print3D' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.SkypeApp' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.WindowsCamera' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.WindowsMaps' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.WindowsSoundRecorder' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.Xbox*' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.ZuneMusic' | Remove-AppxPackage
Get-AppxPackage -allusers 'Microsoft.ZuneVideo' | Remove-AppxPackage
```

Uninstall OneDrive.

```
Settings > Apps > Microsoft OneDrive
```

List remaining apps.

```ps
Get-AppxPackage | Select Name,PackageFullName | Sort Name
```

Uninstall unwanted optional features.

```
Settings > Apps > Manage optional features
```

Clean up the Start Menu.


## Group Policies
Configure group policies (skip unwanted steps).

```
gpedit.msc > Computer Configuration > Administrative Templates > Control Panel

Personalization
+ Do not display the lock screen: Enabled

gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Cloud Content
+ Turn off Microsoft consumer experiences: Enabled

Data Collection and Preview Builds
+ Allow Telemetry: Disabled
+ Do not show feedback notifications: Enabled

OneDrive
+ Save documents to OneDrive by default: Disabled
+ Prevent the usage of OneDrive for file storage: Enabled
+ Prevent the usage of OneDrive for file storage on Windows 8.1: Enabled

Search
+ Allow Cortana: Disabled
+ Allow Cortana above lock screen: Disabled
+ Do not allow web search: Enabled
+ Don't search the web or display web results in Search: Enabled

Speech
+ Allow Automatic Update of Speech Data: Disabled

Windows Defender Antivirus
+ Turn off Windows Defender Antivirus: Enabled

Windows Defender Antivirus > MAPS
+ Join Microsoft MAPS: Disabled

Windows Defender Antivirus > Network Inspection System
+ Turn on definition retirement: Disabled
+ Turn on protocol recognition: Disabled

Windows Defender Antivirus > Real-time Protection
+ Turn off real-time protection: Enabled

Windows Defender Antivirus > Signature Updates
+ Allow definition updates from Microsoft Update: Disabled

Windows Defender SmartScreen > Explorer
+ Configure Windows Defender SmartScreen: Disabled

Windows Defender SmartScreen > Microsoft Edge
+ Configure Windows Defender SmartScreen: Disabled

Windows Error Reporting
+ Disable Windows Error Reporting: Enabled

Windows Update
+ Configure Automatic Updates: Enabled
  Configure automatic updating: 2 - Notify for download and auto install
  [✓] Install updates for other Microsoft products
```


## Tracking
Delete diagnostics services.

```cmd
sc delete diagtrack
sc delete dmwappushservice
```

Disable Application Experience tasks.

```
Task Scheduler > Task Scheduler Library > Microsoft > Windows > Application Experience
+ Microsoft Compatibility Appraiser: Disabled
+ ProgramDataUpdater: Disabled
```


## Drivers & Updates
Disable automatic driver application installation.

```
Control Panel > "System" > Advanced system settings > Hardware > Device Installation Settings
(·) No (your device might not work as expected)
```

Reboot the system.

Connect to the Internet.

Install the latest graphics card drivers.

Install Windows updates.


## Startup
Disable automatically started applications.

```
Task Manager > Startup
+ Windows Defender notification icon: Disabled
```


## Services
Disable unwanted services (ignore if missing).

```
services.msc
+ Certificate Propagation: Manual -> Disabled
+ Microsoft (R) Diagnostics Hub Standard Collector Service: Manual -> Disabled
+ Microsoft Office Click-to-Run Service: Automatic -> Disabled
+ Superfetch: Automatic -> Disabled
+ Windows Biometric Service: Manual -> Disabled
+ Windows Mobile-2003-based device connectivity: Log on as "Local System account"
+ Xbox Accessory Management Service: Manual -> Disabled
+ Xbox Live …: Manual -> Disabled
```


## Notifications
Disable unwanted notifications.

```
Control Panel > System and Security > Security and Maintenance
  [Turn off all messages about …]
```


## Windows Libraries
Move unwanted Windows libraries.

1. Right click on `%UserProfile%\Pictures\Camera Roll` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Camera Roll`.
2. Right click on `%UserProfile%\Pictures\Saved Pictures` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Saved Pictures`.
3. Right click on `%UserProfile%\Videos\Captures` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Captures`.


## Explorer
Hide unwanted "Explorer" links.

```cmd
rem OneDrive
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
```

Hide unwanted "This PC" links.

```cmd
rem 3D Objects
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Desktop
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Documents
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Downloads
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Music
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Pictures
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

rem Videos
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
```

Remove "Edit with Paint 3D", "Edit with Photos" and "Set as desktop background" file context menus.

```cmd
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.obj\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\setdesktopwallpaper" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\setdesktopwallpaper" /f
reg add "HKCR\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
```


## Firewall
Disable all rules in Windows Firewall except the following entries.

```
wf.msc
+ Inbound Rules
  + Connect
  + Core Networking - …
  + Delivery Optimization (…)
  + Hyper-V …
  + Network Discovery (…)
  + Remote Desktop - …
+ Outbound Rules
  + Connect
  + Core Networking - …
  + Hyper-V …
  + Network Discovery (…)
```

Enable inbound rules for "Remomte Desktop - …" if necessary.

Enable inbound rules for "File and Printer Sharing (Echo Request …)". Modify "Private,Public"
rules for inbound and outbound IPv4 and IPv6 Echo Requests and select "Any IP address" under
"Remote IP address" in the "Scope" tab.

To enable the WSL SSH Server, you need to replace the "SSH Server Proxy Service" inbound rule
with a new inbound rule for port 22.


## Keymap
Use this [keymap](res/keymap.zip) to input German characters on a U.S. keyboard.


## Microsoft Software
Configure [Microsoft Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) after visiting <https://www.google.com/ncr>.

```
Settings
Open Microsoft Edge with: A specific page or pages
  about:blank
Open Microsoft Edge with: Previous pages
Open new tabs with: A blank page
[View advanced settings]
  Show the home button: Off
  Use Adobe Flas Player: Off
  Open sites in apps: Off
  Ask me what to do with each download: Off
  [Change search engine]
    Select: Google Search (discovered)
    [Set as default]
  Show search and site suggestions as I type: Off
  Show search history: Off
  Show sites I frequently visit in Top sites: Off
  Let sites save protected media licenses on my device: Off
  Use page prediction to speed up browsing, …: Off
```

Configure [Internet Explorer](https://en.wikipedia.org/wiki/Internet_Explorer).

```
Internet options > General
Home page: about:blank
Startup: Start with tabs from the last session
```

Configure the Photos app.

```
Photos > Settings
Linked duplicates: Off
People: Off
Mouse wheel: Zoom in and out
```

Configure [Outlook 2016](https://products.office.com/en/outlook).

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Setup" /v "DisableOffice365SimplifiedAccountCreation" /t REG_DWORD /d 1 /f
```


## Fonts
Install useful fonts.

* [DejaVu & DejaVu LGC](https://sourceforge.net/projects/dejavu/files/dejavu)
* [DejaVu Sans Mono from Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
* [Iconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* [IPA](http://ipafont.ipa.go.jp)


## Third Party
Install third party software.

* [7-Zip](http://www.7-zip.org)
* [ConEmu](https://conemu.github.io)
* [Affinity Photo](https://affinity.serif.com/photo)
* [Affinity Designer](https://affinity.serif.com/designer)
* [Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview)
* [Blender](https://www.blender.org/)
* [Sublime Text 3](https://www.sublimetext.com/)
* [gVim](http://www.vim.org)
* [Git](https://git-scm.com/)


## gVim
Configure gVim.

```cmd
git clone https://github.com/qis/vim %UserProfile%\vimfiles
```

## Sublime Text 3
Install [Visual Studio Dark](https://packagecontrol.io/packages/Visual%20Studio%20Dark).<br/>
Install [MarkdownEditing](https://packagecontrol.io/packages/MarkdownEditing) (optional).

Configure Sublime Text 3.

```json
// Preferences > Settings
{
  "color_scheme": "Packages/Visual Studio Dark/Visual Studio Dark.tmTheme",
  "close_windows_when_empty": true,
  "ensure_newline_at_eof_on_save": true,
  "font_face": "DejaVu LGC Sans Mono",
  "font_size": 9,
  "hot_exit": false,
  "ignored_packages": [ "Markdown", "Vintage" ],
  "open_files_in_new_window": false,
  "rulers": [ 120 ],
  "show_definitions": false,
  "tab_size": 2,
  "theme": "Default.sublime-theme",
  "translate_tabs_to_spaces": true,
  "caret_extra_bottom": 1,
  "caret_extra_top": 1,
  "caret_extra_width": 1
}
```

Configure GFM (optional).

```json
// Preferences > Package Settings > Markdown Editing > Markdown GFM Settings - User
{
  "color_scheme": "Packages/Visual Studio Dark/Visual Studio Dark.tmTheme",
  "trim_trailing_white_space_on_save": true,
  "draw_centered": false,
  "line_numbers": true,
  "word_wrap": false,
  "rulers": [ 120 ],
  "tab_size": 2
}
```


<!--
## Server
Install software for Windows Server administration.


* [SQL Server Management Studio](https://msdn.microsoft.com/en-us/library/mt238290.aspx)
* [Remote Server Administration Tools for Windows 10](https://www.microsoft.com/en-us/download/details.aspx?id=45520)

Configure the WinRM client.

```cmd
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex {InterfaceIndex} -NetworkCategory Private
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

Configure the WinRM server.

```ps
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

Configure the WinRM server to accept HTTPS connections.

```ps
winrm enumerate winrm/config/listener
New-SelfSignedCertificate -DnsName "{DomainName}" -CertStoreLocation Cert:\LocalMachine\My
cmd /C 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="{DomainName}"; CertificateThumbprint="{Thumbprint}"}'
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
```

Connect over HTTP.

```ps
Enter-PSSession -ComputerName host.domain -Port 5985 -Credential administrator@domain
```

Connect over HTTPS.

```ps
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName host.domain -Port 5986 -Credential administrator@domain -SessionOption $soptions -UseSSL
```
-->


<!--
## Control Panel
Add Control Panel shortcuts to the Windows start menu (use icons from `C:\Windows\System32\shell32.dll`).

[Control Panel Command Line Commands](https://www.lifewire.com/command-line-commands-for-control-panel-applets-2626060)
-->


<!--
## Anti-Virus
Suggested third party anti-virus exclusion lists.

```
Excluded Processes

%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\PerfWatson2.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\VcxprojReader.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.12.25827\bin\HostX86\x64\CL.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.12.25827\bin\HostX86\x64\link.exe

Excluded Directories

%ProgramFiles(x86)%\Microsoft Visual Studio\
%ProgramFiles(x86)%\Windows Kits\
%UserProfile%\AppData\Local\lxss\
C:\Workspace\
```
-->


## Windows Features
Enable or disable Windows features.

```
Control Panel > Programs > Turn Windows features on or off
[■] .NET Framework 3.5 (includes .NET 2.0 and 3.0)
[✓] Hyper-V
[ ] Microsoft XPS Document Writer
[■] SMB 1.0/CIFS File Sharing Support
    [✓] SMB 1.0/CIFS Client
[✓] Telnet Client
[✓] TFTP Client
[✓] Windows Hypervisor Platform
[✓] Windows Subsystem for Linux
```

Reboot the system.

## Windows Subsystem for Linux
Install a WSL distro from <https://aka.ms/wslstore>, launch it and download config files.

```sh
wget https://raw.githubusercontent.com/qis/windows/master/wsl/.bashrc
wget https://raw.githubusercontent.com/qis/windows/master/wsl/.profile
wget https://raw.githubusercontent.com/qis/windows/master/wsl/.tmux.conf
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html) with `sudo EDITOR=vim visudo`.

```sh
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER CLICOLOR LSCOLORS TMUX SESSION"

# User privilege specification.
root  ALL=(ALL) ALL
%sudo ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
```

Create `/etc/wsl.conf`.

```sh
[automount]
enabled=true
options=case=off,metadata,uid=1000,gid=1000,umask=022
```

Fix timezone information.

```sh
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo Europe/Berlin | sudo tee /etc/timezone
```

Add the following line to `/etc/mdadm/mdadm.conf` (fixes some `apt` warnings).

```sh
# definitions of existing MD arrays
ARRAY <ignore> devices=/dev/sda
```

Modify the following lines in `/etc/pam.d/login` (disables message of the day).

```sh
#session    optional    pam_motd.so motd=/run/motd.dynamic
#session    optional    pam_motd.so noupdate
```

Restart `bash.exe`.

Create Windows symlinks.

```sh
ln -s /mnt/c/Users/Qis/vimfiles .config/nvim
ln -s /mnt/c/Users/Qis/vimfiles .vim
ln -s /mnt/c/Users/Qis/Documents ~/documents
ln -s /mnt/c/Users/Qis/Downloads ~/downloads
ln -s /mnt/c/Workspace ~/workspace
mkdir -p ~/.ssh
for i in config id_rsa id_rsa.pub known_hosts; do
  ln -s /mnt/c/Users/Qis/.ssh/$i ~/.ssh/$i
done
chmod 0600 ~/.ssh/*
```

Install packages.

```sh
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
sudo apt autoremove
sudo apt install apt-file p7zip p7zip-rar zip unzip tree htop
sudo apt install imagemagick pngcrush
sudo apt install siege
sudo apt-file update
```

Install youtube-dl.

```sh
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

Install [WSLtty](https://github.com/mintty/wsltty) for better terminal support.<br/>
Install [VcXsrv](https://github.com/ArcticaProject/vcxsrv/releases) for Xorg application support.


## Settings
Follow the [Settings](settings.md) guide to finish the configuration.


## Development
Follow the [Development](development.md) guide to set up a developer workstation.


## Start Menu
![Start Menu](res/start.png)
