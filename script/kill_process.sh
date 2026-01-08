#!/bin/bash
cd /home/ec2-user/script
# 경로와 명령어를 ec2-user 환경에 맞게 수정
docker compose down || true
exit 0
