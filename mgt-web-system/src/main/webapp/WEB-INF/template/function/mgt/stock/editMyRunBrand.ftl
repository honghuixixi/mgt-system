<!DOCTYPE html>
<html>
	<head>
		<title>菜单新增</title>
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
		<form class="form-horizontal" id="form" action="${base}/stock/stockUpdate.jhtml" method="POST">

			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
				<div class="btn-group">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
					<button class="btn btn-warning" data-toggle="jBox-close">关闭
						<i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
			</div>
 
 	       <!--  <div class="page-content"> -->
				<div class="row">
				
					<div class="col-xs-5">
						<div class="form-group">
							<label for="beginDate" class="col-sm-3 control-label">
								编码:
							</label>
							<div class="col-sm-6">
		                    <input type="text" id="beginDate" name="brandC" class="form-control required" value="${vendorStkBrand.id.brandC}"  style="width:200px;"  readonly=true maxlength=16 /> 
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">
								名称：
							</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm required"  id="name" name="name" value='${vendorStkBrand.name}' maxlength=256 readonly=true/>
							</div>
						</div>
					</div>
					
			</div>
		 <!-- </div> -->
		 <div class="row">
				 <div class="col-xs-5">
						<div class="form-group">
							<label for="sortby" class="col-sm-3 control-label">排序号：</label>
							<div class="col-sm-6">
							    <input type="text" id="sortNo" name="sortNo" class="form-control required input-sm number "   value="${vendorStkBrand.sortNo}"   maxlength=20 />
							
							</div>
							<span class="help-inline col-sm-3">*</span>
						</div>
			</div>
		</div>

		<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="spNote" class="col-sm-3 control-label">备注:</label>
					    <div class="col-sm-4">
				            <textarea class="form-control" style="width: 531px; height: 164px;" name="remark" id="spNote" maxlength=85>${vendorStkBrand.remark}</textarea>
						    </div>
						</div>
					</div>
				</div>
		</div>
	</form>
</body>
</html>
