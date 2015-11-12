gulp      = require 'gulp'
config    = require '../config'
del       = require ('del')


###
@成果物の生成
	1 画像・css・jsのコピー
	2 コピーが完了したら不要なファイルを削除 
###

# 1 画像コピー
gulp.task 'build-images', ->
	for page in config.init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.path.dev.root}/"+dir+"#{config.dir.img}/**"
				.pipe gulp.dest "#{config.path.dest.root}/"+dir+"#{config.dir.img}"

# 1 cssコピー
gulp.task 'build-css', ->
	gulp.src "#{config.path.dev.css}/**", { base: "#{config.path.dev.css}" }
			.pipe gulp.dest "#{config.path.dest.css}"

# 1 jsコピー
gulp.task 'build-js', ->
	gulp.src "#{config.path.dev.js}/**", { base: "#{config.path.dev.js}" }
			.pipe gulp.dest "#{config.path.dest.js}"


# 2 ファイル削除
gulp.task 'build-del', ['build-images', 'build-css', 'build-js'], (cb) ->
	delFiles = []
	### @jsの不要ファイル ###
	# init.yamlで指定されたconcat元ファイル群
	for file in config.init.settings.javascript.concat.files
		delFiles.push "#{config.path.dest.js}/"+file+'.js'
	if config.init.settings.javascript.useMinify
		# minを使用する場合はminify前のconcatファイルも追加
		delFiles.push "#{config.path.dest.js}/"+config.init.settings.javascript.concat.name+'.js'

	### @cssの不要ファイル ###
	if config.init.settings.css.useMinify
		# minを使用する場合はminify前ファイルを追加
		delFiles.push "#{config.path.dest.css}/style.css"
		delFiles.push "#{config.path.dest.css}/sp.css"

	# 削除コマンド
	del delFiles, cb




gulp.task 'build', ['build-del', 'ect'], ->
	# 全buildタスクが完了したらメッセージ
	console.log 'build complete!'



