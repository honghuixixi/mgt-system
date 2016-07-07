<!DOCTYPE html>
<html>
	<head>
		<title>文章修改</title>
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
		<form class="form-horizontal" id="form" name="addForm" action="${base}/info/edit.jhtml">
			<input type="hidden"id="id" name="id" value="${article.artId}">
			<input type="hidden"id="author" name="author" value="${article.author}">
			<input type="hidden"id="isPublication" name="isPublication" value="${article.isPublication}">
			<input type="hidden"id="isTop" name="isTop" value="${article.isTop}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call"
					data-fn="checkForm">
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
								文章标题：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="artTitle" maxlength=30
									name="artTitle" value="${article.artTitle}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
        			  <div class="form-group">
	                    <label for="acId" class="control-label">文章类型：</label>
           				<input type="hidden" id="acId" name="acId" value="${article.acId}" treePath="${artCate.treePath}"/>
        			  </div>
					</div>	
				</div>
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							文章描述：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 70px;" name="description" maxlength=300>${article.seoDescription}</textarea>
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
					         <textarea class="form-control" style="width: 531px; height: 164px;" name="_kindcontent" >${article.content}</textarea>
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
	   $.ajax({
		 url:'${base}/info/findByTitle.jhtml',
		 sync:false,
		 type : 'post',
		 dataType : "json",
		 data :{
		 		artTitle:$("#artTitle").val(),
		 		artId:${article.artId},		 
		 },
		 error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(data.data){
				$("#kindcontent").val(editor.html());
				mgt_util.submitForm('#form');
			}else{
				alert("文章标题已存在！");
	 			return false;
			}
		}
	});	
  }
}
</script>
