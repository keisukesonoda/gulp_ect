YAML      = require 'js-yaml'
fs        = require 'fs'
data_init = YAML.safeLoad fs.readFileSync "app/src/data/init.yaml", 'utf8'

dir =
	app:     'app'
	src:     'src'
	dev:     'develop'
	dest:    'product'
	sass:    'sass'
	css:     'css'
	coffee:  'coffee'
	js:      'js'
	img:     'images'
	temp:    'templates'
	content: 'content'

path = 
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


module.exports = 
	dir: dir
	path: path
	init: data_init
