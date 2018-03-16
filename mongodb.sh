#!/usr/bin/env bash

mkdir /data/mongodb -p
docker run -d --name mongodb --restart=always -v /data/mongodb:/data/db -p 27017:27017 mongo