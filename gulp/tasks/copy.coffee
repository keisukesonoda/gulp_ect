gulp      = require 'gulp'
config    = require '../config'
browser   = require 'browser-sync'


###
	@js src/js内の.jsファイルに変更が加わった際、ディレクトリ構成を保ったままdev/jsにコピー
###
gulp.task 'copy-js', (cb) ->
	gulp.src [
		"#{config.path.src.js}/*.js"
		"#{config.path.src.js}/**/*.js"
	], { base: "#{config.path.src.js}" }
			.pipe gulp.dest "#{config.path.dev.js}"
			.pipe browser.reload({ stream: true })


###
  @css init.yamlで指定されたページディレクトリ内のimgファイルをdest内の同階層ディレクトリへ
###
gulp.task 'copy-images', ->
	for page in config.init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{config.path.src.temp}/content/"+dir+"#{config.dir.img}/*"
				.pipe gulp.dest "#{config.path.dev.root}/"+dir+"#{config.dir.img}"
				.pipe browser.reload({ stream: true })



