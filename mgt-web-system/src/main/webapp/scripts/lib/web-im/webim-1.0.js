var easemob_im_img_base_path = "../styles/css/web-im/img"; //图片路径
var conn = null;       //环信连接
var curUserId = null;  //当前登录注册账号名
var curChatUserId = null; //
var bothRoster = [];   //both双方互为好友，要显示的联系人,from我是对方的单向好友
var toRoster = [];     //to表明了联系人是我的单向好友

$(document).ready(function(){
	//初始化连接
	conn = new Easemob.im.Connection({multiResources:Easemob.im.config.multiResources,https:Easemob.im.config.https,url:Easemob.im.config.xmppURL});
	conn.open({
		apiUrl : Easemob.im.config.apiURL,
		user : $("#username").val(),
		pwd : $("#password").val(),
		appKey : Easemob.im.config.appkey
	}); 
	conn.listen({
		onOpened:function(){handleOpen(conn);}, 			//当连接成功时的回调方法
		onError:function(message){handleError(message);}    //异常时的回调方法
	});
});

//***********************连接回调函数***************************

//处理连接时函数,主要是登录成功后对页面元素做处理
var handleOpen = function(conn){
	//从连接中获取到当前的登录人注册帐号名
	curUserId = conn.context.userId;
	//获取当前登录人联系人列表
	conn.getRoster({
		success:function(roster){
			//页面处理
			hiddenWaitLoginedUI();
			showChatUI();
			for(var i in roster){
				var ros = roster[i];
				if(ros.subscription == 'both' || ros.subscription == 'from'){
					bothRoster.push(ros);
				} else if(ros.subscription == 'to'){
					toRoster.push(ros);
				}
			}
			var curRoster;
			if(bothRoster.length > 0){
				curRoster = bothRoster[0];
				buildContactDiv("contractlist", bothRoster); //联系人列表页面处理
				if(curRoster){
					setCurrentContact(curRoster.name);       //页面处理将第一个联系人作为当前聊天div
				}
			}
			//获取当前登录人的群组列表
			conn.listRooms({
				success : function(rooms) {
					if (rooms && rooms.length > 0) {
						buildListRoomDiv("contracgrouplist", rooms);//群组列表页面处理
						if (curChatUserId === null) {
							setCurrentContact(groupFlagMark + rooms[0].roomId);
							$('#accordion2').click();
						}
					}
					conn.setPresence();//设置用户上线状态，必须调用
				},
				error : function(e) {
					conn.setPresence();//设置用户上线状态，必须调用
				}
			});
		}
	});
	
	if ( !Easemob.im.Helper.isCanUploadFileAsync && typeof uploadShim === 'function' ) {
		picshim = uploadShim('sendPicInput', 'pic');
		audioshim = uploadShim('sendAudioInput', 'aud');
		fileshim = uploadShim('sendFileInput', 'file');
	}

	//获取聊天室列表
	conn.getChatRooms({
		apiUrl: Easemob.im.config.apiURL,
		success: function ( list ) {
			var rooms = list.data;
			if ( rooms && rooms.length > 0 ) {
				buildListRoomDiv("chatRoomList", rooms, chatRoomMark);//群组列表页面处理
			}
		},
		error: function ( e ) {
			alert(e);
		}
	});
	//启动心跳
	if (conn.isOpened()) {
		conn.heartBeat(conn);
	}
};
//异常时回调函数
var handleError = function(message){
	curChatRoomId = null;
	clearPageSign();
	e && e.upload && $('#fileModal').modal('hide');
	if (curUserId == null) {
		hiddenWaitLoginedUI();
		alert(e.msg + ",请重新登录");
		showLoginUI();
	} else {
		var msg = e.msg;
		if (e.type == EASEMOB_IM_CONNCTION_SERVER_CLOSE_ERROR) {
			if (msg == "" || msg == 'unknown' ) {
				alert("服务器断开连接,可能是因为在别处登录");
			} else {
				alert("服务器断开连接");
			}
		} else if (e.type === EASEMOB_IM_CONNCTION_SERVER_ERROR) {
			if (msg.toLowerCase().indexOf("user removed") != -1) {
				alert("用户已经在管理后台删除");
			}
		} else {
			alert(msg);
		}
	}
	conn.stopHeartBeat(conn);
}
//*************************************************************

