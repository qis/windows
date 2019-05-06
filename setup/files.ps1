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

# Install custom icons.
& cmake -E copy_directory "$PSScriptRoot\Icons" "$env:AppData\Icons"

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
$conf = "%SystemRoot%\System32\imageres.dll,62"
$text = "%SystemRoot%\System32\imageres.dll,97"

# Applications
$7zipfm = '"%ProgramFiles%\7-Zip\7zFM.exe" "%1"'
$editor = '"%ProgramFiles(x86)%\Vim\vim81\gvim.exe" "%1"'
$sqlite = '"%ProgramFiles%\DB Browser for SQLite\DB Browser for SQLite.exe" "%1"'

# Archives
Associate "7zip" "Archive" $7zipfm "%ProgramFiles%\7-Zip\7zFM.exe,0" (
  "7z", "arj", "bz2", "cab", "deb", "gz", "lz",
  "lzh", "rar", "rpm", "tar", "wim", "xz", "z", "zip"
)

# General
Associate "database" "Database" $sqlite "database.ico" ("db")

# Editor
Associate "configuration" "Configuration" $editor $conf ("cfg", "clang-format", "clang-tidy", "conf", "ini")
Associate "git" "Git" $editor "git.ico" ("gitattributes", "gitconfig", "gitignore", "gitmodules")
Associate "json" "JSON" $editor $text ("json")
Associate "log" "Log" $editor $text ("log")
Associate "markdown" "Markdown" $editor $text ("markdown", "md")
Associate "patch" "Patch" $editor $text ("diff", "patch")
Associate "text" "Text" $editor $text ("txt")

# Code
Associate "asm" "Assembler" $editor "asm.ico" ("asm", "s")
Associate "c" "C Source" $editor "c.ico" ("c")
Associate "cmake" "CMake" $editor "code.ico" ("cmake", "in")
Associate "cpp" "C++ Source" $editor "cpp.ico" ("c++", "cc", "cpp", "cxx")
Associate "cs" "C Sharp" $editor "cs.ico" ("cs")
Associate "css" "CSS" $editor "code.ico" ("css")
Associate "h" "C Header" $editor "h.ico" ("h")
Associate "hpp" "C++ Header" $editor "hpp.ico" ("h++", "hh", "hpp", "hxx", "i++", "ipp", "ixx")
Associate "java" "Java" $editor "code.ico" ("java")
Associate "javascript" "JavaScript" $editor "code.ico" ("js")
Associate "manifest" "Manifest" $editor "xml.ico" ("manifest")
Associate "perl" "Perl" $editor "code.ico" ("pl")
Associate "python" "Python" $editor "code.ico" ("py")
Associate "resource" "Resource" $editor "rc.ico" ("rc")
Associate "shell" "Shell" $editor "code.ico" ("sh")
Associate "vb" "Visual Basic" $editor "vb.ico" ("vb")
Associate "xmlfile" "XML" $editor "xml.ico" ("xml")

& ie4uinit.exe -ClearIconCache

Done
