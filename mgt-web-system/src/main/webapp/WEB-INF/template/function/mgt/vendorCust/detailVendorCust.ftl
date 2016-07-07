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
	
	<body class="toolbar-fixed-top">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>		

			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">
								客户编码：
							</label>
							<div class="col-sm-8">
								${vendorCust.id.custCode}
							</div>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">客户名称：</label>
							<div class="col-sm-8">
								${vendorCust.custName}
							</div>
							
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">客户类型：</label>
						    <div class="col-sm-8">
								${customerName}
						    </div>
						    
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">负责人：</label>
							<div class="col-sm-8">
								${vendorCust.crmPic}
							</div>
							
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group pad_top">
							<label  for="memo" class="col-sm-3 control-label">所属区域：</label>
						    <div class="col-sm-8 width_big">
						    ${areaName}
						    </div>
						   
						</div>
					</div>
					
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">客户地址：</label>
						    <div class="col-sm-8">
					            ${vendorCust.crmAddress1}
						    </div>
						    
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">类别：</label>
							<div class="col-sm-8">
								 ${custCatName}
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">手机：</label>
						    <div class="col-sm-8">
					            ${vendorCust.crmMobile}
						    </div>
						   
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">邮编：</label>
							<div class="col-sm-8">
								${vendorCust.crmZip}
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">业务员：</label>
						    <div class="col-sm-8">
					            ${vendorCust.spUserName}
						    </div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">Email：</label>
							<div class="col-sm-8">
								${vendorCust.emailAddr}
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">电话：</label>
						    <div class="col-sm-8">
					            ${vendorCust.crmTel}
						    </div>
						    
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">网址：</label>
							<div class="col-sm-8">
								${vendorCust.urlAddr}
							</div>
							
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">创建人：</label>
						    <div class="col-sm-8">
					            ${vendorCust.createdBy}
						    </div>
						  
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">备注：</label>
							<div class="col-sm-8">
								${vendorCust.remark}
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-3 control-label">图片：</label>
						    <div class="col-sm-8">
									${vendorCust.imgUrl}
						    </div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">支付方式：</label>
							<div class="col-sm-8">
								${vendorCust.payTerms}
							</div>
						</div>
					</div>
				</div>
			</div>
	</body>
</html>

