#!/bin/bash
# 1. 환경 설정 및 경로 이동
export IMAGE_TAG=${IMAGE_TAG:-latest}
cd /home/ec2-user/script

# 2. [SAA 핵심] IMDSv2를 사용하여 인스턴스 ID 가져오기
# 토큰을 먼저 발행받아야 정보를 조회할 수 있습니다 (보안 강화 버전)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# 3. 환경 변수 파일(.env) 업데이트
# 젠킨스가 만든 .env에 인스턴스 ID를 추가로 기록합니다.
echo "INSTANCE_ID=$INSTANCE_ID" >> .env
export INSTANCE_ID=$INSTANCE_ID

echo "현재 배포 중인 인스턴스 ID: $INSTANCE_ID"

# 4. 도커 컴포즈 실행 로직
if docker compose version > /dev/null 2>&1; then
    echo "Using 'docker compose'..."
    # 최신 이미지를 가져오고 컨테이너를 재시작합니다.
    docker compose pull spring-petclinic
    docker compose down || true
    docker compose up -d
elif docker-compose version > /dev/null 2>&1; then
    echo "Using 'docker-compose'..."
    docker-compose pull spring-petclinic
    docker-compose down || true
    docker-compose up -d
else
    echo "Docker Compose not found!"
    exit 1
fi

# 5. 실행 결과 확인
sleep 2
docker ps
