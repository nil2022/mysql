# Use Ubuntu as base image
FROM ubuntu:latest

# Install MySQL server
RUN apt update && apt install -y mysql-server && rm -rf /var/lib/apt/lists/*

# Expose MySQL port
EXPOSE 3306

# Allow remote connections
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Set MySQL root password and allow connections from any host
ENV MYSQL_ROOT_PASSWORD=my-secret-password

# Start MySQL
CMD ["mysqld_safe"]
