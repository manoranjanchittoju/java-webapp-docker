#!/bin/bash

echo "🚀 Setting up Jenkins with Maven + Docker CLI..."

# Step 1: Create Dockerfile if not exists
if [ ! -f Dockerfile ]; then
cat <<EOF > Dockerfile
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \\
    apt-get install -y docker.io maven && \\
    usermod -aG docker jenkins

USER jenkins
EOF
echo "✅ Dockerfile created."
fi

# Step 2: Create Jenkinsfile if not exists
if [ ! -f Jenkinsfile ]; then
cat <<EOF > Jenkinsfile
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
                    sh 'docker run -d -p 8081:8081 --name java-webapp java-webapp'
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
EOF
echo "✅ Jenkinsfile created."
fi

# Step 3: Build Jenkins image
docker build -t jenkins-dockerized .
echo "✅ Built custom Jenkins image."

# Step 4: Run container
docker stop jenkins-docker 2>/dev/null || true
docker rm jenkins-docker 2>/dev/null || true

docker run -d \\
  --name jenkins-docker \\
  -u root \\
  -p 8080:8080 \\
  -v jenkins_home:/var/jenkins_home \\
  -v /var/run/docker.sock:/var/run/docker.sock \\
  jenkins-dockerized

echo "✅ Jenkins is running at: http://localhost:8080"
echo "🔑 Run to get admin password:"
echo "   docker exec -it jenkins-docker cat /var/jenkins_home/secrets/initialAdminPassword"
