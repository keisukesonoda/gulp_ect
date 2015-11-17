YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "app/src/data/init.yaml", 'utf8'


dir =
	app:     data_init.settings.directory.names.application
	src:     data_init.settings.directory.names.source
	dev:     data_init.settings.directory.names.develop
	dest:    data_init.settings.directory.names.destination
	sass:    data_init.settings.directory.names.sass
	css:     data_init.settings.directory.names.css
	coffee:  data_init.settings.directory.names.coffee
	js:      data_init.settings.directory.names.js
	img:     data_init.settings.directory.names.img
	temp:    data_init.settings.directory.names.temp
	content: data_init.settings.directory.names.content


path = 
	project:
		root:   ''
	bowerDir:  dir.app+'/'+dir.dev+'/'+'bower_components'
	src:
		root:    dir.app+'/'+dir.src
		sass:    dir.app+'/'+dir.src+'/'+dir.sass
		css:     dir.app+'/'+dir.src+'/'+dir.css
		coffee:  dir.app+'/'+dir.src+'/'+dir.coffee
		js:      dir.app+'/'+dir.src+'/'+dir.js
		img:     dir.app+'/'+dir.src+'/'+dir.img
		temp:    dir.app+'/'+dir.src+'/'+dir.temp
		content: dir.app+'/'+dir.src+'/'+dir.temp+'/'+dir.content
	dev:
		root:    dir.app+'/'+dir.dev
		css:     dir.app+'/'+dir.dev+'/'+dir.css
		js:      dir.app+'/'+dir.dev+'/'+dir.js
		img:     dir.app+'/'+dir.dev+'/'+dir.img
	dest:
		root:    dir.app+'/'+dir.dest
		css:     dir.app+'/'+dir.dest+'/'+dir.css
		js:      dir.app+'/'+dir.dest+'/'+dir.js
		img:     dir.app+'/'+dir.dest+'/'+dir.img


params = 
	reloadDelay: 400


module.exports = 
	dir: dir
	path: path
	init: data_init
	params: params
