# Ubuntu
Installation and configuration instructions for Windows 10 on Ubuntu Server with PCI passthrough.

## Preparations
Create an Ubuntu Server installation media with [UNetbootin](https://unetbootin.github.io/).

```
◉ Diskimage [ISO] ubuntu-20.04-live-server-amd64.iso
Space used to preserve files across reboots (Ubuntu only): 512 MB
```

Download software packages necessary for configuring and establishing a Wi-Fi connection.

+ <https://packages.ubuntu.com/focal/amd64/wireless-tools>
  - <https://packages.ubuntu.com/focal/amd64/libiw30>
+ <https://packages.ubuntu.com/focal/amd64/wpasupplicant>
  - <https://packages.ubuntu.com/focal/amd64/libnl-route-3-200>
  - <https://packages.ubuntu.com/focal/amd64/libpcsclite1>
  + <https://packages.ubuntu.com/focal/amd64/libengine-pkcs11-openssl>
    + <https://packages.ubuntu.com/focal/amd64/p11-kit>
      - <https://packages.ubuntu.com/focal/amd64/p11-kit-modules>

Create a `backup` directory on the installation media and copy the `.deb` files.

## Installation
Boot the installation media and install the operating system.

## Configuration
Configure the console (UTF-8, Guess optimal character set, Let the system select a suitable font, 16x32).

```sh
dpkg-reconfigure console-setup
```

Reconfigure CloudInit (deselect everything and select "None").

```sh
dpkg-reconfigure cloud-init
```

Uninstall `snapd`.

```sh
apt purge -y snapd
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

Install software packages necessary for configuring and establishing a Wi-Fi connection.

```sh
mount /dev/sdb /mnt
apt install /mnt/backup/*.deb
```

Delete existing network configurations.

```sh
rm -f /etc/netplan/00-installer-config.yaml
```

<!--
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
-->

Create `/etc/netplan/01-netcfg.yaml` (use `:set expandtab` and `:set shiftwidth=2`).

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
      dhcp6: yes
      optional: true
  wifis:
    wlan0:
      dhcp4: yes
      dhcp6: yes
      optional: true
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

## Updates
Install system updates.

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
apt install -y pv pwgen sshpass tree wireless-tools wpasupplicant
```

## PCI Passthrough
This step is currently being worked on. Notable resources include:

* <https://mathiashueber.com/windows-virtual-machine-gpu-passthrough-ubuntu/>
* <https://forum.level1techs.com/t/play-games-in-windows-on-linux-pci-passthrough-quick-guide/108981>
* <https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF>

## Windows
Use the [readme.md](readme.md) guide to install and set up Windows.
