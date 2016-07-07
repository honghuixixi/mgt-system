<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <style type="text/css">

            	.zzsc {position:fixed;left: 50%;top:50px;margin-left:-400px;padding:34px;width:770px;height:500px;overflow-y:auto;overflow-x:auto; z-index:9999; display:none;background: #FFF}
				.zzsc:after {content:"";display: inline-block;vertical-align: middle;height: 100%;width: 0;background: #FFF}
				.content{display: inline-block; *display: inline; *zoom:1;	vertical-align: middle;}
				.content_mark{ width:100%; height:100%; position:fixed; left:0; top:0; z-index:555; background:#000; opacity:0.5;filter:alpha(opacity=50); display:none;}
            </style>
<title></title> 
[#include "/common/commonHead.ftl" /]
<link rel="stylesheet" media="screen"
	href="${base}/styles/css/base/css/index.css" />
<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<script src="${base}/scripts/lib/plugins/js/index.js"></script>
<!-- 在线客服弹出窗口 -->
<script src="${base}/scripts/lib/web-im/ymPrompt.js"></script>
<link rel="stylesheet" href="${base}/styles/css/web-im/css/ymPrompt.css" />
<script>
	var interVal;
	var msgCount = 0;
	$(function() {
		$("#setUrl").hover(
				function() {
					$("#setUrl img").attr("src",
							"${base}/styles/images/help_after.png");
				},
				function() {
					$("#setUrl img").attr("src",
							"${base}/styles/images/help_before.png");

				});
		$("dd").click(function(e) {
			e.stopPropagation();
			var id = $(this).attr('toHelp');
			$("#setUrl").attr("setUrl", id);
		});
		$("dl").click(function() {
			var id = $(this).attr('dltoHelp');
			$("#setUrl").attr("setUrl", id);
		});
		var onOff = true;
		$(".slide-btn").click(function() {
			if (onOff) {
				$(".menu-wrap").css("padding", "0px");
				$(".menu-wrap").animate({
					width : 20
				}, 500)
				$(".menu-wrap dl").hide();
				$(".slide-btn").html(">>");
				onOff = false;
			} else {
				$(".menu-wrap").css("padding-left", "20px");
				$(".menu-wrap").animate({
					width : 170
				}, 500)
				$(".menu-wrap dl").show();
				$(".slide-btn").html("<<");
				onOff = true;
			}

		});
		//每隔10秒加载离线消息数
		interVal = setInterval(ajaxOffLineMsgCount, 10000);
	});
	
	function ajaxOffLineMsgCount(){
		//获取当前用户环信离线信息
		$.ajax({
		   type: "POST",		   
		   url:  '${base}/easeMob/offlineMsgCount.jhtml',
		   async:false,
		   scope:this,
		   success: function(currentMsgCount){
			   if(currentMsgCount == 0){
				   msgCount = 0;
			   }
			   if(currentMsgCount > msgCount){
				   msgCount = currentMsgCount;
				   //TODO 消息提醒
				   msgCall();
			   }
			   if(currentMsgCount != 0){
				   $("#offLineMsgCount").html(currentMsgCount);
			   }else{
				   $("#offLineMsgCount").html("");
			   }
		   },
	       error:function(){
	    	   if(interVal != null){
	    		   window.clearInterval(interVal);
	    	   }
	       }
		});
	}
	
	//环信聊天页面
	function easeMobIndex(){
		mgt_util.showjBox({
			width :698,
			height : 560,
			title : '环信聊天',
			url : '${base}/easeMob/chatUI.jhtml'
		}); 
		//document.getElementById('chatDiv').style.display='block';
		//login();
	}
	
	//有新消息提醒
	function msgCall(){
		var div = document.getElementById('msgCallDiv');
		var url = "${base}/styles/css/web-im/msg.wav";
	    div.innerHTML = '<embed src="'+url+'" loop="false" autostart="true" scale="noscale" salign="TL" style="width:1px;height:1px;" />';
	}
	
	<!--在线客服-->
	function chatIframe(){
		ymPrompt.win({message:'${base}/easeMob/chatUI.jhtml',width:700,height:548,title:'即时通讯',handler:handler,maxBtn:false,minBtn:true,iframe:true,autoClose:false});
	}
	function handler(type){
		if(type="close"){
			var frames = window.frames;
			for(var i=0; i < frames.length; i++){
				if(frames[i]){
					try{
						window.frames[i].exit();
					}catch(e){
						continue;
					}
				}
			}
		}
	}
</script>
</head>
<body>
	
	<!-- header begin -->
	<div class="header-wrap">
		<div class="logo">
			<img src="${base}/styles/images/header_logo.png"
				onclick="backToHomePage();" />
		</div>
		<div id="setUrl" setUrl="0" class="r-info pull-right setUrl">
			<img src="${base}/styles/images/help_before.png"
				onclick="return backToHomePage111();" /><input hidden="true"
				value="" />
		</div>
		<div class="r-info pull-right">
			<div class="btn-group cmc" id="msgCallDiv"></div>
			<!-- <div class="btn-group cmc" style="color:white;" onclick="easeMobIndex()"><a>环信消息数：<span id="offLineMsgCount">0</span></a></div> -->
			<div class="btn-group cmc">
				<ul class="dropdown-menu" role="menu">
					<li><a href="#" data-toggle="modal"
						data-target="#choise_meeting_modal"><i
							class="glyphicon glyphicon-align-justify"></i> 切换</a></li>
					<li><a href="index.html" class="meeting_logout"><i
							class="icon-signout"></i> 退出</a></li>
				</ul>
			</div>
			<div class="btn-group">
				<button type="button" class="btn btn-success" style="margin-right:0;padding-right:0;">
					<i class="icon-user"></i> <span id="username_dis">系统管理员</span>
				</button>
				<button type="button" style="margin-left:0;" class="btn btn-success dropdown-toggle"
					data-toggle="dropdown">
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu" style="min-width:110px;">
					<li><a href="${base}/employee/employeeInfos.jhtml" target="mainIframe">个人信息</a></li>
							<li><a href="${base}/login/loginout.jhtml"><i
							class="icon-signout"></i> 注销 </a></li>
				</ul>
			</div>
		</div>
		<!---消息提醒-->
		<div class="message-mgtTop" onclick="chatIframe('${user.username}','${user.username}','')"><a href="#">环信消息<i></i></a><span id="offLineMsgCount"></span></div>
	</div>
	<!-- header end -->


	<!-- menu begin -->
	<!-- menu begin -->
	<!-- menu begin -->
	<div class="menu-wrap pull-left">

		[#if Session["mgt_user"]?exists] [#assign currentUser =
		Session["mgt_user"]] [#assign userAuthority =
		Session["user_authority_menu"]]

		<div class="slide-btn"><<</div>
		[#list userAuthority as menu]
		<dl dltoHelp="${menu.ID}" class="">
			<dt class="">
				<i class="right-icon">&gt;</i> ${menu.NAME}
			</dt>
			[#list menu.menuItems as menuItem]
			<dd toHelp="${menuItem.ID}">
				<a href="${base}${menuItem.URL}" class="" target="mainIframe"><i
					class="icon-minus"></i>&nbsp; ${menuItem.NAME}</a>
			</dd>
			[/#list]
		</dl>
		[/#list] [/#if]
	</div>
	<!-- menu end -->
	<!-- main begin -->

	<div class="main-wrap">
		<ul class="ifaNav-ul clearfix">
			<li class="cur"><a href="javascript:parent.location.reload();">首页</a></li>
			<!--<li><a href="#">系统管理</a><i class="close_x"></i></li>
				<li><a href="#">商户管理</a><i class="close_x"></i></li>
				<li><a href="#">供应商管理</a><i class="close_x"></i></li>
				<li><a href="#">运营管理</a><i class="close_x"></i></li>-->
		</ul>
		<iframe src="${base}/welcome/index.jhtml" id="mainIframe"
			name="mainIframe" scrolling="auto" width="100%"
			height="200px;background:#fff;" frameborder="0" noresize></iframe>
	</div>
	<!-- main end -->


	<!-- footer begin -->
	<div class="footer-wrap ">
		<p class="copyright text-right"></p>
		<div style="clear:both;"></div>
	</div>
	
	<script src='//kefu.easemob.com/webim/easemob.js?tenantId=18889&hide=false&sat=false' async='async'></script><script src='//kefu.easemob.com/webim/easemob.js?tenantId=18823&hide=false&sat=false' async='async'></script>
	
	<div class="changeWh_box">
		<div id="userInfo" style="float:left;line-height:35px;color:#fff;padding-left:20px;"></div>
		<div style="float:left;line-height:35px;color:#fff;padding-left:20px;">
			<div class="btn-group" id="changeWh" style="float:left;line-height:35px;color:#ff7708;padding-left:10px;cursor:pointer;">
				<a class="dropdown-toggle"  data-toggle="dropdown" href="#" style="float:left;line-height:35px;color:#ff7708;padding-left:10px;cursor:pointer;">
					[点击切换]
				</a>
				<ul class="dropdown-menu" id="whCs">
				</ul>
			</div>
		</div>
	</div>
	<!--  
        			<a class="jbox-close" style="position:absolute; display:block; cursor:pointer; " onmouseout="$(this).removeClass('jbox-close-hover');" onmouseover="$(this).addClass('jbox-close-hover');" title="关闭"></a>
        	-->
	<div class="zzsc_title jbox">
		<a
			style="position:absolute; display:block; cursor:pointer; top:2px; right:6px; width:15px; height:15px;"
			onmouseout="$(this).removeClass('jbox-close-hover');"
			onmouseover="$(this).addClass('jbox-close-hover');" title="关闭"
			class="jbox-close"></a>
	</div>
	<div class="zzsc">
			    <div id="popId"class="content">我是弹出层.谢谢.</div>
			</div>
			<div class="content_mark">我是遮盖.谢谢.</div>
	<script type="text/javascript">
		//加载仓库列表
		function initWhs(){
			$.ajax({
				url : '${base}/wh/getWhList.jhtml',
				type : 'post',
				dataType : 'json',
				success : function(data, status, jqXHR) {
					$("#username_dis").html(data.t);
					if (data && data.data) {
						var list = data.data;
						$("#username_dis").html(data.t);
						$("#whCs").html("");
						if(list.length<1){
							$("#changeWh").hide();
						}else{
							$("#userInfo").html("当前仓库："+data.msg);
							for(var i=0;i<list.length;i++){
								$("#whCs").append("<li><a class='whselect' value='"+list[i].WH_C+"'>"+list[i].NAME+"</a></li>");
							}
						}
					}else{
						$("#changeWh").hide();
					}
				}
			});
		}
		$(document).ready(function() {
			initWhs();
			$("#changeWh").click(function(){
				initWhs();
			});
			//选择仓库
			$("a.whselect").live("click",function(){
				$this = $(this);
				var whC = $this.attr("value");
				var name= $this.html();
				$.ajax({
					url : '${base}/wh/changeWhc.jhtml',
					type : 'post',
					dataType : 'json',
					data:{whC:whC},
					success : function(data, status, jqXHR) {
						document.getElementById('mainIframe').contentWindow.location.reload(true);
						$("#userInfo").html("当前仓库："+name);
					}
				});
			});
		});

		/*
		获取指定的URL参数值
		URL:http://www.blogjava.net/blog?name=bainian
		参数：paramName URL参数
		调用方法:getParam("name")
		返回值:bainian
		 */
		//1.
		function getParam(paramName) {
			paramValue = "";
			isFound = false;
			if (this.location.search.indexOf("?") == 0
					&& this.location.search.indexOf("=") > 1) {
				arrSource = unescape(this.location.search).substring(1,
						this.location.search.length).split("&");
				i = 0;
				while (i < arrSource.length && !isFound) {
					if (arrSource[i].indexOf("=") > 0)
						s
					{
						if (arrSource[i].split("=")[0].toLowerCase() == paramName
								.toLowerCase()) {
							paramValue = arrSource[i].split("=")[1];
							isFound = true;
						}
					}
					i++;
				}
			}
			return paramValue;
		}
		//点击LOGO图片回到HomePage
		function backToHomePage() {
			window.location.href = '${base}/manager/index.jhtml';

		}

		var date = new Date();
		var year = date.getFullYear();
		$(".copyright").html(" ©" + year + " 杭州物恋科技有限公司");

		function backToHomePage111() {
			var _id = $("#setUrl").attr("setUrl");
			if (_id == 0) {
				return false;
			}
			$.ajax({
				url : "${base}/mgt/mgtMenuHelp/" + _id + ".jhtml",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.mgtMenu.content != null) {
						$("#popId").html(" " + data.mgtMenu.content);
						$('.zzsc_title').show(0);
						$('.zzsc').show();
						$('.jbox-close').click(function() {
							$('.zzsc_title').hide(0);
							$('.zzsc').hide(0);
							$('.content_mark').hide(0);
						});
						$('.content_mark').show(0);
						$('.content_mark').click(function() {
							$('.zzsc').hide(0);
							$('.zzsc_title').hide(0);
							$('.content_mark').hide(0);
						});
					}

				}
			});
		}
	</script>
</body>
</html>
<script>
	window.onload = function() {
		var zzscDiv = document.getElementById('zzsc');
		zzscDiv.style.overflow = 'auto';
	}
</script>

