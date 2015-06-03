var SP = false;
var TAB = false;
var IE8 = false;
var AD = false;
changeUserAgent = function() {
  ROOT = function(){
    var root;
    var scripts = document.getElementsByTagName('script');

    var cur_path = function( href ) {
      var a = href.replace( /[\?|#].*$/, '' );
      if( !/\/$/.test(a) ) a=a.slice( 0, a.lastIndexOf( '/' ) + 1 );
      return a;
    }( location.href );


    var i = scripts.length;
    while (i--) {
      var match = scripts[i].src.match(/(^|.*\/)ua\.js$/);
      if (match) {
        root = match[1];

        if( root.substr( 0, 1 ) === '/' ){
          root = location.protocol + '//' + location.host + root;
        }else if( root.substr( 0, 4 ) !== 'http' ){
          root = cur_path + root;
        }

        break;
      }
    }
    root = root.replace('js/', '');
    return root;
  }();


  var ua = navigator.userAgent,
  tablet =  ua.indexOf('Android') > 0 &&
            ua.indexOf('Mobile') === -1 ||
            ua.indexOf('iPad') > 0 ||
            ua.indexOf('Kindle') > 0,

  sPhone =  ua.indexOf('Android') > 0 &&
            ua.indexOf('Mobile') > 0 ||
            ua.indexOf('iPhone') > 0 &&
            ua.indexOf('iPad') === -1 ||
            ua.indexOf('iPod') > 0 ||
            ua.indexOf('Windows Phone') > 0,

  adrd23 = ua.indexOf('Android 2.3') > 0,

  ie8 = ua.indexOf('MSIE 8.0') > 0;


  if( tablet ) {
    TAB = true;
    file = 'style.min';
    document.getElementsByName('viewport')[0].content = 'width=1024';
  } else if( adrd23 ) {
    SP = true;
    AD = true;
    file = 'sp.min';
    // document.getElementsByName('viewport')[0].content = 'width=device-width,initial-scale=1, maximum-scale=1, user-scalable=no';
  } else if( sPhone ) {
    SP = true;
    file = 'sp.min';
  } else if( ie8 ) {
    IE8 = true;
    TAB = false;
    SP  = false;
    file = 'style.min';
  } else {
    file = 'style.min';
  }

  head = document.getElementsByTagName('head')[0];
  link = document.createElement('link');
  head.appendChild(link);

  link = document.getElementsByTagName('link')[0];
  link.rel = 'stylesheet';
  link.type = 'text/css';
  link.href = ROOT+'css/'+file+'.css';
}();
