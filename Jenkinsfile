pipeline {
  agent any

  tools {
    maven "M3"
    jdk "JDK"
  }

  envirnoment {
    DOCKERHUB_CREDENTIALS = credentials('dockerCredentials')
  }

  stages{
    stage('Git Clone'){
      steps {
        git url: 'https://github.com/eunyoung1111/spring-petclinic.git', branch: 'main'
      }
    }
    stage('Maven Build'){
      steps {
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
    }
    stage('Docker Image Create') {
      steps {
       sh """
        docker build -t eunyoung11/spring-petclinic:$BUILD_NUMBER .
        docker tag eunyoung11/spring-petclinic:$BUILD_NUMBER eunyoung11/spring-petclinic:latest
       """
      }
    }
    stage('Docker Hub Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Docker Image Push'){
      steps {
        sh 'docker push eunyoung11/spring-petclinic:latest'
      }
    }
  }
}
