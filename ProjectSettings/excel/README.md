# Excel の Git 管理について

## フォルダ構成

### 基本形 (単一ファイル構成の場合)

不要なフォルダは削除して良い

```PlainText
my-project/
└── excel/
    ├── my-file.xlsx (xlsm)
    ├── vba/
    │   ├── classes/            # クラスモジュール
    │   ├── forms/              # ユーザーフォーム
    │   ├── modules/            # 標準モジュール
    │   └── objects/            # ThisWorkbook, 各Sheet (.cls)
    ├── powerquery/             # Power Query
    └── dax/                    # DAXメジャー
```

### 複数ファイル構成の場合

ブックごとにフォルダを作成する．共通的な処理は common に格納しておく
(実際には別ブックのコード等を使用することはできないが，管理として共通のものとしておく)

```PlainText
my-project/
└── excel/
    ├── common/                     # 共通で使う資産
    │   ├── vba/
    │   │   └── modules/
    │   └── powerquery/
    ├── book_a/
    │   ├── my-file_a.xlsx (xlsm)
    │   ├── vba/
    │   │   ├── classes/
    │   │   ├── forms/
    │   │   ├── modules/
    │   │   └── objects/
    │   ├── powerquery/
    │   └── dax/
    └── book_b/
        ├── my-file_b.xlsx (xlsm)
        ├── vba/
        │   ├── classes/
        │   ├── forms/
        │   ├── modules/
        │   └── objects/
        ├── powerquery/
        └── dax/
```

## Power Query, DAX の保存形式

- Power Query はファイル名を `<query_name>.pq` として 1 ファイルで 1 クエリを保存する
- DAX メジャーは 1 式あたりが短いため，1 メジャーで 1 ファイルにするとファイル数が爆発してしまう．
  そこで **メジャーを定義するテーブルごとに** `<table_mname>.dax` というファイルをつくり，以下のように定義名付きで並べて保存する：

  ```DAX
  // --- 売上・損益メジャー ---
  [確定損益合計] := 
  SUM(Tbl_Executions_2026[確定損益])

  [累積リターン率] := 
  DIVIDE([確定損益合計], [投入総資本], 0)  
  ```

## VBA の保存形式の方針

VBA のコード部分はテキスト情報だが，エクスポートされたファイルは古い文字コードが使われていたり，またバイナリファイルが出てくる場合もある．
そこで何通りかのルールを提示する．

1. **コード等の編集は Excel VBE 側ですべて行い，Git には VBE 経由でエクスポートした物と，ファイル本体を登録する**\
   - VS Code 上では一切編集しない
   - 実際のコーディングに必要なシンタックスハイライトや入力補完，一括コメントアウトなどは VBE に任せる
   - Excel ファイル側を常に正とするので，VS Code と Excel 間でのデグレは (一応) 起きにくいと考えられる
   - AI (コーディングエージェント) にコードを読ませるのには難がある
2. **テキスト系は VS Code で閲覧・編集・保存しやすいように UTF-8 のテキストファイルで保管する**
   - VS Code で編集して Excel 側には手作業でコピーする．
     もしくは Excel でコードを書いて動作確認できたら VS Code 側に手作業でコードをコピーする
   - ファイルを UTF-8 で一貫して保存できる．`.gitattributes` への特別な設定も不要
   - コーディングエージェントに読み取らせるのが容易
   - 拡張子は `.vba` で統一する．これにより VBE へのインポートが直接できなくなり，また VS Code でシンタックスハイライトが使用できる
   - なおこの方針の中にも，ユーザフォームの扱いによって 2 通りの方針がある：
     1. **ユーザフォームに関してだけは VBE からエクスポートされる `.frm`, `.frx` をそのまま Git 管理する**
        - ユーザフォームのインポートを行うには `.frm`, `.frx` のペアが必要なので，エクスポート機能を使い両方を管理する
        - VS Code では編集しない
     2. **フォームの見た目はブック側で担保し，イベントコードのみ `.vba` で管理する**
        - バイナリである `.frx` は保存せず，フォームのレイアウト情報はブック本体にのみ残して管理する
        - フォームの裏側にあるイベントプロシージャコード (`.frx`) は `.vba` として保存する

> [!warning] クラスモジュールの属性ヘッダー
> VBEからエクスポートしたクラスモジュール (.cls) には，ファイルの先頭に以下のような属性ヘッダー (Attribute) が自動付与されている：
>
> ```vb
> VERSION 1.0 CLASS
> BEGIN
>   MultiUse = -1  'True
> END
> Attribute VB_Name = "Class1"
> Attribute VB_GlobalNameSpace = False
> Attribute VB_Creatable = False
> Attribute VB_PredeclaredId = False
> Attribute VB_Exposed = False 
> ```
>
> VBE の画面上にはこの Attribute 行は表示されない．標準的なクラスであれば気にする必要はないが，事前バインド
> (`VB_PredeclaredId = True`) など特殊な属性を使う場合は，ヘッダー行が落ちると挙動が変わるため管理に注意が必要である
