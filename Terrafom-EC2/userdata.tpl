#!/bin/bash

# Update package lists and upgrade installed packages
apt update && apt upgrade -y

# Install Nginx web server
apt install nginx -y

# Enable Nginx to start on system boot
systemctl enable nginx

# Start Nginx service to be accessed on web
systemctl start nginx

# Create a simple HTML file with Hello World message
sudo bash -c 'echo Hello World, Nginx installation and setup completed successfully. > /var/www/html/index.html'

