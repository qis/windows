# Alpine
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

Install, launch and configure [Alpine WSL](https://aka.ms/wslstore), then `exit` shell.

```cmd
wsl --list
wsl --setdefault Alpine
wsl --set-version Alpine 2
wsl --distribution Alpine --user root
```

Switch to rolling release.

```sh
sed -E 's/v\d+\.\d+/edge/g' -i /etc/apk/repositories
```

Update system.

```sh
apk update
apk upgrade --purge
```

Install packages.

```sh
apk add coreutils curl file git grep htop p7zip pv pwgen sshpass sudo tmux tree tzdata wipe
apk add neovim openssh-client imagemagick pngcrush
```

Install `nvim` as default `vim`.

```sh
sudo ln -s nvim /usr/bin/vim
```

Configure system.

```sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/ash.sh -o /etc/profile.d/ash.sh
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/wsl.sh -o /etc/profile.d/wsl.sh
chmod 0755 /etc/profile.d/ash.sh /etc/profile.d/wsl.sh
```

Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html).

```sh
EDITOR=tee visudo >/dev/null <<'EOF'
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER LS_COLORS TMUX SESSION USERPROFILE"

# User privilege specification.
root   ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
EOF
```

Create `/etc/wsl.conf`.

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

Exit shell to release `/root/.ash_history`.

```sh
exit
```

Restart distribution to apply `/etc/wsl.conf` settings.

```cmd
wsl --terminate Alpine
wsl --distribution Alpine
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
sudo rm -f /root/.ash_history
rm -f ~/.ash_history
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

## Development
Install basic development packages.

```sh
sudo apk add binutils binutils-dev fortify-headers gcc g++ linux-headers libc-dev
sudo apk add cmake make nasm ninja nodejs npm patch perl pkgconf python3 py3-pip sqlite swig z3
sudo apk add libedit-dev libnftnl-dev libmnl-dev libxml2-dev
sudo apk add curl-dev ncurses-dev openssl-dev xz-dev z3-dev
```
