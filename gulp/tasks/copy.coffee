config    = require '../config'
gulp      = require 'gulp'
browser   = require 'browser-sync'
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'


# js files
gulp.task 'copy-js', ->
	gulp.src "#{config.dir.src}/js/*.js"
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

# js libs
gulp.task 'copy-jsLibs', ->
	gulp.src "#{config.dir.src}/libs/*.js"
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

# images
gulp.task 'copy-images', ->
	for page in data_init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.dir.src}/#{config.dir.temp}/content/"+dir+"#{config.dir.img}/*"
				.pipe gulp.dest "#{config.dir.dest}/"+dir+"#{config.dir.img}"
				.pipe browser.reload({ stream: true })



