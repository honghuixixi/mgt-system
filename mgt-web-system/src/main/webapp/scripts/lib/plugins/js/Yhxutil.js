Yhxutil = {
    /**
     * The version of the framework
     * @type String
     */
    version : '1.0.0',
    versionDetail : {
        major : 1,
        minor : 0,
        patch : 0
    }
};
Yhxutil.apply = function(o, c, defaults){
    // no "this" reference for friendly out of scope calls
    if(defaults){
        Yhxutil.apply(o, defaults);
    }
    if(o && c && typeof c == 'object'){
        for(var p in c){
            o[p] = c[p];
        }
    }
    return o;
};
(function(){
    var idSeed = 0,
        toString = Object.prototype.toString,
        ua = navigator.userAgent.toLowerCase(),
        check = function(r){
            return r.test(ua);
        },
        DOC = document,
        docMode = DOC.documentMode,
        isStrict = DOC.compatMode == "CSS1Compat",
        isOpera = check(/opera/),
        isChrome = check(/\bchrome\b/),
        isWebKit = check(/webkit/),
        isSafari = !isChrome && check(/safari/),
        isIE = !isOpera && check(/msie/),
        isIE7 = isIE && (check(/msie 7/) || docMode == 7),
        isIE8 = isIE && (check(/msie 8/) && docMode != 7),
        isIE9 = isIE && check(/msie 9/),
        isIE6 = isIE && !isIE7 && !isIE8 && !isIE9,
        isGecko = !isWebKit && check(/gecko/),
        isGecko2 = isGecko && check(/rv:1\.8/),
        isGecko3 = isGecko && check(/rv:1\.9/),
        isBorderBox = isIE && !isStrict,
        isWindows = check(/windows|win32/),
        isMac = check(/macintosh|mac os x/),
        isLinux = check(/linux/),
        isSecure = /^https/i.test(window.location.protocol);

    // remove css image flicker
    if(isIE6){
        try{
            DOC.execCommand("BackgroundImageCache", false, true);
        }catch(e){}
    }

    Yhxutil.apply(Yhxutil, {
	   	/**
	     * 动态加载文件到doc中，并依据obj来设置属性，加载成功后执行回调函数fn
	     * @name loadFile
	     * @grammar Yhxutil.loadFile(doc,obj)
	     * @grammar Yhxutil.loadFile(doc,obj,fn)
	     * @example
	     * //指定加载到当前document中一个script文件，加载成功后执行function
	     * Yhxutil.loadFile( document, {
	     *     src:"test.js",
	     *     tag:"script",
	     *     type:"text/javascript",
	     *     defer:"defer"
	     * }, function () {
	     *     console.log('加载成功！')
	     * });
	     */
	    loadFile:function () {
		        var tmpList = [];
		        function getItem(doc,obj){
		            try{
		                for(var i= 0,ci;ci=tmpList[i++];){
		                    if(ci.doc === doc && ci.url == (obj.src || obj.href)){
		                        return ci;
		                    }
		                }
		            }catch(e){
		                return null;
		            }
		
		        }
		        return function (doc, obj, fn) {
		            var item = getItem(doc,obj);
		            if (item) {
		                if(item.ready){
		                    fn && fn();
		                }else{
		                    item.funs.push(fn)
		                }
		                return;
		            }
		            tmpList.push({
		                doc:doc,
		                url:obj.src||obj.href,
		                funs:[fn]
		            });
		            if (!doc.body) {
		                var html = [];
		                for(var p in obj){
		                    if(p == 'tag')continue;
		                    html.push(p + '="' + obj[p] + '"')
		                }
		                doc.write('<' + obj.tag + ' ' + html.join(' ') + ' ></'+obj.tag+'>');
		                return;
		            }
		            if (obj.id && doc.getElementById(obj.id)) {
		                return;
		            }
		            var element = doc.createElement(obj.tag);
		            delete obj.tag;
		            for (var p in obj) {
		                element.setAttribute(p, obj[p]);
		            }
		            element.onload = element.onreadystatechange = function () {
		                if (!this.readyState || /loaded|complete/.test(this.readyState)) {
		                    item = getItem(doc,obj);
		                    if (item.funs.length > 0) {
		                        item.ready = 1;
		                        for (var fi; fi = item.funs.pop();) {
		                            fi();
		                        }
		                    }
		                    element.onload = element.onreadystatechange = null;
		                }
		            };
		            element.onerror = function(){
		                throw Error('The load '+(obj.href||obj.src)+' fails,check the url settings of file editor_config.js ')
		            };
		            doc.getElementsByTagName("head")[0].appendChild(element);
		        }
		    }(),
    	
    	emptyFn : function(){},
    	
        applyIf : function(o, c){
            if(o){
                for(var p in c){
                    if(!Yhxutil.isDefined(o[p])){
                        o[p] = c[p];
                    }
                }
            }
            return o;
        },
        
         /**
         * Generates unique ids. If the element already has an id, it is unchanged
         * @param {Mixed} el (optional) The element to generate an id for
         * @param {String} prefix (optional) Id prefix (defaults "Yhxutil-gen")
         * @return {String} The generated Id.
         */
        id : function(el, prefix){
            return (prefix || "Yhxutil-gen") + (++idSeed);
        },
      
        extend : function(){
            // inline overrides
            var io = function(o){
                for(var m in o){
                    this[m] = o[m];
                }
            };
            var oc = Object.prototype.constructor;

            return function(sb, sp, overrides){
                if(typeof sp == 'object'){
                    overrides = sp;
                    sp = sb;
                    sb = overrides.constructor != oc ? overrides.constructor : function(){sp.apply(this, arguments);};
                }
                var F = function(){},
                    sbp,
                    spp = sp.prototype;

                F.prototype = spp;
                sbp = sb.prototype = new F();
                sbp.constructor=sb;
                sb.superclass=spp;
                if(spp.constructor == oc){
                    spp.constructor=sp;
                }
                sb.override = function(o){
                    Yhxutil.override(sb, o);
                };
                sbp.superclass = sbp.supr = (function(){
                    return spp;
                });
                sbp.override = io;
                Yhxutil.override(sb, overrides);
                sb.extend = function(o){return Yhxutil.extend(sb, o);};
                return sb;
            };
        }(),

        override : function(origclass, overrides){
            if(overrides){
                var p = origclass.prototype;
                Yhxutil.apply(p, overrides);
                if(Yhxutil.isIE && overrides.hasOwnProperty('toString')){
                    p.toString = overrides.toString;
                }
            }
        },
        
        namespace : function(){
            var len1 = arguments.length,
                i = 0,
                len2,
                j,
                main,
                ns,
                sub,
                current;
                
            for(; i < len1; ++i) {
                main = arguments[i];
                ns = arguments[i].split('.');
                current = window[ns[0]];
                if (current === undefined) {
                    current = window[ns[0]] = {};
                }
                sub = ns.slice(1);
                len2 = sub.length;
                for(j = 0; j < len2; ++j) {
                    current = current[sub[j]] = current[sub[j]] || {};
                }
            }
            return current;
        },
        toArray : function(){
             return isIE ?
                 function(a, i, j, res){
                     res = [];
                     for(var x = 0, len = a.length; x < len; x++) {
                         res.push(a[x]);
                     }
                     return res.slice(i || 0, j || res.length);
                 } :
                 function(a, i, j){
                     return Array.prototype.slice.call(a, i || 0, j || a.length);
                 };
         }(),
         
        each: function(array, fn, scope) {
            if (Yhxutil.isEmpty(array, true)) {
                return;
            }
            if (!Yhxutil.isIterable(array) || Yhxutil.isPrimitive(array)) {
                array = [array];
            }
            for (var i = 0, len = array.length; i < len; i++) {
                if (fn.call(scope || array[i], array[i], i, array) === false) {
                    return i;
                };
            }
        },
        
        isIterable : function(v){
            //check for array or arguments
            if(Yhxutil.isArray(v) || v.callee){
                return true;
            }
            //check for node list type
            if(/NodeList|HTMLCollection/.test(toString.call(v))){
                return true;
            }
            //NodeList has an item and length property
            //IXMLDOMNodeList has nextNode method, needs to be checked first.
            return ((typeof v.nextNode != 'undefined' || v.item) && Yhxutil.isNumber(v.length));
        },
        
         /**
         * Returns true if the passed value is a JavaScript 'primitive', a string, number or boolean.
         * @param {Mixed} value The value to test
         * @return {Boolean}
         */
        isPrimitive : function(v){
            return Yhxutil.isString(v) || Yhxutil.isNumber(v) || Yhxutil.isBoolean(v);
        },
        
        isEmpty : function(v, allowBlank){
            return v === null || v === undefined || ((Yhxutil.isArray(v) && !v.length)) || (!allowBlank ? v === '' : false);
        },
        
        /**
         * 避免传递的字符串参数被正则表达式读取
         */
        escapeRe : function(s) {
            return s.replace(/([-.*+?^${}()|[\]\/\\])/g, "\\$1");
        },

        /**
         * 验证某个值是否数字的一个辅助方法，若不是，返回指定的缺省值
         */
        num : function(v, defaultValue){
            v = Number(Ext.isEmpty(v) || Ext.isArray(v) || typeof v == 'boolean' || (typeof v == 'string' && v.trim().length == 0) ? NaN : v);
            return isNaN(v) ? defaultValue : v;
        },
        /**
         * 返回true表名送入的对象是JavaScript的array类型对象，否则为false。
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isArray : function(v){
            return toString.apply(v) === '[object Array]';
        },

        /**
         * 返回true表名送入的对象是JavaScript的date类型对象，否则为false。
         * @param {Object} 要测试的对象
         * @return {Boolean}
         */
        isDate : function(v){
            return toString.apply(v) === '[object Date]';
        },

        /**
         * 返回true表名送入的对象是JavaScript的Object类型对象，否则为false。
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isObject : function(v){
            return !!v && Object.prototype.toString.call(v) === '[object Object]';
        },

        /**
         * 返回true表名送入的对象是JavaScript的Function类型对象，否则为false。
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isFunction : function(v){
            return toString.apply(v) === '[object Function]';
        },

        /**
         * 返回true表名送入的对象是JavaScript的Number类型对象,否则为false
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isNumber : function(v){
            return typeof v === 'number' && isFinite(v);
        },

        /**
         * 返回true表名送入的对象是JavaScript的String类型对象
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isString : function(v){
            return typeof v === 'string';
        },

        /**
         * 返回true表名送入的对象是JavaScript的Boolean类型对象
         * @param {Mixed} 要测试的对象
         * @return {Boolean}
         */
        isBoolean : function(v){
            return typeof v === 'boolean';
        },

        /**
         * 返回true表名送入的对象是JavaScript的undefined类型对象
         * @param {Mixed}  要测试的对象
         * @return {Boolean}
         */
        isDefined : function(v){
            return typeof v !== 'undefined';
        },

        PATH :"",
        isStrict: isStrict,
        
        /**
         * 如果是TRUE则是Opera
         * @type Boolean
         */
        isOpera : isOpera,
        /**
         * 如果是TRUE则是WebKit
         * @type Boolean
         */
        isWebKit : isWebKit,
        /**
         * 如果是TRUE则是Chrome
         * @type Boolean
         */
        isChrome : isChrome,
        /**
         * 如果是TRUE则是Safari
         * @type Boolean
         */
        isSafari : isSafari,
        /**
         * 如果是TRUE则是Internet Explorer.
         * @type Boolean
         */
        isIE : isIE,
        /**
         * 如果是TRUE则是Internet Explorer 6.x.
         * @type Boolean
         */
        isIE6 : isIE6,
        /**
         * 如果是TRUE则是Internet Explorer 7.x.
         * @type Boolean
         */
        isIE7 : isIE7,
        /**
         * 如果是TRUE则是Internet Explorer 8.x.
         * @type Boolean
         */
        isIE8 : isIE8,
        /**
         * 如果是TRUE则是Internet Explorer 9.x.
         * @type Boolean
         */
        isIE9 : isIE9,
        /**
         * True if the detected browser uses the Gecko layout engine (e.g. Mozilla, Firefox).
         * @type Boolean
         */
        isGecko : isGecko,
        /**
         * True if the detected browser uses a pre-Gecko 1.9 layout engine (e.g. Firefox 2.x).
         * @type Boolean
         */
        isGecko2 : isGecko2,
        /**
         * True if the detected browser uses a Gecko 1.9+ layout engine (e.g. Firefox 3.x).
         * @type Boolean
         */
        isGecko3 : isGecko3,
        /**
         * True if the detected browser is Internet Explorer running in non-strict mode.
         * @type Boolean
         */
        isBorderBox : isBorderBox,
        /**
         *如果是TRUE则是Linux.
         * @type Boolean
         */
        isLinux : isLinux,
        /**
         * 如果是TRUE则是Windows.
         * @type Boolean
         */
        isWindows : isWindows,
        /**
         * 如果是TRUE则是Mac OS.
         * @type Boolean
         */
        isMac : isMac
    });
    Yhxutil.ns = Yhxutil.namespace;
})();


