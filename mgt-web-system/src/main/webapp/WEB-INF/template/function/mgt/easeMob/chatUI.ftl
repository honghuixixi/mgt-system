<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0"/>
	<title>环信登陆页</title>
	<link rel="stylesheet" href="${base}/styles/css/web-im/css/bootstrap.css" />
	<link rel="stylesheet" href="${base}/styles/css/web-im/css/webim.css" />
  	<!--sdk-->
	<script src="${base}/scripts/lib/web-im/sdk/strophe.js"></script>
	<script src="${base}/scripts/lib/web-im/sdk/easemob.im-1.1.js"></script>
	<!--兼容老版本sdk需引入此文件-->
	<script src="${base}/scripts/lib/web-im/sdk/easemob.im-1.1.shim.js"></script>
	<script src="${base}/scripts/lib/web-im/easemob.im.config.js"></script>
	<script src="${base}/scripts/lib/web-im/jquery-1.11.1.js"></script>
	<script src="${base}/scripts/lib/web-im/bootstrap.js"></script>
	<script src="${base}/scripts/lib/web-im/webim.js"></script>
	<style type="text/css">
		.chatDiv {
			/* z-index:99;
			width: 700px;
			height: 400px;
			left:300px;
			top: 50px;
			
			position:fixed!important;
			position:absolute;
			
			_top:       expression(eval(document.compatMode &&
			            document.compatMode=='CSS1Compat') ?
			            documentElement.scrollTop + (document.documentElement.clientHeight-this.offsetHeight)/2 :
			            document.body.scrollTop + (document.body.clientHeight - this.clientHeight)/2); */
			
		}
	</style>
	
	<script type="text/javascript">
		$(function(){
			login();
		});
		function closeDiv(){
			document.getElementById('chatDiv').style.display='none';
			logout();
		}
		function exit(){
			logout();
			window.parent.ymPrompt.close();
		}
	</script>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;">
	<input type="hidden" name="basepath" value="${base}" id="basepath"/>
	<input type="hidden" name="currentUserName" value="${mgtEmployee.userName}" id="currentUserName"/>
	<input type="hidden" name="username" value="${username}" id="username"/>
	<input type="hidden" name="password" value="${username}" id="password"/>
	<div id="chatDiv" style="display:block;margin-left:-2px;" class="chatDiv">
		<div id="waitLoginmodal" class="modal hide" data-backdrop="static">
	        <img src="${base}/styles/css/web-im/img/waitting.gif">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;正在努力加载中...</img>
	    </div>
	    <!--<div class="content" id="content" style="display: block">-->
	    <div class="chat-window clearfix" id="content" style="display: block;margin:auto;">
	    	<!-- <div class="close-cartBtn" onclick="closeDiv()"></div> -->
	        <div class="leftcontact" id="leftcontact">
	            <div id="headerimg" class="leftheader" style="width:196px;">
	                <span> 
	                	<img
	                	[#if headImg??]
	                		src="${headImg}" 
	                	[#else]
	                		src="${base}/styles/css/web-im/img/head/header4.gif" 
	                	[/#if] 
	                	alt="logo" class="img-circle" style="width:43px;height:43px;position:absolute;top:0px;left:8px;" />
	                </span>
	                <span id="login_user" class="login_user_title" style="padding-left:55px;width:130px;"> 
	                    <a style="width:100px;text-align:left;" class="leftheader-font" href="#"></a>
	                </span>
	                <span class="btn-inverseNew-box">
	                    <div class="btn-group" style="margin-left: -20px;margin-top:-35px;">
	                        <button class="btn-inverseNew" data-toggle="dropdown">
	                            <span class="caret mt-t5"></span>
	                        </button>
	                        <ul class="dropdown-menu" style="min-width:100px;">
	                            <li><a href="javascript:;" onclick="showAddFriend()">添加好友</a></li>
	                            <li><a href="javascript:;" onclick="showDelFriend()">删除好友</a></li>
	                            <!-- <li class="divider"></li>
	                            <li><a href="javascript:;" onclick="logout();return false;">退出</a></li> -->
	                        </ul>
	                    </div>
	                </span>
	            </div>
	            <div id="contractlist11" style="height: 497px;overflow-y: auto; overflow-x: auto;">
	                <div class="accordion" id="accordionDiv">
	                    <div class="accordion-group">
	                        <div class="accordion-heading">
	                            <a id="accordion1" class="accordion-toggle" data-toggle="collapse" data-parent="#accordionDiv" href="#collapseOne">我的好友 </a>
	                        </div>
	                        <div id="collapseOne" class="accordion-body collapse in">
	                            <div class="accordion-inner" id="contractlist">
	                                <ul id="contactlistUL" class="chat03_content_ul">
	                                	<!-- <li class="cur"><a href="#"><img src="static/img/listCart-img.jpg" width="30" height="30" /><span>筱小小</span></a></li>
	                                    <li><a href="#"><img src="static/img/listCart-img.jpg" width="30" height="30" /><span>筱小小</span></a></li> -->
	                                </ul>
	                            </div>
	                        </div>
	                    </div>
	                    <div class="accordion-group">
	                        <div class="accordion-heading">
	                            <a id="accordion2" class="accordion-toggle collapsed"
	                                data-toggle="collapse" data-parent="#accordionDiv"
	                                href="#collapseTwo">我的群组</a>
	                        </div>
	                        <div id="collapseTwo" class="accordion-body collapse">
	                            <div class="accordion-inner" id="contracgrouplist">
	                                <ul id="contracgrouplistUL" class="chat03_content_ul"></ul>
	                            </div>
	                        </div>
	                    </div>
	                    <div class="accordion-group">
	                        <div class="accordion-heading">
	                            <a id="accordion3" class="accordion-toggle collapsed"
	                                data-toggle="collapse" data-parent="#accordionDiv"
	                                href="#collapseThree">陌生人</a>
	                        </div>
	                        <div id="collapseThree" class="accordion-body collapse">
	                            <div class="accordion-inner" id="momogrouplist">
	                                <ul id="momogrouplistUL" class="chat03_content_ul"></ul>
	                            </div>
	                        </div>
	                    </div>
						<div id='em-cr' class="accordion-group">
	                        <div class="accordion-heading">
	                            <a id="accordion4" class="accordion-toggle collapsed"
	                                data-toggle="collapse" data-parent="#accordionDiv"
	                                href="#collapseFour">聊天室</a>
	                        </div>
	                        <div id="collapseFour" class="accordion-body collapse">
	                            <div class="accordion-inner" id="chatRoomList">
	                                <ul id="chatRoomListUL" class="chat03_content_ul"></ul>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	
	            </div>
	        </div>
	        <!--<div id="rightTop" style="height: 78px;"></div>-->
	        <!-- 聊天页面 -->
	        <div class="chatRight">
	            <div id="chat01">
	                <div class="chat01_title">
	                    <ul class="talkTo">
	                        <!-- <li id="talkTo"><span>与筱小小聊天中</span></li> -->
	                        <li id="talkTo"><a href="#"></a></li>
	                        <li id="recycle" style="float: right;"><img src="${base}/styles/css/web-im/img/recycle.png" onclick="clearCurrentChat();" style="margin-right: 15px; cursor: hand; width:14px;height:16px;" title="清屏" /></li>
	                        <li id="roomInfo" style="float: right;"><img id="roomMemberImg" src="${base}/styles/css/web-im/img/head/find_more_friend_addfriend_icon.png" onclick="showRoomMember();" style="margin-right: 15px; cursor: hand; width: 18px; display: none" title="成员" /></li>
	                    </ul>
	                </div>
	                <div id="null-nouser" class="chat01_content"></div>
	            </div>
	
	            <div class="chat02">
	                <div class="chat02_title">
	                    <a class="chat02_title_btn ctb01" onclick="showEmotionDialog()" title="选择表情"></a>
						<input id='sendPicInput' style='display:none'/>
						<a class="chat02_title_btn ctb03" title="选择图片" onclick="send()" type='img' href="#"></a>
						<input id='sendAudioInput' style='display:none'/>
						<a class="chat02_title_btn ctb02" title="选择语音" onclick="send()" href="#" type='audio'></a>
						<!--<input id='sendFileInput' class='emim-hide'/>
						<a class="chat02_title_btn ctb04" title="选择文件" onclick="send()" href="#"></a>-->
						<label id="chat02_title_t"></label>
	                    <div id="wl_faces_box" class="wl_faces_box">
	                        <div class="wl_faces_content">
	                            <div class="title">
	                                <ul>
	                                    <li class="title_name">常用表情</li>
	                                    <li class="wl_faces_close"><span
	                                        onclick='turnoffFaces_box()'>&nbsp;</span></li>
	                                </ul>
	                            </div>
	                            <div id="wl_faces_main" class="wl_faces_main">
	                                <ul id="emotionUL">
	                                </ul>
	                            </div>
	                        </div>
	                        <div class="wlf_icon"></div>
	                    </div>
	                </div>
	                <div id="input_content" class="chat02_content">
	                    <textarea id="talkInputId" style="resize: none;height:83px;"></textarea>
	                </div>
	                <div class="chat02_bar" style="margin-top:0px;">
	                    <ul>
	                        <li style="right: 5px; top: 5px;"><span onclick="sendText()">发送</span></li>
	                    </ul>
	                </div>
	
	                <div style="clear: both;"></div>
	            </div>
	        </div>
	
	        <div id="addFridentModal" class="modal hide" role="dialog"
	            aria-hidden="true" data-backdrop="static">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal"
	                    aria-hidden="true">&times;</button>
	                <h3>添加好友</h3>
	            </div>
	            <div class="modal-body">
	                <input id="addfridentId" onfocus='clearInputValue("addfridentId")' />
	                <div id="add-frident-warning"></div>
	            </div>
	            <div class="modal-footer">
	                <button id="addFridend" class="btn btn-primary"
	                    onclick="startAddFriend()">添加</button>
	                <button id="cancelAddFridend" class="btn" data-dismiss="modal">取消</button>
	            </div>
	        </div>
	
	        <div id="delFridentModal" class="modal hide" role="dialog"
	            aria-hidden="true" data-backdrop="static">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal"
	                    aria-hidden="true">&times;</button>
	                <h3>删除好友</h3>
	            </div>
	            <div class="modal-body">
	                <input id="delfridentId" onfocus='clearInputValue("delfridentId")' />
	                <div id="del-frident-warning"></div>
	            </div>
	            <div class="modal-footer">
	                <button id="delFridend" class="btn btn-primary"
	                    onclick="directDelFriend()">删除</button>
	                <button id="canceldelFridend" class="btn" data-dismiss="modal">取消</button>
	            </div>
	        </div>
	
	        <!-- 一般消息通知 -->
	        <div id="notice-block-div" class="modal hide">
	            <button type="button" class="close" data-dismiss="alert">&times;</button>
	            <div class="modal-body">
	                <h4>Warning!</h4>
	                <div id="notice-block-body"></div>
	            </div>
	        </div>
	
	        <!-- 确认消息通知 -->
	        <div id="confirm-block-div-modal" class="modal hide"
	            role="dialog" aria-hidden="true" data-backdrop="static">
	            <div class="modal-header">
	                <h3>订阅通知</h3>
	            </div>
	            <div class="modal-body">
	                <div id="confirm-block-footer-body"></div>
	            </div>
	            <div class="modal-footer">
	                <button id="confirm-block-footer-confirmButton"
	                    class="btn btn-primary">同意</button>
	                <button id="confirm-block-footer-cancelButton" class="btn"
	                    data-dismiss="modal">拒绝</button>
	            </div>
	        </div>
	
	        <!-- 群组成员操作界面 -->
	        <div id="option-room-div-modal" class="alert modal hide"
	            role="dialog" aria-hidden="true" data-backdrop="static">
	            <button type="button" class="close" data-dismiss="modal"
	                aria-hidden="true">&times;</button>
	            <div class="modal-header">
	                <h3>成员</h3>
	            </div>
	            <div class="modal-body">
	                <div id="room-member-list" style="height: 100px; overflow-y: auto"></div>
	            </div>
	        </div>
	    </div>
		<input type='file' id="fileInput" style='display:none;'/>
		<div id='alert' class='em-alert' style='display:none;'><span></span><button>好的</button></div>
	</div>
    
</body>
</html>
