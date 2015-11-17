gulp      = require 'gulp'
config    = require '../config'
plumber   = require 'gulp-plumber'
coffee    = require 'gulp-coffee'
gutil     = require 'gulp-util'


gulp.task 'coffee', ->
	gulp.src ["#{config.path.src.coffee}/*.coffee"]
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{config.path.src.js}"


