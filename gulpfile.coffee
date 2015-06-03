'use strict'
# directories
# --------------------
dir = {
	src:  'src'
	dest: 'build'
	img:  'images'
	temp: 'templates'
}

# requires
# --------------------
gulp         = require 'gulp'
browser      = require 'browser-sync'
copy         = require 'gulp-copy'
rename       = require 'gulp-rename'
plumber      = require 'gulp-plumber'
compass      = require 'gulp-compass'
sass         = require 'gulp-ruby-sass'
cssmin       = require 'gulp-cssmin'
autoprefixer = require 'gulp-autoprefixer'
coffee       = require 'gulp-coffee'
gutil        = require 'gulp-util'
uglify       = require 'gulp-uglify'
filter       = require 'gulp-filter'
YAML         = require 'js-yaml'
fs           = require 'fs'
ect          = require 'gulp-ect-simple'
data_init    = YAML.safeLoad fs.readFileSync "#{dir.src}" + '/data/init.yaml', 'utf8'


# server
# --------------------
gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{dir.dest}",
		port: 8000,
		open: false,
	})

gulp.task 'reload', ->
	browser.reload({ stream: true })



# compass sass
# --------------------
gulp.task 'compass', ->
	gulp.src "#{dir.src}" + '/sass/**/*.scss'
			.pipe compass({config_file: 'config.rb', css: 'css', sass: 'sass' })
			.pipe gulp.dest "#{dir.dest}" + '/css'

gulp.task 'sass', ->
	sass(dir.src + '/sass/', ({ style: 'expanded', compass: true }))
			.on 'error', (err)-> console.error 'Error!', err.message
			.pipe gulp.dest "#{dir.dest}" + '/css'
			.pipe cssmin()
			.pipe rename({ extname: '.min.css' })
			.pipe gulp.dest "#{dir.dest}" + '/css'
			.pipe browser.reload({ stream: true })


# coffee uglify
# --------------------
gulp.task 'coffee', ->
	gulp.src "#{dir.src}" + '/coffee/*.coffee'
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{dir.dest}" + '/js'
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{dir.dest}" + '/js'
			.pipe browser.reload({ stream: true })


# copies
# --------------------
# html
gulp.task 'copy-html', ->
	gulp.src "#{dir.src}" + '/*.html', {base: "#{dir.src}"}
			.pipe gulp.dest "#{dir.dest}"
			.pipe browser.reload({ stream: true })

# js files
gulp.task 'copy-js', ->
	jsFilter = filter '*.js'
	gulp.src "#{dir.src}" + '/js/*.js'
			.pipe jsFilter
			.pipe jsFilter.restore()
			.pipe gulp.dest "#{dir.dest}" + '/js'
			.pipe browser.reload({ stream: true })

# js libs
gulp.task 'copy-jsLibs', ->
	jsFilter = filter '*.js'
	gulp.src "#{dir.src}" + '/libs/*.js'
			.pipe jsFilter
			.pipe jsFilter.restore()
			.pipe gulp.dest "#{dir.dest}" + '/js'
			.pipe browser.reload({ stream: true })

# main images
gulp.task 'copy-mainImages', ->
	imgFilter = filter ['*.jpg', '*.png', '*.gif']
	gulp.src "#{dir.src}" + '/' + dir.img + '/*'
			.pipe imgFilter
			.pipe imgFilter.restore()
			.pipe gulp.dest "#{dir.dest}" + '/' + dir.img
			.pipe browser.reload({ stream: true })

# lower images
#gulp.task 'copy-mainImages', ->
#	imgFilter = filter ['*.jpg', '*.png', '*.gif']
#	gulp.src "#{dir.src}" + '/' + dir.temp + '/content/' + dir.img + '/*'
#			.pipe imgFilter
#			.pipe imgFilter.restore()
#			.pipe gulp.dest "#{dir.dest}" + '/' + dir.img
#			.pipe browser.reload({ stream: true })

# ect
gulp.task 'ect', ->
	for page, detail of data_init.pages
		switch page
			when 'root'
				for file in detail.files
					gulp.src "#{dir.src}"+'/'+"#{dir.temp}"+'/content/'+file.name+'.ect'
							.pipe ect({
								options:
									root: "#{dir.src}"+'/'+"#{dir.temp}"
									ext:  '.ect'
								data:
									name: file.name
									title: file.title
									class: file.class
									root: true
									init: data_init
							})
							.pipe gulp.dest "#{dir.dest}"
							.pipe browser.reload({ stream: true })
			when 'lowers'
				for lower in detail
					for file in lower.files
						gulp.src "#{dir.src}"+'/'+"#{dir.temp}"+'/content/'+lower.dir+'/'+file.name+'.ect'
								.pipe ect({
									options:
										root: "#{dir.src}"+'/'+"#{dir.temp}"
										ext:  '.ect'
									data:
										name: file.name
										title: file.title
										class: file.class
										init: data_init
								})
								.pipe gulp.dest "#{dir.dest}"+'/'+lower.dir
								.pipe browser.reload({ stream: true })



# default task
# --------------------
gulp.task 'default', ['server', 'ect'], ->
	gulp.watch "#{dir.src}" + '/coffee/*.coffee', ['coffee']
	gulp.watch "#{dir.src}" + '/sass/**/*.scss', ['sass']
	gulp.watch ["#{dir.src}" + '/*.html', "#{dir.src}" + '/**/*.html'], ['copy-html']
	gulp.watch "#{dir.src}" + '/js/*.js', ['copy-js']
	gulp.watch "#{dir.src}" + '/libs/*.js', ['copy-jsLibs']
	gulp.watch "#{dir.src}" + '/' + dir.img + '/*', ['copy-mainImages']
	gulp.watch "#{dir.src}" + '/' + "#{dir.temp}" + '/**/*.ect', ['ect']
