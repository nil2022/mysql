# Use an official Ubuntu image as the base
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=your-secret-password

# Install necessary packages
RUN apt-get update && apt-get install -y \
    mysql-server \
    apache2 \
    php \
    php-mysql \
    libapache2-mod-php \
    phpmyadmin \
    && rm -rf /var/lib/apt/lists/*

# Configure MySQL to allow external connections
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy custom startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for Apache and MySQL
EXPOSE 80 3306

# Set the container startup command
CMD ["bash", "-c", "/start.sh"]
