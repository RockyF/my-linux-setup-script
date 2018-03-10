#!/bin/bash

#stop firewall
systemctl stop firewalld.service

#disable firewall
systemctl disable firewalld.service

#stop selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config