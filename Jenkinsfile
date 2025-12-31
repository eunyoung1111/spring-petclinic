pipeline {
  agent any

  tools {
    maven "M3"
    jdk   "JDK21"
  }

  environment {    
    DOCKER_IMAGE = "eunyoung11/springpetclinic" 
    GITHUB_URL = "https://github.com/eunyoung1111/spring-petclinic.git"
    
    DOCKERHUB_CREDENTIALS = credentials('DockerCredential')
    AWS_CREDENTIALS_NAMES = credentials('AWSCredentials')
    REGION = "ap-northeast-2"
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
          sh 'zip -r script.zip ./script appspec.yml'
          withAWS(region: "ap-northeast-2", credentials:'AWSCredentials') {
            s3Upload(file: "script.zip", bucket: "project01-codedeploy-bucket")
          }
        }
        sh 'rm -rf script.zip'
      }
    }

    stage('CodeDeploy Deployment') {
      steps {
        withAWS(region: "${env.REGION}", credentials:'AWSCredentials') {
          echo 'create CodeDeploy group'
          sh """
          aws deploy create-deployment-group \
          --application-name project01-spring-petclinic \
          --auto-scaling-groups USER01-WAS \ 
          --deployment-group-name project01-spring-petclinic-${BUILD_NUMBER} \
          --service-role-arn arn:aws:iam::491085389788:role/project01-code-deploy-service-role
          """

          echo 'CodeDeploy Workload'
          sh """
          aws deploy create-deployment --application-name project01-spring-petclinic \
          --deployment-config-name CodeDeployDefault.OneAtATime \
          --deployment-group-name project01-spring-petclinic-${BUILD_NUMBER} \
          --s3-location bucket=project01-codedeploy-bucket,bundleType=zip,key=script.zip
          """
        }
        sleep(10)
      }
    }
      
  } // stages 끝
} // pipeline 끝
