#!/bin/bash

echo "n




w
" | fdisk /dev/sdb && mkfs -t ext4 /dev/sdb1
mkdir /data
mount /dev/sdb1 /data
echo '/dev/sdb1 /data ext4 rw,defaults 0 0' >> /etc/fstab
