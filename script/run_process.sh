#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/bin
cd /home/ec2-user/script
docker compose down
docker compose up -d
