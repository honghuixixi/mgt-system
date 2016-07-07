<!DOCTYPE html>
<html>
	<head>
		<title>资源新增</title>
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

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"
			action="${base}/push/save.jhtml">
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
				<div class="btn-group">
					<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">发送
						<i class="fa-save align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
					<button class="btn btn-warning" data-toggle="jBox-close">取消
						<i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
			</div>

			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							标题：
						</label>
						<div class="col-sm-7">
					         <input type="text" id="title" name="title" class="form-control required" name="orderby" maxlength=5>
						</div>
					  </div>		 
				    </div>	
			    </div>	

				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							内容：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" id="content" name="content" style="width: 531px; height: 70px;" name="description" maxlength=300></textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>	
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="orderby" class="col-sm-4 control-label">
								设备范围：
						    </label>
							<div class="col-sm-7">
								<select class="form-control required" id="deviceType" name="deviceType">
								    <option value="Android">Android</option>
								    <option value="IOS">IOS</option>
							    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label">
								项目：
						    </label>
							<div class="col-sm-7">
								<select class="form-control required" id="project" name="project">
								    <option value="B2B">B2B</option>
								    <option value="P2C">P2C</option>
							    </select>
						</div>
						<span class="help-inline col-sm-1">*</span>
					</div>
				</div>
				
 			    <div id="menuContentss" class="menuContent" style="display:none; position: absolute;z-index:100000">
		           <ul id="treeDemoss" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
		        </div>
			</div>
			
			<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							后续行为：
						</label>
						<div class="col-sm-7">
					         <div class="radio">
							   <label>
							      <input type="radio" name="openType" id="openType1" value="2" checked>直接打开应用
							   </label>
							</div>
							<div class="radio">
							   <label>
							      <input type="radio" name="openType" id="openType2" value="1">
							         打开网页:
							         <input class="form-control" id="url" name="url" type="text" style="width: 331px;" disabled="disabled">
							   </label>
							</div>
							<div class="radio">
							   <label>
							      <input type="radio" name="openType" id="openType3" value="3">
							                            自定义打开行为：
							         <input class="form-control" id="pkgContent" name="pkgContent" type="text" style="width: 331px;" disabled="disabled">
							   </label>
							</div>
						</div>
					  </div>		 
				    </div>	
			    </div>	
		</form>
	</body>
</html>
<script>
var datas = {
  id:'ids',
  name:'names'
}

var param = {
  url:'${base}/menu/menuList.jhtml',
  data:datas,
  //true 多选   false 单选
  MultiCheck:false,
  inputId:'citySelCodess',
  inputName:'citySelsss',
  MenuId:'menuContentss',
  treeId:'treeDemoss',
  nocheck:true
}

Yhxutil.ztree.doInit(param);
$(document).ready(function(){
	$("#openType1").click(function(){
		$("#pkgContent").attr("disabled","disabled");
		$("#url").attr("disabled","disabled");
	});
	$("#openType2").click(function(){
		$("#url").removeAttr("disabled");
		$("#pkgContent").attr("disabled","disabled");
	});
	$("#openType3").click(function(){
		$("#pkgContent").removeAttr("disabled");
		$("#url").attr("disabled","disabled");
	});
});
</script>