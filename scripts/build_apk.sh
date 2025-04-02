#!/bin/bash

set -e

# Terminal colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${CYAN}🔍 Reading version from pubspec.yaml...${RESET}"

# Extract version (e.g., 1.0.0)
VERSION_LINE=$(grep '^version:' pubspec.yaml || true)

if [ -z "$VERSION_LINE" ]; then
  echo -e "${RED}❌ 'version:' not found in pubspec.yaml${RESET}"
  exit 1
fi

VERSION=$(echo "$VERSION_LINE" | awk '{print $2}' | cut -d+ -f1)
echo -e "${GREEN}📦 App version: $VERSION${RESET}"

# Timestamp in numeric format: YYYYMMDDHHMM
TIMESTAMP=$(date "+%Y%m%d%H%M")

# Build APK
echo -e "${YELLOW}🛠️  Building Flutter release APK...${RESET}"
flutter build apk --release

# Define paths
ORIGINAL_APK="build/app/outputs/flutter-apk/app-release.apk"
OUTPUT_DIR="build/releases"
OUTPUT_APK="$OUTPUT_DIR/todoapp-$VERSION-$TIMESTAMP.apk"

mkdir -p "$OUTPUT_DIR"

# Rename output
if [ -f "$ORIGINAL_APK" ]; then
  cp "$ORIGINAL_APK" "$OUTPUT_APK"
  echo -e "${GREEN}✅ APK exported: $OUTPUT_APK${RESET}"

  # Open folder (macOS Finder)
  echo -e "${CYAN}📂 Opening output folder...${RESET}"
  open "$OUTPUT_DIR"
else
  echo -e "${RED}❌ APK not found after build${RESET}"
  exit 1
fi
