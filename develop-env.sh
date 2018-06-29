#!/bin/bash

yum -y install nano
yum -y install net-tools
yum -y install git
yum -y install wget

yum -y install docker
chkconfig docker on
echo '{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
' > /etc/docker/daemon.json

service docker start

mkdir -p $pwd/webroot
mkdir -p $pwd/etc/nginx/conf.d
mkdir -p $pwd/log/nginx

curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/nginx.conf > $pwd/etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/default.conf > $pwd/etc/nginx/conf.d/default.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/index.html > $pwd/webroot/index.html
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/info.php > $pwd/webroot/info.php

docker run --name my-php -d -u root --restart=always -v $pwd/webroot:/usr/share/nginx/html php:7.1-fpm
docker run --name my-nginx -d --restart=always -p 80:80 -v $pwd/webroot:/usr/share/nginx/html -v $pwd/etc/nginx/conf.d:/etc/nginx/conf.d -v $pwd/etc/nginx/nginx.conf:/etc/nginx/nginx.conf -v $pwd/log/nginx:/var/log/nginx --link my-php:php nginx
