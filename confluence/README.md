Reading a CSV file and writing it to a confluence page

Test done on RHEL9.  As running confluence server and backend postgres db, probably needs at least 4GB memory.

# install backend database

```
$ sudo dnf install -qy postgresql-server

Installed:
  postgresql-13.7-1.el9_0.x86_64                             postgresql-private-libs-13.7-1.el9_0.x86_64                             postgresql-server-13.7-1.el9_0.x86_64

$ sudo /usr/bin/postgresql-setup --initdb --unit postgresql
 * Initializing database in '/var/lib/pgsql/data'
 * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
$ sudo vi /var/lib/pgsql/data/pg_hba.conf
local   all             all                                     peer
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
$ sudo systemctl enable --now postgresql
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /usr/lib/systemd/system/postgresql.service.
$ sudo -u postgres psql
could not change directory to "/home/steve": Permission denied
psql (13.7)
Type "help" for help.

postgres=# CREATE DATABASE confluencedb;
CREATE DATABASE
postgres=# CREATE USER confluence WITH ENCRYPTED PASSWORD 'abc123';
CREATE ROLE
postgres=# GRANT ALL PRIVILEGES ON DATABASE confluencedb TO confluence;
GRANT
postgres=#
\q
$
```

# install confluence

## create firewall rule for inbound confluence connection

```
$ sudo firewall-cmd --add-port=8090/tcp --permanent
success
$ sudo firewall-cmd --reload
success
$
```

## turn off selinux

```
$ setenforce 0
$ sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
$
$
```

## install

```
$ ls -l atlas*
-rwxr-xr-x. 1 steve steve 831397650 Nov 21 15:11 atlassian-confluence-7.20.2-x64.bin
$ sudo ./atlassian-confluence-7.20.2-x64.bin
Installing fontconfig and fonts
Updating Subscription Management repositories.
...
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
2

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
  bin/bcprov-jdk15on.jar
...
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
$
```

## point browser at confluence

* http://localhost:8090 / http://192.168.0.54:8090
* Select 'Trial' license and get eval license.
* Select 'Non-clustered'.
* DB details

|Field|Value|
|---|---| 
|Database type|PostgreSQL|
|Setup type|Simple|
|Hostname|localhost|
|Port|5432|
|Database name|confluencedb|
|Username|confluence|
|Password|abc123|

* Click 'Test connection' and then next.
* Wait 10 minutes.

* Monitor progress
```
$ sudo tail -f /var/atlassian/application-data/confluence/logs/atlassian-confluence.log /var/lib/pgsql/data/log/postgresql-$(date '+%a').log
...
```
* Click 'Example Site' when done.
* Click 'Manage users and groups within Confluence'.
* Configure admin user

|Field|Value|
|---|---|
|Username|admin|
|Name|admin|
|Email|stevekay@gmail.com|
|Password|abc123|
|Confirm|abc123|

* After another few minutes, message "Setup Successful" should be displayed.

# set confluence to start on boot

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
$ sudo systemctl daemon-reload
$ sudo systemctl enable confluence
$
```

# enable REST API

* Enable via configuration page

![config page](./enable-api.png?raw=true "enable api")

# TODO

* tidyup formatting etc
* how to use with selinux enforcing?
