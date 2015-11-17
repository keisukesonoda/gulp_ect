var my_base, my_basics, my_init, my_initialization, sample;

$(document).on({
  ready: function() {
    my_initialization();
    my_basics();
    return sample.ready();
  }
});

$(window).on({
  load: function() {
    return sample.load();
  }
});

my_initialization = function() {
  my_init.changeTransitTarget();
  my_init.registEasing();
  my_init.getScrollTarget();
  return my_init.getUseragent();
};

my_basics = function() {
  my_base.notSaveImages();
  return my_base.scrollSection();
};

sample = {};

sample.ready = function() {
  return console.log('ready');
};

sample.load = function() {
  return console.log('load');
};

my_init = {};

my_init.changeTransitTarget = function() {
  if (!$.support.transition) {
    return $.fn.transition = $.fn.animate;
  }
};

my_init.registEasing = function() {
  return $.extend(jQuery.easing, {
    easeOutBack: function(x, t, b, c, d, s) {
      if (s === void 0) {
        s = 1.70158;
      }
      return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    },
    easeInOutBack: function(x, t, b, c, d, s) {
      if (s === void 0) {
        s = 1.70158;
      }
      if ((t /= d / 2) < 1) {
        return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
      }
      return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
    },
    easeInOutCubic: function(x, t, b, c, d) {
      if ((t /= d / 2) < 1) {
        return c / 2 * t * t * t + b;
      }
      return c / 2 * ((t -= 2) * t * t + 2) + b;
    }
  });
};

my_init.getScrollTarget = function() {
  var isHtmlScrollable;
  isHtmlScrollable = (function() {
    var elm, html, rs, top;
    html = $('html');
    top = html.scrollTop();
    elm = $('<div/>').height(10000).prependTo('body');
    html.scrollTop(10000);
    rs = !!html.scrollTop();
    html.scrollTop(top);
    elm.remove();
    return rs;
  })();
  return window.scrTgt = isHtmlScrollable ? 'html' : 'body';
};

my_init.getUseragent = function() {
  return window.UA = (function() {
    var ua;
    ua = window.navigator.userAgent.toLowerCase();
    return {
      TAB: ua.indexOf('windows') !== -1 && ua.indexOf('touch') !== -1 || ua.indexOf('android') !== -1 && ua.indexOf('mobile') === -1 || ua.indexOf('firefox') !== -1 && ua.indexOf('tablet') !== -1 || ua.indexOf('ipad') !== -1 || ua.indexOf('kindle') !== -1 || ua.indexOf('silk') !== -1 || ua.indexOf('playbook') !== -1,
      SP: ua.indexOf('windows') !== -1 && ua.indexOf('phone') !== -1 || ua.indexOf('android') !== -1 && ua.indexOf('mobile') !== -1 || ua.indexOf('firefox') !== -1 && ua.indexOf('mobile') !== -1 || ua.indexOf('iphone') !== -1 || ua.indexOf('ipod') !== -1 || ua.indexOf('blackberry') !== -1 || ua.indexOf('bb') !== -1,
      AD: ua.indexOf('android') !== -1,
      ltIE8: typeof window.addEventListener === 'undefined' && typeof document.getElementsByClassName === 'undefined'
    };
  })();
};

my_base = {};

my_base.scrollSection = function() {
  var tgt, trg;
  trg = $('.js-scrKey');
  tgt = $('.js-scrTgt');
  return trg.on('click', function(e) {
    var i, p;
    e.preventDefault();
    i = trg.index(this);
    p = tgt.eq(i).offset().top - 10;
    return $(window.window.scrTgt).animate({
      scrollTop: p
    }, 'fast');
  });
};

my_base.notSaveImages = function() {
  var tgt;
  tgt = $('.js-save');
  return tgt.on({
    mousedown: function(e) {
      e.preventDefault();
      return false;
    },
    contextmenu: function(e) {
      e.preventDefault();
      return false;
    },
    selectstart: function(e) {
      e.preventDefault();
      return false;
    }
  });
};

my_base.scrollTop = function() {
  var scrollToTop;
  scrollToTop = {
    settings: {
      startLine: 100,
      scrollTo: 0,
      scrollDuration: 200,
      fadeDuration: [500, 100]
    },
    controlHTML: '<img src="' + ROOT + 'images/btn_totop.png">',
    controlAttrs: {
      offsetx: 25,
      offsety: 25,
      title: 'Scroll Back to Top',
      "class": 'btn-totop js-opac'
    },
    anchorkeyword: '#top',
    state: {
      isvisible: false,
      shouldvisible: false
    },
    scrollUp: function() {
      var dest;
      if (!this.cssfixedsupport) {
        this.$control.fadeOut('slow');
      }
      dest = isNaN(this.settings.scrollTo) ? this.settings.scrollTo : parseInt(this.settings.scrollTo);
      if (typeof dest === "string" && $('#' + dest).length === 1) {
        dest = $('#' + dest).offset().top;
      } else {
        dest = 0;
      }
      return this.$body.animate({
        scrollTop: dest
      }, this.settings.scrollDuration);
    },
    keepFixed: function() {
      var $window, controlx, controly;
      $window = $(window).scrollTop();
      controlx = $window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx;
      controly = $window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety;
      return this.$control.css({
        left: controlx + 'px',
        top: controly + 'px'
      });
    },
    toggleControl: function() {
      var scrolltop;
      scrolltop = $(window).scrollTop();
      if (!this.cssfixedsupport) {
        this.keepfixed();
      }
      this.state.shouldvisible = scrolltop >= this.settings.startLine ? true : false;
      if (this.state.shouldvisible && !this.state.isvisible) {
        this.$control.stop().fadeIn(this.settings.fadeDuration[0]);
        return this.state.isvisible = true;
      } else if (this.state.shouldvisible === false && this.state.isvisible) {
        this.$control.stop().fadeOut(this.settings.fadeDuration[1]);
        return this.state.isvisible = false;
      }
    },
    init: function() {
      var iebrws, mainObj, mainPos;
      mainObj = scrollToTop;
      iebrws = document.all;
      mainObj.cssfixedsupport = !iebrws || iebrws && document.compatMode === "CSS1Compat" && window.XMLHttpRequest;
      mainObj.$body = $(window.window.scrTgt);
      mainPos = mainObj.cssfixedsupport ? 'fixed' : 'absolute';
      mainObj.$control = $('<div id="topcontrol">' + mainObj.controlHTML + '</div>').css({
        position: mainPos,
        bottom: mainObj.controlAttrs.offsety,
        right: mainObj.controlAttrs.offsetx,
        display: 'none',
        cursor: 'pointer'
      }).attr({
        title: mainObj.controlAttrs.title,
        "class": mainObj.controlAttrs["class"]
      }).click(function() {
        mainObj.scrollUp();
        return false;
      }).appendTo('body');
      if (document.all && !window.XMLHttpRequest && mainObj.$control.text() !== '') {
        mainObj.$control.css({
          width: mainObj.$control.width()
        });
      }
      mainObj.toggleControl();
      $('a[href="' + mainObj.anchorkeyword + '"]').click(function() {
        mainObj.scrollUp();
        return false;
      });
      return $(window).bind('scroll resize', function(e) {
        return mainObj.toggleControl();
      });
    }
  };
  return scrollToTop.init();
};
