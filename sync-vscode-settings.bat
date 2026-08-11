@echo off
setlocal enabledelayedexpansion

:: スクリプトのディレクトリ（プロジェクトルート）に移動
cd /d "%~dp0"

:: パスの定義
set "VSCODE_SETTINGS=%APPDATA%\Code\User\settings.json"
set "HOME_VSCODE=%USERPROFILE%\VS-Code"
set "GIT_SETTINGS=.\UserSettings\my-settings.jsonc"
set "GIT_HOME_VSCODE=.\UserSettings\VS-Code"
set "BACKUP_DIR=.\UserSettings\Backup"

echo =========================================
echo VS Code 設定同期スクリプト
echo =========================================
echo 同期方向を選択してください:
echo   1) VS Code の設定を Git に保存
echo   2) Git の設定を VS Code に反映
echo.
set /p CHOICE="番号を入力 (1 または 2): "

if "%CHOICE%"=="1" goto :VscodeToGit
if "%CHOICE%"=="2" goto :GitToVscode

echo [エラー] 1 か 2 を入力してください。
pause
exit /b 1


:VscodeToGit
echo.
echo [VS Code -^> Git] の同期を開始します...

if not exist "%VSCODE_SETTINGS%" (
    echo [エラー] VS Codeの設定ファイルが見つかりません: %VSCODE_SETTINGS%
    pause
    exit /b 1
)

echo settings.json を my-settings.jsonc にコピーしています...
copy /y "%VSCODE_SETTINGS%" "%GIT_SETTINGS%" >nul

if exist "%HOME_VSCODE%" (
    echo %HOME_VSCODE% を %GIT_HOME_VSCODE% にコピーしています...
    xcopy /y /e /i "%HOME_VSCODE%" "%GIT_HOME_VSCODE%" >nul
) else (
    echo [情報] ホームディレクトリに VS-Code フォルダが存在しません。スキップします。
)

echo 同期が完了しました。
pause
exit /b 0


:GitToVscode
echo.
echo [Git -^> VS Code] の同期を開始します...

if not exist "%GIT_SETTINGS%" (
    echo [エラー] Git管理下の設定ファイルが見つかりません: %GIT_SETTINGS%
    pause
    exit /b 1
)

:: タイムスタンプの取得 (yyyyMMdd-HHmmss)
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd-HHmmss'"') do set TIMESTAMP=%%i

:: バックアップディレクトリの作成
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: 既存設定のバックアップ
if exist "%VSCODE_SETTINGS%" (
    echo settings.json のバックアップを作成しています...
    copy /y "%VSCODE_SETTINGS%" "%BACKUP_DIR%\settings_!TIMESTAMP!.json" >nul
)

if exist "%HOME_VSCODE%" (
    echo VS-Code フォルダのバックアップを作成しています...
    xcopy /y /e /i "%HOME_VSCODE%" "%BACKUP_DIR%\VS-Code_!TIMESTAMP!" >nul
) else (
    echo [情報] 既存の VS-Code フォルダは存在しないため、バックアップをスキップします。
)

:: プロジェクトからVS Codeへ設定を反映
if not exist "%APPDATA%\Code\User" mkdir "%APPDATA%\Code\User"
echo my-settings.jsonc を settings.json として上書きしています...
copy /y "%GIT_SETTINGS%" "%VSCODE_SETTINGS%" >nul

if exist "%GIT_HOME_VSCODE%" (
    echo Gitの VS-Code フォルダをホームディレクトリに配置しています...
    xcopy /y /e /i "%GIT_HOME_VSCODE%" "%HOME_VSCODE%" >nul
)

echo 同期が完了しました。
pause
exit /b 0
