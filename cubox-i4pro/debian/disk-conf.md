# SD card configuration details, of working Debian image

## Partition layout

    root@cubox-i:~# fdisk -l
    
    Disk /dev/mmcblk0: 7892 MB, 7892631552 bytes
    32 heads, 32 sectors/track, 15054 cylinders, total 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x2fc08b14
    
            Device Boot      Start         End      Blocks   Id  System
    /dev/mmcblk0p1            1024       12287        5632   83  Linux
    /dev/mmcblk0p2           12288    15415295     7701504   83  Linux
    root@cubox-i:~#

## Partition contents

    root@cubox-i:~# file -s /dev/mmcblk0
    /dev/mmcblk0: sticky x86 boot sector; partition 1: ID=0x83, starthead 0, startsector 1024, 11264 sectors; partition 2: ID=0x83, starthead 0, startsector 12288, 15403008 sectors, code offset 0x0
    root@cubox-i:~# file -s /dev/mmcblk0p1
    /dev/mmcblk0p1: sticky Linux rev 1.0 ext2 filesystem data, UUID=c361e56a-0494-49a8-8090-0ab2a7cb9a0b, volume name "busybox"
    root@cubox-i:~# file -s /dev/mmcblk0p2
    /dev/mmcblk0p2: sticky Linux rev 1.0 ext3 filesystem data, UUID=db64d24f-c0c8-4ab3-82ae-a8ca3a2592f9 (needs journal recovery) (large files)
    root@cubox-i:~#

## Filesystem contents

    root@cubox-i:~# df -h /boot
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/mmcblk0p1  5.4M  5.2M  167K  97% /boot
    root@cubox-i:~# find /boot -ls
         2    1 drwxr-xr-x   5 root     root         1024 Jan 28  2014 /boot
        11   12 drwx------   2 root     root        12288 Jan 28  2014 /boot/lost+found
        12    1 drwxr-xr-x   2 root     root         1024 Jan 28  2014 /boot/boot
        13 4613 -rw-r--r--   1 root     root      4703740 Jan 28  2014 /boot/boot/uImage
        14  630 -rwxr-xr-x   1 root     root       640496 Jan 28  2014 /boot/busybox
        15    1 -rwxr-xr-x   1 root     root          854 Jan 28  2014 /boot/init
        16    3 -rw-r--r--   1 root     root         2268 Jan 28  2014 /boot/arch-boot.tar.xz
        17    1 drwxr-xr-x   2 root     root         1024 Jan 28  2014 /boot/root
    root@cubox-i:~# file /boot/boot/uImage
    /boot/boot/uImage: u-boot legacy uImage, Linux-3.0.35-8, Linux/ARM, OS Kernel Image (Not compressed), 4703676 bytes, Mon Jan 27 00:27:21 2014, Load Address: 0x10008000, Entry Point: 0x10008000, Header CRC: 0x2CBDA85C, Data CRC: 0x7E2A454B
    root@cubox-i:~# file /boot/busybox
    /boot/busybox: ELF 32-bit LSB executable, ARM, version 1 (SYSV), statically linked, stripped
    root@cubox-i:~# cat /boot/init
    #!/busybox sh
    /busybox mkdir -p /root
    /busybox mount -t tmpfs none /root
    /busybox mkdir /root/bin /root/root
    /busybox cp /busybox /root/bin/
    /root/bin/busybox --install /root/bin
    
    /busybox cat > /root/init <<"EOF"
    #!/bin/sh
    umount /root
    
    mkdir -p /proc /sys /dev /tmp /var/run
    mkdir -p /etc /mnt
    ln -s var/run
    
    mount -t proc     none /proc
    mount -t sysfs    none /sys
    mount -t devtmpfs none /dev
    
    mkdir -p /dev/pts /dev/shm
    mount -t devpts   none /dev/pts
    mount -t tmpfs    none /dev/shm
    
    mount -t tmpfs    none /tmp
    mount -t tmpfs    none /var/run
    
    echo 'root:$1$ihlrowCo$sF0HjA9E8up9DYs258uDQ0:10063:0:99999:7:::' > /etc/shadow
    echo 'root:x:0:0:root:/root:/bin/sh' > /etc/passwd
    touch /etc/group
    
    rm /init
    exec sh
    EOF
    
    /busybox chmod +x /root/init
    /busybox tar -xf /arch-boot.tar.xz -C /root/root
    
    /busybox pivot_root /root /root/root
    
    cd /
    exec /init
    root@cubox-i:#
    
