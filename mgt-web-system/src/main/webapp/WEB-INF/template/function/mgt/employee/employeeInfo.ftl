<!DOCTYPE html>
<html>
	<head>
		<title>用户新增</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
	</head>
<style type="text/css">
table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
.informe-cont1C-r .help-block{display:inline-block;padding-left:5px;color:#f00;}
</style>

	<body>
		<div class="informe-box">
		
			<div class="informe-cont1">
				<div class="informe-cont1T">账号信息</div>
				<div class="informe-cont1C">
					<div class="informe-cont1C-l">
						<ul>
							<li><label>账户状态：</label><span>
								[#if employee.status=='1']启用[/#if]
								[#if employee.status=='0']禁用[/#if]
							</span></li>
							<li><label>手机号码：</label><span>${employee.mobile}</span></li>
							<li><label>登录账号：</label><span>${employee.accountName}</span></li>
						</ul>
					</div>
					
					<div class="informe-cont1C-r">
					<form class="form-horizontal" id="form" method="post"
						action="${base}/employee/editPassword.jhtml" enctype="multipart/form-data">
						<ul>
							<li><label>旧密码：</label><span><input type="password" maxlength="64" class="form-control input-sm required"
									name="oldPassword" value=""  id="oldPassword">
									<font>*</font></span></li>
							<li><label>新密码：</label><span><input type="password" maxlength="64" class="form-control input-sm required"
									name="newPassword" value=""  id="newPassword"><font>*</font></span></li>
							<li><label>新密码确认：</label><span><input type="password" maxlength="64" class="form-control input-sm required"
									name="confirmPassword" value=""  id="confirmPassword"><font>*</font></span></li>
							<li><label>&nbsp;</label><span><a class="informe-btn1" href="#" data-toggle="jBox-call" data-fn="checkForm">保存</a></li>
						</ul>
						</form>
					</div>
				</div>
			</div>
			<div class="informe-cont1">
				<div class="informe-cont1T">基本信息</div>
				<div class="informe-cont1C">
					<div class="informe-cont1C-l">
						<ul>
							<li><label>账号：</label><span>${employee.userCode}</span></li>
							<li><label>所属部门：</label><span> ${departmentName}</span></li>
							<li><label>邮箱：</label><span> ${employee.email}</span></li>
							<li><label>生日：</label><span> ${employee.birthday}</span></li>
							<li><label>住址：</label><span>${employee.address}</span></li>
							<li><label>角色：</label><span>[#if scuser.logisticsProviderFlg=='Y']物流公司员工[/#if]
							[#if scuser.purchaserFlg=='Y']供应商[/#if]</span></li>
							<li><label>备注：</label><span>${employee.memo}</span></li>
						</ul>
					</div>
					<div class="informe-cont1C-r">
						<ul>
							<li><label>账号名称：</label><span>${employee.userName}</span></li>
							<li><label>所属公司：</label><span>[#if parentEmployee != null]${parentEmployee.userName}[/#if]</span></li>
							<li><label>电话：</label><span>${employee.tel}</span></li>
							<li><label>性别：</label><span>[#if employee.sex=='1']男[/#if]
								[#if employee.sex=='2']女[/#if]</span></li>
							<li><label>身份证：</label><span>${employee.identityCard}</span></li>
							<li class="upImg_li">
								<label>图片：</label>
								<dl>
									<dt><input class="grxxflie-btn" type="file" id="file" name="file" onchange="ajaxFileUpload();"/><div class="grxx-fileBox"></div></dt>
									<dd><img src="${employee.picUrl}" width="58" height="58" id="picUrl" /><i></i></dd>
								</dl>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="informe-cont1">
				<div class="informe-cont1T">权限列表</div>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <th width="33%">角色</th>
				    <th width="34%">功能</th>
				    <th width="33%">权限</th>
				  </tr>
				  [#list menuList as menu]
				  	<tr>
					    <td align="center">${menu.ROLE_NAME}</td>
					    <td align="center">${menu.NAME}</td>
					    <td align="left">
					    	[#list resourceList as resource]
					    		[#if resource.MENU_ID == menu.ID && resource.ROLE_ID == menu.ROLE_ID ]
					    			<span style='padding:0 10px;white-space:nowrap'>${resource.NAME}</span>
					    		[/#if]
					    	[/#list]
					    </td>
					  </tr>
				  [/#list]
				  
				</table>
			</div>
			
		</div>
	</body>
</html>
<script>
function checkForm(){
	var confirmPassword = $("#confirmPassword").val();
	var newPassword = $("#newPassword").val();
	var oldPassword = $("#oldPassword").val();
	if (mgt_util.validate(form)){
		if(confirmPassword==newPassword){
			$('#form').ajaxSubmit({
		    	dataType: 'json', 
				contentType: "text/html; charset=utf-8", 
       			success: function (data) {
       				if(data.code=='100'){
       					$("#oldPassword").val("");
       					$("#newPassword").val("");
       					$("#confirmPassword").val("");
        				top.$.jBox.tip('输入原始密码不正确！', 'error');
        			}else if(data.code=='101'){
        				top.$.jBox.tip('修改成功！', 'success');
        			}
   					
        		},error : function(data){
        				top.$.jBox.tip('系统异常！', 'error');
        		}
     		});
		}else{
			$("#confirmPassword").val("");
			top.$.jBox.tip('两次输入密码不一致', 'error');
		}
	}
}
//ajax 实现文件上传 
function ajaxFileUpload() {
	$.ajaxFileUpload({
		url : "${base}/upload/iconUpload.jhtml?time="+new Date(),
		secureuri : false,
		data : {
			filePre : "feedback",
			p : new Date()
		},
		fileElementId : "file",
		dataType : "json",
		success : function(data) {
			if (data.status == "success") {
				$("#picUrl").attr("src",data.fullPath);
				top.$.jBox.tip('图片修改成功！');
				$("#jUploadFormfile").remove();
				$("#jUploadFramefile").remove();
			}
			switch(data.message){
			 //解析上传状态
				case "-1" : 
					alert("上传文件不能为空!");
				    break;
				case "1" : 
					alert("上传失败!");
				    break;
				case "2" : 
					alert("文件超过上传大小!");
				    break;
				case "3" : 
					alert("文件格式错误!");
				    break;
				case "4" : 
					alert("上传文件路径非法!");
				    break;
				case "5" :
					alert("上传目录没有写权限!");
				    break;
			}
		},
		error : function(data) {
			alert("上传失败！");
		}
	});
}
</script>