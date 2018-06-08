#!/bin/bash

userroot=$1
echo ">>> install root: ${userroot}"

#------mongodb
install_mongodb(){
	echo ">>> install mongodb"

	mkdir -p $userroot/db/mongodb

	docker run --name mongodb -d --restart=always \
	-p 27017:27017 \
	-v $userroot/db/mongodb:/data/db \
	mongo
}

#------mysql
install_mysql(){
	echo ">>> install mysql"

	mkdir -p $userroot/db/mysql

	docker run --name mysql -e MYSQL_ROOT_PASSWORD=root -d --restart=always \
	-p 3306:3306 \
	-v $userroot/db/mysql:/var/lib/mysql \
	-v $userroot/etc/mysql/conf.d:/etc/mysql/conf.d \
	mysql:5.7.22
}

#------redis
install_redis(){
	echo ">>> install redis"

	mkdir -p $userroot/db/redis

	docker run --name redis -d --restart=always \
	-p 6379:6379 \
	-v $userroot/db/redis:/data \
	redis
}

#------php-fpm
install_php(){
	echo ">>> install php-fpm"

	mkdir $userroot/webroot

	docker run --name my-php -d --restart=always \
	-v $userroot/webroot:/usr/share/nginx/html \
	php:7.1-fpm
}

#------nginx
install_nginx(){
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
}

#------etcd
install_etcd(){
	HostIP='192.168.0.118'

	docker run -d -v $userroot/etc/etcd/certs:/etc/ssl/certs -p 4001:4001 -p 2380:2380 -p 2379:2379 \
	 --name etcd quay.io/coreos/etcd:v2.3.8\
	 -name etcd0 \
	 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
	 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
	 -initial-advertise-peer-urls http://${HostIP}:2380 \
	 -listen-peer-urls http://0.0.0.0:2380 \
	 -initial-cluster-token etcd-cluster-1 \
	 -initial-cluster etcd0=http://${HostIP}:2380 \
	 -initial-cluster-state new
}


if [ -n "$2" ]
then
	cmd=install_$2
	$cmd
else
	install_mongodb
	install_mysql
	install_redis
	install_php
	install_nginx
	install_etcd
fi
