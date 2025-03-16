# Deploying Nginx and MySQL as Web Services on Render

This guide will help you deploy **Nginx (port 8000)** and **MySQL (port 3306)** as separate web services on Render using Docker.

## Prerequisites
- A **GitHub/GitLab** repository with Dockerfiles for Nginx and MySQL.
- A **Render** account.

---

## 1️⃣ **Setup Nginx Web Service**

### **Dockerfile (Nginx)**
```dockerfile
# Use Ubuntu as the base image
FROM ubuntu:latest

# Install Nginx
RUN apt update && apt install -y nginx && rm -rf /var/lib/apt/lists/*

# Expose port 8000
EXPOSE 8000

# Modify Nginx default configuration to listen on port 8000
RUN sed -i 's/listen 80 default_server;/listen 8000 default_server;/g' /etc/nginx/sites-available/default

# Copy Render's startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set entrypoint to the startup script
CMD ["/start.sh"]
```

### **start.sh (Nginx Startup Script)**
```sh
#!/bin/bash
# Start Nginx
nginx -g 'daemon off;'
```

### **Render Deployment Steps for Nginx**
1. Push the `Dockerfile` and `start.sh` to your GitHub/GitLab repository.
2. Go to [Render](https://dashboard.render.com/).
3. Create a **new Web Service**.
4. Select your repository and choose **Docker**.
5. Set **port to 8000**.
6. Deploy the service.

---

## 2️⃣ **Setup MySQL Web Service**

### **Dockerfile (MySQL)**
```dockerfile
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
```

### **Render Deployment Steps for MySQL**
1. Push the `Dockerfile` to your GitHub/GitLab repository.
2. Go to [Render](https://dashboard.render.com/).
3. Create a **new Web Service**.
4. Select your repository and choose **Docker**.
5. Set **port to 3306**.
6. Add an environment variable:
   ```
   MYSQL_ROOT_PASSWORD=my-secret-password
   ```
7. Deploy the service.

---

## 3️⃣ **Connecting to MySQL Externally**
Once deployed, Render will provide a **public URL** for your **MySQL service** (e.g., `mysql-service-name.onrender.com`).

To connect from your backend or MySQL client:
```sh
mysql -h mysql-service-name.onrender.com -u root -p
```

For backend connections, use:
```
DATABASE_HOST=mysql-service-name.onrender.com
DATABASE_USER=root
DATABASE_PASSWORD=my-secret-password
DATABASE_PORT=3306
```

---

## **Final Setup**
✅ **Nginx running on port 8000**  
✅ **MySQL running on port 3306 with external access**  

Now your services are live on Render! 🚀

