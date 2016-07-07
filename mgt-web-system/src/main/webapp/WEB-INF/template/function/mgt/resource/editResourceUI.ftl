<!DOCTYPE html>
<html>
	<head>
		<title>资源修改</title>
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
		<form class="form-horizontal" id="form" action="${base}/resource/edit.jhtml">
			<input type="hidden" id="id" name="id" value="${resource.id}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>

			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="name"  value="${resource.name}"  maxlength=30>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
		            <div class="col-xs-5">
						<div class="form-group">
							<label for="citySel" class="col-sm-4 control-label"> 
							所属菜单：
							</label>
							<div class="col-sm-7">
								<input id="citySelsss" name="citySel" type="text"  class="form-control required" readonly  value="${menu.name}" onclick="Yhxutil.ztree.showMenu(this);" />
								<input id="citySelCodess" name="citySelCode" type="hidden"  value="${menu.id}"/>
							</div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="value" class="col-sm-4 control-label">值：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required "
									name="value"   value="${resource.value}"  maxlength=30>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">地址：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required "
									name="url"  value="${resource.url}"  maxlength=300>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="orderby" class="col-sm-4 control-label">排序：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  number required"
									name="orderby"  value="${resource.orderby}"  maxlength=5>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label">状态：</label>
							<div class="col-sm-7">
								<select class="form-control required" id="status" name="status">
									<option value="1" [#if menu.visible==1]selected="selected"[/#if]>启用</option>
									<option value="0" [#if menu.visible==0]selected="selected"[/#if]>禁用</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div id="menuContentss" class="menuContent" style="display:none; position: absolute;z-index:100000">
					<ul id="treeDemoss" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
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
</script>