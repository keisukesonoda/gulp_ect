gulp      = require 'gulp'
config    = require '../config'
browser   = require 'browser-sync'
plumber   = require 'gulp-plumber'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
gutil     = require 'gulp-util'
uglify    = require 'gulp-uglify'
rename    = require 'gulp-rename'

###
	1 init.yamlで指定したconcat元ファイルを配列にまとめる
	2 .coffeeを.jsにコンパイル
	3 指定したファイルをconcatしてminify化する
	4 生成したminifyファイル
###

# 1 init.yamlで指定したconcatファイルを配列化
concatFiles = []
for file in config.init.settings.javascript.concat.files
	concatFiles.push "#{config.path.src.js}/"+file+'.js'

# 2 .coffeeから.jsを生成
gulp.task 'coffee-compile', ->
	gulp.src ["#{config.path.src.coffee}/*.coffee"]
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{config.path.src.js}"

# 3 concat & minify処理
gulp.task 'concat_minify', ['coffee-compile'], ->
	gulp.src concatFiles
			.pipe plumber()
			.pipe concat config.init.settings.javascript.concat.name+'.js'
			.pipe gulp.dest "#{config.path.src.js}"
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{config.path.dev.js}"
			.pipe browser.reload({ stream: true })

gulp.task 'coffee', ['concat_minify']

