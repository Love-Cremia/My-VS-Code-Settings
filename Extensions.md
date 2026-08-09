
# インストールするもの

- Japanese Language Package
- Git Graph
- Ascii Tree Generator
- Open in External App
- Python系
- Markdown All in One
- textlint ※ 前身である vscode-textlint はメンテされていないためNG
- markdownlint

# 設定

## markdownlint

### 設定値ファイルの準備

- `./.vscode/` に `.markdownlint.jsonc` を作成する
  (yaml, json, jsonc に対応している．コメントしたいので jsonc)
- プロジェクトの settings.json に以下を記述する：

    ```json
    {
        "markdownlint.configFile": ".vscode/.markdownlint.jsonc"
    }
    ```

- ユーザ設定で全プロジェクト共通の設定をしたいときは，以下のようにする：
    1. どこかに`.markdownlint.jsonc` を置く．
    場所の例としては `~` またはユーザ用 Settings.json と同じ `~/Library/Application Support/Code/User/`
    2. ユーザ Settings.json に上記ファイルのパスを指定する．

        ```json
        {
            "markdownlint.configFile": "~/Library/Application Support/Code/User/.markdownlint.json"
        }
        ```

### 設定値ファイルの書き方

基本的には注意や警告が出たらそのルールを調べて値を変えたり無効にしたり．

```json
{
    // インデントの数
    "MD007": {
        "indent": 4
    },

    // h1 を1つしか認めない
    "MD025": false
}
```
