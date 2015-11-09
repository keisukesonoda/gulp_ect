gulp      = require 'gulp'
config    = require '../config'
browser   = require 'browser-sync'
del       = require ('del')
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'


###
 jsファイルのコピー・消去
 1 src/js内の.jsファイルに変更が加わった際、
   ディレクトリ構成を保ったままdest/jsにコピー
 2 init.yamlで指定されたconcat元ファイル、
   およびminify前のconcatファイルを消去
###
gulp.task 'copy-js', (cb) ->
	# 1 srcからdestへコピー
	gulp.src [
		"#{config.dir.src}/js/*.js"
		"#{config.dir.src}/js/**/*.js"
	], { base: "#{config.dir.src}/js}" }
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

	# コピーされたjsファイルから、指定のファイルを消去
	setTimeout ->
		# init.yamlで指定されたconcat元ファイル
		files = []
		for file in data_init.concatScripts
			files.push "#{config.dir.dest}/js/"+file+".js"
		# minify前のconcatファイル
		files.push "#{config.dir.dest}/js/"+data_init.concatName+".js"
		# 消去処理
		del files, cb
	, 500




###
 画像ファイルのコピー
 1 init.yamlで指定されたページディレクトリ内のimgファイルを
   dest内の同階層ディレクトリへコピー
###
gulp.task 'copy-images', ->
	for page in data_init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.dir.src}/#{config.dir.temp}/content/"+dir+"#{config.dir.img}/*"
				.pipe gulp.dest "#{config.dir.dest}/"+dir+"#{config.dir.img}"
				.pipe browser.reload({ stream: true })



