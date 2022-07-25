# centos7-setup

Notes on setting up a CentOS 7 VM for testing.

## VirtualBox setup

* Network = bridged
* Disk = at least 10GB
* Image = boot from Centos-7-x86_64-Minimal-YYWW.iso

## Setup network (static IP, Google DNS)
    sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-en*
    sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' /etc/sysconfig/network-scripts/ifcfg-en*
    echo 'IPADDR=192.168.0.200' >>/etc/sysconfig/network-scripts/ifcfg-en*
    echo 'GATEWAY=192.168.0.1' >>/etc/sysconfig/network-scripts/ifcfg-en*
    echo 'NM_CONTROLLED=no' >>/etc/sysconfig/network-scripts/ifcfg-en*
    echo 'nameserver 8.8.8.8' >/etc/resolv.conf
    hostnamectl set-hostname centos
    systemctl restart network

## Timezone
    timedatectl set-timezone Europe/London

## Patch OS (using deltarpm where possible)
    yum install -y deltarpm
    yum -y update
    reboot

## Setup git (client, colours, keys)
    sudo yum install -y git
    curl -o .gitconfig https://raw.githubusercontent.com/h3xx/git-colors-neonwolf/master/git-colors-neonwolf-256.gitconfig
    git config --global color.branch auto
    git config --global color.diff auto
    git config --global color.interactive auto
    git config --global color.ui auto
    git config --global color.pager true
    git config --global user.name "Steve Kay"
    git config --global user.email stevekay@gmail.com
    git config --global push.default matching
    ssh-keygen -t rsa -b 4096 -C "my github key"
    # (paste contents of ~/.ssh/id_rsa.pub into https://github.com/settings/ssh/new)

## vim 
    sudo yum install -y vim-enhanced
    echo "alias vi=vim" >>~/.bashrc
    . ~/.bashrc
    
    
