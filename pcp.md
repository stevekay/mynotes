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

