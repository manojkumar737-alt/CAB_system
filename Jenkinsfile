pipeline {
  agent any

  environment {
    IMAGE_NAME = "cab_system_app"
    CONTAINER_NAME = "cab_system_container"
    PORT = "8080" // Change if needed
  }

  stages {
    stage('Clone') {
      steps {
        git url: 'https://github.com/manojkumar737-alt/CAB_system.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ."
      }
    }
    stage('Debug') {
  steps {
    sh 'which docker || echo "Docker not found"'
    sh 'docker --version || echo "Docker CLI not available"'
    sh 'ls -l || echo "Listing files failed"'
  }
}
    stage('Run Docker Container') {
      steps {
        // Stop and remove old container if it's running
        sh """
          docker stop ${CONTAINER_NAME} || true
          docker rm ${CONTAINER_NAME} || true
        """

        // Run new container
        sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}"
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful. Container running on port ${PORT}"
    }
    failure {
      echo "❌ Something went wrong during build or deployment."
    }
  }
}
