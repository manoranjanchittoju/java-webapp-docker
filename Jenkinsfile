pipeline {
    agent any

    tools {
        maven 'Maven 3.8.1'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/manoranjanchittoju/java-webapp-docker.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Run') {
            steps {
                script {
                    sh 'docker build -t java-webapp .'
                    sh 'docker rm -f java-webapp || true'
                    sh 'docker run -d -p 8082:8080 --name java-webapp java-webapp'
                }
            }
        }
    }

    post {
        always {
            sh 'docker ps -a'
        }
    }
}
