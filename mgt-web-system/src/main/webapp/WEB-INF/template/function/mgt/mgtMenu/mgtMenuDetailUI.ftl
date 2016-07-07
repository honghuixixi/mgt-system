<!DOCTYPE html>
<html>
	<head>
		<title>菜单帮助编辑</title>
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
		<script>					
		//页面加载时触发jq富文本编辑框插件				
		var editor;
			KindEditor.ready(function(K) {
				editor = K.create('textarea[name="_kindcontent"]', {
					allowFileManager : true
				});
			});
		</script>
		<script type="text/javascript">  
  			$().ready(function() { 
  				var $acId = $("#acId");
  				// 文章类型选择
				$acId.lSelect({
				url: "${base}/info/artType.jhtml"
				});
			});
  		</script>	
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" name="addForm" action="${base}/mgt/mgtMenuUpdate.jhtml" method="POST">
			<input type="hidden"id="code" name="code" value="${mgtMenu.code}">
			<input type="hidden"id="imgSrc" name="imgSrc" value="${mgtMenu.imgSrc}">
			<input type="hidden"id="url" name="url" value="${mgtMenu.url}">
			<input type="hidden"id="pId" name="pId" value="${mgtMenu.pId}">
			<input type="hidden"id="visible" name="visible" value="${mgtMenu.visible}">
			<input type="hidden"id="id" name="id" value="${mgtMenu.id}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call"
					data-fn="checkForm" data-form="#form"
					>
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
						<div class="form-group">
							<label for="artTitle" class="col-sm-4 control-label">
								菜单名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="name" maxlength=30
									name="name" value="${mgtMenu.name}" readonly="true">
							</div>
							<span class="help-inline col-sm-1"></span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							菜单描述：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 70px;" name="description" maxlength=300>${mgtMenu.description}</textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>				
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="kindcontent" class="col-sm-4 control-label">
							编辑区域：
						</label>
							<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 164px;" name="_kindcontent" >${mgtMenu.content}</textarea>
					         <input type="hidden" id="kindcontent" name="kindcontent">
							</div>
					   </div>		 
				    </div>	
			    </div>			    						 
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
function checkForm(){
	if (mgt_util.validate(form)){ 
		$("#kindcontent").val(editor.html());
		mgt_util.submitForm('#form');
  }
}
</script>