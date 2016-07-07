<!DOCTYPE html>
<html>
	<head>
		<title>资源新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
		<script language="javascript" type="text/javascript">
			$(document).ready(function(){
				$("#import").click(function(){
					$.ajaxFileUpload({
						url : "${base}/upload/excelUpload.jhtml?time="+new Date(),
						secureuri : false,
						data : {
							filePre : "feedback",
							p : new Date()
						},
						fileElementId : "file",
						dataType : "json",
						success : function(data) {
							$(".note").html("");
							$(".note").append(data.message);
							$("#jUploadFormfile").remove();
							$("#jUploadFramefile").remove();	
						},
						error : function(data) {
							alert("上传失败！");
						}
					});
				});
			})
		</script> 
	</head>
	<body class="toolbar-fixed-top">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>

			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								模板：
							</label>
							<div class="col-sm-7">
								<a href="${base}/download/userinfotemplate.xls">客户资料表导入模板.xls</a>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">文件：</label>
						    <div class="col-sm-7">
						    	<input name="file" id="file" type="file"  />
						    </div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<div class="col-sm-7">
								<button type="button" id="import" class="btn_divBtn">导入 </button>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-9">
						<div class="form-group note">
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<div class="col-sm-7">
							</div>
						</div>
					</div>
				</div>
			</div>
	</body>
</html>
