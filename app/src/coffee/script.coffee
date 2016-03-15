$(document).on({
	ready: ->
		# init functions
		my_initialization()
		# basic functions
		my_basics()
		# ready functions
		sample.ready()
})

$(window).on({
	load: ->
		sample.load()
})


my_initialization = ->
	my_init.changeTransitTarget()
	my_init.registEasing()
	my_init.getScrollTarget()
	my_init.getUseragent()
	my_init.getRootPath()


my_basics = ->
	my_base.notSaveImages()
	my_base.scrollSection()
	# basic.scrollTop()


sample = {}
sample.ready = ->
	console.log 'ready'

sample.load = ->
	console.log 'load'



















my_init = {}
my_init.changeTransitTarget = ->
	# transitionに対応していなければanimate
	if !$.support.transition
		$.fn.transition = $.fn.animate;


my_init.registEasing = ->
	# easingの登録
	$.extend(jQuery.easing, {
		easeOutBack: (x, t, b, c, d, s) ->
			if s is undefined
				s = 1.70158
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b
		easeInOutBack: (x, t, b, c, d, s) ->
			if s is undefined
				s = 1.70158;
			if (t /= d / 2) < 1
				return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b
		easeInOutCubic: (x, t, b, c, d) ->
			if (t /= d / 2) < 1
				return c / 2 * t * t * t + b
			return c / 2 * ((t -= 2) * t * t + 2) + b
	})


my_init.getScrollTarget = ->
	# ブラウザによってscroll対象が'body'か'html'か判別
	isHtmlScrollable = do ->
		html = $('html')
		top = html.scrollTop()
		elm = $('<div/>').height(10000).prependTo('body')
		html.scrollTop(10000)
		rs = !!html.scrollTop()
		html.scrollTop(top);
		elm.remove()
		return rs
	window.scrTgt = if isHtmlScrollable then 'html' else 'body'


my_init.getUseragent = ->
	window.UA = do ->
		ua = window.navigator.userAgent.toLowerCase()
		return {
			TAB : ua.indexOf('windows') isnt -1 and ua.indexOf('touch') isnt -1 or
						ua.indexOf('android') isnt -1 and ua.indexOf('mobile') is -1 or
						ua.indexOf('firefox') isnt -1 and ua.indexOf('tablet') isnt -1 or
						ua.indexOf('ipad') isnt -1 or
						ua.indexOf('kindle') isnt -1 or
						ua.indexOf('silk') isnt -1 or
						ua.indexOf('playbook') isnt -1
			SP  : ua.indexOf('windows') isnt -1 and ua.indexOf('phone') isnt -1 or
						ua.indexOf('android') isnt -1 and ua.indexOf('mobile') isnt -1 or
						ua.indexOf('firefox') isnt -1 and ua.indexOf('mobile') isnt -1 or
						ua.indexOf('iphone') isnt -1 or
						ua.indexOf('ipod') isnt -1 or
						ua.indexOf('blackberry') isnt -1 or
						ua.indexOf('bb') isnt -1
			AD  : ua.indexOf('android') isnt -1
			ltIE8:typeof window.addEventListener is 'undefined' and typeof document.getElementsByClassName is 'undefined'
		}


