pipeline {
    agent any

    environment {
        // 🔧 Ganti sesuai akun Docker Hub kamu
        DOCKER_IMAGE = "username/simpleapp"
        DOCKER_TAG = "latest"
        REGISTRY_CREDENTIALS = "dockerhub-credentials"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out source code...'
                checkout scm
            }
        }

        stage('Build Kotlin Project (in Builder Container)') {
            steps {
                echo '⚙️ Building Kotlin app inside builder container...'
                sh '''
                docker exec android-builder bash -c "
                    cd /workspace &&
                    ./gradlew clean assembleDebug
                "
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo '🐳 Building Docker image...'
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    echo '🚀 Pushing image to Docker Hub...'
                    docker.withRegistry('https://index.docker.io/v1/', "${REGISTRY_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build & Push Completed Successfully!"
        }
        failure {
            echo "❌ Build Failed! Check logs above."
        }
    }
}
