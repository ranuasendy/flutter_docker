FROM ubuntu:22.04

ENV ANDROID_HOME /opt/android-sdk
ENV FLUTTER_HOME /opt/flutter
ENV PATH="$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

RUN apt-get update && apt-get install -y \
    curl unzip git openjdk-17-jdk wget libgl1-mesa-dev \
    && curl -O https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && mkdir -p $ANDROID_HOME/cmdline-tools \
    && unzip commandlinetools-linux-*.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses \
    && $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" "platforms;android-33" "build-tools;33.0.2"

RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && flutter doctor

WORKDIR /app
