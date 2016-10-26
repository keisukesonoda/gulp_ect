# common
# --------------------
gulp    = require 'gulp'
conf    = require '../config'
plumber = require 'gulp-plumber'
rename  = require 'gulp-rename'


### -------------------------
	@sass
------------------------- ###
sass         = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'

gulp.task 'sass', ->
	gulp.src [
		"#{conf.path.src.sass}/**/*.scss"
		"!#{conf.path.src.sass}/editor-style.scss"
	]
			.pipe plumber({
				handleError: (err) ->
					console.log err
					this.emit('end')
				})
			.pipe sass({
				outputStyle: 'expanded'
			}).on('error', sass.logError)
			.pipe gulp.dest(conf.path.dev.css)






### -------------------------
	@coffee
------------------------- ###
coffee  = require 'gulp-coffee'
gutil   = require 'gulp-util'
rename  = require 'gulp-rename'

gulp.task 'coffee', ->
	gulp.src "#{conf.path.src.coffee}/**/*.coffee"
			.pipe plumber({
				handleError: (err) ->
					console.log err
					this.emit('end')
				})
			.pipe coffee({
				bare: true
			}).on('error', gutil.log)
			.pipe rename('script.js')
			.pipe gulp.dest "#{conf.path.src.js}"

