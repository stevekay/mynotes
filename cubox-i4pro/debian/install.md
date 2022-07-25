# Installing Debian 7 wheezy on cubox-i4pro.

Notes based on following https://gist.github.com/richardjortega/b7c5435f2cd1f8f75298 and https://people.debian.org/~gwolf/

## On a Linux VM, download Debian image

    [root@localhost ~]# df -h .
    Filesystem           Size  Used Avail Use% Mounted on
    /dev/mapper/cl-root  8.0G  7.5G  524M  94% /
    [root@localhost ~]# wget https://people.debian.org/~gwolf/cubox.img.xz
    --2017-02-11 20:49:18--  https://people.debian.org/~gwolf/cubox.img.xz
    Resolving people.debian.org (people.debian.org)... 5.153.231.30, 2001:41c8:1000:21::21:30
    Connecting to people.debian.org (people.debian.org)|5.153.231.30|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 105133096 (100M) [application/x-xz]
    Saving to: ‘cubox.img.xz’
    
    100%[======================================>] 105,133,096 5.76MB/s   in 17s
    
    2017-02-11 20:49:35 (5.94 MB/s) - ‘cubox.img.xz’ saved [105133096/105133096]
    
    [root@localhost ~]# xz -d cubox.img.xz
    [root@localhost ~]# 

## Insert SD card (/dev/sdb), write image to it

    [root@localhost ~]# fdisk -l /dev/sdb
    
    Disk /dev/sdb: 7892 MB, 7892631552 bytes, 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk label type: dos
    Disk identifier: 0xf56c4ddc
    
    Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1   *        2048       34815       16384    e  W95 FAT16 (LBA)
    /dev/sdb2           34816    15415295     7690240   83  Linux
    [root@localhost ~]# time dd if=cubox.img of=/dev/sdb
    1445890+0 records in
    1445890+0 records out
    740295680 bytes (740 MB) copied, 1398.93 s, 529 kB/s
    
    real    23m18.941s
    user    0m0.348s
    sys     0m11.771s
    [root@localhost ~]#

## Insert SD card into cubox, boot up, login

On usb keyboard, logon as root, password cubox-i.

## Add network details

    root@cubox-i:~# echo 'auto eth0' >>/etc/network/interfaces
    root@cubox-i:~# echo 'iface eth0 inet dhcp' >>/etc/network/interfaces
    root@cubox-i:~# ifdown eth0
    root@cubox-i:~# ifup eth0
    Internet Systems Consortium DHCP Client 4.2.2
    Copyright 2004-2011 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/
    
    Listening on LPF/eth0/d0:63:b4:00:3e:40
    Sending on   LPF/eth0/d0:63:b4:00:3e:40
    Sending on   Socket/fallback
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 4
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 10
    DHCPREQUEST on eth0 to 255.255.255.255 port 67
    DHCPOFFER from 192.168.0.1
    DHCPACK from 192.168.0.1
    bound to 192.168.0.17 -- renewal in 40960 seconds.
    root@cubox-i:~#

Test network connectivity by doing a DNS lookup.

    root@cubox-i:~# getent hosts www.google.com
    2a00:1450:4009:80f::2004 www.google.com
    root@cubox-i:~#

## Install ssh
  
    root@cubox-i:~# apt-get install ssh

## Log onto cubox via ssh instead of using USB keyboard

    [root@localhost ~]# ssh 192.168.0.17
    The authenticity of host '192.168.0.17 (192.168.0.17)' can't be established.
    ECDSA key fingerprint is c5:1d:ee:50:de:e9:ca:93:29:52:16:24:a3:3c:e2:8e.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '192.168.0.17' (ECDSA) to the list of known hosts.
    root@192.168.0.17's password:
    Linux cubox-i.localdomain 3.0.35-8 #1 SMP PREEMPT Sun Jan 26 17:27:04 MST 2014 armv7l
        
    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    root@cubox-i:~#

## Resize root filesystem to use entire SD card

root filesystem currently 689MB, with 58% used.  Resize it to use whole SD card.

    root@cubox-i:~# df -h /
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root       689M  379M  276M  58% /
    root@cubox-i:~# 

Review current partition layout.

    root@cubox-i:~# fdisk -l
    
    Disk /dev/mmcblk0: 7892 MB, 7892631552 bytes
    32 heads, 32 sectors/track, 15054 cylinders, total 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x2fc08b14
    
            Device Boot      Start         End      Blocks   Id  System
    /dev/mmcblk0p1            1024       12287        5632   83  Linux
    /dev/mmcblk0p2           12288     1445887      716800   83  Linux
    root@cubox-i:~# 

Delete existing partition 2, recreate as remainder of SD card after partition 1.

    root@cubox-i:~# fdisk /dev/mmcblk0
    
    Command (m for help): p
    
    Disk /dev/mmcblk0: 7892 MB, 7892631552 bytes
    32 heads, 32 sectors/track, 15054 cylinders, total 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x2fc08b14
    
            Device Boot      Start         End      Blocks   Id  System
    /dev/mmcblk0p1            1024       12287        5632   83  Linux
    /dev/mmcblk0p2           12288     1445887      716800   83  Linux
    
    Command (m for help): d
    Partition number (1-4): 2
    
    Command (m for help): p
    
    Disk /dev/mmcblk0: 7892 MB, 7892631552 bytes
    32 heads, 32 sectors/track, 15054 cylinders, total 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x2fc08b14
    
            Device Boot      Start         End      Blocks   Id  System
    /dev/mmcblk0p1            1024       12287        5632   83  Linux
    
    Command (m for help): n
    Partition type:
       p   primary (1 primary, 0 extended, 3 free)
       e   extended
    Select (default p): p
    Partition number (1-4, default 2): 2
    First sector (12288-15415295, default 12288):
    Using default value 12288
    Last sector, +sectors or +size{K,M,G} (12288-15415295, default 15415295):
    Using default value 15415295
    
    Command (m for help): p
    
    Disk /dev/mmcblk0: 7892 MB, 7892631552 bytes
    32 heads, 32 sectors/track, 15054 cylinders, total 15415296 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x2fc08b14
        
            Device Boot      Start         End      Blocks   Id  System
    /dev/mmcblk0p1            1024       12287        5632   83  Linux
    /dev/mmcblk0p2           12288    15415295     7701504   83  Linux
        
    Command (m for help): w
    The partition table has been altered!
    
    Calling ioctl() to re-read partition table.
    
    WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
    The kernel still uses the old table. The new table will be used at
    the next reboot or after you run partprobe(8) or kpartx(8)
    Syncing disks.
    root@cubox-i:~# reboot

Resize and then check new usage.  Now 7.3GB and 6% used.

    root@cubox-i:~# resize2fs /dev/root
    resize2fs 1.42.5 (29-Jul-2012)
    Filesystem at /dev/root is mounted on /; on-line resizing required
    old_desc_blocks = 1, new_desc_blocks = 1
    Performing an on-line resize of /dev/root to 1925376 (4k) blocks.
    The filesystem on /dev/root is now 1925376 blocks long.
    
    root@cubox-i:~# df -h /
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root       7.3G  379M  6.6G   6% /
    root@cubox-i:~#
