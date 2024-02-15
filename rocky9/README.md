
# Install

# Configure

## Turn off GUI

`sudo systemctl set-default multi-user.target`

## Install git

`sudo yum install -y git-core`

## Create key for use with git etc

`ssh-keygen -t rsa -b 4096`

## Static IP

`sudo nmcli con mod eth0 ipv4.addresses 172.17.144.100/24`
`sudo nmcli con mod eth0 ipv4.gateway 172.17.144.1`
`sudo nmcli con mod eth0 ipv4.dns 172.17.144.1`
`sudo nmcli con mod eth0 ipv4.method manual`


