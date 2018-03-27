#!/usr/bin/env bash

mkdir -p /data/mongodb
docker run -d --name mongodb --restart=always -v /data/mongodb:/data/db -p 27017:27017 mongo