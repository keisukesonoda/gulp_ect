config  = require '../config'
gulp    = require 'gulp'
browser = require 'browser-sync'


###
 サーバー起動
 defaultタスクにて指定しているため、
 gulpコマンドで同時にサーバー起動
###
gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{config.path.dest.view}",
		port: 8000,
		open: false,
	})
