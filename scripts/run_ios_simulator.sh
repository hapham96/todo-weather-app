#!/bin/bash

# 🌈 Color settings
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${CYAN}🚀 Flutter iOS Simulator Launcher${RESET}"

# 🧼 Check if --clean flag is used
if [[ "$1" == "--clean" ]]; then
  echo -e "${YELLOW}🧹 Cleaning Flutter project...${RESET}"
  flutter clean
else
  echo -e "${YELLOW}⚡ Skipping flutter clean for faster startup (use --clean to enable cleaning)${RESET}"
fi

# 📦 Get dependencies
echo -e "${YELLOW}📦 Fetching Flutter packages...${RESET}"
flutter pub get

# 📱 Launch iOS Simulator app
open -a Simulator

# 📋 Get list of available iPhone simulators
IPHONE_DEVICES=($(flutter devices | grep -i "iphone" | awk -F '•' '{print $2}' | awk '{$1=$1};1'))
NUM_DEVICES=${#IPHONE_DEVICES[@]}

# ❌ No devices found
if [ $NUM_DEVICES -eq 0 ]; then
  echo -e "${RED}❌ No iPhone simulators detected.${RESET}"
  exit 1
fi

# ✅ One device found – auto-select
if [ $NUM_DEVICES -eq 1 ]; then
  DEVICE_ID=${IPHONE_DEVICES[0]}
  echo -e "${GREEN}✅ Automatically selected device: $DEVICE_ID${RESET}"

# 🔘 Multiple devices – show selection menu
else
  echo -e "${CYAN}📱 Multiple iPhone simulators detected. Please select one:${RESET}"
  flutter devices | grep -i "iphone" | nl -w2 -s'. '

  echo ""
  read -p "$(echo -e "${YELLOW}Enter the number of the device: ${RESET}")" CHOICE

  if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$NUM_DEVICES" ]; then
    echo -e "${RED}❌ Invalid selection.${RESET}"
    exit 1
  fi

  DEVICE_ID=${IPHONE_DEVICES[$((CHOICE-1))]}
  echo -e "${GREEN}✅ Selected device: $DEVICE_ID${RESET}"
fi

# 🚀 Run the Flutter app
echo -e "${CYAN}🚀 Launching Flutter app on device: $DEVICE_ID${RESET}"
flutter run -d "$DEVICE_ID"
