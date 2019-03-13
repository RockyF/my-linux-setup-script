#!/bin/bash

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source /root/.bashrc
nvm install 8.9.4

npm config set registry https://registry.npm.taobao.org
npm i -g pm2
