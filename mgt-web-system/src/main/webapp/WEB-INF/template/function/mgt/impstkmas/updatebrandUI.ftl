<!DOCTYPE html>
<html>
	<head>
		<title>客户新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	</head>
	
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"  method="post"  action="${base}/impstkmas/updatebrand.jhtml">
			<input type="hidden"  id="ids"  name="ids" value="${ids}" >
			<div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>		

			<div class="page-content">
				<div class="row">
					<div class="col-xs-9">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">品牌：</label>
							<div class="col-sm-3">
								<select class="form-control" style="width:120px;" name="catC" id="BRAND_C" >
		                        [#list brandList as brand]
									 	<option value='${brand.brandC}'>${brand.name}</option>
								[/#list]
		                    </select>
							</div>
						</div>
					</div>
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
	//chosen插件初始化，绑定元素
	$(function(){
		$("#BRAND_C").chosen();
	});	
	function checkForm(){
	if (mgt_util.validate(form)){
		mgt_util.submitForm('#form');
	}
}
</script>
