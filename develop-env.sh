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
mkdir /data/log/nginx -p

curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/default.conf > /data/etc/nginx/conf.d/default.conf
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/index.html > /data/web/index.html
curl https://raw.githubusercontent.com/RockyF/my-linux-setup-script/master/nginx/info.php > /data/web/info.php

docker run --name my-php -d -v /data/webroot:/usr/share/nginx/html php:7.1-fpm
docker run --name my-nginx -d -p 80:80 -v /data/webroot:/usr/share/nginx/html -v /data/etc/nginx/conf.d:/etc/nginx/conf.d -v /data/log/nginx:/var/log/nginx:rw --link my-php:php nginx
