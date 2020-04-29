# Ubuntu
Configure the console (UTF-8, Guess optimal character set, Let the system select a suitable font, 16x32).

```sh
dpkg-reconfigure console-setup
```

Reconfigure CloudInit (deselect everything except "None").

```sh
dpkg-reconfigure cloud-init open-iscsi
```

Remove unused packages and reboot the system.

```sh
apt purge -y cloud-init cloud-guest-utils cloud-initramfs-{copymods,dyn-netconf} open-iscsi
rm -rf /etc/cloud /var/lib/cloud
apt autopurge -y
reboot
```

Modify GRUB config `/etc/default/grub`.

```
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
```

Update GRUB config and reboot the system.

```sh
update-grub
reboot
```

<!--

If wired network is not available, use Wi-Fi and install the following packages manually:

+ <https://packages.ubuntu.com/focal/amd64/wireless-tools>
  - <https://packages.ubuntu.com/focal/amd64/libiw30>
+ <https://packages.ubuntu.com/focal/amd64/wpasupplicant>
  - <https://packages.ubuntu.com/focal/amd64/libnl-route-3-200>
  - <https://packages.ubuntu.com/focal/amd64/libpcsclite1>
  + <https://packages.ubuntu.com/focal/amd64/libengine-pkcs11-openssl>
    + <https://packages.ubuntu.com/focal/amd64/p11-kit>
      - <https://packages.ubuntu.com/focal/amd64/p11-kit-modules>

-->

Update the system.

```sh
apt update
apt upgrade -y
apt dist-upgrade -y
apt autopurge -y
apt autoclean
reboot
```

Install packages.

```sh
apt install -y neovim p7zip-full pv pwgen sshpass tree
apt install -y imagemagick pngcrush fonts-dejavu wireless-tools wpasupplicant
```

Test Wi-Fi (add `scan_ssid=1` if the SSID is not broadcasted).

```sh
iwconfig
ip link set wlan0 up
iwlist wlan0 scan | grep ESSID
wpa_passphrase SSID PSK > /etc/wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
dhclient wlan0
ip addr show
```

Delete existing network configurations.

```sh
rm -f /etc/netplan/00-installer-config.yaml
```

Create `/etc/netplan/01-netcfg.yaml` (use `:set expandtab` and `:set shiftwidth=2`).

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
      dhcp6: no
  wifis:
    wlan0:
      dhcp4: yes
      dhcp6: no
      access-points:
        "<ssid>":
          password: "<password>"
```

Apply network settings and reboot.

```sh
systemctl daemon-reload
netplan apply
reboot
```

Delete Wi-Fi test configuration file.

```sh
rm /etc/wpa_supplicant.conf
```

## Development
Use the [WSL](wsl/ubuntu.md) guide to configure a development environment.

## Desktop

