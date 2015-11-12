config       = require '../config'
gulp         = require 'gulp'
compass      = require 'gulp-compass'
sass         = require 'gulp-ruby-sass'
cssmin       = require 'gulp-cssmin'
autoprefixer = require 'gulp-autoprefixer'
rename       = require 'gulp-rename'
browser      = require 'browser-sync'

### @sassファイルのコンパイル###
gulp.task 'sass', ->
	sass("#{config.path.src.sass}/", ({ style: 'expanded', compass: true }))
			.on 'error', (err)-> console.error 'Error!', err.message
			.pipe gulp.dest "#{config.path.dev.css}"
			.pipe cssmin()
			.pipe rename({ extname: '.min.css' })
			.pipe gulp.dest "#{config.path.dev.css}"
			.pipe browser.reload({ stream: true })