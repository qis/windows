# Debian
Enable WSL support as **administrator**.

```cmd
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Install [WSL 2 Linux Kernel](https://aka.ms/wsl2kernel), then configure WSL.

```cmd
wsl --set-default-version 2
```

Install, launch and configure [Debian Linux](https://aka.ms/wslstore), then `exit` shell.

```cmd
wsl --list
wsl --setdefault Debian
wsl --set-version Debian 2
wsl --distribution Debian --user root
```

Upgrade system to the latest version.

```sh
tee /etc/apt/sources.list >/dev/null <<'EOF'
deb http://ftp.de.debian.org/debian/ unstable main contrib non-free
EOF
```

Update system.

```sh
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt autoclean
```

Install packages.

```sh
apt install -y curl file git gnupg htop man openssh-{client,server} p7zip-full pv pwgen sshpass sudo tmux tree wget
apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 neovim imagemagick pngcrush
```

Configure system.

```sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/bash.sh -o /etc/profile.d/bash.sh
chmod 0755 /etc/profile.d/bash.sh
```

Configure `sudo(8)`.

```sh
EDITOR=vim visudo
```

Type `:1,$d`, `:set paste`, `i` and paste contents followed by `ESC` and `:wq`.

```sh
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER CLICOLOR LSCOLORS TMUX SESSION USERPROFILE"

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

Disable message of the day.

```sh
sed -E 's/^(session.*pam_motd\.so.*)/#\1/' -i /etc/pam.d/*
```

Delete shell config files.

```sh
rm -f /{root,home/*}/.{bashrc,profile,viminfo}
```

Exit shell to release `~/.bash_history`.

```sh
exit
```

Terminate distribution to apply `/etc/wsl.conf` settings.

```cmd
wsl --terminate Debian
```

Configure `nvim`.

```sh
sudo rm -rf /etc/vim /etc/xdg/nvim
sudo ln -s "${USERPROFILE}/vimfiles" /etc/vim
sudo ln -s /etc/vim /etc/xdg/nvim
sudo touch /root/.viminfo
touch ~/.viminfo
```

Clean home directory files.

```sh
sudo rm -f /root/.bash_history /root/.bash_logout
sudo touch /root/.hushlogin
rm -f ~/.bash_history ~/.bash_logout
touch ~/.hushlogin
```

Create **user** home directory symlinks.

```sh
ln -s "${USERPROFILE}/.gitconfig" ~/.gitconfig
ln -s "${USERPROFILE}/Documents" ~/documents
ln -s "${USERPROFILE}/Downloads" ~/downloads
ln -s /mnt/c/Workspace ~/workspace
mkdir -p ~/.ssh; chmod 0700 ~/.ssh
for i in authorized_keys config id_rsa id_rsa.pub known_hosts; do
  ln -s "${USERPROFILE}/.ssh/$i" ~/.ssh/$i
done
sudo chown `id -un`:`id -gn` "${USERPROFILE}/.ssh"/* ~/.ssh/*
sudo chmod 0600 "${USERPROFILE}/.ssh"/* ~/.ssh/*
```

Restart Windows to apply settings.

## Development
Install [LLVM](https://llvm.org/).

```sh
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  llvm-10-runtime llvm-10-tools lld-10 lldb-10 \
  clang-10 clang-format-10 clang-tidy-10 libc++-10-dev libc++abi-10-dev \
  binutils-dev linux-headers-amd64
```

Switch the default C and C++ compiler.

```sh
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang-10 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-10 100
```

Install development packages.

```sh
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  cmake make nasm ninja-build nodejs npm patch perl pkgconf python3 python3-pip sqlite3
```