//登录系统时的操作方法
var login = function() {
	handlePageLimit();

	setTimeout(function () {

		var total = getPageCount();
		if ( total > PAGELIMIT ) {
			alert('当前最多支持' + PAGELIMIT + '个resource同时登录');
			return;
		}

		if ($("#usetoken").is(":checked")) {
			var user = $("#username").val();
			var token = $("#token").val();
			if (user == '' || token == '') {
				alert("请输入用户名和令牌");
				return;
			}
			hiddenLoginUI();
			showWaitLoginedUI();
			//根据用户名令牌登录系统
			conn.open({
				apiUrl : Easemob.im.config.apiURL,
				user : user,
				accessToken : token,    
				//连接时提供appkey
				appKey : Easemob.im.config.appkey
			});
		} else {
			var user = $("#username").val();
			var pass = $("#password").val();
			if (user == '' || pass == '') {
				alert("请输入用户名和密码");
				return;
			}
			hiddenLoginUI();
			showWaitLoginedUI();
			//根据用户名密码登录系统
			conn.open({
				apiUrl : Easemob.im.config.apiURL,
				user : user,
				pwd : pass,
				//连接时提供appkey
				appKey : Easemob.im.config.appkey
			});         
		}
		return false;
	}, 50);
};

var hiddenWaitLoginedUI = function () {
	$('#waitLoginmodal').modal('hide');
};
var showChatUI = function () {
	$('#content').css({
		"display" : "block"
	});
	var login_userEle = document.getElementById("login_user").children[0];
	login_userEle.innerHTML = curUserId;
	login_userEle.setAttribute("title", curUserId);
};

//***********************构造页面DIV***************************

//设置当前显示的聊天窗口div，如果有联系人则默认选中联系人中的第一个联系人，如没有联系人则当前div为null-nouser
var setCurrentContact = function(defaultUserId) {
	alert("ddd33");
	showContactChatDiv(defaultUserId);
	alert("33");
	if (curChatUserId != null) {
		hiddenContactChatDiv(curChatUserId);
	} else {
		$('#null-nouser').css({
			"display" : "none"
		});
	}
	alert("44");
	curChatUserId = defaultUserId;
};

//联系人列表页面处理
var buildContactDiv = function(contactlistDivId, roster){
	var uielem = document.getElementById("contactlistUL");
	var cache = {};
	for (i = 0; i < roster.length; i++) {
		if (!(roster[i].subscription == 'both' || roster[i].subscription == 'from')) {
			continue;
		}
		var jid = roster[i].jid;
		var userName = jid.substring(jid.indexOf("_") + 1).split("@")[0];
		if (userName in cache) {
			continue;
		}
		cache[userName] = true;
		var lielem = $('<li>').attr({
			'id' : userName,
			'class' : 'offline',
			'className' : 'offline',
			'type' : 'chat',
			'displayName' : userName
		}).click(function() {
			chooseContactDivClick(this);
		});
		$('<img>').attr("src", easemob_im_img_base_path+"/head/contact_normal.png").appendTo(lielem);
		$('<span>').html(userName).appendTo(lielem);
		$('#contactlistUL').append(lielem);
	}
	var contactlist = document.getElementById(contactlistDivId);
	var children = contactlist.children;
	if (children.length > 0) {
		contactlist.removeChild(children[0]);
	}
	contactlist.appendChild(uielem);
}
//构造群组列表
var buildListRoomDiv = function(contactlistDivId, rooms, type) {
	var uielem = document.getElementById(contactlistDivId + "UL");
	uielem.innerHTML = '';
	var cache = {};
	for (i = 0; i < rooms.length; i++) {
		var roomsName = rooms[i].name;
		var roomId = rooms[i].roomId || rooms[i].id;
		if (roomId in cache) {
			continue;
		}
		cache[roomId] = true;
		var lielem = $('<li>').attr({
			'id' : (type == chatRoomMark ? chatRoomMark : groupFlagMark) + roomId,
			'class' : 'offline',
			'className' : 'offline',
			'type' : type || groupFlagMark,
			'displayName' : roomsName,
			'roomId' : roomId,
			'joined' : 'false'
		}).click(function() {
			chooseContactDivClick(this);
		});
		$('<img>').attr({'src' : easemob_im_img_base_path+'/head/group_normal.png'}).appendTo(lielem);
		$('<span>').html(roomsName).appendTo(lielem);
		$(uielem).append(lielem);
	}
	var contactlist = document.getElementById(contactlistDivId);
	var children = contactlist.children;
	if (children.length > 0) {
		contactlist.removeChild(children[0]);
	}
	contactlist.appendChild(uielem);
};

