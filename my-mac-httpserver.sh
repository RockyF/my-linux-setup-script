#!/bin/bash

userroot=/Volumes/MacStorage/Users/rocky.l
echo ">>> install root: ${userroot}"

#------php-fpm
echo ">>> install php-fpm"

mkdir $userroot/webroot

docker run --name my-php -d --restart=always \
-v $userroot/webroot:/usr/share/nginx/html \
php:7.1-fpm

#------nginx
echo ">>> install nginx"

mkdir $userroot/webroot
mkdir -p $userroot/etc/nginx/conf.d
mkdir -p $userroot/log/nginx

curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/default.conf > $userroot/etc/nginx/conf.d/default.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/index.html > $userroot/webroot/index.html

docker run --name my-nginx -d --restart=always -p 80:80 \
-v $userroot/webroot:/usr/share/nginx/html \
-v $userroot/etc/nginx/conf.d:/etc/nginx/conf.d \
-v $userroot/log/nginx:/var/log/nginx \
--link my-php:php nginx