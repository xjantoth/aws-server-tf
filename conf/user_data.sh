#!/bin/bash

echo "Hello User Data from Terraform" > /opt/user_data.txt
yum update -y

yum install -y \
vim \
httpd \
docker \


usermod -a -G docker ec2-user
curl -L \
https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null

chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


for i in docker httpd; do 
    systemctl enable $i && systemctl start $i
done

EC2_AVAILA_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

echo "$EC2_AVAILA_ZONE This is HTTPD from Terrafrom Certification $(uname -n)" > /var/www/html/index.html

# WORK=/opt/wp-docker
# mkdir -p $WORK
# cd $WORK

# cat > $WORK/docker-compose.yml <<'EOF'
# version: '3'
# services:
#   wordpress:
#     image: wordpress:4.9.8
#     container_name: wordpress
#     restart: always
#     volumes:
#       - ./wp-content:/var/www/html/wp-content
#     environment:
#       WORDPRESS_DB_HOST: db
#       WORDPRESS_DB_NAME: wpdb
#       WORDPRESS_DB_USER: user
#       WORDPRESS_DB_PASSWORD: password
#     ports:
#       - 8080:80
#       - 443:443
#   db:
#     image: mysql:8
#     container_name: mysql
#     restart: always
#     command: "--default-authentication-plugin=mysql_native_password"
#     environment:
#       MYSQL_ROOT_PASSWORD: password
#       MYSQL_DATABASE: wpdb
#       MYSQL_USER: user
#       MYSQL_PASSWORD: password
#   phpmyadmin:
#     image: phpmyadmin/phpmyadmin
#     restart: always
#     ports:
#       - 3333:80
#     environment:
#       PMA_HOST: db
#       MYSQL_ROOT_PASSWORT: password
# EOF

# docker-compose up -d
    