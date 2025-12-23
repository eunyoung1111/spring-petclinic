pipeline {
  agent any

  tools {
    maven "M3"
    jdk   "JDK21"
  }

  environment {    
    DOCKER_IMAGE = "eunyoung11/springpetclinic" 
    GITHUB_URL = "https://github.com/eunyoung1111/spring-petclinic.git" // 깃허브 (1111)
    
    DOCKERHUB_CREDENTIALS = credentials('DockerCredentials')
    AWS_CREDENTIALS_NAMES = credentials('AWSCredentials')
    GIT_CREDENTIALS = credentials('GitCredentials')
  }

  stages {
    stage('Git Clone') {
      steps {
        // 1111 계정 사용
        git branch: 'main', 
            credentialsId: 'GitCredentials', 
            url: "${env.GITHUB_URL}"
      }
    }

    stage('Maven Build') {
      steps {        
        echo "Maven Build"
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
    }

    stage('Docker Image Build') {
      steps {
        echo 'Docker Image Build'        
        dir("${env.WORKSPACE}") {
          sh """
          # 빌드할 때 도커허브(11) 계정명 사용
          docker build -t spring-petclinic:${BUILD_NUMBER} .
          docker tag spring-petclinic:${BUILD_NUMBER} ${env.DOCKER_IMAGE}:latest
          """
        }
      }
    }

    stage('Docker Image Push') {
      steps {
        echo 'Docker Image Push'
        dir("${env.WORKSPACE}") {
          // --password-stdin (하이픈 2개)로 수정
          sh """
          echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
          docker push ${env.DOCKER_IMAGE}:latest
          docker logout
          """
        }
      }
    }

    stage('Docker Image Remove') {
      steps {
        echo 'Docker Image Remove'
        dir ("${env.WORKSPACE}") {
          sh """
          # 로컬에 남은 이미지들 삭제
          docker rmi ${env.DOCKER_IMAGE}:latest
          docker rmi spring-petclinic:${BUILD_NUMBER}
          """
        }
      }
    }
  } // stages 끝
} // pipeline 끝
