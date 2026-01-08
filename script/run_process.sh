#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/bin:/usr/libexec/docker/cli-plugins

cd /home/ec2-user/script

# 도커 컴포즈가 있는지 먼저 확인하고 실행하는 안전한 방식
if docker compose version > /dev/null 2>&1; then
    docker compose down || true
    docker compose up -d
elif docker-compose version > /dev/null 2>&1; then
    docker-compose down || true
    docker-compose up -d
else
    echo "Docker Compose not found!"
    exit 1
fi
