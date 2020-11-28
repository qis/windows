# Ubuntu
Enable WSL support as **administrator**.

```cmd
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Reboot Windows.

```cmd
shutdown /r /t 0
```

Install [WSL 2 Linux Kernel](https://aka.ms/wsl2kernel), then configure WSL.

```cmd
wsl --set-default-version 2
```

Install and launch [Ubuntu](https://aka.ms/wslstore).

```sh
sudo visudo -c

sudo EDITOR=tee visudo >/dev/null <<'EOF'
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER LS_COLORS TMUX SESSION USERPROFILE"

# User privilege specification.
root  ALL=(ALL) ALL
%sudo ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
EOF

exit
```

Set Ubuntu as the default WSL distribution and start it.

```sh
wsl -s Ubuntu
wsl -d Ubuntu
```

Update system.

```sh
sudo apt update
sudo apt upgrade -y
sudo apt autoremove --purge -y
sudo apt clean
```

Remove snapd.

```sh
sudo apt purge snapd -y
sudo apt autoremove --purge -y
sudo rm -rf /root/snap /snap
sudo apt clean
```

Install packages.

```sh
sudo apt install -y ccze net-tools p7zip pv pwgen tree wipe zip
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 pngcrush imagemagick
```

Configure system.

```sh
sudo curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
sudo curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/bash.sh -o /etc/profile.d/bash.sh
sudo curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/wsl.sh -o /etc/profile.d/wsl.sh
sudo chmod 0755 /etc/profile.d/bash.sh /etc/profile.d/wsl.sh
```

Configure WSL.

```sh
sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[automount]
enabled=true
options=case=off,metadata,uid=1000,gid=1000,umask=022
EOF
```

Disable message of the day.

```sh
sudo sed -E 's/^(session.*pam_motd\.so.*)/#\1/' -i /etc/pam.d/*
```

Replace shell config files.

```sh
sudo rm -f /{root,home/*}/.{bashrc,profile,viminfo}
ln -s /etc/profile.d/bash.sh ~/.bashrc
```

Exit shell to release `~/.bash_history`.

```sh
exit
```

Restart distribution to apply `/etc/wsl.conf` settings.

```cmd
wsl -t Ubuntu
wsl -d Ubuntu
```

Configure `vim`.

```sh
sudo rm -rf /etc/vim
sudo git clone https://github.com/qis/vim /etc/vim
sudo touch /root/.viminfo
touch ~/.viminfo
```

Clean home directory files.

```sh
sudo rm -f /root/.bash_history /root/.bash_logout
rm -f ~/.bash_history ~/.bash_logout
sudo touch /root/.hushlogin
touch ~/.hushlogin
```

Create **user** home directory symlinks in WSL.

```sh
mkdir -p ~/.ssh; chmod 0700 ~/.ssh
for i in authorized_keys config id_rsa id_rsa.pub known_hosts; do
  ln -s "${USERPROFILE}/.ssh/$i" ~/.ssh/$i
done
sudo chown `id -un`:`id -gn` "${USERPROFILE}/.ssh"/* ~/.ssh/*
sudo chmod 0600 "${USERPROFILE}/.ssh"/* ~/.ssh/*
ln -s "${USERPROFILE}/.gitconfig" ~/.gitconfig
```

## SSH Server
Reinstall SSH server.

```sh
sudo apt remove openssh-server
sudo apt install openssh-server
sudo service ssh start
```

Automatically start SSH server.

```
Task Scheduler > Create Task...
+ General
  Name: WSL SSH Server
  Description: Start SSH server in WSL
  Security options: ◉ Run whether user is logged on or not
  ☑ Hidden | Configure for: Windows 10
+ Triggers > New...
  Begin the task: At startup
+ Actions > New...
  Program/script: C:\Windows\System32\wsl.exe
  Add arguments (optional): sudo service ssh start
```
