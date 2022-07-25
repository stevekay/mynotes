

openelec page is at http://openelec.tv/get-openelec

choose stable releases -> freescale imx6

download disk image

wget http://openelec.tv/get-openelec/category/58-freescale-imx6-builds?download=103:solidrun-cubox-hummingboard-diskimage

[steve@localhost openelec]$ ls -l
total 154932
-rw-rw-r--. 1 steve steve 158650248 Jan 12 01:12 58-freescale-imx6-builds?download=103:solidrun-cubox-hummingboard-diskimage
[steve@localhost openelec]$

[steve@localhost openelec]$ file *
58-freescale-imx6-builds?download=103:solidrun-cubox-hummingboard-diskimage: gzip compressed data, was "OpenELEC-imx6.arm-7.0.1.img", from Unix, last modified: Thu Jan 12 00:38:03 2017




[steve@localhost openelec]$ file OpenELEC-imx6.arm-7.0.1.img
OpenELEC-imx6.arm-7.0.1.img: x86 boot sector; partition 1: ID=0xc, active, starthead 0, startsector 2048, 1048577 sectors; partition 2: ID=0x83, starthead 3, startsector 1052672, 65537 sectors, code offset 0xb8
[steve@localhost openelec]$


[steve@localhost openelec]$ sudo dd if=OpenELEC-imx6.arm-7.0.1.img of=/dev/sdc bs=1M


[steve@localhost openelec]$ sudo dd if=OpenELEC-imx6.arm-7.0.1.img of=/dev/sdc bs=1M
548+0 records in
548+0 records out
574619648 bytes (575 MB) copied, 106.489 s, 5.4 MB/s
[steve@localhost openelec]$


on first boot, resizes to full size of sd card

alas, black screen....

FAIL