my_init.getRootPath = ->
	stylesheets = document.getElementsByTagName('link')

	cur_path = ((href) ->
		a = href.replace(/[\?|#].*$/, '')
		if !/\/$/.test(a)
			a = a.slice(0, a.lastIndexOf('/') + 1)
		a
	)(location.href)

	files = [
		'style.css'
		'style.min.css'
	]

	i = stylesheets.length
	while i--
		matchs = [
			stylesheets[i].href.match(/(^|.*\/)style\.css$/)
			stylesheets[i].href.match(/(^|.*\/)style\.min\.css$/)
		]

		$.each matchs, (i, match) ->
			if match isnt null
				root = match[1]

				if root.substr(0, 1) is '/'
					root = location.protocol + '//' + location.host + root
				else if root.substr(0, 4) is 'file'
					root = root
				else if root.substr(0, 4) isnt 'http'
					root = cur_path + root

				window.ROOT = root.replace('css/', '')

				return false








my_base = {}
my_base.scrollSection = ->
	trg = $('.js-scrKey')
	tgt = $('.js-scrTgt')
	scr = {}

	trg.on('click', (e) ->
		e.preventDefault()

		if ! $(this).attr('data-href')
			scr = {}
			return
		else
			scr.to = $(this).attr('data-href')

		tgt.each ->
			if $(this).hasClass(scr.to)
				scr.pos = ($(this).offset().top) - 30

		$(scrTgt).animate({ scrollTop: scr.pos }, 'fast')
	)


my_base.notSaveImages = ->
	tgt = $('.js-save')
	# image controls off
	tgt.on({
		mousedown: (e) ->
			e.preventDefault()
			return false
		contextmenu: (e) ->
			e.preventDefault()
			return false
		selectstart: (e) ->
			e.preventDefault()
			return false
	})


my_base.scrollTop = ->
	scrollToTop = {

		settings:
			startLine: 100
			scrollTo: 0
			scrollDuration: 200
			fadeDuration: [ 500, 100]

		controlHTML: '<img src="'+ROOT+'images/btn_totop.png">'

		controlAttrs:
			offsetx: 25
			offsety: 25
			title: 'Scroll Back to Top'
			class: 'btn-totop js-opac'

		anchorkeyword: '#top'

		state:
			isvisible:false
			shouldvisible:false


		scrollUp: ->
			if !this.cssfixedsupport
				this.$control.fadeOut('slow')

			dest = if isNaN(this.settings.scrollTo) then this.settings.scrollTo else parseInt(this.settings.scrollTo)

			if typeof dest is "string" and $('#'+dest).length is 1
				dest = $('#'+dest).offset().top
			else
				dest = 0
			this.$body.animate({ scrollTop: dest }, this.settings.scrollDuration);


		keepFixed: ->
			$window	= $(window).scrollTop()
			controlx = $window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx
			controly = $window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety
			this.$control.css({
				left:controlx+'px'
				top:controly+'px'
			});


		toggleControl: ->
			scrolltop = $(window).scrollTop();

			if !this.cssfixedsupport
				this.keepfixed();

			this.state.shouldvisible = if (scrolltop >= this.settings.startLine) then true else false

			if this.state.shouldvisible and !this.state.isvisible
				this.$control.stop().fadeIn(this.settings.fadeDuration[0])
				this.state.isvisible = true

			else if this.state.shouldvisible is false and this.state.isvisible
				this.$control.stop().fadeOut(this.settings.fadeDuration[1])
				this.state.isvisible = false


		init: ->
			mainObj = scrollToTop
			iebrws = document.all
			mainObj.cssfixedsupport = !iebrws or iebrws and document.compatMode is "CSS1Compat" and window.XMLHttpRequest;

			mainObj.$body = $(window.window.scrTgt)

			mainPos = if mainObj.cssfixedsupport then 'fixed' else 'absolute'

			mainObj.$control = $('<div id="topcontrol">'+mainObj.controlHTML+'</div>')
				.css({
					position: mainPos
					bottom: mainObj.controlAttrs.offsety
					right: mainObj.controlAttrs.offsetx
					display: 'none'
					cursor: 'pointer'
				})
				.attr({
					title: mainObj.controlAttrs.title
					class: mainObj.controlAttrs.class
				})
				.click( ->
					mainObj.scrollUp()
					return false
				)
				.appendTo('body')

			if document.all and !window.XMLHttpRequest and mainObj.$control.text() isnt ''
				mainObj.$control.css({
					width: mainObj.$control.width()
				})

			mainObj.toggleControl();

			$('a[href="'+mainObj.anchorkeyword+'"]').click( ->
				mainObj.scrollUp();
				return false;
			);

			$(window).bind('scroll resize', (e) ->
				mainObj.toggleControl();
			);
	} # scrollToTop
	scrollToTop.init()
