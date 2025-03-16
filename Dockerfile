# Use Ubuntu as the base image
FROM ubuntu:latest

# Update and install MySQL, Apache, PHP, and required dependencies
RUN apt update && apt install -y \
    mysql-server \
    php \
    php-mysqli \
    apache2 \
    php-cli \
    php-curl \
    php-json \
    php-mbstring \
    php-xml \
    wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Expose MySQL and Apache HTTP ports
EXPOSE 8000 3306

# Allow remote MySQL connections
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Set MySQL root password via environment variable
ENV MYSQL_ROOT_PASSWORD=my-secret-password

ENV PMA_HOST=mysql


# Install phpMyAdmin
RUN wget -O /tmp/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip && \
    unzip /tmp/phpmyadmin.zip -d /var/www/html/ && \
    mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin && \
    rm /tmp/phpmyadmin.zip

# Set Apache to serve phpMyAdmin on port 8000
RUN sed -i 's/80/8000/g' /etc/apache2/ports.conf
RUN sed -i 's/:80>/:8000>/g' /etc/apache2/sites-enabled/000-default.conf

# Startup script to run MySQL and Apache
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set entrypoint
CMD ["/start.sh"]
