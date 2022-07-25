# Developing sysstat

* [Compile](#compile)
* [Export](#export)

## Compile

Steps to compile sysstat (with PCP support)

* need to have `gcc` and `pcp-devel` installed, so install using `sudo dnf install -y gcc pcp-devel`

        $ sudo dnf install -y gcc pcp-devel
        Updating Subscription Management repositories.
        Last metadata expiration check: 1:16:30 ago on Wed 08 Jun 2022 13:01:12 BST.
        ...
        Complete!
        $

* go to https://github.com/sysstat/sysstat/fork and create fork

* clone the fork, `git clone git@github.com:stevekay/sysstat.git`

<details>
  <summary>Click to expand!</summary>

````  
$ git clone git@github.com:stevekay/sysstat.git
Cloning into 'sysstat'...
remote: Enumerating objects: 15071, done.
remote: Counting objects: 100% (1700/1700), done.
remote: Compressing objects: 100% (515/515), done.
remote: Total 15071 (delta 1163), reused 1577 (delta 1139), pack-reused 13371
Receiving objects: 100% (15071/15071), 9.71 MiB | 1.68 MiB/s, done.
Resolving deltas: 100% (10741/10741), done.
$
````
</details>

* `cd sysstat`
* create new branch, `git branch feature_A`
=======
* clone the fork, `git clone git@github.com:<<<YOUR-USERNAME>>>/sysstat.git`

        $ git clone git@github.com:<<<YOUR-USERNAME>>>/sysstat.git
        Cloning into 'sysstat'...
        remote: Enumerating objects: 15071, done.
        remote: Counting objects: 100% (1700/1700), done.
        remote: Compressing objects: 100% (515/515), done.
        remote: Total 15071 (delta 1163), reused 1577 (delta 1139), pack-reused 13371
        Receiving objects: 100% (15071/15071), 9.71 MiB | 1.68 MiB/s, done.
        Resolving deltas: 100% (10741/10741), done.
        $

* change directory and create new branch, `cd sysstat && git branch feature_A`

        $ cd sysstat && git branch feature_A
        $

* checkout new branch, `git checkout feature_A`

        $ git checkout feature_A
        Switched to branch 'feature_A'
        $

* configure, `./configure`

        $ ./configure
        .
        Check programs:
        .
        checking for gcc... gcc
        checking whether the C compiler works... yes
        checking for C compiler default output file name... a.out
        checking for suffix of executables...
        checking whether we are cross compiling... no
        checking for suffix of object files... o
        ...
        checking for unistd.h... (cached) yes
        checking pcp/pmapi.h usability... yes
        checking pcp/pmapi.h presence... yes
        checking for pcp/pmapi.h... yes
        checking pcp/impl.h usability... yes
        checking pcp/impl.h presence... yes
        checking for pcp/impl.h... yes
        checking sys/time.h usability... yes
        ...
        config.status: creating tests/variables
        config.status: creating Makefile
        
           Sysstat version:             12.6.0
           Installation prefix:         /usr/local
           rc directory:                /etc/rc.d
           Init directory:              /etc/rc.d/init.d
           Systemd unit dir:            /usr/lib/systemd/system
           Systemd sleep dir:           /usr/lib/systemd/system-sleep
           Configuration file:          /etc/sysconfig/sysstat
           Man pages directory:         ${datarootdir}/man
           Compiler:                    gcc
           Compiler flags:              -g -O2
           Linker flags:
        
        $ 
        
* compile the code, using `make`

        $ make
        gcc -o sadc.o -c -g -O2 -Wall -Wstrict-prototypes -pipe -O2 -DSA_DIR=\"/var/log/sa\" -DSADC_PATH=\"/usr/local/lib64/sa/sadc\"   -DHAVE_PCP -DHAVE_SYS_SYSMACROS_H -DHAVE_LINUX_SCHED_H -DHAVE_PCP_IMPL_H -DHAVE_SYS_PARAM_H -DUSE_NLS -DPACKAGE=\"sysstat\" -DLOCALEDIR=\"/usr/local/share/locale\" sadc.c
        gcc -o sa_common_light.o -c -g -O2 -Wall -Wstrict-prototypes -pipe -O2 -DSOURCE_SADC -DSA_DIR=\"/var/log/sa\" -DSADC_PATH=\"/usr/local/lib64/sa/sadc\"   -DHAVE_PCP -DHAVE_SYS_SYSMACROS_H -DHAVE_LINUX_SCHED_H -DHAVE_PCP_IMPL_H -DHAVE_SYS_PARAM_H -DUSE_NLS -DPACKAGE=\"sysstat\" -DLOCALEDIR=\"/usr/local/share/locale\" sa_common.c
        gcc -o common_light.o -c -g -O2 -Wall -Wstrict-prototypes -pipe -O2 -DSOURCE_SADC -DSA_DIR=\"/var/log/sa\" -DSADC_PATH=\"/usr/local/lib64/sa/sadc\"   -DHAVE_PCP -DHAVE_SYS_SYSMACROS_H -DHAVE_LINUX_SCHED_H -DHAVE_PCP_IMPL_H -DHAVE_SYS_PARAM_H -DUSE_NLS -DPACKAGE=\"sysstat\" -DLOCALEDIR=\"/usr/local/share/locale\" common.c
        gcc -o sadc -g -O2 -Wall -Wstrict-prototypes -pipe -O2 sadc.o act_sadc.o sa_wrap.o sa_common_light.o common_light.o systest.o librdstats.a librdsensors.a -s
        ...
        gcc -o cifsiostat.o -c -g -O2 -Wall -Wstrict-prototypes -pipe -O2 -DSA_DIR=\"/var/log/sa\" -DSADC_PATH=\"/usr/local/lib64/sa/sadc\"   -DHAVE_PCP -DHAVE_SYS_SYSMACROS_H -DHAVE_LINUX_SCHED_H -DHAVE_PCP_IMPL_H -DHAVE_SYS_PARAM_H -DUSE_NLS -DPACKAGE=\"sysstat\" -DLOCALEDIR=\"/usr/local/share/locale\" cifsiostat.c
        gcc -o cifsiostat -g -O2 -Wall -Wstrict-prototypes -pipe -O2 cifsiostat.o librdstats_light.a libsyscom.a -s
        $       

* install, `sudo make install_all`

        $ sudo make install_all
        mkdir -p /usr/local/share/man/man1
        mkdir -p /usr/local/share/man/man5
        mkdir -p /usr/local/share/man/man8
        rm -f /usr/local/share/man/man8/sa1.8*
        ...
        fi
        if [ -n "/usr/lib/systemd/system" -a -n "/usr/lib/systemd/system-sleep" -a -d "/usr/lib/systemd/system-sleep" ]; then \
                install -m 755 cron/sysstat.sleep /usr/lib/systemd/system-sleep; \
        fi
        $

## Export

Export current stats to a PCP archive

* Use `sadf -l -O pcparchive=/tmp/mypcp` to generate a PCP archive based on performance data already captured by sysstat.

        $ sadf -l -O pcparchive=/tmp/mypcp
        $ ls -l /tmp/mypcp*
        -rw-r--r--. 1 steve steve 5944 Jun  8 14:42 /tmp/mypcp.0
        -rw-r--r--. 1 steve steve  212 Jun  8 14:42 /tmp/mypcp.index
        -rw-r--r--. 1 steve steve 1212 Jun  8 14:42 /tmp/mypcp.meta
        $

* List the metrics held in the newly generated file

        $ pminfo -a /tmp/mypcp
        system.restart.ncpu
        system.restart.count
        kernel.all.cpu.idle
        kernel.all.cpu.guest_nice
        kernel.all.cpu.guest
        kernel.all.cpu.irq.soft
        ...
        proc.hog.mem
        proc.hog.disk
        proc.hog.net
        $

* Dump the contents of the newly generated file

        $ pmdumplog /tmp/mypcp
        
        12:06:14.000000 7 metrics
            60.0.32 (hinv.ncpu): value 4
            60.12.0 (kernel.uname.release): value "5.14.0-70.13.1.el9_0.x86_64"
            60.12.2 (kernel.uname.sysname): value "Linux"
            60.12.3 (kernel.uname.machine): value "x86_64"
            60.12.4 (kernel.uname.nodename): value "localhost"
            245.0.6 (system.restart.count): value 1
            245.0.7 (system.restart.ncpu): value 4
        
        12:20:05.000000 11 metrics
            60.0.20 (kernel.all.cpu.user): value 1193
            60.0.21 (kernel.all.cpu.nice): value 4
            60.0.22 (kernel.all.cpu.sys): value 1191
            60.0.25 (kernel.all.cpu.iowait): value 141
            60.0.55 (kernel.all.cpu.steal): value 0
            60.0.34 (kernel.all.cpu.irq.total): value 861
            60.0.54 (kernel.all.cpu.irq.hard): value 741
            60.0.53 (kernel.all.cpu.irq.soft): value 120
            60.0.60 (kernel.all.cpu.guest): value 0
            60.0.81 (kernel.all.cpu.guest_nice): value 0
            60.0.23 (kernel.all.cpu.idle): value 331913
        ...
            60.0.60 (kernel.all.cpu.guest): value 0
            60.0.81 (kernel.all.cpu.guest_nice): value 0
            60.0.23 (kernel.all.cpu.idle): value 3654642
        $
