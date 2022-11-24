Fresh build of RHEL9, minimal.

With subsequent confluence install.

* Fix cmd history

```
[steve@localhost ~]$ echo 'set -o vi' >> ~/.bashrc
[steve@localhost ~]$
```

* Don't prompt for password

```
[steve@localhost ~]$ sudo sed -i 's/%wheel.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
[steve@localhost ~]$
```

* Register, so we get repos

```
[steve@localhost ~]$ sudo subscription-manager register
Registering to: subscription.rhsm.redhat.com:443/subscription
Username: stevekay1970
Password:
The system has been registered with ID: f259d817-e8e5-486b-b02c-62d1fd2e5aa2
The registered system name is: localhost.localdomain
[steve@localhost ~]$ sudo subscription-manager attach
Installed Product Current Status:
Product Name: Red Hat Enterprise Linux for x86_64
Status:       Subscribed

[steve@localhost ~]$
```

* Install git

```
[steve@localhost ~]$ sudo yum install -qy git
Importing GPG key 0xFD431D51:
 Userid     : "Red Hat, Inc. (release key 2) <security@redhat.com>"
 Fingerprint: 567E 347A D004 4ADE 55BA 8A5F 199E 2F91 FD43 1D51
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
Importing GPG key 0x5A6340B3:
 Userid     : "Red Hat, Inc. (auxiliary key 3) <security@redhat.com>"
 Fingerprint: 7E46 2425 8C40 6535 D56D 6F13 5054 E4A4 5A63 40B3
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

Installed:
  emacs-filesystem-1:27.2-6.el9.noarch
  git-2.31.1-2.el9.2.x86_64
  git-core-2.31.1-2.el9.2.x86_64
  git-core-doc-2.31.1-2.el9.2.noarch
...
[steve@localhost ~]$
```

* Install + enable sysstat
```
[steve@localhost ~]$ sudo yum install -qy sysstat

Installed:
  avahi-libs-0.8-12.el9.x86_64               libuv-1:1.42.0-1.el9.x86_64
  lm_sensors-libs-3.6.0-10.el9.x86_64        nspr-4.34.0-14.el9_0.x86_64
  nss-3.79.0-14.el9_0.x86_64                 nss-softokn-3.79.0-14.el9_0.x86_64
  nss-softokn-freebl-3.79.0-14.el9_0.x86_64  nss-sysinit-3.79.0-14.el9_0.x86_64
  nss-util-3.79.0-14.el9_0.x86_64            pcp-conf-5.3.7-7.el9.x86_64
  pcp-libs-5.3.7-7.el9.x86_64                sysstat-12.5.4-3.el9.x86_64

[steve@localhost ~]$ sudo systemctl enable --now sysstat
[steve@localhost ~]$
```

* Create new keypair for our github account

```
[steve@localhost ~]$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/steve/.ssh/id_rsa):
Created directory '/home/steve/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/steve/.ssh/id_rsa
...
[steve@localhost ~]$
```

