# Ubuntu
Install, launch and configure [Ubuntu Linux](https://aka.ms/wslstore), then `exit` shell.

```cmd
wsl.exe --setdefault Ubuntu
wsl.exe --distribution Ubuntu --user root
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
apt install -y curl file git htop neovim openssh-client p7zip-full pv pwgen sudo tmux tree
apt install -y imagemagick pngcrush
```

Install `nvim` as default `vim`.

```sh
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
```

Configure system.

```sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/bash.sh -o /etc/profile.d/bash.sh
chmod 0755 /etc/profile.d/bash.sh
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html).

```sh
EDITOR=vim visudo
```

Type `:1,$d`, `:set paste`, `i` and paste contents followed by `ESC` and `:wq`.

```sh
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER CLICOLOR LSCOLORS TMUX SESSION USER_PROFILE"

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

Exit shell to release `/root/.bash_history` and apply settings.

```sh
exit
```

Create **user** and **root** home directory symlinks.

```sh
mkdir -p ~/.config
rm -f ~/.bash_history ~/.bash_logout ~/.bashrc ~/.profile ~/.viminfo
ln -s "${USER_PROFILE}/vimfiles" ~/.config/nvim
touch ~/.config/nviminfo
```

Create **user** home directory symlinks.

```sh
ln -s "${USER_PROFILE}/.gitconfig" ~/.gitconfig
ln -s "${USER_PROFILE}/Documents" ~/documents
ln -s "${USER_PROFILE}/Downloads" ~/downloads
ln -s /mnt/c/Workspace ~/workspace
mkdir -p ~/.ssh; chmod 0700 ~/.ssh
for i in authorized_keys config id_rsa id_rsa.pub known_hosts; do
  ln -s "${USER_PROFILE}/.ssh/$i" ~/.ssh/$i
done
sudo chown `id -un`:`id -gn` "${USER_PROFILE}/.ssh"/* ~/.ssh/*
sudo chmod 0600 "${USER_PROFILE}/.ssh"/* ~/.ssh/*
```

## Development
Install packages.

```sh
sudo apt install -y binutils linux-headers-generic libc6-dev
sudo apt install -y make nasm ninja-build nodejs npm patch perl pkgconf python python-pip sqlite3 swig z3
sudo apt install -y build-essential binutils-dev libedit-dev libnftnl-dev libmnl-dev libxml2-dev libz3-dev
```

Install [CMake](https://cmake.org/).

```sh
sudo rm -rf /opt/cmake; sudo mkdir -p /opt/cmake
wget https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.tar.gz
sudo tar xf cmake-3.17.0-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
```

Install [Node](https://nodejs.org/).

```sh
sudo rm -rf /opt/node; sudo mkdir -p /opt/node
wget https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz
sudo tar xf node-v12.16.1-linux-x64.tar.xz -C /opt/node --strip-components 1
```
