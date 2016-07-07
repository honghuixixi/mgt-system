<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>用户登录</title>
            [#include "/common/commonHead.ftl" /]
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<meta name="viewport" content="width=device-width,minimum-scale=1,user-scalable=no,maximum-scale=1,initial-scale=1">
			<meta name="apple-mobile-web-app-capable" content="yes">
			<meta name="apple-mobile-web-app-status-bar-style" content="black">
			<meta name="format-detection" content="telephone=no">
			<link href="css.css" rel="stylesheet" type="text/css">
			<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<style type="text/css">
*{padding: 0;margin:0;} *, *:before, *:after { -webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box; } input, button, select, textarea{outline:none} body{font:12px/1.125 Arial,Helvetica,sans-serif; color: #676767; background:url(${base}/styles/images/login_bg.gif) #fff repeat-x;} #page{ width: 1024px;padding:20px 0; min-height:580px; height:auto!important; height:580px;height: 580px; position: relative; margin:0 auto; background: url(${base}/styles/images/bg.jpg) no-repeat ; } .logo_box{ text-align: center; } .logo_box img{ width:160px; } .content{ position: absolute; top:240px;left:632px;width: 100%; max-width: 220px; padding: 10px 0; } .con{padding:10px 0;} .form-group input{padding:10px;font-size: 14px;border:none 0;background:none;width:100%;} .input_box{margin-top: 10px;} .form-group{ margin-bottom: 15px;margin-right:15px;} .form-group label{ font-size: 16px; font-weight: bold;color:#ef7904; } .select{ padding:20px 0; margin-top: -10px; overflow:hidden;line-height:20px;}.select span{padding:0 40px 0 5px;} .select  a{color:#676767;}.check_input{ vertical-align: middle;float:left; } .btn_login{ font-size: 14px; font-weight: bold; line-height:38px; text-align: center; background:url(${base}/styles/images/login_btn.png) no-repeat; color: #fff; display: block; width: 90px; text-decoration: none;height:38px;border:none 0; } #wapper{ position: relative; }.form-group .mar-top{margin-top:40px;}.error_msg{position:absolute;top:342px;left:632px;color: #f00; text-align:right;}
</style>
<script>
window.onload = function(){
	PlaceHolder.init();
};
</script>
</head>
<body>
<div id="wapper">
    <div id="page">
       	<a class="login_logoBoxa" href="http://www.11wlw.cn/"><img src="${base}/styles/images/login_logo.png" width="211" height="41" /></a>
        <div  class="content">
            <div class="logo_box">
            	<!--<img src="${base}/styles/images/logo.png" />-->
            </div>    
            <div class="box">
                <div class="con">
                <form  role="form" method="post" id="loginForm"	autocomplete="off" action="${base}/login/logindo.jhtml">
                    <div class="form-group">
                        <label for="username">用户登录</label>
                        <div class="input_box"> <input type="text"  id="accountName" name="accountName" class=" required " value=""  placeholder="请输入用户名"></div>
                    </div>
                    <div class="form-group">
                        <!--<label for="password">密码:</label>-->
                        <div class="input_box mar-top">
                         <input type="password" id="password" name="password" value=""  class=" required " placeholder="请输入密码">
                        </div>
                    </div>
                    <div class="select">
                        <label>
                            <input type="checkbox" checked class="check_input"> <span>记住密码</span><a href="#">忘记密码？</a>
                        </label>
                    </div>
                    <div style="padding-left:40px;">
						<button class="btn_login" style="display:inline;" type="submit" >登&nbsp;录</button>
						<!--<button class="btn_login" style="display:inline;" type="button" onclick="merchantRegister();">商户入驻</button>-->
                    </div>
                     </form>
                </div>            
            </div>
        </div>
        
		[#if errorinfo??]
		[#if errorinfo.success==false]
			<div class="error_msg">
				<center>
					${errorinfo.msg}
				</center>
			</div>
		[/#if]
		[/#if]
        
    </div>
</div>
<script type="text/javascript">
var H=document.documentElement.clientHeight;
var o=document.getElementById('wapper');
function auto(){
	if(H>630){
		o.style.top=(H-630)/2+'px';
	}
}

//auto();
window.onresize=function(){
	H=document.documentElement.clientHeight;
	setTimeout(function(){auto()},300);
}
$(document).ready(function() {
	if(window.top==window.self){//不存在父页面
		
	}else{
		top.window.document.location.href = window.document.location.href;
	}
});
function merchantRegister(){
	alert("请联系管理员");
}
var PlaceHolder = {
    _support: (function() {
        return 'placeholder' in document.createElement('input');
    })(),

    //提示文字的样式，需要在页面中其他位置定义
    className: 'abc',

    init: function() {
        if (!PlaceHolder._support) {
            //未对textarea处理，需要的自己加上
            var inputs = document.getElementsByTagName('input');
            PlaceHolder.create(inputs);
        }
    },

    create: function(inputs) {
        var input;
        if (!inputs.length) {
            inputs = [inputs];
        }
        for (var i = 0, length = inputs.length; i <length; i++) {
            input = inputs[i];
            if (!PlaceHolder._support && input.attributes && input.attributes.placeholder) {
                PlaceHolder._setValue(input);
                input.addEventListener('focus', function(e) {
                    if (this.value === this.attributes.placeholder.nodeValue) {
                        this.value = '';
                        this.className = '';
                    }
                }, false);
                input.addEventListener('blur', function(e) {
                    if (this.value === '') {
                        PlaceHolder._setValue(this);
                    }
                }, false);
            }
        }
    },

    _setValue: function(input) {
        input.value = input.attributes.placeholder.nodeValue;
        input.className = PlaceHolder.className;
    }
};
</script>
</body>
</html>