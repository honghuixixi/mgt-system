<!DOCTYPE html>
<html>
	<head>
		<title>附属账户余额查询</title>
		[#include "/common/commonHead.ftl" /]
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
		<form class="form-horizontal" id="form" action="${base}/menu/add.jhtml" method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 
 	        <div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="totalMoney" class="col-sm-4 control-label">
								总金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="totalMoney" name="totalMoney" value="${amout}" maxlength=20>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="state" class="col-sm-4 control-label">
								状态：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" name="state" id="state" maxlength=200>
							</div>
						</div>
					</div>
				</div>	
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="getAmout" class="col-sm-4 control-label">
								可提现金额 ：
							</label>
							<div class="col-sm-7">
							<input type="text" class="form-control input-sm" name="getAmout" id="getAmout" maxlength=200>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="notGetAmout" class="col-sm-4 control-label">不可提现金额：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" name="notGetAmout" id="notGetAmout" maxlength=200>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="getForstAmout" class="col-sm-4 control-label">可提现冻结金额：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number required" id="getForstAmout" name="getForstAmout" value="" maxlength=200>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="notGetForstAmout" class="col-sm-4 control-label" width="100px">不可提现冻结金额：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number required" id="notGetForstAmout" value="" maxlength=200>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="totalIntegral" class="col-sm-4 control-label">总积分：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number required" id="totalIntegral" value="" maxlength=200>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="accountType" class="col-sm-4 control-label">账户性质：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number required" id="accountType" value="" maxlength=200>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</form>
	</body>
</html>
