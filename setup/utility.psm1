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

function IsAdmin {
  $identity = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  return $identity.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
