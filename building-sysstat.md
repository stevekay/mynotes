# install compiler
     sudo yum install -y gcc

# fork + clone + setup
    curl -u stevekay https://api.github.com/repos/sysstat/sysstat/forks -d '')
    git clone https://github.com/stevekay/sysstat.git
    mkdir /var/tmp/mysar{,/data,/conf}
    echo 'export man_group=$(id -ng)' >>~/.bashrc
    echo 'export sa_dir=/var/tmp/mysar/data' >>~/.bashrc
    echo 'export conf_dir=/var/tmp/mysar.conf' >>~/.bashrc
    echo 'export S_COLORS=' >>~/.bashrc
    echo 'export PATH=$PATH:/var/tmp/mysar/bin' >>~/.bashrc
    . ~/.bashrc
    cd sysstat
    ./configure --prefix=/var/tmp/mysar --sysconfdir=/var/tmp/mysar/conf
    make install

# create test data
    /var/tmp/mysar/lib/sa/sadc -S XALL 1 60 /var/tmp/mysar/data/sar.dat &
    dd if=/dev/zero of=/dev/null bs=10240 count=555555
    export S_COLORS=
    /var/tmp/mysar/bin/sar -u -f /var/tmp/mysar/data/sar.dat

# webserver
    sudo yum install -q -y httpd
    sudo systemctl --now enable httpd
    sudo firewall-cmd --add-service=http --permanent
    sudo firewall-cmd --reload

# create svg
    sudo chown steve /var/www/html
    /var/tmp/mysar/bin/sadf -O autoscale,showinfo,showtoc -g  /var/tmp/mysar/data/sar.dat -- -A >/var/www/html/sar.svg
    # (open in browser http://servername/sar.svg)

# refresh from upstream
    git remote add upstream https://github.com/sysstat/sysstat.git
    git fetch upstream
    git pull upstream master
    git commit -am "refresh"
