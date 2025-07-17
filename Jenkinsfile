pipeline {
    agent any
    environment {
        GITHUB_CREDENTIALS = credentials('github-token')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = 'manojkumar737/cab_system_app'
        IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: 'https://github.com/manojkumar737-alt/CAB_system.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_TAG} ."
            }
        }
        stage('Login to DockerHub') {
            steps {
                sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
            }
        }
        stage('Push Image') {
            steps {
                sh "docker push ${IMAGE_TAG}"
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
