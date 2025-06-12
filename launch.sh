#!/bin/sh

# launch.sh
# One-shot helper to boot an Android AVD, start ADB in TCP mode,
# build & run the Docker dev stack, then connect the container to ADB.

set -euo pipefail

# ────────────────────────────────────────────────────────────────
# CONFIG – change these if you renamed things
# ────────────────────────────────────────────────────────────────
AVD_NAME="flutter_arm_avd"     # your ARM64 AVD’s name
CONTAINER_NAME="flutter_dev"   # matches docker-compose.yml
DOCKER_DIR="$(dirname "$0")/docker"   # path to docker files

# ────────────────────────────────────────────────────────────────
# 1. Start the emulator (only if it’s not already running)
# ────────────────────────────────────────────────────────────────
if ! pgrep -f "emulator.*${AVD_NAME}" >/dev/null; then
  echo "▶️  Launching AVD ${AVD_NAME} …"
  nohup emulator -avd "${AVD_NAME}" -netdelay none -netspeed full \
        >/dev/null 2>&1 &
  
  echo "⏳  Waiting for Android to be available via ADB …"
  adb wait-for-device

  echo "⏳  Waiting for Android to finish booting …"
  boot_completed=""

  until [[ "$boot_completed" == "1" ]]; do
    boot_completed="$(adb -e shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')"
    sleep 2
  done
  
  echo "✅  Emulator is up!"
else
  echo "✅  AVD ${AVD_NAME} is already running."
fi

# ────────────────────────────────────────────────────────────────
# 2. Restart ADB so it listens on TCP 5037
# ────────────────────────────────────────────────────────────────
echo "🔄  Restarting ADB on tcp:5037 …"
adb kill-server
adb start-server
adb -a -P 5037 nodaemon server >/dev/null 2>&1 &
sleep 2   # give it a moment to come up

# ────────────────────────────────────────────────────────────────
# 3. Build and start Docker stack
# ────────────────────────────────────────────────────────────────
echo "🐳  Building Docker image …"
pushd "${DOCKER_DIR}" >/dev/null
docker compose down
docker compose build
echo "🚀  Starting Docker services …"
docker compose up -d
popd >/dev/null

# ────────────────────────────────────────────────────────────────
# 4. Connect the container’s ADB client to the host ADB server
# ────────────────────────────────────────────────────────────────
echo "🔗  Connecting container to host ADB …"
docker exec "${CONTAINER_NAME}" bash -c "export ADB_VENDOR_KEYS=/root/.android/adbkey && adb kill-server && adb connect host.docker.internal:5037 && adb devices"
docker exec -it flutter_dev bash -c "
  adb kill-server
  adb connect host.docker.internal:5037
  adb devices
"

echo "📱  Attached devices from inside container:"
docker exec "${CONTAINER_NAME}" flutter devices || true

echo -e "\n🎉  Dev environment is ready!"