//选择联系人的处理
var getContactLi = function(chatUserId) {
	return document.getElementById(chatUserId);
};
//构造当前聊天记录的窗口div
var getContactChatDiv = function(chatUserId) {
	return document.getElementById(curUserId + "-" + chatUserId);
};
//如果当前没有某一个联系人的聊天窗口div就新建一个
var createContactChatDiv = function(chatUserId) {
	var msgContentDivId = curUserId + "-" + chatUserId;
	var newContent = document.createElement("div");
	$(newContent).attr({
		"id" : msgContentDivId,
		"class" : "chat01_content",
		"className" : "chat01_content",
		"style" : "display:none"
	});
	return newContent;
};

//显示当前选中联系人的聊天窗口div，并将该联系人在联系人列表中背景色置为蓝色
var showContactChatDiv = function(chatUserId) {
	var contentDiv = getContactChatDiv(chatUserId);
	if (contentDiv == null) {
		contentDiv = createContactChatDiv(chatUserId);
		document.getElementById(msgCardDivId).appendChild(contentDiv);
	}
	contentDiv.style.display = "block";
	var contactLi = document.getElementById(chatUserId);
	if (contactLi == null) {
		return;
	}
	contactLi.style.backgroundColor = "#33CCFF";
	var dispalyTitle = null;//聊天窗口显示当前对话人名称
	if (chatUserId.indexOf(groupFlagMark) >= 0) {
		dispalyTitle = "群组" + $(contactLi).attr('displayname') + "聊天中";
		curRoomId = $(contactLi).attr('roomid');
		$("#roomMemberImg").css('display', 'block');
	} else if (chatUserId.indexOf(chatRoomMark) >= 0) {
		dispalyTitle = "聊天室" + $(contactLi).attr('displayname');
		curRoomId = $(contactLi).attr('roomid');
		$("#roomMemberImg").css('display', 'block');
	} else {
		dispalyTitle = "与" + chatUserId + "聊天中";
		$("#roomMemberImg").css('display', 'none');
	}
	document.getElementById(talkToDivId).children[0].innerHTML = dispalyTitle;
};
//对上一个联系人的聊天窗口div做隐藏处理，并将联系人列表中选择的联系人背景色置空
var hiddenContactChatDiv = function(chatUserId) {
	var contactLi = document.getElementById(chatUserId);
	if (contactLi) {
		contactLi.style.backgroundColor = "";
	}
	var contentDiv = getContactChatDiv(chatUserId);
	if (contentDiv) {
		contentDiv.style.display = "none";
	}
};
//切换联系人聊天窗口div
var chooseContactDivClick = function(li) {
	var chatUserId = li.id,
		roomId = $(li).attr("roomId");

	if ( curChatRoomId && curChatRoomId != roomId ) {//切换时，退出当前聊天室
		var source = document.getElementById(curUserId + '-' + chatRoomMark + curChatRoomId);
		source && (source.innerHTML = '');
		conn.quitChatRoom({
			roomId : curRoomId
		});
		curChatRoomId = null;
	}

	if ($(li).attr("type") == groupFlagMark && ('true' != $(li).attr("joined"))) {
		conn.join({
			roomId : roomId
		});
		$(li).attr("joined", "true");
	} else if ( $(li).attr("type") === chatRoomMark ) {
		curChatRoomId = roomId;
		conn.joinChatRoom({
			roomId : roomId
		});
	}

	if (chatUserId != curChatUserId) {
		if (curChatUserId == null) {
			showContactChatDiv(chatUserId);
		} else {
			showContactChatDiv(chatUserId);
			hiddenContactChatDiv(curChatUserId);
		}
		curChatUserId = chatUserId;
	}
	//对默认的null-nouser div进行处理,走的这里说明联系人列表肯定不为空所以对默认的聊天div进行处理
	$('#null-nouser').css({
		"display" : "none"
	});
	var badgespan = $(li).children(".badge");
	if (badgespan && badgespan.length > 0) {
		li.removeChild(li.children[2]);
	}
	//点击有未读消息对象时对未读消息提醒的处理
	var badgespanGroup = $(li).parent().parent().parent().find(".badge");
	if (badgespanGroup && badgespanGroup.length == 0) {
		$(li).parent().parent().parent().prev().children().children().remove();
	}
};

//*************************************************************





