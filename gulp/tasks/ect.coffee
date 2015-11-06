config    = require '../config'
gulp      = require 'gulp'
browser   = require 'browser-sync'
ect       = require 'gulp-ect-simple'
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'

gulp.task 'ect', ->
	for page in data_init.pages
		directory = if page.dir isnt null then page.dir+'/' else ''
		for file in page.files
			gulp.src "#{config.path.src.temp}/content/"+directory+file.name+'.ect'
					.pipe ect({
						options:
							root: "#{config.path.src.temp}"
							ext:  '.ect'
						data:
							name: file.name
							title: file.title
							class: file.class
							hierarchy: if page is 'root' then 'root'
							init: data_init
					})
					.pipe gulp.dest "#{config.path.dest.view}/"+directory
					.pipe browser.reload({ stream: true })