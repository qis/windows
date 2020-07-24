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
deb http://deb.debian.org/debian testing main contrib non-free
deb http://deb.debian.org/debian testing-updates main contrib non-free
deb http://deb.debian.org/debian-security testing-security main
EOF
```

Update system.

```sh
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt clean
```

Remove old packages.

```sh
dpkg --list
apt remove -y gcc-8-base iptables mailutils nano vim-tiny
apt autoremove -y
apt clean
```

Install packages.

```sh
apt install -y bzip2 xz-utils
apt install -y ca-certificates curl git wget
apt install -y file gnupg htop man manpages openssh-client p7zip pv pwgen sudo tmux tree
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
Defaults env_keep += "MM_CHARSET EDITOR PAGER LS_COLORS TMUX SESSION USERPROFILE"

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
sudo chown $(id -un):$(id -gn) "${USERPROFILE}/.ssh"/* ~/.ssh/*
sudo chmod 0600 "${USERPROFILE}/.ssh"/* ~/.ssh/*
```

Restart Windows to apply settings.

## eMail
Configure system.

```sh
sudo usermod -c "root@$(hostname -a)" root
sudo usermod -c "$(id -un)@$(hostname -a)" $(id -un)

sudo touch /etc/ssmtp/{ssmtp.conf,revaliases}
sudo chown root:mail /etc/ssmtp/{ssmtp.conf,revaliases}
sudo chmod 0640 /etc/ssmtp/{ssmtp.conf,revaliases}

sudo touch /var/mail/$(id -un)
sudo chown $(id -un):$(id -gn) /var/mail/$(id -un)

exit
```

Replace `exim(8)` with `ssmtp(8)`.

```sh
sudo apt autoremove -y exim4-daemon-light mailutils
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 mailutils ssmtp
```

Configure `ssmtp(8)`.

```sh
email_user=qis
email_fqdn=example.com
read -s email_pass

sudo tee /etc/ssmtp/ssmtp.conf >/dev/null <<EOF
root=$(id -un)
Hostname=$(hostname -a)
MailHub=smtp.ionos.de:587
RewriteDomain=${email_fqdn}
AuthUser=${email_user}@${email_fqdn}
AuthPass=${email_pass}
UseSTARTTLS=YES
EOF

sudo tee /etc/ssmtp/revaliases >/dev/null <<EOF
root:${email_user}@${email_fqdn}
$(id -un):${email_user}@${email_fqdn}
EOF

printf "Subject: ssmtp test\n\nssmtp text" | ssmtp -v ${email_user}@${email_fqdn}
echo "mail text" | mail -s "mail test" ${email_user}@${email_fqdn} --debug-level=7

exit
```

## Updates
Configure automatic updates.

```sh
sudo apt install -y unattended-upgrades apt-listchanges
```

```sh
sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null <'EOF'
APT::Periodic::Update-Package-Lists "7";
APT::Periodic::Unattended-Upgrade "7";
EOF

sudo tee /etc/apt/apt.conf.d/50unattended-upgrades >/dev/null <'EOF'
// Controls which packages are upgraded.
Unattended-Upgrade::Origins-Pattern {
  "o=Debian,a=testing";
  "o=Debian,a=testing-updates";
  "o=Debian,a=testing-security";
};

// Python regular expressions, matching packages to exclude from upgrading.
Unattended-Upgrade::Package-Blacklist {
  "linux-";
};

// Split the upgrade into the smallest possible chunks so that they can be interrupted.
Unattended-Upgrade::MinimalSteps "true";

// Send email to this address for problems or packages upgrades.
//Unattended-Upgrade::Mail "admin@example.com";
//Unattended-Upgrade::MailReport "only-on-error";

// Remove unused automatically installed kernel-related packages.
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";

// Do automatic removal of newly unused dependencies after the upgrade.
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

// Do automatic removal of unused packages after the upgrade.
Unattended-Upgrade::Remove-Unused-Dependencies "true";

// Automatically reboot if the file /var/run/reboot-required is found after the upgrade.
Unattended-Upgrade::Automatic-Reboot "true";

// If automatic reboot is enabled and needed, reboot at the specific time.
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
EOF
```

## Development
Install basic development packages.

```sh
sudo apt install -y autoconf automake bison flex libtool make
sudo apt install -y binutils-dev linux-headers-amd64 libc-dev manpages-dev
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  cmake nasm ninja-build patch perl pkgconf python3 python3-pip sqlite3
```

### GCC
Install [GCC](https://gcc.gnu.org/).

```sh
sudo apt install -y gcc-10 g++-10 gdb
```

Switch the default C and C++ compiler.

```sh
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-10 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-10 100
```

### LLVM
Install [LLVM](https://llvm.org/).

```sh
sudo apt install -y -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 \
  llvm-10-runtime llvm-10-tools lld-10 lldb-10 \
  clang-10 clang-format-10 clang-tidy-10 \
  libc++-10-dev libc++abi-10-dev
```

Switch the default C and C++ compiler.

```sh
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang-10 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-10 100
```
