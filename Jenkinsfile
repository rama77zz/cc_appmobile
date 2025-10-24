pipeline {
    agent any

    environment {
        // Nama container builder sesuai docker-compose
        BUILDER_CONTAINER = 'android-builder'
        // Nama image untuk hasil build
        DOCKER_IMAGE = 'jenkins/jenkins:lts'   // Ganti dengan username Docker Hub kamu
        // Kredensial Docker (harus sudah diset di Jenkins Credentials)
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                echo '📥 Checking out source code...'
                git branch: 'main', url: 'https://github.com/rama77zz/cc_appmobile.git'
                checkout scm
            }
        }

        stage('Build Kotlin Project (in Builder Container)') {
            steps {
                echo '🏗️ Building Kotlin project in container...'
                // Jalankan Gradle di dalam container android-builder
                sh '''
                    docker exec ${BUILDER_CONTAINER} bash -c "
                        cd /workspace &&
                        ./gradlew clean build
                    "
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image for Kotlin app...'
                sh '''
                    docker build -t ${DOCKER_IMAGE} .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo '🚀 Pushing image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }

    post {
        always {
            echo '📦 Pipeline finished (success or fail). Cleaning up workspace...'
            sh 'docker system prune -f || true'
        }
        success {
            echo '✅ Build and deployment successful!'
        }
        failure {
            echo '❌ Build or deployment failed. Please check logs.'
        }
    }
}
