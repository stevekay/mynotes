Reading a CSV file and writing it to a confluence page

Test done on RHEL9.  As running confluence server and backend postgres db, probably needs at least 1GB.

# installed confluence

```
See where Confluence will be installed and the settings that will be used.
Installation Directory: /opt/atlassian/confluence
Home Directory: /var/atlassian/application-data/confluence
HTTP Port: 8090
RMI Port: 8000
Install as service: Yes
Install [i, Enter], Exit [e]
i

Extracting files ...


Please wait a few moments while we configure Confluence.

Installation of Confluence 7.20.2 is complete
Start Confluence now?
Yes [y, Enter], No [n]
y

Please wait a few moments while Confluence starts up.
Launching Confluence ...

Installation of Confluence 7.20.2 is complete
Your installation of Confluence 7.20.2 is now ready and can be accessed via
your browser.
Confluence 7.20.2 can be accessed at http://localhost:8090
Finishing installation ...
[root@rhel9 steve]# 
```

# firewall rules

```
$  sudo firewall-cmd --add-port=8090/tcp --permanent
success
$ sudo firewall-cmd --reload
success
$
```

# setup in browser

* Point browser at https://localhost:8090
* Get trial license per onscreen instructions

# setup database

```
$ sudo yum install -y postgresql-server
$ sudo /usr/bin/postgresql-setup initdb
WARNING: using obsoleted argument syntax, try --help
WARNING: arguments transformed to: postgresql-setup --initdb --unit postgresql
 * Initializing database in '/var/lib/pgsql/data'
 * Initialized, logs are in /var/lib/pgsql/initdb_postgresql.log
$ sudo systemctl start postgresql --now
$ sudo -u postgres psql
psql (13.7)
Type "help" for help.

postgres=# "alter user postgres with password
postgres"# alter user postgres with password abc123
Use control-D to quit.
postgres"#
$ sudo -u postgres psql
psql (13.7)
Type "help" for help.

postgres=# CREATE DATABASE foo WITH OWNER = postgres;
CREATE DATABASE
postgres=#
\q
$

# todo - create user bob, password abc123, grant access to db
```

```
# hack pg_hba.conf

[root@rhel9 data]# grep -v "^#" pg_hba.conf
local   all             all                                     peer
host    all             all             all md5
[root@rhel9 data]# 
```

# connect in browser

* Back to browser, enter db details+creds

