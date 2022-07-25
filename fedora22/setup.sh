#!/bin/sh
# Linode Fedora 22 post-install script
# - setup WordPress
#

SSH_PORT=30271           # Random port for ssh
PASSWORD=password        # Random password
NONROOT_USER=bob         # Non-root trusted user
HOST_NAME=li-bob         # Hostname
ISP_SUBNET=88.3.0.0/16   # ISP subnet
DB_ROOT_PASSWORD=pass2   # MariaDB root password
WP_DB_NAME=wpdb          # Name of wordpress db
WP_DB_USER=wpuser        # Name of wordpress db user
WP_DB_PASSWORD=pass3     # Wordpress db password
IP=123.123.123.123       # IP address of this host
WP_CONFIG=/etc/wordpress/wp-config.php 
                         # Wordpress config file

# check we are on fedora 22
grep "^Fedora release 22 (Twenty Two)" /etc/fedora-release >/dev/null
if [ $? != 0 ]
then
 echo not fedora 22 !
 exit 5
fi

# sshd secure
# - Add user
# - Add sudo rule for user
# - Set PermitRootLogin to no
# - Move ssh to different port
echo ==Securing sshd==
useradd $NONROOT_USER || exit 5
passwd --stdin $NONROOT_USER <<EOF || exit 5
$PASSWORD
EOF
echo "$NONROOT_USER ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers || exit 5
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' \
    /etc/ssh/sshd_config || exit 5
sed -i 's/^#Port 22/Port '$SSH_PORT'/' \
    /etc/ssh/sshd_config || exit 5

# Setup hostname+timezone
echo ==Setting up hostname==
echo "$IP $HOST_NAME" >>/etc/hosts || exit 5
hostnamectl set-hostname $HOST_NAME || exit 5
timedatectl set-timezone Europe/London || exit 5

# Setup firewall-cmd
# - Shutdown iptables
# - Start firewalld
echo ==Firewall config==
echo ..stopping iptables
systemctl disable iptables || exit 5
systemctl stop iptables 2>&1 | grep -v "Failed to stop iptables"
echo ..starting firewalld
systemctl enable firewalld || exit 5
systemctl start firewalld || exit 5
echo ..permit my ISP subnet to ssh
firewall-cmd --permanent --add-rich-rule=\
"rule port port=$SSH_PORT protocol=tcp family=ipv4 \
source address=$ISP_SUBNET accept"
echo ..permit localhost to mysql
firewall-cmd --permanent --add-rich-rule=\
"rule port port=3306 protocol=tcp family=ipv4 \
source address=127.0.0.1 accept"
echo ..block other subnets ssh
firewall-cmd --permanent --remove-service=ssh

# Enable ntp time sync
echo ==NTP==
systemctl start ntpd || exit 5
systemctl enable ntpd || exit 5

# Install MariaDB
dnf -y install mariadb mariadb-server php-mysqlnd || exit 5
systemctl start mariadb || exit 5
systemctl enable mariadb || exit 5

echo ..securing mariadb and creating wordpress db
mysql -u root <<EOF || exit 5
UPDATE mysql.user SET Password=PASSWORD('$DB_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
CREATE DATABASE ${WP_DB_NAME};
GRANT index, create, select, insert, update, delete, drop, alter, lock tables on ${WP_DB_NAME}.* to '${WP_DB_USER}'@'localhost' identified by '$WP_DB_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Install wordpress
dnf -y install wordpress || exit 5

# Configure wordpress
cp $WP_CONFIG ${WP_CONFIG}.orig || exit 5
sed -i 's/database_name_here/'$WP_DB_NAME'/' $WP_CONFIG || exit 5
sed -i 's/username_here/'$WP_DB_USER'/' $WP_CONFIG || exit 5
sed -i 's/password_here/'$WP_DB_PASSWORD'/' $WP_CONFIG || exit 5
cp -r /usr/share/wordpress/* /var/www/html || exit 5

# Secure wordpress
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig || exit 5
sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/httpd/conf/httpd.conf || exit 5

# Prevent crawlers
cat >/var/www/html/robots.txt <<EOF
User-agent: *
Disallow: /wp-admin/
Disallow: /wp-includes/
Disallow: /wp-content/plugins/
Disallow: /wp-content/themes/
Disallow: /feed/
Disallow: */feed/
EOF

# Start webserver
systemctl start httpd || exit 5
systemctl enable httpd || exit 5
firewall-cmd --zone=public --add-service=http || exit 5
firewall-cmd --permanent --zone=public --add-service=http || exit 5

# point browser at site
echo Go to http://${IP} and enter site title, username, password, email addr
echo Hit ENTER when done
read KAK

# code prettify plugin
echo Installing Crayon syntax highlighter plugin
cd /var/www/html/wp-content/plugins || exit 5
wget https://downloads.wordpress.org/plugin/crayon-syntax-highlighter.zip
unzip crayon-syntax-highlighter.zip || exit 5

# revise permissions on uploads dir from root:root 755 to root:apache 775
echo Enabling uploads
chgrp apache /var/www/html/wp-content/uploads || exit 5
chmod 775    /var/www/html/wp-content/uploads || exit 5

# setup cron job to backup wordpress db each day
echo Setting up cron job for daily wordpress db backups
cat >>/etc/cron.daily/wp-mysqldump.cron <<EOF
#!/bin/bash
umask 066
mysqldump --add-drop-table -u $WP_DB_USER -p $WP_DB_NAME --password=$WP_DB_PASSWORD | bzip2 > ~/wordpress-\$(date '+%A').dmp.bz2
EOF
chmod 700 /etc/cron.daily/wp-mysqldump.cron || exit 5

echo Setting up cron job for daily wp-content backups each day
# tar not installed by default!
dnf -y --quiet install tar || exit 5
cat >>/etc/cron.daily/wp-contentdump.cron <<EOF
#!/bin/sh
umask 066
cd /var/www/html/wp-content || exit 5
tar cf - --bzip . > ~/wordpress-\$(date '+%A').content.bz2
EOF
chmod 700 /etc/cron.daily/wp-contentdump.cron || exit 5

echo Update using dnf
dnf -y --quiet update || exit 5

echo Done, perform reboot now
echo hit ENTER
read FOO
reboot
exit
