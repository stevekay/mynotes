# USB wifi adapter rtl8812au chipset doesn't work

* Insert adapter, generates these syslog entries, but doesn't appear in `ip a` or `nmcli dev`

````
Jun 13 15:09:43 localhost kernel: usb 1-1.3: new high-speed USB device number 4 using ehci-pci
Jun 13 15:09:43 localhost kernel: usb 1-1.3: New USB device found, idVendor=0bda, idProduct=8812, bcdDevice= 0.00
Jun 13 15:09:43 localhost kernel: usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 13 15:09:43 localhost kernel: usb 1-1.3: Product: 802.11n NIC
Jun 13 15:09:43 localhost kernel: usb 1-1.3: Manufacturer: Realtek
Jun 13 15:09:43 localhost kernel: usb 1-1.3: SerialNumber: 123456
Jun 13 15:09:43 localhost mtp-probe[1473]: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3"
Jun 13 15:09:43 localhost mtp-probe[1473]: bus: 1, device: 4 was not an MTP device
Jun 13 15:09:43 localhost mtp-probe[1474]: checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3"
Jun 13 15:09:43 localhost mtp-probe[1474]: bus: 1, device: 4 was not an MTP device
Jun 13 15:09:45 localhost systemd[1]: systemd-hostnamed.service: Deactivated successfully.
````

* Download, compile, install driver

  * `sudo dnf -y install git kernel-devel kernel-debug-devel`
  * `mkdir ~/src ; cd ~/src`
  * `git clone https://github.com/morrownr/8812au-20210629`
  * `cd 8812au-20210629`
  * `./cdmode-on.sh`
  * `make`
  * `sudo make install`
  * `reboot`

* After reboot, device is visible

````
$ nmcli dev
DEVICE               TYPE      STATE         CONNECTION
eno1                 ethernet  connected     eno1
wlan1                wifi      disconnected  --
wlp0s26u1u3          wifi      disconnected  --
p2p-dev-wlan1        wifi-p2p  disconnected  --
p2p-dev-wlp0s26u1u3  wifi-p2p  disconnected  --
lo                   loopback  unmanaged     --
$
````

* Scan for ssids

````
$ sudo nmcli dev wifi
IN-USE  BSSID              SSID                        MODE   CHAN  RATE        SIGNAL  BARS  SECURITY
        12:34:56:78:9A:BC  HelloWorld                  Infra  44    405 Mbit/s  55      **    WPA2
        12:34:56:78:9A:BC  HelloWorld-Guest            Infra  44    405 Mbit/s  55      **    WPA2

IN-USE  BSSID              SSID                        MODE   CHAN  RATE        SIGNAL  BARS  SECURITY
        12:34:56:78:9A:BC  HelloWorld                  Infra  44    405 Mbit/s  55      **    WPA2
        12:34:56:78:9A:BC  HelloWorld-Guest            Infra  44    405 Mbit/s  55      **    WPA2
$
````

* Connect to network

````
$ sudo nmcli dev wifi connect HelloWorld-Guest --ask
Password: **********
Device 'wlan1' successfully activated with 'a1b510d2-3c5d-4265-a094-0e6ebcbcc345'.
$
````

* Visible via `lsusb` as below

````
$ sudo lsusb
Bus 002 Device 003: ID 062a:4106 MosArt Semiconductor Corp. Wireless Mouse 2.4G
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 04f2:0400 Chicony Electronics Co., Ltd USB Keyboard
Bus 001 Device 003: ID 0bda:8812 Realtek Semiconductor Corp. RTL8812AU 802.11a/b/g/n/ac 2T2R DB WLAN Adapter
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
$
````

