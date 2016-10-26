gulp = require 'gulp'
conf = require '../config'

###
 @ファイル監視
 defaultタスクにて指定しているため、
 gulpコマンドで同時に監視を開始
###
gulp.task 'watch', ->
	# cofee
	gulp.watch "#{conf.path.src.coffee}/*.coffee", ['coffee']
	# js
	gulp.watch "#{conf.path.src.js}/*.js", ['copy-js']
	# images
	gulp.watch [
		"#{conf.dir.app}/#{conf.dir.src}/#{conf.dir.temp}/#{conf.dir.content}/#{conf.dir.img}/*"
		"#{conf.dir.app}/#{conf.dir.src}/#{conf.dir.temp}/#{conf.dir.content}/**/#{conf.dir.img}/*"
	], ['copy-images']
	# sass
	gulp.watch [
		"#{conf.path.src.sass}/**/*.scss"
	], ['sass']
	# ect
	gulp.watch [
		"#{conf.path.src.temp}/**/**/*.ect"
	], ['ect-basic']
	# reload
	gulp.watch "#{conf.path.src.root}/**", ['reload']



