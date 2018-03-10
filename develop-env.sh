#!/bin/bash

yum -i install nano

yum -i install git

yum -i install docker
chkconfig docker on
echo '{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
' > /etc/docker/daemon.json