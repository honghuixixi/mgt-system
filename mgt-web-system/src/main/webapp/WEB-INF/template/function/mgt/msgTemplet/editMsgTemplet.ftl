<!DOCTYPE html>
<html>
	<head>
		<title>修改部门信息</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/msgTemplet/edit.jhtml">
			<input type="hidden"  name="pkNo" value="${msgTemplet.pkNo}">
			<input type="hidden"  name="tempFlag" value="${msgTemplet.tempFlag}">
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
							<label for="busiCode" class="col-sm-4 control-label">
								业务代码:
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" readonly="readonly"
									id="busiCode" name="busiCode" value="${msgTemplet.busiCode}" >
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="busiName" class="col-sm-4 control-label">
								业务名称:
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" 
									id="busiName" name="busiName" value="${msgTemplet.busiName}" >
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
								<input type="text" class="form-control input-sm" 
									id="tempName" name="tempName" value="${msgTemplet.tempName}" >
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
							 <textarea class="form-control" style="width: 475px; height: 164px;" 
							 	name="content" >${msgTemplet.content}</textarea>
							</div>
						</div>
					</div>
				</div>
			  
			</div>
		</form>
	</body>
	
</html>
