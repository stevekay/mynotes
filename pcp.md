# Performance Co-Pilot

## convert sar datafile to pcp archive
    sar2pcp /var/tmp/mysar/data/sar.dat /var/tmp/foo.pcp

## list what metrics are in a file
    pminfo -a /var/tmp/foo.pcp

## sar -q equivalent
    pmrep -a /var/tmp/foo.pcp -p proc.runq.runnable proc.nprocs
    sar -q -f /var/tmp/mysar/data/sar.dat

## pcp vector view
    sudo yum install pcp-webapp-vector pcp-webapi
    sudo systemctl start pmcd pmwebd
    sudo systemctl enable pmcd pmwebd
    sudo firewall-cmd --add-port=44323/tcp --permanent
    sudo firewall-cmd --reload
    http://localhost:44323/vector/index.html#/?host=localhost:44323&hostspec=localhost
    
 ## pcp webjs view
    sudo yum install -y pcp-webjs
    http://localhost:44323

## write some stats from C

    $ cat pcptest.c
    #include <stdio.h>
    
    #include <pcp/pmapi.h>
    #include <pcp/impl.h>
    #include <pcp/import.h>
    
    int main() {
            struct timeval tv;
            int i;
    
            pmiStart("mover_v1",0);
            pmiAddMetric("mover.nfile",PM_IN_NULL,PM_TYPE_U32,PM_INDOM_NULL,PM_SEM_INSTANT,pmiUnits(0,0,1,0,0,PM_COUNT_ONE));
            for(i=0;i<5;i++) {
                    pmiPutValue("mover.nfile", "", "123");
                    gettimeofday(&tv,NULL);
                    pmiWrite(tv.tv_sec,tv.tv_usec);
                    sleep(1);
            }
            pmiEnd();
    }
    $ gcc -lpcp_import -lpcp -o pcptest pcptest.c
    $ ./pcptest
    $ pmdumplog -a mover_v1
    Log Label (Log Format Version 2)
    Performance metrics from host centos
        commencing Wed Jan 16 22:41:56.300563 2019
        ending     Wed Jan 16 22:42:00.304888 2019
    Archive timezone: GMT
    PID for pmlogger: 5623

    Descriptions for Metrics in the Log ...
    PMID: 245.0.1 (mover.nfile)
        Data Type: 32-bit unsigned int  InDom: PM_INDOM_NULL 0xffffffff
        Semantics: instant  Units: count

    Instance Domains in the Log ...

    Temporal Index
                    Log Vol    end(meta)     end(log)
    22:41:56.300563       0          132          132
    22:41:56.300563       0          183          132
    22:42:00.304888       0          183          332

    [40 bytes]
    22:41:56.300563 1 metric
        245.0.1 (mover.nfile): value 123

    [40 bytes]
    22:41:57.302185 1 metric
        245.0.1 (mover.nfile): value 123

    [40 bytes]
    22:41:58.303067 1 metric
        245.0.1 (mover.nfile): value 123

    [40 bytes]
    22:41:59.303778 1 metric
        245.0.1 (mover.nfile): value 123

    [40 bytes]
    22:42:00.304888 1 metric
        245.0.1 (mover.nfile): value 123
    $

## sysstat hack to produce pcp
    $ sadf /var/tmp/mysar/data/sar.dat -O pcp,file=xxx -- -q
