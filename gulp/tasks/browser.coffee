config  = require '../config'
gulp    = require 'gulp'
browser = require 'browser-sync'

gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{config.path.dest.view}",
		port: 8000,
		open: false,
	})
