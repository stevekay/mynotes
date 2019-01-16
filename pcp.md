# Performance Co-Pilot

## convert sar datafile to pcp archive
    sar2pcp /var/tmp/mysar/data/sar.dat /var/tmp/foo.pcp

## list what metrics are in a file
    pminfo -a /var/tmp/foo.pcp

## sar -q equivalent
    pmrep -a /var/tmp/foo.pcp -p proc.runq.runnable proc.nprocs
    sar -q -f /var/tmp/mysar/data/sar.dat
