# gulp_ect SAMPLE
* Gruntfileよりもgulpfileの方が記述が簡単で直感的

* Gruntより高速

* gulpfile保存後の再起動がめんどいのでgulperを使用すると楽

* mac環境ですすめます

## 下準備
gulpを動かすために必要（便利）なツールをインストールします

### node.js

<a href="https://nodejs.org/" target="blank">node.js</a>

INSTALLボタンをクリックし、手順に沿ってインストール

コマンドラインから
``` console
$ node -v
```
nodeのバージョンが表示されればインストールは完了しています

### gulp本体
コマンドラインから
```console
$ sudo npm install -g gulp
```

### gulper
```console
$ sudo npm install -g gulper
```

gulpfileを編集した際、その編集を適用させるためにはgulpの再起動（コマンドラインから[ctrl+c]→起動）が必要ですが、gulperをインストールする事で、gulpの再起動を自動で行ってくれます。

起動コマンドは
```console
$ gulp <task-name>
```
↓
```console
$ gulper <task-name>
```
となります。

<a href="https://www.npmjs.com/package/gulper" target="blank">参照</a>

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

## 開発
開発用のディレクトリはsrcです  
src内の各ファイルを編集すると、各ファイルがbuildに吐き出されます。

srcおよびbuildのディレクトリ名称はgulpfile.coffeeで定義しています。
```coffee
dir = {
	src:  'src' # ここと
	dest: 'build' # ここ
	img:  'images'
	temp: 'templates'
}
```

### データ
ページ情報や、グローバルな情報はsrc/data/init.yamlに記述します

### 概要
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
	<!-- トップページ以外で記述されます -->
<% end %>
```


いろいろ触って遊んでみてください


### 今後の追加
Grunt_ectとかぶりますが

* 開発環境と納品物生成のタスクを分ける

* yamlファイルを保存した際にgulpfileも保存してreloadをかけたい



