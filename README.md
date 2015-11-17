# gulp ect SAMPLE

アップデートしました。

* gulpタスクの分離

* 開発用ディレクトリと納品用ディレクトリを分離

* bower導入


## 下準備
gulpを動かすために必要（便利）なツールをインストール

### node.js
<a href="https://nodejs.org/" target="blank">node.js</a>

INSTALLボタンをクリックし、手順に沿ってインストール

コマンドラインから
``` console
$ node -v
```
nodeのバージョンが表示されればインストールは完了

### gulp本体
コマンドラインから
```console
$ sudo npm install -g gulp
```

### gulper
[gulper](http://blog.anatoo.jp/entry/2015/02/01/155545)を使用すると、gulpfile保存時に自動的にgulpを再起動してくれるので楽チンです
```console
$ sudo npm install -g gulper
```

インストール後、
```console
$ gulp <task-name>
```
だったものを
```console
$ gulper <task-name>
```
とコマンド入力を少し変更するだけです。


### coffeeも必要かも


## 概要

### ディレクトリ構成

- gulp_ect
    - app
      + develop # 開発
      + product # 納品
      + src # ソース
    - bower_components
      + ※省略
    - gulp
      - tasks # タスク毎にファイルを分割
        * browser.coffee
        * build.coffee
        * coffee.coffee
        * copy.coffee
        * default.coffee
        * ect.coffee
        * sass.coffee
        * watch.coffee
      * config.coffee
    - node_modules
      + ※省略




































<!--
## 環境構築
任意のディレクトリ階層へクローンしてください

### npmプラグインのインストール
```console
$ sudo npm install
```

node_modulesというディレクトリ内にpackage.json内で指定されたプラグイン群がインストールされます

コマンドラインで
```console
$ gulper
```

を叩けばgulpが走り始めます。

### bower_componentsのインストール





## 各種設定・データ管理
ディレクトリ名やminifyの有無等、各種セッティングやページ構成のデータはdata/init.yamlで管理しています。
```yaml
settings:
  directory:
    names: # ディレクトリ名設定
      application: app
      source:      src
      develop:     develop
      destination: product
      sass:        sass
      css:         css
      coffee:      coffee
      js:          js
      img:         images
      temp:        templates
      content:     content
  javascript:
    useMinify: true
    original: # 独自ファイル設定
      files: # dest連結後に削除するオリジナルファイル
        - jquery.transit
        - script
      name: vendor # dest連結後のファイル名
    libraries: # bowerで取得したライブラリ設定
      name: libs # dest連結後のファイル名
  css:
    useMinify: true
```



### ectの概要
init.yamlのデータをgulpfileが取得してectに渡し、htmlに吐き出す仕組みです

### データファイルの追加
例えばコンテンツページのデータを持つファイルを作成する場合、src/data/contents.yaml等の名前でファイルを作成し、gulpfile.coffeeにて
```coffee
data_contents = YAML.safeLoad fs.readFileSync "#{dir.src}"+'/data/contents.yaml', 'utf8'
```
と記述すればcontents.yamlが使えるようになります。

### データのセット
gulpfileにて、各ectファイルへ渡すデータを指定します。
```coffee
for page, detail of data_init.pages
  switch page
    when 'root'
      for file in detail.files
        gulp.src "#{dir.src}"+'/'+"#{dir.temp}"+'/content/'+file.name+'.ect'
            .pipe ect({
              options:
                root: "#{dir.src}"+'/'+"#{dir.temp}"
                ext:  '.ect'
              data: # ここ
                name: file.name
                title: file.title
                class: file.class
                root: true
                init: data_init
            })
            .pipe gulp.dest "#{dir.dest}"
            .pipe browser.reload({ stream: true })
```
上記の例ではinit.yamlのpages配列をまわして、keyがrootだった場合はvalueのfilesという配列を中でまわしています  
個別のfileが持つ「name, title, class」のデータをセットし、さらにrootにはtrueの値を渡しています  
initにdata_initを渡す事で、ectファイル上でinit.yaml全体へのアクセスもできるようになっています

## ECT
gulp、ect、yamlの連携により、様々なテンプレートパターンの作成が可能です  
大量のhtmlファイルの複製や、わずか一箇所の修正のために全てのファイルを直さなければならない等の無駄なコストが省けます

### データの呼び出し
上記**データのセット**で指定したデータは@を使って呼び出します

init.yamlに
```yaml
pages:
  root:
    files:
      - name: index
        title: トップ
        class: home
      - name: ex
        title: example
        class: example
```
というデータがあった場合
```ect
<p><%= @title %></p>
```
index.htmlを吐く時は
```html
<p>トップ</p>
```
ex.htmlを吐く時は
```html
<p>example</p>
```
とコンパイルされます


### シンタックス
ectはcoffeescriptのシンタックスに準拠します

#### エスケープなしの出力
```ect
<%- someVar %>
```

#### エスケープありの出力
```ect
<%= someVar %>
```

#### パーシャル
```ect
<% include 'partials/gnav.ect' %>
```

#### 継承
```ect
<% extend 'layout/layout.ect' %>
```
呼び出し
```ect
<% content %>
```

#### ブロック
```ect
<% block 'blockName' %>
  <p>This is block content</p>
<% end %>
```
呼び出し
```ect
<% content 'blockName' %>
```






#### ループ
coffeescriptのループ記法

##### 配列
```coffee
for hoge in hoges
  console.log hoge
```

##### 連想配列
```coffee
for key, val of hoges
  console.log key
  console.log val
```

例えばgulpfileのデータを指定する箇所で
```coffee
data:
  words: [hoge, fuga, piyo]
```
と配列がセットされている場合
```ect
<div>
  <% for word in @words : %>
    <p><%= word %></p>
  <% end %>
</div>
```
で
```html
<div>
  <p>hoge</p>
  <p>fuga</p>
  <p>piyo</p>
</div>
```
となります

#### 条件分岐

##### if文
```ect
<% if @class isnt 'home' : %>
  <p>下層ページです</p>
<% end %>
```
-->
