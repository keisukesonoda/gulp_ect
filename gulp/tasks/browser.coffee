gulp    = require 'gulp'
config  = require '../config'
browser = require 'browser-sync'


###
 @サーバー起動
 developを表示
###
gulp.task 'server', ->
	browser({
		server:
			baseDir: ["#{config.path.project.root}", "#{config.path.dev.root}"]
		port: 8000
		open: false
		reloadDelay: config.params.reloadDelay
	})
