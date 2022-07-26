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

