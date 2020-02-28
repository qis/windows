# Alpine
Install, launch and configure [Alpine Linux](https://aka.ms/wslstore), then `exit` shell.

```cmd
wsl.exe --setdefault Alpine
wsl.exe --distribution Alpine --user root
```

Update system.

```sh
apk update
apk upgrade
```

Install packages.

```sh
apk add coreutils curl file git htop neovim openssh-client p7zip pv pwgen sudo tmux tree
apk add imagemagick pngcrush
```

Install `nvim` as default `vim`.

```sh
sudo ln -s nvim /usr/bin/vim
```

Configure system.

```sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/ash.sh -o /etc/profile.d/ash.sh
chmod 0755 /etc/profile.d/ash.sh
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html).

```sh
addgroup sudo
usermod -aG sudo `ls /home|head -1`
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

Exit shell to release `/root/.ash_history` and apply settings.

```sh
exit
```

Create **user** and **root** home directory symlinks.

```sh
mkdir -p ~/.config
rm -f ~/.ash_history ~/.viminfo
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
sudo apk add binutils fortify-headers linux-headers libc-dev
sudo apk add make nasm ninja patch perl pkgconf python sqlite swig z3
sudo apk add build-base binutils-dev libedit-dev libnftnl-dev libmnl-dev libxml2-dev
sudo apk add curl-dev ncurses-dev openssl-dev xz-dev z3-dev
```

Install [CMake](https://cmake.org/).

```sh
sudo rm -rf /opt/cmake
sudo apk add cmake
wget https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz
tar xf cmake-3.16.4.tar.gz
cmake -GNinja -Wno-dev \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/cmake \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_USE_SYSTEM_CURL=ON \
  -B cmake-build cmake-3.16.4
ninja -C cmake-build
sudo ninja -C cmake-build install
sudo apk del cmake
```

Install [Node](https://nodejs.org/).

```sh
sudo apk add nodejs npm
```
