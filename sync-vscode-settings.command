#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
PROJECT_DIR="$SCRIPT_DIR/UserSettings"
BACKUP_DIR="$PROJECT_DIR/Backup"

mkdir -p "$BACKUP_DIR"

if [ -f "$PROJECT_DIR/my-settings.jsonc" ]; then
  PROJECT_SETTINGS="$PROJECT_DIR/my-settings.jsonc"
elif [ -f "$PROJECT_DIR/my-settings.json" ]; then
  PROJECT_SETTINGS="$PROJECT_DIR/my-settings.json"
else
  PROJECT_SETTINGS="$PROJECT_DIR/my-settings.jsonc"
fi

printf '同期方向を選択してください:\n1: VS Code -> Git\n2: Git -> VS Code\n'
read -r choice

case "$choice" in
  1)
    cp -f "$VSCODE_SETTINGS" "$PROJECT_SETTINGS"
    ;;
  2)
    timestamp="$(date '+%Y%m%d-%H%M%S')"
    backup_file="$BACKUP_DIR/settings_${timestamp}.json"
    cp -f "$VSCODE_SETTINGS" "$backup_file"
    cp -f "$PROJECT_SETTINGS" "$VSCODE_SETTINGS"
    ;;
  *)
    echo "無効な選択です" >&2
    exit 1
    ;;
esac

echo "正常に完了しました"
