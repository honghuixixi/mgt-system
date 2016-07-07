<!DOCTYPE html>
<html>
	<head>
		<title>商品批量修改</title>
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
		<form class="form-horizontal" id="form" method="post"
			action="${base}/vendorPro/updStkMas.jhtml">
			
			<input type="hidden" name="ids"  value="${ids}" / >
			<div class="navbar-fixed-top" id="toolbar">
				<span class="btn" >
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</span>
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
				<div class="row">
		 
							<div class="col-xs-5" >
				        <div class="form-group">
							<label for="picUrl" class="col-sm-4">
								所属分类：
							</label>
							<div class="col-sm-7 cat_span">
							<select name="vendorCatC" id="vendorCatC">
							
							     <option value="-1">选择分类</option>
							     [#if list ??]
							         [#list list as cat]
				                          <option value='${cat.id.catC}'>${cat.name}</option>
									[/#list]
								[/#if]
							    </select>
							
							
							
					<span class="help-inline" id="catmsg">*</span>
					</div>
					</div>
				</div>
				</div>
		 	 
		</form>
			 
	</body>
</html>
<script>
function checkForm(){
	if (mgt_util.validate(form)){
		if($("#vendorCatC").val()==-1){
			
			$("#catmsg").html("请选择类别");
		}else{
		mgt_util.submitForm('#form');
			
		}
		
	}
}
</script>