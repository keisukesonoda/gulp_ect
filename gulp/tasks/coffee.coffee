gulp      = require 'gulp'
config    = require '../config'
browser   = require 'browser-sync'
plumber   = require 'gulp-plumber'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
gutil     = require 'gulp-util'
uglify    = require 'gulp-uglify'
rename    = require 'gulp-rename'
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'




###
	1 .coffeeを.jsにコンパイル
	2 init.yamlで指定したconcat元ファイルを配列にまとめる
	3 指定したファイルをconcatしてminify化する
###
gulp.task 'coffee', ->
	# 1 .coffeeから.jsを生成
	gulp.src ["#{config.path.src.coffee}/*.coffee"]
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{config.path.src.js}"

	# 2 init.yamlで指定したconcatファイルを配列化
	files = []
	for file in data_init.concatScripts
		files.push "#{config.dir.src}/js/"+file+'.js'

	# 3 concat & minify処理
	gulp.src files
			.pipe plumber()
			.pipe concat data_init.concatName+'.js'
			.pipe gulp.dest "#{config.path.src.js}"
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })






