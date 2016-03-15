gulp       = require 'gulp'
config     = require '../config'
browser    = require 'browser-sync'
ect        = require 'gulp-ect-simple'
inject     = require 'gulp-inject'
bowerFiles = require 'main-bower-files'

require('events').EventEmitter.defaultMaxListeners = 0

###
 ectファイルをhtmlへコンパイル
 1 init.yamlのpages配列を参照してディレクトリ毎にhtmlをコンパイル
 2 bower.jsonのsaveに登録されているファイルパスを取得してdev内のhtmlにパスを記載
###
gulp.task 'ect-develop', ->
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
							task: 'develop'
							ROOT: if page.dir is null then '' else '../'
					})
					.pipe gulp.dest "#{config.path.dev.root}/"+directory
					.pipe browser.reload({ stream: true })



gulp.task 'inject', ['ect-develop'], ->
	# ectのコンパイルが完全に完了してからでないと
	# 正常に動作してくれないため、setTimeoutでdelayをかける
	setTimeout ->
		bower      = gulp.src bowerFiles(),read: false
		app        = gulp.src [
									 "#{config.path.dev.js}/*.js"
									 "#{config.path.dev.css}/*.css"
								 ], read: false

		for page in config.init.pages
			directory = if page.dir isnt null then page.dir+'/' else ''
			for file in page.files
				gulp.src "#{config.path.dev.root}/"+directory+file.name+'.html'
						.pipe inject bower, relative: true, name: 'bower'
						.pipe inject app, relative: true, name: 'app'
						.pipe gulp.dest "#{config.path.dev.root}/"+directory
	, config.params.reloadDelay


gulp.task 'ect', ['inject']

