#!/bin/bash

# Start MySQL
service mysql start

# Wait for MySQL to initialize
sleep 10

# Set MySQL root password and allow external access
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -e "FLUSH PRIVILEGES;"

# Restart MySQL to apply changes
service mysql restart

# Start Apache
apachectl -D FOREGROUND
