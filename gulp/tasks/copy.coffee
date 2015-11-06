config    = require '../config'
gulp      = require 'gulp'
browser   = require 'browser-sync'
del       = require ('del')
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'


# js files
gulp.task 'copy-js', (cb) ->
	gulp.src [
		"#{config.dir.src}/js/*.js"
		"#{config.dir.src}/js/**/*.js"
	], { base: "#{config.dir.src}/js}" }
			.pipe gulp.dest "#{config.path.dest.js}"
			.pipe browser.reload({ stream: true })

	setTimeout ->
		# init.yamlで消去されているconcat元ファイルを指定
		files = []
		for file in data_init.concatScripts
			files.push "#{config.dir.dest}/js/"+file+".js"
		# minify前のconcatファイルも指定
		files.push "#{config.dir.dest}/js/cat.js"
		# 消去
		del files, cb
	, 300




# images
gulp.task 'copy-images', ->
	for page in data_init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.dir.src}/#{config.dir.temp}/content/"+dir+"#{config.dir.img}/*"
				.pipe gulp.dest "#{config.dir.dest}/"+dir+"#{config.dir.img}"
				.pipe browser.reload({ stream: true })



