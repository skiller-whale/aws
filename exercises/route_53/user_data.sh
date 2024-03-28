#!/bin/bash

# Update packages
yum update -y

# Install Apache Web Server
yum install -y httpd

# Install stress for later
yum install -y stress

# Configure the landing page
echo "<h1>Welcome to $(hostname -I)</h1>" > /var/www/html/index.html

# Enable and start the Apache service
systemctl start httpd
systemctl enable httpd
