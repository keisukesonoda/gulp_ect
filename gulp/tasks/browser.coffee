gulp    = require 'gulp'
config  = require '../config'
browser = require 'browser-sync'


###
 @サーバー起動
 develop内を表示
###
gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{config.path.dev.root}",
		port: 8000,
		open: false,
	})
