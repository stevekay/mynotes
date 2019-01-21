# sar2pcp-example

    $ /usr/lib64/sa/sadc 1 5 sar.dat
    $ export SADF=/usr/bin/sadf
    $ sar2pcp sar.dat sar2pcp
    $ ls
    README.md  sar2pcp.0  sar2pcp.index  sar2pcp.meta  sar.dat
    $ pmdumplog -x sar2pcp proc.nprocs
    
    Mon Jan 21 22:23:13.000000 2019 1 metric
        245.0.46 (proc.nprocs): value 121
    
    Mon Jan 21 22:23:14.000000 2019 1 metric
        245.0.46 (proc.nprocs): value 121
    
    Mon Jan 21 22:23:15.000000 2019 1 metric
        245.0.46 (proc.nprocs): value 121
    
    Mon Jan 21 22:23:16.000000 2019 1 metric
        245.0.46 (proc.nprocs): value 121
    $
