Reading a CSV file and writing it to a confluence page

Test done on RHEL9.  As running confluence server and backend postgres db, probably needs at least 4GB memory.

- [install backend database](#install-backend-database)
- [install confluence](#install-confluence)
  * [create firewall rule for inbound confluence connection](#create-firewall-rule-for-inbound-confluence-connection)
  * [turn off selinux](#turn-off-selinux)
  * [install](#install)
  * [point browser at confluence](#point-browser-at-confluence)
- [set confluence to start on boot](#set-confluence-to-start-on-boot)
- [enable REST API](#enable-rest-api)
- [TODO](#todo)

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

* New systemd unit to be created, so starts after network and db are up.
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

# install atlassian python api

Per https://github.com/atlassian-api/atlassian-python-api
```
$ pip install atlassian-python-api
Defaulting to user installation because normal site-packages is not writeable
Collecting atlassian-python-api
  Downloading atlassian-python-api-3.31.0.tar.gz (140 kB)
     |████████████████████████████████| 140 kB 1.3 MB/s
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
    Preparing wheel metadata ... done
Requirement already satisfied: requests in /usr/lib/python3.9/site-packages (from atlassian-python-api) (2.25.1)
Collecting oauthlib
  Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
     |████████████████████████████████| 151 kB 4.4 MB/s
Requirement already satisfied: six in /usr/lib/python3.9/site-packages (from atlassian-python-api) (1.15.0)
Collecting deprecated
  Downloading Deprecated-1.2.13-py2.py3-none-any.whl (9.6 kB)
Collecting requests-oauthlib
  Downloading requests_oauthlib-1.3.1-py2.py3-none-any.whl (23 kB)
Collecting wrapt<2,>=1.10
  Downloading wrapt-1.14.1-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (77 kB)
     |████████████████████████████████| 77 kB 4.4 MB/s
Requirement already satisfied: idna<3,>=2.5 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (2.10)
Requirement already satisfied: chardet<5,>=3.0.2 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (4.0.0)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (1.26.5)
Building wheels for collected packages: atlassian-python-api
  Building wheel for atlassian-python-api (PEP 517) ... done
  Created wheel for atlassian-python-api: filename=atlassian_python_api-3.31.0-py3-none-any.whl size=142756 sha256=c6b2a7375a3cb828d8faef8b0d3f62ab4f3f80b0800b3d636beb90758b4e2b6a
  Stored in directory: /home/steve/.cache/pip/wheels/7c/de/28/17ffb4cc7df3965a41a28605ec75cf0ff73f5fad05950e2e7f
Successfully built atlassian-python-api
Installing collected packages: wrapt, oauthlib, requests-oauthlib, deprecated, atlassian-python-api
  WARNING: Value for scheme.platlib does not match. Please report this to <https://github.com/pypa/pip/issues/10151>
  distutils: /home/steve/.local/lib/python3.9/site-packages
  sysconfig: /home/steve/.local/lib64/python3.9/site-packages
  WARNING: Additional context:
  user = True
  home = None
  root = None
  prefix = None
Successfully installed atlassian-python-api-3.31.0 deprecated-1.2.13 oauthlib-3.2.2 requests-oauthlib-1.3.1 wrapt-1.14.1
$
```

# retrieve a page using REST API

```
$ cat get-page.py
#!/usr/bin/python3

from atlassian import Confluence

confluence = Confluence(url="http://localhost:8090", username="admin", password="abc123")

content1 = confluence.get_page_by_title(space="FOO", title="Hello World")

print(content1)
$ ./get-page.py
{'id': '98371', 'type': 'page', 'status': 'current', 'title': 'Hello World', 'extensions': {'position': 'none'}, '_links': {'webui': '/display/FOO/Hello+World', 'edit': '/pages/resumedraft.action?draftId=98371&draftShareId=fc1ac958-76e8-4006-9bdd-9f8013876dd4', 'tinyui': '/x/Q4AB', 'self': 'http://192.168.0.54:8090/rest/api/content/98371'}, '_expandable': {'container': '/rest/api/space/FOO', 'metadata': '', 'operations': '', 'children': '/rest/api/content/98371/child', 'restrictions': '/rest/api/content/98371/restriction/byOperation', 'history': '/rest/api/content/98371/history', 'ancestors': '', 'body': '', 'version': '', 'descendants': '/rest/api/content/98371/descendant', 'space': '/rest/api/space/FOO'}}
$
```

* TBA

# TODO

* how to use with selinux enforcing?
