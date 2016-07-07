<!DOCTYPE html>
<html>
	<head>
		<title>部门添加</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<link rel="stylesheet">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>

	<body class="toolbar-fixed-top" >
		<form class="form-horizontal" id="form" action="${base}/msgTemplet/add.jhtml" method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
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
							<label for="busiCode" class="col-sm-4 control-label">
								业务代码:
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required charLength" id="busiCode" name="busiCode" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="busiName" class="col-sm-4 control-label">
								业务名称:
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" id="busiName" name="busiName" value="" >
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="margin-top: 5px;margin-bottom: 5px;">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="tempName" class="col-sm-4 control-label">
								模板名称:
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" id="tempName" name="tempName" value="" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="content" class="col-sm-4 control-label">
								消息体模板:
							</label>
							<div class="col-sm-7">
							 <textarea class="form-control" style="width: 500px; height: 164px;" name="content"></textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
	<script type="text/javascript">

		function checkForm(){
			if (mgt_util.validate(form)){
				var busiCode = $("#busiCode").val();
				$.ajax({
					type: "POST",
					url:  '${base}/msgTemplet/findBusiCodeExist.jhtml',
					async:false,
					data: {busiCode:busiCode},
					scope:this,
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success: function(data){
						if(data){
							if(data.code=="Y"){
								$.jBox.tip('业务代码已经存在！');
								return;
							}else if(data.code=="N"){
								mgt_util.submitForm('#form');
							}
						}
						$.jBox.tip('请刷新重试，或联系管理员！');
						return;
					}
				});
			}
		}	
	</script>
</html>
