pipeline {
  agent any

  tools {
    maven "M3"
    jdk   "JDK21"
  }

  environment {    
    DOCKER_IMAGE = "eunyoung11/springpetclinic" 
    GITHUB_URL = "https://github.com/eunyoung1111/spring-petclinic.git"
    
    DOCKERHUB_CREDENTIALS = credentials('DockerCredentials')
    AWS_CREDENTIALS_NAMES = credentials('AWSCredentials') // NAME으로 통일
    REGION = "ap-northeast-2" // : 대신 = 사용
  }

  stages {
    stage('Git Clone') {
      steps {
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
          docker rmi ${env.DOCKER_IMAGE}:latest
          docker rmi spring-petclinic:${BUILD_NUMBER}
          """
        }
      }
    }

    stage('Upload S3') {
      steps {
        echo 'Upload S3'
        dir ("${env.WORKSPACE}") {
          // appspec.yml 오타 수정
          sh 'zip -r script.zip ./script appspec.yml'
          
          // withAWS 블록 { } 추가
          withAWS(region: "${env.REGION}", credentials: "${env.AWS_CREDENTIALS_NAMES}") {
            s3Upload(file: "script.zip", bucket: "user01-codedeploy-bucket")
          }
        }
        sh 'rm -rf script.zip'
      }
    }
  } // stages 끝
} // pipeline 끝
