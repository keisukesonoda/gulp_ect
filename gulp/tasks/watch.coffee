gulp   = require 'gulp'
config = require '../config'

###
 @ファイル監視
 defaultタスクにて指定しているため、
 gulpコマンドで同時に監視を開始
###
gulp.task 'watch', ->
	# cofee
	gulp.watch "#{config.path.src.coffee}/*.coffee", ['coffee']
	# js
	gulp.watch "#{config.path.src.js}/*.js", ['copy-js']
	# images
	gulp.watch [
		"#{config.path.src.content}/#{config.dir.img}/*"
		"#{config.path.src.content}/**/#{config.dir.img}/*"
	], ['copy-images']
	# sass
	gulp.watch [
		"#{config.path.src.sass}/*.scss"
		"#{config.path.src.sass}/**/*.scss"
	], ['sass']
	# ect
	gulp.watch [
		"#{config.path.src.temp}/**/*.ect"
		"#{config.path.src.temp}/**/**/*.ect"
	], ['ect']




