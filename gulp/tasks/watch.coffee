config = require '../config'
gulp   = require 'gulp'

gulp.task 'watch', ->
	# cofee
	gulp.watch "#{config.path.src.coffee}/*.coffee", ['coffee']
	# js copy
	gulp.watch "#{config.path.src.js}/*.js", ['copy-js']
	gulp.watch "#{config.dir.src}/libs/*.js", ['copy-jsLibs']
	# image copy
	gulp.watch [
		"#{config.dir.src}/#{config.dir.temp}/content/#{config.dir.img}/*"
		"#{config.dir.src}/#{config.dir.temp}/content/**/#{config.dir.img}/*"
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
