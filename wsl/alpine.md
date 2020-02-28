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
EDITOR=vi visudo
```

Press `i` and paste using the window menu followed by `ESC` and `:wq`.

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
ln -s "${USER_PROFILE}/.gitconfig" ~/.gitconfig
ln -s "${USER_PROFILE}/vimfiles" ~/.config/nvim
touch ~/.config/nviminfo
```

Create **user** home directory symlinks.

```sh
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
sudo apk add make nasm ninja nodejs npm patch perl pkgconf python sqlite swig z3
sudo apk add build-base libxml2-dev z3-dev libedit-dev ncurses-dev xz-dev
```

Install [CMake](https://cmake.org/).

```sh
sudo rm -rf /opt/cmake
sudo apk add cmake curl-dev openssl-dev
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
sudo apk del cmake curl-dev openssl-dev
```

Add `/opt/cmake/bin` to the `PATH` environment variable.

```sh
export PATH="/opt/cmake/bin:${PATH}"
cmake --version
```

Create required directories on Windows.

```cmd
md C:\Workspace
md C:\Workspace\downloads
```

Download [vcpkg](https://github.com/microsoft/vcpkg) and [qis/toolchains](https://github.com/qis/toolchains) on Windows.

```cmd
cd C:\Workspace
git clone git@github.com:microsoft/vcpkg
cmake -E rename vcpkg/scripts/toolchains vcpkg/scripts/toolchains.orig
git clone git@github.com:qis/toolchains vcpkg/scripts/toolchains
```

Set Windows environment variables in `rundll32.exe sysdm.cpl,EditEnvironmentVariables`.

```cmd
set VCPKG_ROOT=C:\Workspace\vcpkg
set VCPKG_DOWNLOADS=C:\Workspace\downloads
set VCPKG_DEFAULT_TRIPLET=x64-windows
```

Create symbolic links in `wsl.exe`.

```sh
sudo ln -s /mnt/c/Workspace/vcpkg /opt/vcpkg
sudo ln -s /mnt/c/Workspace/downloads /opt/downloads
```

Build vcpkg in `cmd.exe`.

```cmd
C:\Workspace\vcpkg\bootstrap-vcpkg.bat -disableMetrics -win64
```

Build vcpkg in `wsl.exe`.

```sh
/opt/vcpkg/bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries && rm -rf /opt/vcpkg/toolsrc/build.rel
```

<details>
<summary>Modify the <code>triplets/x64-windows.cmake</code> triplet file.</summary>
&nbsp;

```cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_LIBRARY_LINKAGE dynamic)
set(VCPKG_CRT_LINKAGE dynamic)

set(VCPKG_C_FLAGS "/arch:AVX2 /W3 /wd26812 /wd28251 /wd4275")
set(VCPKG_CXX_FLAGS "${VCPKG_C_FLAGS}")
```

</details>

<details>
<summary>Modify the <code>triplets/x64-windows-static.cmake</code> triplet file.</summary>
&nbsp;

```cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CRT_LINKAGE static)

set(VCPKG_C_FLAGS "/arch:AVX2 /W3 /wd26812 /wd28251 /wd4275")
set(VCPKG_CXX_FLAGS "${VCPKG_C_FLAGS}")
```

</details>

<details>
<summary>Modify the <code>triplets/x64-linux.cmake</code> triplet file.</summary>
&nbsp;

```cmake
set(VCPKG_CMAKE_SYSTEM_NAME Linux)
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)
```

</details>

Build LLVM in `wsl.exe`.

```sh
make -C /opt/vcpkg/scripts/toolchains MUSL=ON TRIPLE=x86_64-linux-musl
```

Install the same TBB version in `cmd.exe`.

```cmd
vcpkg install --overlay-ports="%VCPKG_ROOT%\scripts\toolchains\tbb" tbb:x64-windows tbb:x64-windows-static
```

Remove dependencies (optional).

```sh
sudo apk del build-base libxml2-dev z3-dev libedit-dev ncurses-dev xz-dev
```
