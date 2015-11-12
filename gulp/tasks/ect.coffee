gulp      = require 'gulp'
config    = require '../config'
browser   = require 'browser-sync'
ect       = require 'gulp-ect-simple'

# buildで動かした場合はtaskに'build'が入る
minimist  = require 'minimist'
args      = minimist(process.argv.slice(2))
task      = args['_'][0]

###
 ectファイルをhtmlへコンパイル
 1 init.yamlで指定したpages配列をまわしてディレクトリ階層を取得
###
gulp.task 'ect', ->
	# dest先を変数化
	destTo = if task is 'build' then "#{config.path.dest.root}" else "#{config.path.dev.root}"

	for page in config.init.pages
		# 1 page.dirがnullの場合はroot
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
							hierarchy: if ! directory then 'root'
							init: config.init
							task: if task is 'build' then 'dest' else 'dev'
					})
					.pipe gulp.dest destTo+'/'+directory
					.pipe browser.reload({ stream: true })




