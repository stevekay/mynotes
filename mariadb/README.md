# mariadb

### install

`sudo yum install -y mariadb-server`

### start

`sudo systemctl --now enable mariadb`

### login

`sudo mariadb -h localhost`

### create non-root user

`create user 'steve'@'localhost' identified by 'abc123';

### list all users

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

