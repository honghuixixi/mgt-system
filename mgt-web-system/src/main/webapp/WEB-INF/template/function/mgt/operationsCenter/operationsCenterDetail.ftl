<!DOCTYPE html>
<html>
	<head>
		<title>客户详情</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	
	<body>
	<div class="yyzx_xgBox">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>	
			
			<div class="page-content">
				<ul class="yyzx_xqUl">
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">运营中心编码：</label>
							<span class="yyzx_xqSpan">${user.userName}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label  for="userName" class="col-sm-4 control-label width_left2">上级运营中心：</label>
						    <div class="yyzx_xqSpan">${parentUser.userName}</div>
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">企业名称：</label>
							<span class="yyzx_xqSpan">${user.name}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">联系人：</label>
							<span class="yyzx_xqSpan">${user.crmPic}<i class="yyzx_xqIcon1"></i></span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">联系电话：</label>
							<span class="yyzx_xqSpan">${user.crmMobile}<i class="yyzx_xqIcon2"></i></span>
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">所属区域：</label>
							<span class="yyzx_xqSpan">${area.FULLNAME}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">传真：</label>
							<span class="yyzx_xqSpan">${user.crmFax}</span>
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">邮箱：</label>
							<span class="yyzx_xqSpan">${user.email}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">邮编：</label>
							<span class="yyzx_xqSpan">${user.crmZip}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">地址：</label>
							<span class="yyzx_xqSpan">${user.crmAddress1}</span>
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">备注：</label>
							<span class="yyzx_xqText">${employee.memo}<i class="yyzx_xqIcon3"></i></span>
						</div>
					</li>
				</ul>
			</div>	

		</div>
	</body>
</html>

