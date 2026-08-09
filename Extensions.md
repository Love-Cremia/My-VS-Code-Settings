
# インストールするもの

- Japanese Language Package
- Git Graph
- Ascii Tree Generator
- Open in External App
- Python 系
- Markdown All in One
- markdownlint
- textlint ※ 前身である vscode-textlint はメンテされていないため NG

# 設定

## markdownlint

### 設定値ファイルの準備

- プロジェクトルートに `.markdownlint.jsonc` を作成する
  (yaml, json, jsonc に対応している．コメントしたいので jsonc を使おう)

- ユーザ設定で全プロジェクト共通の設定をしたいときは，以下のようにする：
    1. どこかに `.markdownlint.jsonc` を置く．
    場所の例としては `~` またはユーザ用 Settings.json と同じ `~/Library/Application Support/Code/User/`
    2. ユーザ Settings.json に上記ファイルのパスを指定する．

        ```json
        {
            "markdownlint.configFile": "~/Library/Application Support/Code/User/.markdownlint.json"
        }
        ```

- プロジェクト用の markdownlint の設定ファイルをプロジェクトルート以外に置きたい場合，プロジェクトの settings.json に以下を記述すれば対応できる：

    ```json
    {
        "markdownlint.configFile": ".vscode/.markdownlint.jsonc"
    }
    ```

    ただしこれは非推奨．
    ツール側の標準仕様 (Convention over Configuration) に従い，プロジェクトルートに置くほうが好ましい．

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

## textlint

### 環境準備

textlint は JavaScript だか TypeScript で作られているため，まず Node.js が必要．

```shell
node --version
npm --version
```

が通るように各自で環境構築する (Node.js を普通にインストールすればだいたい OK)

### textlint モジュールインストール

#### 初めて実行する場合

package.json, package-lock.json がない場合が該当する．

まずプロジェクトルートで以下のコマンドを実行する：

```shell
npm init -y
npm install --save-dev textlint textlint-rule-preset-ja-spacing
```

以下のファイル，フォルダが生成される．

- package.json
- package-lock.json
- node_modules/

このうち，**node_modules は非常に膨大になるので必ず gitignore の対象にすること**．
一方 package, package-lock は複数の PC で環境を揃えるのに必要であるから，原則 Git でコミットすること．

#### package-lock.json がある場合

以下のコマンドを実行：

```shell
npm ci
```

### 設定ファイル

ルートディレクトリに `.textlintrc.json` を作成し，以下を記述する．
なおこのファイルはコメントに対応しているので，**拡張子は `.json` のままでコメントを書いてよい**らしい．

```json
{
    "rules": {
        "preset-ja-spacing": {
            "ja-space-between-half-and-full-width": {
                "space": "always"
            },
            "ja-no-space-around-parentheses": true,
            "ja-space-around-code": {
                "before": true,
                "after": true
            }
        }
    }
}
```

### 設定ファイルやデフォルトモジュールの場所を変える方法

settings.json に以下を追記すれば別のフォルダを参照できる．
なお環境変数を使うとうまく処理されないことがあるので，ユーザフォルダを書くときも `~` ではなく `/Users/username/...` のように書くこと．
(これに関しては 1 回トライしてダメだったら直す，で良い気がする)

```json
    "textlint.nodePath": "./.textlint/node_modules",
    "textlint.configPath": "./.textlint/.textlintrc.json",
```

※プロジェクトルートからの相対パスなら，頭の `./` はなくても良いかも．
