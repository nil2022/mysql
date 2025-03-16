# Deploying MySQL + phpMyAdmin as a Web Service on Render

This guide will help you deploy **MySQL (port 3306)** with **phpMyAdmin (port 8000)** as a web service on Render using Docker.

## Prerequisites
- A **GitHub/GitLab** repository with Dockerfiles for MySQL + phpMyAdmin.
- A **Render** account.

---

## 1️⃣ **Setup MySQL + phpMyAdmin Web Service**

### **Dockerfile (MySQL + phpMyAdmin)**
```dockerfile
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
```

### **start.sh (Startup Script)**
```sh
#!/bin/bash

# Start MySQL service
service mysql start

# Set MySQL root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# Start Apache server
apachectl -D FOREGROUND
```

### **Render Deployment Steps for MySQL + phpMyAdmin**
1. Push the `Dockerfile` and `start.sh` to your GitHub/GitLab repository.
2. Go to [Render](https://dashboard.render.com/).
3. Create a **new Web Service**.
4. Select your repository and choose **Docker**.
5. Set **port to 8000**.
6. Add an environment variable:
   ```
   MYSQL_ROOT_PASSWORD=my-secret-password
   ```
7. Deploy the service.

---

## 2️⃣ **Access phpMyAdmin**
Once deployed, visit:
```
https://your-service-name.onrender.com/phpmyadmin
```
- **Username:** `root`
- **Password:** `my-secret-password`

---

## 3️⃣ **Connecting to MySQL Externally**
Once deployed, Render will provide a **public URL** for your **phpMyAdmin**.

To connect to MySQL from your backend:
```
DATABASE_HOST=your-service-name.onrender.com
DATABASE_USER=root
DATABASE_PASSWORD=my-secret-password
DATABASE_PORT=3306
```

---

## **Final Setup**
✅ **phpMyAdmin running on port 8000**  
✅ **MySQL running on port 3306 with external access**  

Now your services are live on Render! 🚀

