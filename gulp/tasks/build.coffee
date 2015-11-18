gulp   = require 'gulp'
config = require '../config'
del    = require 'del'

ect        = require 'gulp-ect-simple'
inject     = require 'gulp-inject'
bowerFiles = require 'main-bower-files'

cssmin = require 'gulp-cssmin'
rename = require 'gulp-rename'

uglify = require 'gulp-uglify'
usemin = require 'gulp-usemin'

###
@成果物の生成
	@build_init
		buildコマンド毎にdestディレクトリを削除
	@build_copy_images
		各階層の画像をコピー
	@build_copy_min_css
		init.yamlのsettings:css:useMinifyを参照
			true           -> .min.cssを生成
			false or blank -> .cssをコピー
		htmlのパスは、テンプレート側で変数を持たせ書き換え
	@build_copy_js
		devからdestへjsディレクトリをコピー
	@build_html
		各階層のectをhtmlへコンパイル
	@build_inject
		コンパイルされたhtmlへ各ファイルを吐き出す
			・bowerでインストールしたjsファイル
			・bowerでインストールしたcssファイル
			・jsディレクトリ直下のjsファイル
	@build_usemin_js
		init.yamlのsettings:javascript:useMinifyを参照
			true           -> 連結してminify
			false or blank -> 連結
		ファイル名は、テンプレート側で変数を持たせ書き換え
	@del
		不要なjsファイルを削除
###


gulp.task 'build-init', (cb) ->
	del ["#{config.path.dest.root}"], cb



gulp.task 'build-copy-images', ['build-init'], ->
	for page in config.init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.path.dev.root}/"+dir+"#{config.dir.img}/**"
				.pipe gulp.dest "#{config.path.dest.root}/"+dir+"#{config.dir.img}"



gulp.task 'build-copy-min-css', ['build-copy-images'], ->
	if config.init.settings.css.useMinify
		# minify化
		gulp.src "#{config.path.dev.css}/*.css"
				.pipe cssmin()
				.pipe rename({ extname: '.min.css' })
				.pipe gulp.dest "#{config.path.dest.css}"
	else
		gulp.src "#{config.path.dev.css}/**", { base: "#{config.path.dev.css}" }
				.pipe gulp.dest "#{config.path.dest.css}"



gulp.task 'build-copy-js', ['build-copy-min-css'], ->
	gulp.src "#{config.path.dev.js}/**", { base: "#{config.path.dev.js}" }
			.pipe gulp.dest "#{config.path.dest.js}"



gulp.task 'build-html', ['build-copy-js'], ->
	for page in config.init.pages
		# page.dirがnullの場合はrootパス
		directory = if page.dir isnt null then page.dir+'/' else ''
		for file in page.files
			gulp.src "#{config.path.src.content}/"+directory+file.name+'.ect'
					.pipe ect({
						options:
							root: "#{config.path.src.temp}"
							ext:  '.ect'
						data:
							name: file.name
							title: file.title
							class: file.class
							hierarchy: if ! directory then 'root'
							init: config.init
							task: 'build'
							ROOT: if page.dir is null then '' else '../'
					})
					.pipe gulp.dest "#{config.path.dest.root}/"+directory



gulp.task 'build-inject', ['build-html'], ->
	# ectのコンパイルが完全に完了してからでないと
	# 正常に動作してくれないため、setTimeoutでdelayをかける
	setTimeout ->
		bower      = gulp.src bowerFiles(),read: false
		app        = gulp.src "#{config.path.dest.js}/*.js", read: false

		for page in config.init.pages
			directory = if page.dir isnt null then page.dir+'/' else ''
			for file in page.files
				gulp.src "#{config.path.dest.root}/"+directory+file.name+'.html'
						.pipe inject bower, relative: true, name: 'bower'
						.pipe inject app, relative: true, name: 'app'
						.pipe gulp.dest "#{config.path.dest.root}/"+directory
	, config.params.reloadDelay



gulp.task 'build-usemin-js', ['build-inject'], ->
	setTimeout ->
		# 要ブラッシュアップ（usemin()にオブジェクト変数を渡すとエラーになる）
		if config.init.settings.javascript.useMinify
			for page in config.init.pages
				directory = if page.dir isnt null then page.dir+'/' else ''
				for file in page.files
					gulp.src "#{config.path.dest.root}/"+directory+file.name+'.html'
							.pipe usemin({
								css_libs:  [cssmin()]
								js_libs:   [uglify()]
								js_vendor: [uglify()]
							})
							.pipe gulp.dest "#{config.path.dest.root}/"+directory
		else
			for page in config.init.pages
				directory = if page.dir isnt null then page.dir+'/' else ''
				for file in page.files
					gulp.src "#{config.path.dest.root}/"+directory+file.name+'.html'
							.pipe usemin()
							.pipe gulp.dest "#{config.path.dest.root}/"+directory
	, config.params.reloadDelay*2.5



gulp.task 'build-del', ['build-usemin-js'], (cb) ->
	delFiles = []
	# init.yamlで指定された削除するファイル群
	for file in config.init.settings.javascript.original.files
		delFiles.push "#{config.path.dest.js}/"+file+'.js'

	# 削除コマンド
	setTimeout ->
		del delFiles, cb
	, config.params.reloadDelay*3


gulp.task 'build', ['build-del']



