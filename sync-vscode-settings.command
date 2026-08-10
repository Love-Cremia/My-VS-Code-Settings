#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
VSCODE_MARKDOWNLINT="$HOME/Library/Application Support/Code/User/.markdownlint.jsonc"
PROJECT_DIR="$SCRIPT_DIR/UserSettings"
BACKUP_DIR="$PROJECT_DIR/Backup"

mkdir -p "$BACKUP_DIR"

PROJECT_SETTINGS="$PROJECT_DIR/my-settings.jsonc"

PROJECT_MARKDOWNLINT="$PROJECT_DIR/.markdownlint.jsonc"

printf '同期方向を選択してください:\n1: VS Code -> Git\n2: Git -> VS Code\n'
read -r choice

case "$choice" in
  1)
    cp -f "$VSCODE_SETTINGS" "$PROJECT_SETTINGS"
    if [ -f "$VSCODE_MARKDOWNLINT" ]; then
      cp -f "$VSCODE_MARKDOWNLINT" "$PROJECT_MARKDOWNLINT"
    fi
    ;;
  2)
    timestamp="$(date '+%Y%m%d-%H%M%S')"
    backup_settings="$BACKUP_DIR/settings_${timestamp}.json"
    backup_markdownlint="$BACKUP_DIR/markdownlint_${timestamp}.jsonc"

    cp -f "$VSCODE_SETTINGS" "$backup_settings"
    if [ -f "$VSCODE_MARKDOWNLINT" ]; then
      cp -f "$VSCODE_MARKDOWNLINT" "$backup_markdownlint"
    fi

    cp -f "$PROJECT_SETTINGS" "$VSCODE_SETTINGS"
    if [ -f "$PROJECT_MARKDOWNLINT" ]; then
      cp -f "$PROJECT_MARKDOWNLINT" "$VSCODE_MARKDOWNLINT"
    fi
    ;;
  *)
    echo "無効な選択です" >&2
    exit 1
    ;;
esac

echo "正常に完了しました"
