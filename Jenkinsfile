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
                sh 'mvn clean package -DskipTests -Dcheckstyle.skip
            }
        }

        stage('Docker Image Build') {
            steps {
                echo 'Docker Image Build'        
                dir("${env.WORKSPACE}") {
                    sh """
                    docker build -t ${env.DOCKER_IMAGE}:${BUILD_NUMBER} .
                    docker tag ${env.DOCKER_IMAGE}:${BUILD_NUMBER} ${env.DOCKER_IMAGE}:latest
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
                    docker push ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}
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
                    docker rmi ${env.DOCKER_IMAGE}:${BUILD_NUMBER} || true
                    docker rmi ${env.DOCKER_IMAGE}:latest || true
                    """
                }
            }
        }

        stage('Upload S3') {
            steps {
                echo 'Upload S3'
                dir ("${env.WORKSPACE}") {
                    sh "echo 'IMAGE_TAG=${env.BUILD_NUMBER}' > ./script/.env"
                    sh 'zip -r script.zip ./script appspec.yml'
                    withAWS(region: "${env.REGION}", credentials:'AWSCredentials') {
                        s3Upload(file: "script.zip", bucket: "project01-codedeploy-bucket")
                    }
                }
                sh 'rm -rf script.zip'
            }
        }

        stage('CodeDeploy Deployment') {
            steps {
                withAWS(region: "${env.REGION}", credentials:'AWSCredentials') {
                    echo 'create CodeDeploy group (Skip if exists)'
                    sh """
                    aws deploy create-deployment-group \
                    --application-name project01-spring-petclinic \
                    --auto-scaling-groups project01-was-asg \
                    --deployment-group-name project01-spring-petclinic-group \
                    --service-role-arn arn:aws:iam::491085389788:role/project01-code-deploy-service-role || true
                    """

                    echo 'CodeDeploy Workload'
                    sh """
                    aws deploy create-deployment --application-name project01-spring-petclinic \
                    --deployment-config-name CodeDeployDefault.OneAtATime \
                    --deployment-group-name project01-spring-petclinic-group \
                    --s3-location bucket=project01-codedeploy-bucket,bundleType=zip,key=script.zip
                    """
                }
                sleep(10)
            }
        }
    } // stages 끝
} // pipeline 끝
