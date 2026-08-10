@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "PROJECT_DIR=%SCRIPT_DIR%\UserSettings"
set "BACKUP_DIR=%PROJECT_DIR%\Backup"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>&1

set "PROJECT_SETTINGS=%PROJECT_DIR%\my-settings.jsonc"
if not exist "%PROJECT_SETTINGS%" set "PROJECT_SETTINGS=%PROJECT_DIR%\my-settings.json"
if not exist "%PROJECT_SETTINGS%" (
  echo Git 側の設定ファイルが見つかりません: %PROJECT_DIR%\my-settings.jsonc >&2
  exit /b 1
)

set "VSCODE_SETTINGS=%APPDATA%\Code\User\settings.json"
if not exist "%VSCODE_SETTINGS%" set "VSCODE_SETTINGS=%USERPROFILE%\AppData\Roaming\Code\User\settings.json"
if not exist "%VSCODE_SETTINGS%" (
  echo VS Code の設定ファイルが見つかりません。VS Code を起動してから再実行してください。 >&2
  exit /b 1
)

echo.
echo 同期方向を選択してください:
echo   1) VS Code の設定を Git に保存
echo   2) Git の設定を VS Code に反映
echo.
set /p "choice=番号を入力してください (1 または 2): "

if /I "%choice%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$src = '%VSCODE_SETTINGS%'; $dst = '%PROJECT_SETTINGS%'; New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null; Copy-Item -LiteralPath $src -Destination $dst -Force; Write-Output '正常に完了しました'"
) else if /I "%choice%"=="2" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$src = '%VSCODE_SETTINGS%'; $proj = '%PROJECT_SETTINGS%'; $backupDir = '%BACKUP_DIR%'; $timestamp = [DateTime]::Now.ToString('yyyyMMdd-HHmmss'); $backup = Join-Path $backupDir ('settings_' + $timestamp + '.json'); New-Item -ItemType Directory -Path $backupDir -Force | Out-Null; Copy-Item -LiteralPath $src -Destination $backup -Force; Copy-Item -LiteralPath $proj -Destination $src -Force; Write-Output '正常に完了しました'"
) else (
  echo 無効な選択です >&2
  exit /b 1
)

endlocal
