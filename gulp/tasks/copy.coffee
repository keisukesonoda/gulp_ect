gulp = require 'gulp'
conf = require '../config'


###
	@js src/js内の.jsファイルに変更が加わった際、ディレクトリ構成を保ったままdev/jsにコピー
###
gulp.task 'copy-js', ->
	gulp.src [
		"#{conf.path.src.js}/*.js"
		"#{conf.path.src.js}/**/*.js"
	], { base: "#{conf.path.src.js}" }
			.pipe gulp.dest "#{conf.path.dev.js}"


###
  @css init.yamlで指定されたページディレクトリ内のimgファイルをdest内の同階層ディレクトリへ
###
gulp.task 'copy-images', ->
	for page in conf.data.init.pages
		dir = if page.dir isnt null then page.dir+'/' else ''
		gulp.src "#{conf.path.src.temp}/content/"+dir+"#{conf.dir.img}/*"
				.pipe gulp.dest "#{conf.path.dev.root}/"+dir+"#{conf.dir.img}"



