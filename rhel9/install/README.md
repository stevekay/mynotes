# Steps

## Download VirtualBox

From https://www.virtualbox.org

## Download ISO

From https://developers.redhat.com/products/rhel/download?source=sso

## Install

* Create new VirtualBox VM
  * Memory = 2GB
  * Disk = 12GB (min install uses about 1.2GB of disk for /, plus 2GB for swap)
  * Network = Bridged
* Boot from ISO
* Install

## Configure
* After install, set static ip from console
  * `nmcli con mod enp0s3 ipv4.address 192.168.0.54/24 ipv4.dns 8.8.8.8 ipv4.gateway 192.168.0.1`
  * `nmcli con up enp0s3`
* Setup yum repos
````
[root@localhost ~]# subscription-manager register
Registering to: subscription.rhsm.redhat.com:443/subscription
Username: <my rh username>
Password: <my rh password>
The system has been registered with ID: XXXXXXXXXXXXXXXXX
The registered system name is: localhost.localdomain
[root@localhost ~]# subscription-manager attach
subscription-manager refresh
Installed Product Current Status:
Product Name: Red Hat Enterprise Linux for x86_64
Status:       Subscribed

[root@localhost ~]# 
````
* Install some basic stuff beyond minimum install
  * `yum install -y bc git bind-utils vim`

* Patch
  * `yum update -y`

## Setup git

* create new key
````
[steve@localhost ~]$ ssh-keygen -t rsa -b 1024 -C "rhel9vm"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/steve/.ssh/id_rsa):
Created directory '/home/steve/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/steve/.ssh/id_rsa
Your public key has been saved in /home/steve/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:XXX  rhel9vm
The key's randomart image is:
+---[RSA 1024]----+
...
+----[SHA256]-----+
[steve@localhost ~]$
````
* add key (contents of `~/.ssh/id_rsa.pub`) to https://github.com/settings/keys
* clone this repo, `git clone git@github.com:stevekay/rhel9.git`
* setup git config
````
[steve@localhost install]$ cat ~/.gitconfig
[user]
        name = Steve Kay
        email = stevekay@gmail.com
[steve@localhost install]$
````

# Troubleshooting

## VirtualBox RHEL9 install fails with "glibc error after update no x86-64-v2 support"

As administrator, run `bcdedit /set hypervisorlaunchtype off`

Credit: [scottgus1 on VirtualBox forum](https://forums.virtualbox.org/viewtopic.php?f=25&t=99390)
