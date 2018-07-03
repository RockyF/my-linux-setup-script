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

workpath=`pwd`

mkdir -p $workpath/webroot
mkdir -p $workpath/etc/nginx/conf.d
mkdir -p $workpath/log/nginx

curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/nginx.conf > $workpath/etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/default.conf > $workpath/etc/nginx/conf.d/default.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/index.html > $workpath/webroot/index.html
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/info.php > $workpath/webroot/info.php

docker run --name my-php -d -u root --restart=always -v $workpath/webroot:/usr/share/nginx/html php:7.1-fpm
docker run --name my-nginx -d --restart=always -p 80:80 -v $workpath/webroot:/usr/share/nginx/html -v $workpath/etc/nginx/conf.d:/etc/nginx/conf.d -v $workpath/etc/nginx/nginx.conf:/etc/nginx/nginx.conf -v $workpath/log/nginx:/var/log/nginx --link my-php:php nginx
