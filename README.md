# 本プロジェクトの構成

```PlainText
.
├── ProjectSettings/ # プロジェクトで個別設定する場合のファイル．このフォルダの中身を直接プロジェクトルートに配置する
│   ├── .markdownlint.jsonc
│   ├── .textlintrc.json
│   └── .vscode/
│       ├── settings.json
│       └── markdown-preview-numbering.css
└── UserSettings/ # VS Code のマイユーザ設定
    ├── Backup/ # GitIgnore対象．コマンドでユーザ設定ファイルを差し替えたときのバックアップ
    │   ├── settings_yyyyMMdd-hhmmss.json
    │   └── ...
    ├── .markdownlint.jsonc # ユーザ設定用の markdownlint 設定ファイル
    └── my-settings.jsonc # VS Code ユーザ設定．区別がつきやすいようにファイル名に my- をつけて拡張子も jsonc に変えてある
```

## 各種ファイルの配置先

- ProjectSettings の中身：プロジェクトルート
- UserSettings の中身：ユーザ用 settings.json と同じフォルダ
    - Mac の場合は `~/Library/Application Support/Code/User/`
    - Windows の場合は `%APPDATA%\Code\User\`

# 拡張機能設定

## インストールするもの

- Japanese Language Package
- Git Graph
- Ascii Tree Generator
- Open in External App
- Python 系
- Markdown All in One
- markdownlint
- textlint ※ 前身である vscode-textlint はメンテされていないため NG

## 設定

### markdownlint

#### 設定値ファイルの準備

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

#### 設定値ファイルの書き方

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

#### ユーザ設定とプロジェクト設定が両方ある場合

ユーザの settings.json に .markdownlint.jsonc の指定があり，プロジェクト側にも .markdownlint.jsonc がある場合，
後者で **上書き** される．
重ねがけではなく上書きである点に注意せよ．
すなわち後者が空ファイルや `{ }` だけの空 JSON だったとしても，ファイルが存在する時点でユーザ設定は無視される．

### textlint

#### 環境準備

textlint は JavaScript だか TypeScript で作られているため，まず Node.js が必要．

```shell
node --version
npm --version
```

が通るように各自で環境構築する (Node.js を普通にインストールすればだいたい OK)

#### textlint モジュールインストール

##### 初めて実行する場合

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

##### package.json, package-lock.json が両方ある場合

以下のコマンドを実行：

```shell
npm ci
```

#### 設定ファイル

ルートディレクトリに `.textlintrc.json` を作成し，[このファイルの内容](./.textlintrc.json) を記述する．
なおこのファイルはコメントに対応しているので，**拡張子は `.json` のままでコメントを書いてよい**らしい．

#### 検知・修正を有効化する

ユーザまたはプロジェクトの settings.json に以下の設定を追記する：

```json
{
    // textlint の設定
    "textlint.run": "onType",
    "textlint.autoFixOnSave": true,
    "textlint.languages": [
        "markdown"
    ]
}
```

"textlint.autoFixOnSave" を true にしておくと，保存時に検出済みの箇所を修正してくれる．
また textlint.run の値を "onType" にしておくと，文字を打つたびに検知が走る．
そのため上記の組み合わせの場合，(めちゃくちゃ速く操作しない限りは) 1 回の上書き保存でフォーマットが終了する．

タイプするたびに検知されるのが困る場合は，"textlint.run" を "onSave" にするとよい．
こうすると検知はファイルを上書き保存したときにのみ実行される．
したがって 2 回上書き保存しないとフォーマットされない．

#### 設定ファイルやデフォルトモジュールの場所を変える方法

settings.json に以下を追記すれば別のフォルダを参照できる．
なお環境変数を使うとうまく処理されないことがあるので，ユーザフォルダを書くときも `~` ではなく `/Users/username/...` のように書くこと．
(これに関しては 1 回トライしてダメだったら直す，で良い気がする)

```json
    "textlint.nodePath": "./.textlint/node_modules",
    "textlint.configPath": "./.textlint/.textlintrc.json",
```

※プロジェクトルートからの相対パスなら，頭の `./` はなくても良いかも．
