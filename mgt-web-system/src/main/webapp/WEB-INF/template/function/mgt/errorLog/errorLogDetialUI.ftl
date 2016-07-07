<!DOCTYPE html>
<html>
	<head>
		<title>错误日志详情页面</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor-min.js"></script>
		<script type="text/javascript">
			$(function(){
				if($('#userNo').val() != null){
					$('#userNo').attr("readonly",true);
				}
				if($('#userNo').val() == ""){
					$('#userNo').attr("readonly",false);
				}
				if($('#workResult').text() != null){
					$('#workResult').attr("readonly",true);
				}
				if($('#workResult').text() == ""){
					$('#workResult').attr("readonly",false);
				}
			});
		</script>
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" name="addForm" action="${base}/errorLog/errorLogSolve.jhtml" method="POST">
			<input type="hidden"id="statusFlg" name="statusFlg" value="${errorLogDetail.STATUS_FLG}">
			<input type="hidden"id="createDate" name="createDate" value="${errorLogDetail.CREATE_DATE}">
			<input type="hidden"id="appCode" name="appCode" value="${errorLogDetail.APP_CODE}">
			<input type="hidden"id="grade" name="grade" value="${errorLogDetail.GRADE}">
			<input type="hidden"id="errorCode" name="errorCode" value="${errorLogDetail.ERROR_CODE}">
			<input type="hidden"id="workDate" name="workDate" value="${errorLogDetail.WORK_DATE}">
			<div class="navbar-fixed-top" id="toolbar" >
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
					
			<div class="page-content">
				
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group required" >
						<label for="description" class="col-sm-4 control-label">
							错误内容：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 70px;" name="description" maxlength=300 readonly="true">${errorLogDetail.DESCRIPTION}</textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>	
			    <div class="row">
					<div class="col-xs-5">
					  <div class="form-group required" >
						<label for="description" class="col-sm-4 control-label">
							错误等级：
						</label>
						<div class="col-sm-7">
							[#if errorLogDetail.GRADE==1]
					         <input type="text" class="form-control input-sm  addRoleByName" id="grade" maxlength=30 name="grade" value="一般" readonly="true">
					        [#elseif errorLogDetail.GRADE==2]
					        <input type="text" class="form-control input-sm  addRoleByName" id="grade" maxlength=30 name="grade" value="严重" readonly="true">
					        [/#if]
						</div>
					  </div>
				    </div>	
				    <div class="col-xs-5">
					  <div class="form-group required" >
						<label for="description" class="col-sm-4 control-label">
							操作类型：
						</label>
						<div class="col-sm-7">
							[#if errorLogDetail.APP_CODE==1]
					          <input type="text" class="form-control input-sm  addRoleByName" id="appCode" maxlength=30 name="appCode" value="订单" readonly="true">
					        [#elseif errorLogDetail.GRADE==2]
					        <input type="text" class="form-control input-sm  addRoleByName" id="appCode" maxlength=30 name="appCode" value="支付" readonly="true">
					        [/#if]
						</div>
					  </div>		 
				    </div>	
			    </div>
			    <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="artTitle" class="col-sm-4 control-label">
							处理人：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="userNo" maxlength=30
									name="userNo" value="${errorLogDetail.userId}" readonly="true">
							</div>
							<span class="help-inline col-sm-1"></span>
						</div>
					</div>
				</div>	
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group required">
						<label for="description" class="col-sm-4 control-label ">
							处理结果：
						</label>
						<div class="col-sm-7  ">
					         <textarea class="form-control required" style="width: 531px; height: 70px;" id="workResult"name="workResult" maxlength=300 >${errorLogDetail.WORK_RESULT}</textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>	
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group required" >
						<label for="description" class="col-sm-4 control-label">
							错误返回码：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 70px;" name="returnCode" maxlength=300 readonly="true">${errorLogDetail.RETURN_CODE}</textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>			
			</div>
		</form>
	</body>
</html>
