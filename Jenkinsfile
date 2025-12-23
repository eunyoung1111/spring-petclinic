pipeline {
  agent any

  tools {
    maven "M3"
    jdk   "JDK21"
  }

  enviroment {
    DOCKERHUB_CREDENTIALS = credentilas('DockerCredentials')
    AWS_CREDENTIALS_NAMES = credentilas('AWSCredentials')
    GIT_CREDENTIALS = credentilas('GitCredentials')
  }

  stages {
    stage('Git Clone') {
      steps {
        git url: 'https://github.com/eunyoung1111/spring-petclinic.git'
        branch: 'main', credentialsID: 'GIT_CREDENTIALS'
      }
    }
  }


}
