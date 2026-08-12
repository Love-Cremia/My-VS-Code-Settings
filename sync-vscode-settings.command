#!/bin/bash

# スクリプトのディレクトリ（プロジェクトルート）に移動
cd "$(dirname "$0")" || exit 1

# パスの定義
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
HOME_VSCODE="$HOME/VS-Code"
GIT_SETTINGS="./UserSettings/my-settings.jsonc"
GIT_HOME_VSCODE="./UserSettings/VS-Code"
BACKUP_DIR="./UserSettings/Backup"

echo "========================================="
echo "VS Code 設定同期スクリプト"
echo "========================================="
echo "同期方向を選択してください:"
echo "  1) VS Code の設定を Git に保存"
echo "  2) Git の設定を VS Code に反映"
echo ""
read -p "番号を入力 (1 または 2): " CHOICE

# 一時停止用の関数（Windows版のpauseに相当）
pause() {
    read -p "Press Enter to continue..."
}

if [ "$CHOICE" = "1" ]; then
    echo ""
    echo "[VS Code -> Git] の同期を開始します..."

    if [ ! -f "$VSCODE_SETTINGS" ]; then
        echo "[エラー] VS Codeの設定ファイルが見つかりません: $VSCODE_SETTINGS"
        pause
        exit 1
    fi

    echo "settings.json を my-settings.jsonc にコピーしています..."
    # UserSettingsディレクトリが存在しない場合は作成
    mkdir -p "$(dirname "$GIT_SETTINGS")"
    cp "$VSCODE_SETTINGS" "$GIT_SETTINGS"

    if [ -d "$HOME_VSCODE" ]; then
        echo "$HOME_VSCODE を $GIT_HOME_VSCODE にコピーしています..."
        # 既存フォルダを削除してからコピー（xcopy /e /y と同等のクリーンな上書き）
        rm -rf "$GIT_HOME_VSCODE"
        cp -R "$HOME_VSCODE" "$GIT_HOME_VSCODE"
    else
        echo "[情報] ホームディレクトリに VS-Code フォルダが存在しません。スキップします。"
    fi

    echo "同期が完了しました。"
    pause
    exit 0

elif [ "$CHOICE" = "2" ]; then
    echo ""
    echo "[Git -> VS Code] の同期を開始します..."

    if [ ! -f "$GIT_SETTINGS" ]; then
        echo "[エラー] Git管理下の設定ファイルが見つかりません: $GIT_SETTINGS"
        pause
        exit 1
    fi

    # タイムスタンプの取得 (yyyyMMdd-HHmmss)
    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

    # バックアップディレクトリの作成
    mkdir -p "$BACKUP_DIR"

    # 既存設定のバックアップ
    if [ -f "$VSCODE_SETTINGS" ]; then
        echo "settings.json のバックアップを作成しています..."
        cp "$VSCODE_SETTINGS" "$BACKUP_DIR/settings_${TIMESTAMP}.json"
    fi

    if [ -d "$HOME_VSCODE" ]; then
        echo "VS-Code フォルダのバックアップを作成しています..."
        cp -R "$HOME_VSCODE" "$BACKUP_DIR/VS-Code_${TIMESTAMP}"
    else
        echo "[情報] 既存の VS-Code フォルダは存在しないため、バックアップをスキップします。"
    fi

    # プロジェクトからVS Codeへ設定を反映
    mkdir -p "$(dirname "$VSCODE_SETTINGS")"
    echo "my-settings.jsonc を settings.json として上書きしています..."
    cp "$GIT_SETTINGS" "$VSCODE_SETTINGS"

    if [ -d "$GIT_HOME_VSCODE" ]; then
        echo "Gitの VS-Code フォルダをホームディレクトリに配置しています..."
        rm -rf "$HOME_VSCODE"
        cp -R "$GIT_HOME_VSCODE" "$HOME_VSCODE"
    fi

    echo "同期が完了しました。"
    pause
    exit 0

else
    echo "[エラー] 1 か 2 を入力してください。"
    pause
    exit 1
fi
