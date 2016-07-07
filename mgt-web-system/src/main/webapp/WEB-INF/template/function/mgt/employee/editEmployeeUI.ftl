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
</style>

	<body class="toolbar-fixed-top">
				<form class="form-horizontal" id="form" method="post"
			action="${base}/employee/edit.jhtml" enctype="multipart/form-data">
				<input type="hidden" name="id"  value="${employee.id}"  >
			<div class="navbar-fixed-top" id="toolbar">
				<span class="btn" >
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</span>
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
						
		<div class="navbar-fixed-left toolbar-tit" id="toolbar">登陆信息</div>
			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="accountName" class="col-sm-4 control-label">登录账号：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="accountName" maxlength="60" readonly="true" id="accountName" value="${employee.accountName}">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					
										<div class="col-xs-5">
						<div class="form-group">
							<label for="mobile" class="col-sm-4 control-label">
								账户状态：
							</label>
							<div class="col-sm-7">
								<input type="radio" name="status" value="1" [#if employee.status=='1']checked=checked[/#if] />启用
								<input type="radio" name="status" value="0" [#if employee.status=='0']checked=checked[/#if] />停用
							</div>
						</div>
					 
					</div>
					
				 
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="mobile" class="col-sm-4 control-label">
								手机：
							</label>
							<div class="col-sm-7">
								<input type="text" maxlength="16" class="form-control input-sm" 
									name="mobile"   value="${employee.mobile}" >
							</div>
						</div>
					 
					</div>
							<div class="col-xs-5">
							<div class="form-group">
								<label for="password" class="col-sm-4 control-label">
									初始密码：
								</label>
								<div class="col-sm-7">
									<input type="password" maxlength="64" class="form-control input-sm required"
										name="password" value="${employee.password}"  >
								</div>
								<span class="help-inline col-sm-1">*</span>
							</div>
						</div>
			
				</div>
		 
 
	 
		 
			</div>
			
			
		<div class="navbar-fixed-left toolbar-tit" id="toolbar">基本信息</div>
			
				<div class="row">
				<div class="col-xs-5">
						<div class="form-group">
							<label for="userCode" class="col-sm-4 control-label">
								用户编号：
							</label>
							<div class="col-sm-7">
								<input type="text" maxlength="32" class="form-control input-sm  required"  readonly="true" 
									name="userCode"   value="${employee.userCode}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
							<div class="col-xs-5">
						<div class="form-group">
							<label for="userName" class="col-sm-4 control-label">
								用户姓名：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength="60"
									name="userName"   value="${employee.userName}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
		 
				<div class="row">
				<div class="col-xs-5">
						<div class="form-group">
							<label for="userCode" class="col-sm-4 control-label">
								上级：
							</label>
							<div class="col-sm-7">
								<input id="citySelsss1" name="citySel1" type="text"  class="form-control" readonly  onclick="Yhxutil.employee.showMenu(this);" [#if parentEmployee != null]value="${parentEmployee.userName}"[/#if] />
								<input id="citySelCodess1" name="citySelCode1" type="hidden"  [#if parentEmployee != null]value="${parentEmployee.id}"[/#if]  />	
							</div>
						</div>
					</div>
							<div class="col-xs-5" >
				        <div class="form-group">
							<label for="picUrl" class="col-sm-4 control-label">
								所属部门：
							</label>
							<div class="col-sm-7">
								<input id="citySelsss" name="citySel" type="text"  class="form-control" readonly  onclick="Yhxutil.ztree.showMenu(this);" value="${departmentName}"/>
								<input id="citySelCodess" name="citySelCode" type="hidden"  value="${departmentId}"/>	
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="tel" class="col-sm-4 control-label">
								电话：
							</label>
							<div class="col-sm-7">
								<input type="text" maxlength="16" class="form-control input-sm"
									name="tel" value="${employee.tel}" >
							</div>
						</div>
					 
					</div>
				<div class="col-xs-5">
						<div class="form-group">
							<label for="email" class="col-sm-4 control-label">
								邮箱：
							</label>
							<div class="col-sm-7">
								<input type="text" maxlength="32" class="form-control input-sm email" name="email" value="${employee.email}" >
							</div>
						</div>
					</div>
				</div>
		 
					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="sex" class="col-sm-4 control-label">
								性别：
							</label>
							<div class="col-sm-7">
								<input type="radio" name="sex" value="1"  [#if employee.sex=='1']checked=checked[/#if] />男
								<input type="radio" name="sex" value="2"  [#if employee.sex=='2']checked=checked[/#if] />女
							</div>
						</div>
					</div>
					
								<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								生日：
							</label>
							<div class="col-sm-7">
		      				<input type="text" id="birthday" name="birthday" class="form-control "   onClick="WdatePicker()"style="width:176px;" value="${employee.birthday}" />
							</div>
						</div>
					</div>
				</div>
				
							
				<div class="row">
				<div class="col-xs-5">
						<div class="form-group">
							<label for="identityCard" class="col-sm-4 control-label">
								身份证：
							</label>
							<div class="col-sm-7">
								<input type="text" maxlength="18" class="form-control input-sm "
									name="identityCard" value="${employee.identityCard}" >
							</div>
						</div>
					</div>
							<div class="col-xs-5">
						<div class="form-group">
							<label for="address" class="col-sm-4 control-label">
								住址：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm " maxlength="100"
									name="address"  value="${employee.address}" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
				<div class="col-xs-5">
						<div class="form-group">
							<label for="picUrl" class="col-sm-4 control-label">
								图片：
							</label>
							<div class="col-sm-7">
									<input type="file"  class="form-control input-sm"  name="picUrl" id="picUrl"   />
							</div>
						</div>
					</div>
	 				<div class="col-xs-5">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色：</label>
							<div class="col-sm-7"><input type="checkbox" name="logisticsProviderFlg"  value="Y" [#if employee.logisticsProviderFlg=='Y']checked=checked[/#if] >配送员
							<input type="checkbox" NAME="salesmenFlg" value="Y" [#if employee.salesmenFlg=='Y']checked=checked[/#if] >销售员
							<input type="checkbox" NAME="pickFlg" value="Y"  [#if employee.pickFlg=='Y']checked=checked[/#if] >分拣员
							</div>
						</div>
					</div>
				</div>
		 			<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="description" class="col-sm-4 control-label">
								备注:
							</label>
							<div class="col-sm-7">
							 <textarea class="form-control" maxlength="500" style="width: 500px; height: 164px;" name="memo">${employee.memo}</textarea>
							</div>
						</div>
					</div>
				</div>
				
				
		 	<div id="menuContentss" class="menuContent" style="display:none; position: absolute;z-index:100000">
					<ul id="treeDemoss" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
				</div>
		 	<div id="menuContentss1" class="menuContent" style="display:none; position: absolute;z-index:100000">
					<ul id="treeDemoss1" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
				</div>
				<center>
				<table class="gridtable">
				<tr><td colspan="3">设置权限</td></tr>
				<tr><td ></td><td width="200PX">角色名称</td><td  width="260PX">角色描述</td></tr>
				          	[#list roleList as roles]
				<tr><td ><input type="checkbox" name="roleIds" value="${roles.id}"/></td><td >${roles.name}</td><td >${roles.memo}</td></tr>
				[/#list]
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
				</center>
		</form>
			 
	</body>
</html>
<script>
 [#if employeeRoleList != null]
      	[#list employeeRoleList as employeeRoles]
      			$("input[name='roleIds'][value='${employeeRoles.ROLE_ID}']").attr("checked",true);
      	
    [/#list]
    [/#if]
var datas = {
	id:'ids',
	name:'names'
}
var param = {
	url:'${base}/department/deptList.jhtml',
	data:datas,
	//true 多选   false 单选
	MultiCheck:false,
	inputId:'citySelCodess',
	inputName:'citySelsss',
	MenuId:'menuContentss',
	treeId:'treeDemoss'   
}
var param1 = {
	url:'${base}/employee/employeeLists.jhtml',
	data:datas,
	//true 多选   false 单选
	MultiCheck:false,
	inputId:'citySelCodess1',
	inputName:'citySelsss1',
	MenuId:'menuContentss1',
	treeId:'treeDemoss1'   
}

Yhxutil.ztree.doInit(param);
Yhxutil.employee.doInit(param1);
function checkForm1(){
	if (mgt_util.validate(form)){
		$('#form').ajaxSubmit({
			success: function (html, status) {
				var html = jQuery.parseJSON(html);
					if(html.code == 'userNumberIsExist'){
	   		        	 $.jBox.tip('登录账号已经存在！');
	   		        	 return;
	   		        }else{
	   					top.$.jBox.tip('保存成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   			    }
			},error : function(data){
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				return;
			}
		});
     }
}

function  findExist() {
	var accountName = $("#accountName").val();
    var data={
		accountName:accountName
	}
	$.ajax({
	   type: "POST",		   
	   url:  '${base}/user/findUserAccountExist',
	   async:false,
	   data: data,
	   scope:this,
	   success: function(response){
	       var obj = jQuery.parseJSON(response)
	       if(obj.data.code=="EmployeeNumberIsExist"){
	    	   $.jBox.tip('用户登录账户已存在！');
			}
		}
	});
}

function checkForm(){
	if (mgt_util.validate(form)){
		     $('#form').ajaxSubmit({
		     		dataType: 'json', 
					contentType: "text/html; charset=utf-8", 
       			    success: function (html, status) {
   					top.$.jBox.tip('保存成功！', 'success');
   					top.$.jBox.refresh = true;
   					mgt_util.closejBox('jbox-win');
         },error : function(data){
	    		top.$.jBox.tip('系统异常！', 'error');
	    		top.$.jBox.refresh = true;
	    		mgt_util.closejBox('jbox-win');
          }
     });
	}
}
    var treeObj = $.fn.zTree.getZTreeObj("treeDemoss");
    var node = treeObj.getNodeByParam('id','${departmentId}');
    treeObj.checkNode(node, true, true);
    [#if parentEmployee != null]
    var treeObj1 = $.fn.zTree.getZTreeObj("treeDemoss1");
    var node1 = treeObj1.getNodeByParam('id','${parentEmployee.id}');
    treeObj1.checkNode(node1, true, true);
    [/#if]
   
</script>