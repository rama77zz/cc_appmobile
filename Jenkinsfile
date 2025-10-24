<<<<<<< HEAD
pipeline {
    agent any

    environment {
        IMAGE_NAME = "android_builder"
        CONTAINER_NAME = "android-builder1"
        JENKINS_CONTAINER = "jenkinss"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Checkout source code dari repo kamu..."
                git branch: 'main', url: 'https://github.com/rama77zz/cc_appmobile.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo "🏗️ Build Docker images menggunakan docker-compose..."
                bat 'docker-compose build'
            }
        }

        stage('Run Docker Containers') {
            steps {
                echo "🚀 Jalankan ulang container Jenkins dan Android Builder..."
                bat '''
                echo ==== HENTIKAN CONTAINER LAMA ====
                docker stop jenkins || echo "jenkins tidak berjalan"
                docker rm jenkins || echo "jenkins sudah dihapus"
                docker stop android-builder || echo "android-builder tidak berjalan"
                docker rm android-builder || echo "android-builder sudah dihapus"

                echo ==== JALANKAN ULANG DOCKER COMPOSE ====
                docker-compose down || exit 0
                docker-compose up -d

                echo ==== CEK CONTAINER YANG AKTIF ====
                docker ps
                '''
            }
        }

        stage('Verify Builder Container Running') {
            steps {
                echo "🔍 Verifikasi container builder Android berjalan dengan benar..."
                bat '''
                echo ==== TUNGGU 20 DETIK SUPAYA CONTAINER SIAP ====
                ping 127.0.0.1 -n 20 >nul

                echo ==== CEK STATUS CONTAINER BUILDER ====
                docker ps --filter "name=android-builder"

                echo ==== CEK LOG BUILD JIKA PERLU ====
                docker logs android-builder --tail 20
                '''
            }
        }

        stage('Build Android App') {
            steps {
                echo "⚙️ Menjalankan build Gradle di dalam container android-builder..."
                bat '''
                docker exec android-builder bash -c "./gradlew clean build || ./gradlew assembleDebug"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Android App berhasil dibuild menggunakan Docker Compose!'
        }
        failure {
            echo '❌ Build gagal, cek log Jenkins console output.'
        }
    }

}
