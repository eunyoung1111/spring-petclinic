pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('dockerhub')
    }

    stages {

        stage('Clone') {
            steps {
                git url: 'https://github.com/너계정/spring-petclinic.git', branch: 'main'
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
                docker build -t 너도커ID/petclinic:latest .
                echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin
                docker push 너도커ID/petclinic:latest
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
