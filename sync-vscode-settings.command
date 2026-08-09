#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_FILE="$HOME/Library/Application Support/Code/User/settings.json"
TARGET_FILE="$SCRIPT_DIR/UserSettings/settings.json"

cp -f "$SOURCE_FILE" "$TARGET_FILE"
echo "正常に完了しました"
