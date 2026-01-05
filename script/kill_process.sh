#!/bin/bash
#cd /home/ubuntu/script
#docker compose down || true

docker compose -f /home/ubuntu/script/docker-compose.yml down || true
exit 0
