# rocky 8.6

* get minimal ISO from `https://rockylinux.org/download`
* install
* add sudoers
* networking
  * `sudo nmcli con mod enp0s3 ipv4.address 192.168.0.54/24 ipv4.dns 8.8.8.8 ipv4.gateway 192.168.0.1`
  * `sudo nmcli con up enp0s3`
* update
  * `dnf update`

