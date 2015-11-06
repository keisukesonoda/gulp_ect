config  = require '../config'
gulp    = require 'gulp'
browser = require 'browser-sync'
plumber = require 'gulp-plumber'
coffee  = require 'gulp-coffee'
gutil   = require 'gulp-util'
uglify  = require 'gulp-uglify'
rename  = require 'gulp-rename'


gulp.task 'coffee', ->
	gulp.src ["#{config.path.src.coffee}/*.coffee"]
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })