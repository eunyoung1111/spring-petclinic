pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('dockerhub')   // DockerHub Credentials
    }

    stages {

        stage('Clone') {
            steps {
                git url: 'https://github.com/eunyoung1111/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Build JAR') {
            steps {
                sh './mvnw package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh """
                docker build -t eunyoung1111/petclinic:latest .
                echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin
                docker push eunyoung1111/petclinic:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                    kubectl apply -f k8s/petclinic-deployment.yaml
                    kubectl apply -f k8s/petclinic-service.yaml
                    """
                }
            }
        }
    }
}
