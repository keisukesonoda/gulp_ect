var ROOT = function(){
	var root, scripts;
	scripts = document.getElementsByTagName('script');

	var cur_path = function(href) {
		var a = href.replace( /[\?|#].*$/, '' );
		if( !/\/$/.test(a) ) a=a.slice( 0, a.lastIndexOf( '/' ) + 1 );
		return a;
	}(location.href)

	var i = scripts.length;
	while(i--) {
		var match = scripts[i].src.match(/(^|.*\/)ua\.js$/);
		if (match) {
			root = match[1];

			if( root.substr( 0, 1 ) === '/' ){
				root = location.protocol + '//' + location.host + root;
			}else if( root.substr( 0, 4 ) === 'file' ){
				break;
			}else if( root.substr( 0, 4 ) !== 'http' ){
				root = cur_path + root;
			}
			break;
		}
	} // end while
	root = root.replace('js/', '');
	return root;
}();


var UA = function() {
	var ua = window.navigator.userAgent.toLowerCase();
	return {
		TAB : ua.indexOf('windows') != -1 && ua.indexOf('touch') != -1 ||
					ua.indexOf('android') != -1 && ua.indexOf('mobile') == -1 ||
					ua.indexOf('firefox') != -1 && ua.indexOf('tablet') != -1 ||
					ua.indexOf('ipad') != -1 ||
					ua.indexOf('kindle') != -1 ||
					ua.indexOf('silk') != -1 ||
					ua.indexOf('playbook') != -1,
		SP  : ua.indexOf('windows') != -1 && ua.indexOf('phone') != -1 ||
					ua.indexOf('android') != -1 && ua.indexOf('mobile') != -1 ||
					ua.indexOf('firefox') != -1 && ua.indexOf('mobile') != -1 ||
					ua.indexOf('iphone') != -1 ||
					ua.indexOf('ipod') != -1 ||
					ua.indexOf('blackberry') != -1 ||
					ua.indexOf('bb') != -1,
		AD23: ua.indexOf('android') != -1 && ua.indexOf('2.3') != -1,
		ltIE8:typeof window.addEventListener == 'undefined' && typeof document.getElementsByClassName == 'undefined',
	}
}();


var changeCss = function(){
	var file, head, link;
	if( UA.TAB ) {
		// tablet
		file = 'style.min';
		document.getElementsByName('viewport')[0].content = 'width=1024';
	} else if( UA.AD23 ) {
		// android 2.3
		file = 'sp.min';
		// document.getElementsByName('viewport')[0].content = 'width=device-width,initial-scale=1, maximum-scale=1, user-scalable=no';
	} else if( UA.SP ) {
		// smart phone
		file = 'sp.min';
	} else if( UA.ltIE8 ) {
		// IE under ver.8
		file = 'style.min';
	} else {
		// modern PC
		file = 'style.min';
	}

	head = document.getElementsByTagName('head')[0];
	link = document.createElement('link');
	head.appendChild(link).id="style";

	link = document.getElementById('style');
	link.rel = 'stylesheet';
	link.type = 'text/css';
	link.href = ROOT+'css/'+file+'.css';
}();