Yhxutil.JSON = new (function(){
    var useHasOwn = !!{}.hasOwnProperty,
        pad = function(n) {
            return n < 10 ? "0" + n : n;
        },
        doDecode = function(json){
            return eval("(" + json + ')');    
        },
        doEncode = function(o){
        	var toString = Object.prototype.toString;
            if(!(typeof o !== 'undefined') || o === null){
                return "null";
            }else if(toString.apply(o) === '[object Array]'){
                return encodeArray(o);
            }else if(toString.apply(o) === '[object Date]'){
                return Yhxutil.JSON.encodeDate(o);
            }else if(typeof o === 'string'){
                return encodeString(o);
            }else if(typeof o == "number"){
                return isFinite(o) ? String(o) : "null";
            }else if(typeof o === 'boolean'){
                return String(o);
            }else {
                var a = ["{"], b, i, v;
                for (i in o) {
                    // don't encode DOM objects
                    if(!o.getElementsByTagName){
                        if(!useHasOwn || o.hasOwnProperty(i)) {
                            v = o[i];
                            switch (typeof v) {
                            case "undefined":
                            case "function":
                            case "unknown":
                                break;
                            default:
                                if(b){
                                    a.push(',');
                                }
                                a.push(doEncode(i), ":",
                                        v === null ? "null" : doEncode(v));
                                b = true;
                            }
                        }
                    }
                }
                a.push("}");
                return a.join("");
            }    
        },
        m = {
            "\b": '\\b',
            "\t": '\\t',
            "\n": '\\n',
            "\f": '\\f',
            "\r": '\\r',
            '"' : '\\"',
            "\\": '\\\\'
        },
        encodeString = function(s){
            if (/["\\\x00-\x1f]/.test(s)) {
                return '"' + s.replace(/([\x00-\x1f\\"])/g, function(a, b) {
                    var c = m[b];
                    if(c){
                        return c;
                    }
                    c = b.charCodeAt();
                    return "\\u00" +
                        Math.floor(c / 16).toString(16) +
                        (c % 16).toString(16);
                }) + '"';
            }
            return '"' + s + '"';
        },
        encodeArray = function(o){
            var a = ["["], b, i, l = o.length, v;
                for (i = 0; i < l; i += 1) {
                    v = o[i];
                    switch (typeof v) {
                        case "undefined":
                        case "function":
                        case "unknown":
                            break;
                        default:
                            if (b) {
                                a.push(',');
                            }
                            a.push(v === null ? "null" : Yhxutil.JSON.encode(v));
                            b = true;
                    }
                }
                a.push("]");
                return a.join("");
        };
    this.encodeDate = function(o){
        return '"' + o.getFullYear() + "-" +
                pad(o.getMonth() + 1) + "-" +
                pad(o.getDate()) + "T" +
                pad(o.getHours()) + ":" +
                pad(o.getMinutes()) + ":" +
                pad(o.getSeconds()) + '"';
    };

    this.encode = function() {
        var ec;
        return function(o) {
            if (!ec) {
                // setup encoding function on first access
                ec = doEncode;
            }
            return ec(o);
        };
    }();

    this.decode = function() {
        var dc;
        return function(json) {
            if (!dc) {
                dc = doDecode;
            }
            return dc(json);
        };
    }();

})();

Yhxutil.encode = Yhxutil.JSON.encode;
Yhxutil.decode = Yhxutil.JSON.decode;
Yhxutil.PATH = '${_project.envRoot}';