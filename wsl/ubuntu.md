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

Install, launch and configure [Ubuntu Linux](https://aka.ms/wslstore), then `exit` shell.

```cmd
wsl --list
wsl --setdefault Ubuntu
wsl --set-version Ubuntu 2
wsl --distribution Ubuntu --user root
```

Update system.

```sh
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt clean
```

Install packages.

```sh
apt install -y ca-certificates curl file git gnupg htop man manpages p7zip pv pwgen sudo tmux tree wget wipe
apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 neovim imagemagick pngcrush
```

Install `nvim` as default `vim`.

```sh
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
```

Configure system.

```sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/bash.sh -o /etc/profile.d/bash.sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/wsl.sh -o /etc/profile.d/wsl.sh
chmod 0755 /etc/profile.d/bash.sh /etc/profile.d/wsl.sh
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html).

```sh
EDITOR=tee visudo >/dev/null <<'EOF'
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
```

Configure WSL.

```sh
tee /etc/wsl.conf >/dev/null <<'EOF'
[automount]
enabled=true
options=case=off,metadata,uid=1000,gid=1000,umask=022
EOF
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

Restart distribution to apply `/etc/wsl.conf` settings.

```cmd
wsl --terminate Ubuntu
wsl --distribution Ubuntu
```

Configure `nvim`.

```sh
sudo rm -rf /etc/vim /etc/xdg/nvim; sudo mkdir -p /etc/xdg
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
Install basic development packages.

```sh
sudo apt install -y binutils-dev linux-headers-generic libc6-dev manpages-dev
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  autoconf automake bison flex libtool make nasm ninja-build patch \
  perl pkgconf python3 python3-pip sqlite3 zip
```

Install CMake.

```sh
sudo rm -rf /opt/cmake; sudo mkdir -p /opt/cmake
wget https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.tar.gz
sudo tar xf cmake-3.18.0-Linux-x86_64.tar.gz -C /opt/cmake --strip-components=1
sudo tee /etc/profile.d/cmake.sh >/dev/null <<'EOF'
export PATH="/opt/cmake/bin:${PATH}"
EOF
sudo chmod 0755 /etc/profile.d/cmake.sh
rm -f cmake-3.18.0-Linux-x86_64.tar.gz
```

Install [GCC](https://gcc.gnu.org/).

```sh
sudo apt install -y gcc-10 g++-10 gdb
```

Set default GCC compiler.

```sh
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100
```

Install [LLVM](https://llvm.org/).

```sh
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  llvm-10-{runtime,tools} {lld,lldb,clang,clang-format,clang-tidy}-10 libc++{,abi}-10-dev
```

Set default LLVM compiler.

```sh
sudo update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-10   100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-10 100
```

Set default system compiler.

```sh
sudo update-alternatives --remove-all cc
sudo update-alternatives --remove-all c++
sudo update-alternatives --install /usr/bin/cc  cc  /usr/bin/clang   100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
```

Install code formatting tools.

```sh
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  clang-format-10 clang-tidy-10
```

Set default code formatting tools.

```sh
sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-10 100
sudo update-alternatives --install /usr/bin/clang-tidy   clang-tidy   /usr/bin/clang-tidy-10   100
```

### Node.js
Install [Node.js](https://nodejs.org/).

```sh
sudo rm -rf /opt/node; sudo mkdir -p /opt/node
wget https://nodejs.org/dist/v12.18.3/node-v12.18.3-linux-x64.tar.xz
sudo tar xf node-v12.18.3-linux-x64.tar.xz -C /opt/node --strip-components=1
sudo tee /etc/profile.d/node.sh >/dev/null <<'EOF'
export PATH="/opt/node/bin:${PATH}"
EOF
sudo chmod 0755 /etc/profile.d/node.sh
rm -f node-v12.18.3-linux-x64.tar.xz
```
