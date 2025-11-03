FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_SDK_VERSION=3.35.4-stable

# --------------------------
# Alap csomagok + 32-bit libs a Android SDK-hoz
# --------------------------
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      sudo git curl wget unzip zip xz-utils openjdk-17-jdk \
      libglu1-mesa libc6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
      libbz2-1.0 libstdc++6 libstdc++-10-dev \
      watchman && \
    rm -rf /var/lib/apt/lists/*

# --------------------------
# Non-root user létrehozása: ubuntu
# --------------------------
RUN usermod -l ubuntu root || true
USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu

# --------------------------
# Android SDK telepítése a home könyvtárba
# --------------------------
ENV ANDROID_SDK_ROOT=$HOME/Android/Sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -O commandlinetools.zip "https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" && \
    unzip commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm commandlinetools.zip

# Licenses és SDK csomagok telepítése (csak egyszer!)
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
      "platform-tools" \
      "platforms;android-35" \
      "build-tools;35.0.0" \
      "emulator" \
      "system-images;android-35;google_apis;x86_64"

# --------------------------
# Flutter telepítése a home könyvtárba + bashrc
# --------------------------
ENV FLUTTER_SDK_ROOT=$HOME/flutter
ENV PATH="${PATH}:${FLUTTER_SDK_ROOT}/bin"

RUN curl -OL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    tar -xf flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz -C $HOME/ && \
    rm flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    # Flutter PATH hozzáadása bashrc-hez
    echo 'export FLUTTER_SDK_ROOT=$HOME/flutter' >> $HOME/.bashrc && \
    echo 'export PATH=$PATH:$FLUTTER_SDK_ROOT/bin' >> $HOME/.bashrc

# --------------------------
# Disable analytics & flutter doctor
# --------------------------
RUN flutter --disable-analytics
RUN flutter doctor