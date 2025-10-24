pipeline {
    agent any

    environment {
        IMAGE_NAME = "simpleapp-android"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using host docker (requires docker.sock bound to jenkins)
                    docker.build("${IMAGE_NAME}")
                }
            }
        }

        stage('Run Build in Container') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}").inside('-v $WORKSPACE:/workspace') {
                        sh './gradlew assembleDebug --no-daemon'
                    }
                }
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "Build succeeded, APK archived."
        }
        failure {
            echo "Build failed."
        }
    }
}
