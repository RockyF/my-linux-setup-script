#!/bin/bash

echo "n




w
" | fdisk /dev/sdb && mkfs -t ext4 /dev/sdb1
mkdir /data
mount /dev/sdb1 /data
echo '/dev/sdb1 /data ext4 rw,defaults 0 0' >> /etc/fstab

#stop firewall
systemctl stop firewalld.service

#disable firewall
systemctl disable firewalld.service

#stop selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yum -y install nano

yum -y install git

yum -y install docker
chkconfig docker on
echo '{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
' > /etc/docker/daemon.json

service docker start
