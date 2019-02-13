#!/bin/bash
set -e

echo "Starting identidock system"

docker run -d --restart=always --name redis redis:latest
docker run -d --restart=always --name dnmonster nsprng/dnmonster:1.0
docker run -d --restart=always --link dnmonster:dnmonster --link redis:redis \
  -e ENV=PROD --name identidock nsprng/identidock:1.0
docker run -d --restart=always --link  identidock:identidock -p 80:80 \
  -e NGINX_HOST=ub1 -e NGINX_PROXY=http://identidock:9090 --name proxy \
  nsprng/identiproxy:1.0

echo "Started"
