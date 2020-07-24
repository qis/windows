# Gentoo
Enable WSL support as **administrator**.

```cmd
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Install [WSL 2 Linux Kernel](https://aka.ms/wsl2kernel), then configure WSL.

```cmd
wsl --set-default-version 2
```

<https://developer.moe/gentoo-on-wsl-2>