* Paste public key (~/.ssh/id_rsa.pub) into github Settings -> SSH and GPG keys ( https://github.com/settings/keys )


* Update to latest release

```
[steve@localhost ~]$ sudo yum update
Updating Subscription Management repositories.
Last metadata expiration check: 0:31:02 ago on Thu 24 Nov 2022 10:48:11 GMT.
Dependencies resolved.
...
[steve@localhost ~]$
```

* Turn off mitigations, for faster operation in lab.

```
[steve@localhost ~]$ sudo grubby --args='mitigations=off' --update-kernel=ALL
[steve@localhost ~]$
```

* Get the notes repo

```
[steve@localhost ~]$ git clone git@github.com:stevekay/mynotes.git
Cloning into 'mynotes'...
The authenticity of host 'github.com (140.82.121.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
remote: Enumerating objects: 548, done.
remote: Counting objects: 100% (87/87), done.
remote: Compressing objects: 100% (64/64), done.
remote: Total 548 (delta 41), reused 64 (delta 19), pack-reused 461
Receiving objects: 100% (548/548), 1.33 MiB | 1.87 MiB/s, done.
Resolving deltas: 100% (200/200), done.
[steve@localhost ~]$
```

* git config : owner, colours

```
[steve@localhost ~]$ cat .gitconfig
[user]
        name = Steve Kay
        email = stevekay@gmail.com
# Neonwolf Color Scheme for Git
#
# Based mostly on the colors from the badwolf airline theme
#
# Github: https://github.com/h3xx/git-colors-neonwolf
#
# Recommended additions to make this work:
#
#[core]
#   pager           = less -R       # handle colors correctly
#
#[color]
#   branch          = auto
#   diff            = auto
#   interactive     = auto
#   ui              = auto

[color "diff"]
    frag            = bold 160 238 # red
    meta            = bold 45 238  # light blue
    old             = bold 202 238 # orange
    new             = bold 82 238  # green
    commit          = bold 226 238 # yellow
    func            = bold 213 238 # dark orange


[color "grep"]
    linenumber      = bold 165 235
    filename        = bold 39 235
    separator       = bold 82 235
    function        = bold 222
    selected        = bold 255 235
    context         = 240
    match           = bold 154 235
    #matchContext   = ? # matching text in context lines
    #matchSelected  = ? # matching text in selected lines

[color "status"]
    added           = bold 154 235
    changed         = bold 166 235
    untracked       = bold 81 235
    unmerged        = bold 196 235

[color "decorate"]
    HEAD            = bold 81 235
    branch          = bold 121 235
    remoteBranch    = bold 222 235
    tag             = bold 166 235

[color "branch"]
    current         = bold 121 235
    local           = bold 81 235
    remote          = bold 222 235
    upstream        = bold 222 235
    plain           = 255

[color "interactive"]
    prompt          = bold 121 235
    header          = bold 165 235
    help            = bold 222 235
    error           = bold 196 235

# vi: ft=gitconfig ts=8 sts=8 sw=4 et
[color]
        branch = auto
        diff = auto
        interactive = auto
        ui = auto
        pager = true
[steve@localhost ~]$ 
```

* At this point, disk usage as below.

```
[steve@localhost confluencev2]$ df -h
Filesystem             Size  Used Avail Use% Mounted on
devtmpfs               4.0M     0  4.0M   0% /dev
tmpfs                  1.7G     0  1.7G   0% /dev/shm
tmpfs                  688M  8.6M  680M   2% /run
/dev/mapper/rhel-root   34G  1.5G   33G   5% /
/dev/sda1             1014M  280M  735M  28% /boot
tmpfs                  344M     0  344M   0% /run/user/1000
[steve@localhost confluencev2]$
```

* Install postgres

```
[steve@localhost confluencev2]$ sudo dnf install -qy postgresql-server

Installed:
  libicu-67.1-9.el9.x86_64
  postgresql-13.7-1.el9_0.x86_64
  postgresql-private-libs-13.7-1.el9_0.x86_64
  postgresql-server-13.7-1.el9_0.x86_64

[steve@localhost confluencev2]$
```

* Initialize postgres db
```
[steve@localhost confluencev2]$ sudo /usr/bin/postgresql-setup --initdb --unit postgresql
 * Initializing database in '/var/lib/pgsql/data'
 * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
[steve@localhost confluencev2]$
```

* Postgres to use md5 auth, rather than ident
```
[steve@localhost confluencev2]$ sudo sed -i 's/ident$/md5/' /var/lib/pgsql/data/pg_hba.conf
[steve@localhost confluencev2]$
```

* Start
```
[steve@localhost confluencev2]$ sudo systemctl enable --now postgresql
[steve@localhost confluencev2]$
```

* Create db
```
[steve@localhost confluencev2]$ sudo -u postgres psql -c "CREATE DATABASE confdb"
could not change directory to "/home/steve/mynotes/confluencev2": Permission denied
CREATE DATABASE
[steve@localhost confluencev2]$ sudo -u postgres psql -c "CREATE USER confuser WITH ENCRYPTED PASSWORD 'abc123'"
could not change directory to "/home/steve/mynotes/confluencev2": Permission denied
CREATE ROLE
[steve@localhost confluencev2]$ sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE confdb TO confuser"
could not change directory to "/home/steve/mynotes/confluencev2": Permission denied
GRANT
[steve@localhost confluencev2]$
```

* Download confluence from https://www.atlassian.com/software/confluence/download-archives

```
[steve@localhost confluencev2]$ ls -l ~/atlassian-confluence-7.20.2-x64.bin
-rwxrwxr-x. 1 steve steve 831397650 Nov 24 12:19 /home/steve/atlassian-confluence-7.20.2-x64.bin
[steve@localhost confluencev2]$
```

* Install tar

```
[steve@localhost ~]$ sudo dnf install -qy tar

Installed:
  tar-2:1.34-5.el9.x86_64

[steve@localhost ~]$
```

* Install confluence 

```
[steve@localhost ~]$ sudo ./atlassian-confluence-7.20.2-x64.bin
Installing fontconfig and fonts
Updating Subscription Management repositories.
Last metadata expiration check: 1:00:34 ago on Thu 24 Nov 2022 11:22:34 GMT.
Updating Subscription Management repositories.
Last metadata expiration check: 1:00:37 ago on Thu 24 Nov 2022 11:22:34 GMT.
Package fontconfig-2.14.0-1.el9.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
Updating Subscription Management repositories.
Last metadata expiration check: 1:00:56 ago on Thu 24 Nov 2022 11:22:34 GMT.
Package dejavu-sans-fonts-2.37-18.el9.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!
Updating Subscription Management repositories.
Last metadata expiration check: 1:00:59 ago on Thu 24 Nov 2022 11:22:34 GMT.
Dependencies resolved.
================================================================================
 Package           Architecture     Version             Repository         Size
================================================================================
Installing Groups:
 Fonts

Transaction Summary
================================================================================

Complete!
Regenerating the font cache
Fonts and fontconfig have been installed
Unpacking JRE ...
Starting Installer ...

This will install Confluence 7.20.2 on your computer.
OK [o, Enter], Cancel [c]

Click Next to continue, or Cancel to exit Setup.

Choose the appropriate installation or upgrade option.
Please choose one of the following:
Express Install (uses default settings) [1],
Custom Install (recommended for advanced users) [2, Enter],
Upgrade an existing Confluence installation [3]


Select the folder where you would like Confluence 7.20.2 to be installed,
then click Next.
Where should Confluence 7.20.2 be installed?
[/opt/atlassian/confluence]


Default location for Confluence data
[/var/atlassian/application-data/confluence]


Configure which ports Confluence will use.
Confluence requires two TCP ports that are not being used by any other
applications on this machine. The HTTP port is where you will access
Confluence through your browser. The Control port is used to Startup and
Shutdown Confluence.
Use default ports (HTTP: 8090, Control: 8000) - Recommended [1, Enter], Set custom value for HTTP and Control ports [2]


Confluence can be run in the background.
You may choose to run Confluence as a service, which means it will start
automatically whenever the computer restarts.
Install Confluence as Service?
Yes [y, Enter], No [n]


Extracting files ...


Please wait a few moments while we configure Confluence.

Installation of Confluence 7.20.2 is complete
Start Confluence now?
Yes [y, Enter], No [n]


Please wait a few moments while Confluence starts up.
Launching Confluence ...

Installation of Confluence 7.20.2 is complete
Your installation of Confluence 7.20.2 is now ready and can be accessed via
your browser.
Confluence 7.20.2 can be accessed at http://localhost:8090
Finishing installation ...
[steve@localhost ~]$
```

* Open port 8090 for browser connection
```
[steve@localhost ~]$ sudo firewall-cmd --add-port=8090/tcp --permanent
success
[steve@localhost ~]$ sudo firewall-cmd --reload
success
[steve@localhost ~]$
```

* Point browser at http://192.168.0.31:8090

![select-trial](images/select-trial.png?raw=true "select-trial")

![trial](images/enter-trial-lic.png?raw=true "trial")

![nonclust](images/non-clustered.png?raw=true "nonclust")

![dbsettings](images/db-settings.png?raw=true "dbsettings")

![loadcontent](images/load-content.png?raw=true "loadcontent")

![configusermgmt](images/config-user-mgmt.png?raw=true "configusermgmt")

![admin](images/config-admin-account.png?raw=true "admin")

![complete](images/complete.png?raw=true "complete")

![createspace](images/create-space.png?raw=true "createspace")

![createnewpage](images/create-new-page.png?raw=true "createnewpage")

![showpage](images/created-page.png?raw=true "showpage")

* Reduce memory footprint

```
[steve@localhost confluencev2]$ sudo sed -i.bak 's/Xms1024m/Xms512m/;s/Xmx1024m/Xmx512m/' /opt/atlassian/confluence/bin/setenv.sh
[steve@localhost confluencev2]$ sudo sed -i.bak 's/^max_connections.*/max_connections = 50/' /var/lib/pgsql/data/postgresql.conf
[steve@localhost confluencev2]$ sudo sed -i.bak 's/^shared_buffers.*/shared_buffers = 50MB/' /var/lib/pgsql/data/postgresql.conf
[steve@localhost confluencev2]$ sudo sed -i.bak 's/^#temp_buffers.*/temp_buffers = 2MB/' /var/lib/pgsql/data/postgresql.conf
[steve@localhost confluencev2]$ sudo sed -i.bak 's/^#work_mem.*/work_mem = 2MB/' /var/lib/pgsql/data/postgresql.conf
[steve@localhost confluencev2]$
```

* Setup systemd service for confluence
```
$ sudo vi /lib/systemd/system/confluence.service
[Unit]
Description=Confluence
After=network.target postgresql.service

[Service]
Type=forking
User=confluence
PIDFile=/opt/atlassian/confluence/work/catalina.pid
ExecStart=/opt/atlassian/confluence/bin/start-confluence.sh
ExecStop=/opt/atlassian/confluence/bin/stop-confluence.sh
TimeoutSec=200
LimitNOFILE=32768
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
$ sudo systemctl enable confluence
Created symlink /etc/systemd/system/multi-user.target.wants/confluence.service → /usr/lib/systemd/system/confluence.service.
$
```

* Reboot

```
$ sudo reboot
$
```
