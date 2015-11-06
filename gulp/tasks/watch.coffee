config = require '../config'
gulp   = require 'gulp'

gulp.task 'watch', ->
	gulp.watch "#{config.path.src.coffee}/*.coffee", ['coffee']
	gulp.watch [
		"#{config.path.src.sass}/*.scss"
		"#{config.path.src.sass}/**/*.scss"
	], ['sass']
	gulp.watch [
		"#{config.path.src.origin}/*.html"
		"#{config.path.src.origin}/**/*.html"
	], ['copy-html']
	gulp.watch "#{config.path.src.js}/*.js", ['copy-js']
	gulp.watch "#{config.dir.src}/libs/*.js", ['copy-jsLibs']
	gulp.watch "#{config.dir.src}/#{config.dir.img}/*", ['copy-mainImages']
	gulp.watch "#{config.dir.src}/#{config.dir.temp}/content/**/#{config.dir.img}/*", ['copy-lowerImages']
	gulp.watch [
		"#{config.path.src.temp}/**/*.ect"
		"#{config.path.src.temp}/**/**/*.ect"
	], ['ect']
