#!/bin/bash

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source /root/.bash_profile
nvm install 8.9.4

npm config set registry https://registry.npm.taobao.org
npm i -g pm2
