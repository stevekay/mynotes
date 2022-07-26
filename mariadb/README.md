# mariadb

##### install

`sudo yum install -y mariadb-server`

##### start

`sudo systemctl --now enable mariadb`

##### login

`sudo mariadb -h localhost`

##### create non-root user

`create user 'steve'@'localhost' identified by 'abc123';`

##### list all users

`select Host, User, Password from mysql.user;`

```
MariaDB [(none)]> select Host, User, Password from mysql.user;
+-----------+-------------+-------------------------------------------+
| Host      | User        | Password                                  |
+-----------+-------------+-------------------------------------------+
| localhost | mariadb.sys |                                           |
| localhost | root        | invalid                                   |
| localhost | mysql       | invalid                                   |
| localhost | steve       | *6691484EA6B50DDDE1926A220DA01FA9E575C18A |
+-----------+-------------+-------------------------------------------+
4 rows in set (0.002 sec)

MariaDB [(none)]>
```

##### give user full perms on a new db foo

`grant all on foo.* to 'steve'@'localhost';`

##### use db (use current username, i.e. steve, and prompt for password)
`create database foo;`
`use foo;`

##### create a table

`create table food ( item varchar(20), quantity int);`

##### insert into table
`insert into food (item,quantity) values('cake',5);`

##### dump the db
`mysqldump -h localhost -u steve -p foo > foo.sql`

##### restore database
`mysql < foo.sql`

##### set config for auto login

````
$ cat >.my.cnf
[client]
host = localhost
user = steve
password = abc123
database = foo
$ mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 17
Server version: 10.5.13-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [foo]>
````

##### file locations

````
$ sudo ls -l /var/log/mariadb/mariadb.log
-rw-rw----. 1 mysql mysql 2299 Jul 26 19:02 /var/log/mariadb/mariadb.log
$ sudo tail /var/log/mariadb/mariadb.log
2022-07-26 18:50:15 0 [Note] /usr/libexec/mariadbd: ready for connections.
Version: '10.5.13-MariaDB'  socket: '/var/lib/mysql/mysql.sock'  port: 3306  MariaDB Server
2022-07-26 18:51:34 4 [Warning] Access denied for user 'steve'@'localhost' (using password: NO)
2022-07-26 18:53:29 6 [Warning] Access denied for user 'root'@'localhost'
2022-07-26 18:53:41 7 [Warning] Access denied for user 'root'@'localhost'
2022-07-26 18:57:32 9 [Warning] Access denied for user 'steve'@'localhost' (using password: NO)
2022-07-26 19:02:14 11 [Warning] Access denied for user 'steve'@'localhost' (using password: NO)
2022-07-26 19:02:18 12 [Warning] Access denied for user 'steve'@'localhost' (using password: NO)
2022-07-26 19:02:23 13 [Warning] Access denied for user 'steve'@'localhost' to database 'abc123'
2022-07-26 19:02:35 14 [Warning] Access denied for user 'steve'@'localhost' (using password: NO)
$
````

````
$ sudo find /var/lib/mysql/foo -ls
 51162659      0 drwx------   2 mysql    mysql          52 Jul 26 19:00 /var/lib/mysql/foo
 52754606      4 -rw-rw----   1 mysql    mysql          65 Jul 26 18:57 /var/lib/mysql/foo/db.opt
 52754608      4 -rw-rw----   1 mysql    mysql         482 Jul 26 19:00 /var/lib/mysql/foo/food.frm
 52754609     96 -rw-rw----   1 mysql    mysql       98304 Jul 26 19:00 /var/lib/mysql/foo/food.ibd
$
````

##### list all tables
````
MariaDB [foo]> show tables;
+---------------+
| Tables_in_foo |
+---------------+
| food          |
+---------------+
1 row in set (0.000 sec)

MariaDB [foo]>
````

````
MariaDB [(none)]> select table_name from information_schema.tables;
+------------------------------------------------------+
| table_name                                           |
+------------------------------------------------------+
| ALL_PLUGINS                                          |
| APPLICABLE_ROLES                                     |
| CHARACTER_SETS                                       |
| CHECK_CONSTRAINTS                                    |
| COLLATIONS                                           |
| COLLATION_CHARACTER_SET_APPLICABILITY                |
| COLUMNS                                              |
| COLUMN_PRIVILEGES                                    |
...
````

````
MariaDB [(none)]> use mysql; show tables;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| column_stats              |
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| global_priv               |
| gtid_slave_pos            |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| index_stats               |
| innodb_index_stats        |
| innodb_table_stats        |
| plugin                    |
| proc                      |
| procs_priv                |
| proxies_priv              |
| roles_mapping             |
| servers                   |
| slow_log                  |
| table_stats               |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| transaction_registry      |
| user                      |
+---------------------------+
31 rows in set (0.001 sec)

MariaDB [mysql]>
````

##### show ports in use

````
$ sudo lsof -Pp 16080 | grep TCP
mariadbd 16080 mysql   16u  IPv6              47683       0t0      TCP *:3306 (LISTEN)
$
````

##### run sql commands from commandline

````
$ mysql -e 'desc food;'
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| item     | varchar(20) | YES  |     | NULL    |       |
| quantity | int(11)     | YES  |     | NULL    |       |
+----------+-------------+------+-----+---------+-------+
$
`````

##### status
````
MariaDB [foo]> status
--------------
mysql  Ver 15.1 Distrib 10.5.13-MariaDB, for Linux (x86_64) using  EditLine wrapper

Connection id:          29
Current database:       foo
Current user:           steve@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server:                 MariaDB
Server version:         10.5.13-MariaDB MariaDB Server
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    latin1
Db     characterset:    latin1
Client characterset:    utf8
Conn.  characterset:    utf8
UNIX socket:            /var/lib/mysql/mysql.sock
Uptime:                 4 hours 1 min 6 sec

Threads: 1  Questions: 117  Slow queries: 0  Opens: 119  Open tables: 112  Queries per second avg: 0.008
--------------

MariaDB [foo]>
````
