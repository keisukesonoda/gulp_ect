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
spawn        = require('child_process').spawn
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
data_init    = YAML.safeLoad fs.readFileSync "#{dir.src}"+'/data/init.yaml', 'utf8'


# server
# --------------------
gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{dir.dest}",
		port: 8000,
		open: true,
	})



# compass sass
# --------------------
gulp.task 'compass', ->
	gulp.src "#{dir.src}"+'/sass/**/*.scss'
			.pipe compass({
				config_file: 'config.rb'
				sass: "#{dir.src}"+'/sass'
				css: "#{dir.dest}"+'/css'
			})

gulp.task 'sass', ->
	sass(dir.src+'/sass/', ({ style: 'expanded', compass: true }))
			.on 'error', (err)-> console.error 'Error!', err.message
			.pipe gulp.dest "#{dir.dest}"+'/css'
			.pipe cssmin()
			.pipe rename({ extname: '.min.css' })
			.pipe gulp.dest "#{dir.dest}"+'/css'
			.pipe browser.reload({ stream: true })


# coffee uglify
# --------------------
gulp.task 'coffee', ->
	gulp.src "#{dir.src}"+'/coffee/*.coffee'
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			.pipe gulp.dest "#{dir.dest}"+'/js'
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{dir.dest}"+'/js'
			.pipe browser.reload({ stream: true })


# copies
# --------------------
filters =
	js:  filter '*.js'
	img: filter ['*.jpg', '*.png', '*.gif']


# html
gulp.task 'copy-html', ->
	gulp.src "#{dir.src}"+'/*.html', {base: "#{dir.src}"}
			.pipe gulp.dest "#{dir.dest}"
			.pipe browser.reload({ stream: true })

# js files
gulp.task 'copy-js', ->
	gulp.src "#{dir.src}"+'/js/*.js'
			.pipe filters.js
			.pipe filters.js.restore()
			.pipe gulp.dest "#{dir.dest}"+'/js'
			.pipe browser.reload({ stream: true })

# js libs
gulp.task 'copy-jsLibs', ->
	gulp.src "#{dir.src}"+'/libs/*.js'
			.pipe filters.js
			.pipe filters.js.restore()
			.pipe gulp.dest "#{dir.dest}"+'/js'
			.pipe browser.reload({ stream: true })

# main images
gulp.task 'copy-mainImages', ->
	gulp.src "#{dir.src}"+'/'+dir.img+'/*'
			.pipe filters.img
			.pipe filters.img.restore()
			.pipe gulp.dest "#{dir.dest}"+'/'+dir.img
			.pipe browser.reload({ stream: true })

# lower images
gulp.task 'copy-lowerImages', ->
	for page, detail of data_init.pages
		if page is 'lowers'
			for lower in detail
				for file in lower.files
					gulp.src "#{dir.src}"+'/'+"#{dir.temp}"+'/content/'+lower.dir+'/'+"#{dir.img}"+'/*'
							.pipe filters.img
							.pipe filters.img.restore()
							.pipe gulp.dest "#{dir.dest}"+'/'+lower.dir+'/'+"#{dir.img}"
							.pipe browser.reload({ stream: true })


# ect
gulp.task 'ect', ->
	for page, details of data_init.pages
		for detail in details
			directory = if detail.dir isnt null then detail.dir+'/' else ''
			for file in detail.files
				gulp.src "#{dir.src}"+'/'+"#{dir.temp}"+'/content/'+directory+file.name+'.ect'
						.pipe ect({
							options:
								root: "#{dir.src}"+'/'+"#{dir.temp}"
								ext:  '.ect'
							data:
								name: file.name
								title: file.title
								class: file.class
								hierarchy: if page is 'root' then 'root'
								init: data_init
						})
						.pipe gulp.dest "#{dir.dest}"+'/'+directory
						.pipe browser.reload({ stream: true })

gulp.task 'watch', ->
	gulp.watch "#{dir.src}"+'/coffee/*.coffee', ['coffee']
	gulp.watch "#{dir.src}"+'/sass/**/*.scss', ['sass']
	gulp.watch "#{dir.src}"+'/js/*.js', ['copy-js']
	gulp.watch "#{dir.src}"+'/libs/*.js', ['copy-jsLibs']
	gulp.watch "#{dir.src}"+'/'+"#{dir.temp}"+'/**/*.ect', ['ect']
	gulp.watch "#{dir.src}"+'/'+dir.img+'/*', ['copy-mainImages']
	gulp.watch "#{dir.src}"+'/'+"#{dir.temp}"+'/content/**/'+dir.img+'/*', ['copy-lowerImages']
	gulp.watch ["#{dir.src}"+'/*.html', "#{dir.src}"+'/**/*.html'], ['copy-html']



# default task
# --------------------
gulp.task 'default', ['server', 'watch'], ->
