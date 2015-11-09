config    = require '../config'
gulp      = require 'gulp'
browser   = require 'browser-sync'
ect       = require 'gulp-ect-simple'
YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "#{config.path.src.origin}/data/init.yaml", 'utf8'



###
 ectファイルをhtmlへコンパイル
 1 init.yamlで指定したpages配列をまわしてディレクトリ階層を取得
 2 htmlへ渡すパラメータの指定
 3 ディレクトリ内のファイルを取得してdest内の同階層にhtmlを生成
###
gulp.task 'ect', ->
	for page in data_init.pages
		# 1 page.dirがnullの場合はroot
		directory = if page.dir isnt null then page.dir+'/' else ''
		for file in page.files
			gulp.src "#{config.path.src.temp}/content/"+directory+file.name+'.ect'
					.pipe ect({
						options:
							root: "#{config.path.src.temp}"
							ext:  '.ect'
						data:
							# パラメータはinit.yamlで指定
							name: file.name
							title: file.title
							class: file.class
							hierarchy: if ! directory then 'root'
							init: data_init
					})
					# html生成
					.pipe gulp.dest "#{config.path.dest.view}/"+directory
					.pipe browser.reload({ stream: true })