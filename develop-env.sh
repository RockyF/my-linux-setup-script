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
