(function ($) {
    "use strict";

    if (!$.browser) {
        $.browser = {};
        $.browser.mozilla = /mozilla/.test(navigator.userAgent.toLowerCase()) && !/webkit/.test(navigator.userAgent.toLowerCase());
        $.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
        $.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
        $.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
    }
    $(window).on("resize", function () {
        if ($this != null) iframe_resize($this);
        return (this);
    });
    var $this = null;
    var settings = {
        para1: "abc",
        para2: "xyz"
    };
    var methods = {
        resize: function () {
            if ($this != null) iframe_resize($this);
        },
        init: function () {
            if (typeof (options) == "object") {
                settings = $.extend(settings, options);
            }
            if (this.length == 0) return;
            if ($(this)[0].nodeName == "IFRAME") {
                $this = $(this);
                $this.css("margin", "0px");
                $this.css("padding", "0px");
                iframe_resize($this);
                //$($this[0].contentWindow.document.body).css("overflow", "auto");        // 子ウインドのスクロールバー有効
                //$(document.body).css("overflow", "hidden");                             // 親ウインドのスクロールバー無効
            }
        }
    }
    function iframe_resize(o) {
        //return (false);
        var o1 = $(o);
        //o1 = $(".iframe_content");
        var top = 0;               // border-top の幅
        var left = 0;
        var baseY = 0;
        var baseX = 0;
        var className = "";
        var id_name = "";
//        o1[0].offssetTop;
        $(o1).each(function (i, elem) {
            top = elem.clientTop;               // border-top の幅
            left = elem.clientLeft;
            baseY = elem.offsetTop;
            baseX = elem.offsetLeft;
            className = elem.className;
            id_name = elem.id;
            if (baseY != 0) {
                //$.debug(id_name,$(elem).css("border-width") );
                return(false);
            }
        })
        //$.debug(id_name, window.innerHeight, window.innerWidth, top, left, baseY, baseX);
        $(o1).each(function (i, elem) {
            var height = window.innerHeight - (baseY + (top * 1) + left);
            var width = window.innerWidth - (baseX + (left * 2));
            height -= 1;
            width -= 1;
            $(elem).css("height", height).css("width", width);
        })
    }

    $.fn.frame = function (method) {
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof method === "object" || !method) {
            return methods.init.apply(this, arguments);
        } else {
            $.error("Method " + method + " does not exist on jQuery.my.frame");
        }
    };

})(window.jQuery);
