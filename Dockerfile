# Gunakan base image dengan JDK
FROM openjdk:17-jdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip bash && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

# Download Android SDK Command-line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d . && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip

# Install platform tools dan build tools menggunakan sdkmanager
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"

# Tentukan direktori kerja
WORKDIR /workspace

# Copy seluruh project ke dalam container
COPY . .

# Beri izin eksekusi pada gradlew
RUN chmod +x gradlew

# Jalankan build untuk memastikan dependensi diunduh
RUN ./gradlew clean build || true

# Command default: tetap hidup (untuk diakses Jenkins)
CMD ["tail", "-f", "/dev/null"]
