# Alpine
Install and launch [Alpine Linux](https://aka.ms/wslstore), then close the terminal.

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
sudo ln -s nvim /usr/bin/vim
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/tmux.conf -o /etc/tmux.conf
curl -L https://raw.githubusercontent.com/qis/windows/master/wsl/ash.sh -o /etc/profile.d/ash.sh
chmod 0755 /etc/profile.d/ash.sh
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

# WSL settings.
Defaults env_keep += "USER_PROFILE"

# User privilege specification.
root  ALL=(ALL) ALL
%sudo ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
```

Exit shell to release `~/.ash_history` and apply profile.

```sh
exit
```

Create `/etc/wsl.conf`.

```sh
[automount]
enabled=true
options=case=off,metadata,uid=1000,gid=1000,umask=022
```

Initialize **user** and **root** home directory structures.

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

Install LLVM toolchain using <https://github.com/qis/llvm>.
