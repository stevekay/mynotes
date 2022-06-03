# debian

* get ISO from https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/
* virtualbox
  * network = bridged

* remove cdrom from /etc/fstab
* remove cdrom from /etc/apt/sources.list
* install sudo `sudo apt install sudo`
* add to sudoers
* `sudo apt update`
* `sudo apt upgrade`

# install sysstat

* `sudo apt install -y sysstat`

# build sysstat

* `sudo apt remove -y sysstat`
* `sudo apt install -y git gcc make`
* create keypair `ssh-keygen -t rsa -b 1024`
* add pub key to github
* download sysstat, `git clone https://github.com/sysstat/sysstat.git`
* `cd sysstat`
* `./configure`
* `make`
* `sudo make install_all`

