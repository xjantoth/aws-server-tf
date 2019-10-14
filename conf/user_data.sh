#!/bin/bash

echo "Hello User Data from Terraform" > /opt/user_data.txt
yum update -y
yum install vim httpd -y 
systemctl enable httpd && systemctl start httpd
echo "This is HTTPD from Terrafrom Certification" > /var/www/html/index.html