#!/bin/bash

# Start MySQL service
service mysql start

# Set MySQL root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# Start Apache server
apachectl -D FOREGROUND
