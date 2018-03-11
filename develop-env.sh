#!/bin/bash

yum -y install nano

yum -y install git

yum -y install docker
chkconfig docker on
echo '{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
' > /etc/docker/daemon.json

service docker start

mkdir /data/webroot -p
mkdir /data/etc/nginx/conf.d -p
mkdir /data/log -p

curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/default.conf > mkdir /data/etc/nginx/conf.d/default.conf
docker run --name my-php -d -v /data/webroot:/usr/share/nginx/html php:7.1-fpm
docker run --name my-nginx -d -p 80:80 -v /data/webroot:/usr/share/nginx/html -v /data/etc/nginx/conf.d:/etc/nginx/conf.d -v /data/log:/var/log/nginx --link my-php:php nginx
