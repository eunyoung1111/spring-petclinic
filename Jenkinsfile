pipeline {
  agent any

  tools {
    maven "M3"
    jdk   "JDK21"
  }

  environment {
    // credentials() 함수는 해당 ID의 값을 변수에 할당할 때 사용합니다.
    DOCKERHUB_CREDENTIALS = credentials('DockerCredentials')
    AWS_CREDENTIALS_NAMES = credentials('AWSCredentials')
    GIT_CREDENTIALS = credentials('GitCredentials')
  }

  stages {
    stage('Git Clone') {
      steps {
        // git step은 아래와 같이 인자들을 구성합니다.
        git branch: 'main', 
            credentialsId: 'GitCredentials', 
            url: 'https://github.com/eunyoung1111/spring-petclinic.git'
      }
    }
  }
}
