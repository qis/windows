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

Import-Module -Name "$PSScriptRoot\..\script\Win10"

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

# Make the "HKCR:" drive available.
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

# Remove "Edit with Paint 3D" from Explorer context menus.
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "3D Edit" /s /k /e
("3mf", "bmp", "fbx", "gif", "glb", "jfif", "jpe", "jpeg", "jpg", "obj", "ply", "png", "stl", "tif", "tiff") | ForEach {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\3D Edit" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

# Remove "Set as desktop background" from Explorer context menus.
# reg query "HKLM\SOFTWARE\Classes\SystemFileAssociations" /f "setdesktopwallpaper" /s /k /e
("bmp", "dib", "gif", "jfif", "jpe", "jpeg", "jpg", "png", "tif", "tiff", "wdp") | ForEach {
  Remove-Item -Path "HKLM:\Software\Classes\SystemFileAssociations\.$_\Shell\setdesktopwallpaper" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
}

# Remove "AMD Radeon Software" from Explorer context menus.
Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\ACE" -Name "(Default)" -Type String -Value "--"

Done
