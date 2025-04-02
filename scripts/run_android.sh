#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Get all Android devices
DEVICES=$(flutter devices | grep -i "android" | awk '{print $(NF)}')

# Count devices
DEVICE_COUNT=$(echo "$DEVICES" | wc -l)

# If no device found
if [ "$DEVICE_COUNT" -eq 0 ]; then
  echo "${YELLOW}⚠️  No Android devices found.${RESET}"
  exit 1
fi

# If one device, auto-select
if [ "$DEVICE_COUNT" -eq 1 ]; then
  SELECTED_DEVICE="$DEVICES"
  echo "${GREEN}✅ Found 1 device: $SELECTED_DEVICE${RESET}"
else
  echo "${CYAN}📱 Multiple Android devices detected:${RESET}"
  INDEX=1
  IFS=$'\n'
  for DEVICE in $DEVICES; do
    echo "${YELLOW}  [$INDEX] $DEVICE${RESET}"
    INDEX=$((INDEX + 1))
  done

  read -p "👉 Choose a device [1-$DEVICE_COUNT]: " CHOICE
  SELECTED_DEVICE=$(echo "$DEVICES" | sed -n "${CHOICE}p")
fi

# Run Flutter app on selected device
echo "${CYAN}🚀 Running Flutter app on: $SELECTED_DEVICE${RESET}"
flutter run -d "$SELECTED_DEVICE"
