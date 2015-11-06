config    = require '../config'
gulp      = require 'gulp'
# filter    = require 'gulp-filter'
browser   = require 'browser-sync'
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'

# functions
# --------------------
# filters =
# 	js:  filter '*.js'
# 	img: filter ['*.jpg', '*.png', '*.gif']


# html
gulp.task 'copy-html', ->
	gulp.src "#{config.path.src.origin}/*.html", {base: "#{config.path.src.origin}"}
			.pipe gulp.dest "#{config.path.dest.view}"
			.pipe browser.reload({ stream: true })

# js files
gulp.task 'copy-js', ->
	gulp.src "#{config.path.src.js}/*.js"
			# .pipe filters.js
			# .pipe filters.js.restore()
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

# js libs
gulp.task 'copy-jsLibs', ->
	gulp.src "#{config.path.src.origin}/libs/*.js"
			# .pipe filters.js
			# .pipe filters.js.restore()
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

# main images
gulp.task 'copy-mainImages', ->
	gulp.src "#{config.path.src.img}/*"
			# .pipe filters.img
			# .pipe filters.img.restore()
			.pipe gulp.dest "#{config.path.dest.img}"
			.pipe browser.reload({ stream: true })

# lower images
gulp.task 'copy-lowerImages', ->
	for page in data_init.pages
		directory = if page.dir isnt null then page.dir+'/' else ''

		if directory
			gulp.src "#{config.dir.src}/#{config.dir.temp}/content/"+directory+"#{config.dir.img}/*"
					# .pipe filters.img
					# .pipe filters.img.restore()
					.pipe gulp.dest "#{config.dir.dest}/"+directory+"#{config.dir.img}"
					.pipe browser.reload({ stream: true })

