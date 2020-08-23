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

# Make the "HKCR:" drive available.
If (!(Test-Path "HKCR:")) {
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

# Creates a file association.
function Associate {
  $name = $args[0]
  $text = $args[1]
  $exec = $args[2]
  $icon = $args[3]
  $type = $args[4]
  If ($icon.IndexOf("\") -eq -1) {
    $icon = "%AppData%\Icons\" + $icon
  }
  & cmd /c "ftype ${name}=${exec}"
  Set-ItemProperty -Path "HKCR:\${name}" -Name "(Default)" -Type String -Value "${text}"
  If (!(Test-Path "HKCR:\${name}\DefaultIcon")) {
    New-Item -Path "HKCR:\${name}\DefaultIcon" -Force | Out-Null
  }
  Set-ItemProperty -Path "HKCR:\${name}\DefaultIcon" -Name "(Default)" -Type String -Value "${icon}"
  Remove-Item -Path "HKCR:\${name}_auto_file" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
  $type | ForEach {
    & cmd /c "assoc .${_}=${name}"
    Set-ItemProperty -Path "HKCR:\.${_}" -Name "(Default)" -Type String -Value "${name}"
    Remove-Item -Path "HKCR:\.${_}_auto_file" -Recurse -ErrorAction SilentlyContinue -Force | Out-Null
  }
}

# Icons
$audio = "%ProgramFiles%\MPV\mpv.exe,0"
$video = "%ProgramFiles%\MPV\mpv.exe,0"

# Applications
$7zipfm = '"%ProgramFiles%\7-Zip\7zFM.exe" "%1"'
$player = '"%ProgramFiles%\MPV\mpv.exe" "%1"'

# Archives
Associate "7zip" "Archive" $7zipfm "%ProgramFiles%\7-Zip\7zFM.exe,0" (
  "7z", "arj", "bz2", "cab", "deb", "gz", "lz",
  "lzh", "rar", "rpm", "tar", "wim", "xz", "z", "zip"
)

# Audio
Associate "audio" "Audio" $player $audio ("mp3", "aac", "flac", "mka", "wav")

# Video
Associate "video" "Video" $player $video ("mp4", "avi", "flv", "mkv", "mov", "webm")

& ie4uinit.exe -ClearIconCache
