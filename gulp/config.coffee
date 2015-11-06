dir =
	src:  'src'
	dest: 'build'
	img:  'images'
	temp: 'templates'

path = 
	src:
		origin: './'+dir.src
		sass:   './'+dir.src+'/sass'
		css:    './'+dir.src+'/css'
		coffee: './'+dir.src+'/coffee'
		js:     './'+dir.src+'/js'
		img:    './'+dir.src+'/'+dir.img
		temp:   './'+dir.src+'/'+dir.temp
	dest:
		view: './'+dir.dest
		css:  './'+dir.dest+'/css'
		js:   './'+dir.dest+'/js'
		img:  './'+dir.dest+'/'+dir.img


module.exports = 
	path: path
	dir: dir