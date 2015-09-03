$(document).on({
	ready: ->
		if !$.support.transition
		# transitionに対応していなければanimate
			$.fn.transition = $.fn.animate;

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

		console.log 'ready'


		# basic functions
		basic.notSaveImages()
		basic.scrollSection()
		basic.scrollTop()
})


$(window).on({
	load: ->
		console.log 'load'
})












basic = {}
basic.scrollSection = ->
	trg = $('.js-scrKey')
	tgt = $('.js-scrTgt')

	trg.on('click', (e) ->
		e.preventDefault()
		i = trg.index(this)
		p = tgt.eq(i).offset().top - 10
		$(window.window.scrTgt).animate({ scrollTop: p }, 'fast')
	)


basic.notSaveImages = ->
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


basic.scrollTop = ->
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
