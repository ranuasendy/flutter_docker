FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk \
    FLUTTER_HOME=/opt/flutter
ENV ANDROID_ADB_SERVER_PORT=5037
ENV ADB_VENDOR_KEYS=/root/.android/adbkey
ENV PATH="$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# ---------- 1. system deps ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl unzip git wget openjdk-17-jdk-headless libgl1-mesa-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# ---------- 2. Android command-line tools ------------------------------------
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    curl -fsSL -o /tmp/cmdline-tools.zip \
         https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept licenses & install platform packages
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-33" \
        "build-tools;33.0.2"

# ---------- 3. Flutter --------------------------------------------------------
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME} && \
    flutter doctor -v

WORKDIR /app
