Fedora 22 wordpress script.

Post-build script to install + configure wordpress/firewall/mysql etc.

* Move ssh to another port
* Disable ssh as root
* Add a non-root user
* Setup hostname+timezone
* Enable firewalld
 * allow http from anywhere
 * allow ssh on new port from your ISP only
 * allow MySQL from localhost only
* Enable NTP time sync
* Install + configure MariaDB
* Secure MariaDB
* Install + configure WordPress
* Secure WordPress
* Prevent webcrawlers
* Start + enable Apache webserver
* Install Crayon syntax highlighter plugin
* Setup cron jobs for daily MariaDB + content backups

Tested September 2015 on Fedora 22, using the default repo package versions:
* firewalld-0.3.13-7.fc22.noarch
* mariadb-10.0.21-1.fc22.x86_64
* mariadb-server-10.0.21-1.fc22.x86_64
* php-mysqlnd-5.6.13-1.fc22.x86_64
* wordpress-4.3-1.fc22.noarch
