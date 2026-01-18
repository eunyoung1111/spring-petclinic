# 🏥 Spring Petclinic: CI/CD Pipeline & Automated Deployment

이 프로젝트는 Spring Boot 기반의 Petclinic 애플리케이션을 AWS 클라우드 환경에 자동화된 파이프라인으로 배포하는 전체 과정을 담고 있습니다.
Jenkins와 Docker, AWS CodeDeploy를 결합하여 개발자가 코드를 푸시하면 실제 서버까지 반영되는 현대적인 DevOps 워크플로우를 구현했습니다.

## 🚀 Tech Stack
- **Framework:** Spring Boot, Java, Maven
- **CI/CD:** Jenkins, AWS CodeDeploy
- **Containerization:** Docker, Docker Compose
- **Infrastructure:** AWS (EC2, S3, ALB, ASG)

## 🏗 Architecture & Flow
1. **Build:** Jenkins 컨테이너가 호스트의 Docker 엔진(DooD 방식)을 공유하여 Maven 빌드 및 Docker 이미지 생성
2. **Artifact:** 빌드된 아티팩트를 AWS S3에 저장
3. **Deploy:** AWS CodeDeploy가 S3에서 파일을 가져와 Auto Scaling Group 내 EC2 인스턴스들에 배포
4. **Service:** Application Load Balancer(ALB)를 통해 유입되는 트래픽을 각 인스턴스에 분산

![architecture](./Pipeline_Flow.png)
![build](./jenkins_build.png)

## 🛠 주요 설정 파일
- `Jenkinsfile`: 빌드, 이미지 푸시, 배포 명령을 포함한 전체 파이프라인 정의
- `Dockerfile`: 멀티 스테이지 빌드를 적용한 최적화된 애플리케이션 이미지 생성
- `appspec.yml`: CodeDeploy의 배포 단계별 스크립트 실행 정의

## 📝 Troubleshooting Case Study
### [ALB Health Check 실패 및 ASG 무한 재생성 해결]
- **문제**: 인스턴스 배포 후 'Unhealthy' 판정으로 인해 ASG가 인스턴스를 무한 삭제/생성하는 현상 발생
- **원인**: 보안그룹(SG) 간 참조 설정 누락 및 애플리케이션 부팅 시간을 고려하지 않은 Health Check 유예 기간 설정
- **해결**: 인스턴스 보안그룹에 ALB 보안그룹 ID를 소스로 추가하고, Grace Period를 300초로 조정하여 인프라 안정성 확보
