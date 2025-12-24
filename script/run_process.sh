#!/bin/bash
#cd /home/ubuntu/script
#docker compose up -d

docker compose -f /home/ubuntu/script/docker-compose.yml up || true
