# Output of various configuration commands of cubox on Debian

## CPU

    root@cubox-i:~# cat /proc/cpuinfo
    Processor       : ARMv7 Processor rev 10 (v7l)
    processor       : 0
    BogoMIPS        : 790.52
    
    processor       : 1
    BogoMIPS        : 790.52
    
    processor       : 2
    BogoMIPS        : 790.52
    
    processor       : 3
    BogoMIPS        : 790.52
    
    Features        : swp half thumb fastmult vfp edsp neon vfpv3
    CPU implementer : 0x41
    CPU architecture: 7
    CPU variant     : 0x2
    CPU part        : 0xc09
    CPU revision    : 10
    
    Hardware        : SolidRun i.MX 6Quad/Dual/DualLite/Solo CuBox-i Board
    Revision        : 63015
    Serial          : 0000000000000000
    root@cubox-i:~# lscpu
    Architecture:          armv7l
    Byte Order:            Little Endian
    CPU(s):                4
    On-line CPU(s) list:   0-3
    Thread(s) per core:    1
    Core(s) per socket:    1
    Socket(s):             4
    root@cubox-i:~#

## Memory

    root@cubox-i:~# free -m
                 total       used       free     shared    buffers     cached
    Mem:          1761         54       1707          0          4         10
    -/+ buffers/cache:         38       1723
    Swap:            0          0          0
    root@cubox-i:~#

## cmdline

    root@cubox-i:~# cat /proc/cmdline
    root=/dev/mmcblk0p2 rootfstype=ext3 ro rootwait video=nomodeset console=ttymxc0,115200 init=/init
    root@cubox-i:~#

## OS version

    root@cubox-i:~# uname -a
    Linux cubox-i.localdomain 3.0.35-8 #1 SMP PREEMPT Sun Jan 26 17:27:04 MST 2014 armv7l GNU/Linux
    root@cubox-i:~# cat /etc/os-release
    PRETTY_NAME="Debian GNU/Linux 7 (wheezy)"
    NAME="Debian GNU/Linux"
    VERSION_ID="7"
    VERSION="7 (wheezy)"
    ID=debian
    ANSI_COLOR="1;31"
    HOME_URL="http://www.debian.org/"
    SUPPORT_URL="http://www.debian.org/support/"
    BUG_REPORT_URL="http://bugs.debian.org/"
    root@cubox-i:~#
