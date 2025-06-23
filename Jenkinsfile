pipeline {
    agent any

    tools {
        maven 'Maven 3.8.1' // Configure in Jenkins Global Tools
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
                    sh 'docker run -d -p 8081:8081 --name java-webapp java-webapp'
                }
            }
        }
    }
}
