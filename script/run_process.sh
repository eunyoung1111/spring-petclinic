#!/bin/bash
#export PATH=$PATH:/usr/local/bin:/usr/bin:/usr/libexec/docker/cli-plugins
export IMAGE_TAG=${IMAGE_TAG:-latest}
cd /home/ec2-user/script

if docker compose version > /dev/null 2>&1; then
    # [핵심 추가] 젠킨스가 새로 올린 이미지를 서버로 가져옵니다.
    docker compose pull spring-petclinic
    docker compose down || true
    docker compose up -d
elif docker-compose version > /dev/null 2>&1; then
    # [핵심 추가] 구형 명령어인 경우에도 동일하게 적용합니다.
    docker-compose pull spring-petclinic
    docker-compose down || true
    docker-compose up -d
else
    echo "Docker Compose not found!"
    exit 1
fi
