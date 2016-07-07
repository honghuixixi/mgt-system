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
		<script language="javascript" type="text/javascript">
			$(document).ready(function(){
				$('#defFlg').change(function(){
					if(jQuery("#defFlg  option:selected").text() == 'N'){
						$('#defValue').attr('hidden',true);
					}else{
						$('#defValue').attr('hidden',false);
					}
				});
			})
		</script> 
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"
			action="${base}/mgtSetting/mgtSettingEdit.jhtml">
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
							<label for="status" class="col-sm-4 control-label"> 
							名称：
							</label>
							<div class="col-sm-7">
							    <input id="citySelsss" name="menuName" type="text" class="form-control required" readonly value="${mgtSetting.menuName}" onclick="Yhxutil.ztree.showMenu(this);" />
								<input id="citySelCodess" name="menuId" type="hidden" value="${mgtSetting.menuId}" />
						    </div>
						    <span class="help-inline col-sm-1">*</span>
					    </div>
				    </div>
				    
				    <div class="col-xs-5">
						<div class="form-group">
							<label for="value" class="col-sm-4 control-label">
								描述：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="description" value="${mgtSetting.description}" maxlength=30 >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
		            <div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label"> 
							默认设置项：
							</label>
							<div class="col-sm-7">
							   <select class="form-control required" id="defFlg" name="defFlg">
								    <option value="N" [#if mgtSetting.defFlg=='N']selected="selected"[/#if]>否</option>
								    <option value="Y" [#if mgtSetting.defFlg=='Y']selected="selected"[/#if]>是</option>
							    </select>
						    </div>
						    <span class="help-inline col-sm-1">*</span>
					    </div>
				    </div>
				    
				    <div class="col-xs-5">
						<div class="form-group">
							<label for="value" class="col-sm-4 control-label">
								是否允许用户设置：
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="userFlg" name="userFlg">
								    <option value="Y" [#if mgtSetting.userFlg=='Y']selected="selected"[/#if]>是</option>
								    <option value="N" [#if mgtSetting.userFlg=='N']selected="selected"[/#if]>否</option>
							    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<input id="itemNo" name="itemNo" type="hidden" value="${mgtSetting.itemNo}"/>
				<div class="row">
					<div class="col-xs-5" id="defValue" hidden="true">
						<div class="form-group">
							<label for="orderby" class="col-sm-4 control-label">
								默认值：
						    </label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number " name="defValue" value="${mgtSetting.defValue}"maxlength=5>
							</div>
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