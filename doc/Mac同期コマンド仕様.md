# Mac 同期コマンド仕様

## 概要

VS Code のユーザ settings.json と，このプロジェクトにある settings.json を同期するコマンド．

## 関係ファイル構成

```plaintext
. # Project Root
├── temporary # GitIgnore対象
└── UserSettings/
    ├── my-settings.jsonc # このリポジトリで Git 管理するファイル．区別のため頭に my- とつけている
    └── Backup/ # GitIgnore 対象
        ├── settings_yyyyMMdd-hhmmss.json
        └── ...
```

実際の VS Code のユーザ settings.json のパスは `~/Library/Application Support/Code/User/settings.json`

## 処理ステップ

1. 実行するとまずどちらからどちらへの同期かを聞く
2. VS Code の実際の設定 -> Git の方向が選択されたら，そのようにコピーする
 (Git で過去バージョンの履歴が管理されているので，バックアップ作成は不要)
3. Git -> VS Code の実際の設定の方向が選択された場合．
   1. まずバックアップを取得する．既存設定をそのままプロジェクトの
     `./UserSettings/Backup/` にコピーし，コピー後にファイル名を日時付きに変更する．
   2. `./UserSettings/my-settings.json` を実際の `settings.json` に上書きする．確認メッセージは不要．
   もし 1 行のコマンドで実現できない場合は，一度
   `./temporary` にコピーし，リネームし，それから本番上書きコピーを行う．
