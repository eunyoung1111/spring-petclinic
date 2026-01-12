#!/bin/bash
# 1. 환경 설정 및 경로 이동
export IMAGE_TAG=${IMAGE_TAG:-latest}
cd /home/ec2-user/script

# 2. IMDSv2를 사용하여 인스턴스 ID 가져오기
# 단계 A: 6시간(21,600초) 동안 유효한 보안 토큰 발행
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
# 단계 B: 발행된 토큰을 헤더에 담아 실제 인스턴스 ID를 조회
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# 3. 환경 변수 파일(.env) 업데이트
# 젠킨스가 만든 .env에 인스턴스 ID를 추가로 기록 (로드밸런스 확인용)
echo "INSTANCE_ID=$INSTANCE_ID" > .env
export INSTANCE_ID=$INSTANCE_ID

echo "현재 배포 중인 인스턴스 ID: $INSTANCE_ID"

# 4. 도커 컴포즈 실행 로직
if docker compose version > /dev/null 2>&1; then
    echo "Using 'docker compose'..."
    # 최신 이미지를 가져오기(pull), 컨테이너를 재시작(down, up -d)
    docker compose pull spring-petclinic
    docker compose down || true
    docker compose up -d
elif docker-compose version > /dev/null 2>&1; then
    echo "Using 'docker-compose'..."
    docker-compose pull spring-petclinic
    docker-compose down || true
    docker-compose up -d
else
    echo "Docker Compose not found"
    exit 1
fi

# 5. 실행 결과 확인
sleep 2
docker ps    # 현재 정상적으로 뜬 컨테이너 목록 출력
