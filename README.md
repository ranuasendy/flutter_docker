# 🚀 Flutter Android Dev with Docker (Hybrid Setup)

This project simplifies your Flutter Android development by using Docker to manage the SDK/tooling — while letting your **host system handle emulators** for better performance.

---

## 🗉 Features

✅ Dockerized Flutter + Android SDK  
✅ Runs on macOS, Windows, or Linux  
✅ Uses host Android emulator (fast, hardware-accelerated)  
✅ Ready-to-use with VS Code Dev Containers  

---

## 📁 Project Structure

```
your_flutter_project/
├── .devcontainer/
│   └── devcontainer.json
├── app/                        # Your Flutter project files
├── docker/                     # Docker and devcontainer setup
│   ├── Dockerfile
│   └── docker-compose.yml
├── README.md
```

---

## ⚙️ Setup Instructions

### 1. Clone this Repo

```bash
git clone https://github.com/your-user/your-flutter-docker-project.git
cd your-flutter-docker-project
```

### 2. Create and Start Android Emulator (on host)

#### Install Android SDK Command Line Tools

1. Install Android Studio (or SDK separately)
2. Open terminal and run:

```bash
sdkmanager "platform-tools" "emulator" "system-images;android-33;google_apis;x86_64" "platforms;android-33"
```

#### Create AVD (Android Virtual Device)

```bash
avdmanager create avd -n flutter_avd -k "system-images;android-33;google_apis;x86_64" --device "pixel"
```

#### Start Emulator

```bash
emulator -avd flutter_avd
```

### 3. Expose ADB to Container

On the host (macOS/Windows/Linux):

```bash
adb kill-server
adb -a -P 5037 nodaemon server
```

### 4. Build and Run Docker

```bash
cd docker
docker-compose build
docker-compose up -d
```

Then connect ADB inside the container:

```bash
docker exec -it flutter_dev bash
adb connect host.docker.internal:5037
flutter devices
```

You should see your emulator or physical device.

---

## 💻 VS Code Dev Container (Optional)

Open this project folder in VS Code and install the **Dev Containers** extension. You’ll be prompted to “Reopen in Container” — it just works™.

---

## 📦 What's Inside

- Flutter SDK (stable)
- Android SDK (platform 33 + tools)
- OpenJDK 17
- Git, unzip, curl, etc.

---

## 🧼 Clean Up

To stop and remove the container:

```bash
cd docker
docker-compose down
```

---

## 📝 License

MIT
