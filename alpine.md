# Alpine
Set up Alpine Linux in WSL.

```cmd
wsl.exe --setdefault Alpine
wsl.exe --user root
```

Install packages.

```sh
apk update
apk upgrade
apk add curl file git htop neovim openssh-client p7zip pv pwgen sudo tmux tree
apk add imagemagick pngcrush
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/ash.sh -o /etc/profile.d/ash.sh
chmod 0755 /etc/profile.d/ash.sh
exit
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html).

```sh
addgroup sudo
usermod -aG sudo `ls /home|head -1`
passwd `ls /home|head -1`
visudo
```

Paste using the window menu (ALT+Space).

```sh
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER CLICOLOR LSCOLORS TMUX SESSION"

# User privilege specification.
root  ALL=(ALL) ALL
%sudo ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
```

Initialize **user** and **root** home directory structures.

```sh
mkdir -p ~/.config
rm -f ~/.ash_history ~/.viminfo
ln -s /mnt/c/Users/aharm/.gitconfig ~/.gitconfig
ln -s /mnt/c/Users/aharm/vimfiles ~/.config/nvim
touch ~/.config/nviminfo
```

Create **user** home directory symlinks.

```sh
ln -s /mnt/c/Users/aharm/Documents ~/documents
ln -s /mnt/c/Users/aharm/Downloads ~/downloads
ln -s /mnt/c/Workspace ~/workspace
mkdir -p ~/.ssh; chmod 0700 ~/.ssh
for i in authorized_keys config id_rsa id_rsa.pub known_hosts; do
  ln -s /mnt/c/Users/aharm/.ssh/$i ~/.ssh/$i
done
sudo chown `id -un`:`id -gn` /mnt/c/Users/aharm/.ssh/* ~/.ssh/*
sudo chmod 0600 /mnt/c/Users/aharm/.ssh/* ~/.ssh/*
```

Install development packages.

```sh
sudo apk add fortify-headers linux-headers libc-dev
sudo apk add make nasm ninja nodejs npm perl pkgconf python sqlite swig z3
```

Install LLVM.

```sh
sudo apk add build-base cmake libxml2-dev z3-dev libedit-dev ncurses-dev xz-dev
make -C /opt/vcpkg/scripts/toolchains MUSL=ON
sudo apk del build-base cmake libxml2-dev z3-dev libedit-dev ncurses-dev xz-dev
```

Install CMake.

```sh
sudo apk add openssl-dev
wget https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz
tar xf cmake-3.16.4.tar.gz
cd cmake-3.16.4
CC=clang CXX=clang++ sh bootstrap -- -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/cmake
make
make install
sudo apk del openssl-dev
cmake --version
```
