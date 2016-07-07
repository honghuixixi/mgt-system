<!DOCTYPE html>
<html>
	<head>
		<title>广告商品新增</title>
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
		<form class="form-horizontal" id="form" action="${base}/vendorStk/add.jhtml" method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
				<div class="btn-group">
					<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
					<button class="btn btn-warning" data-toggle="jBox-close">关闭
						<i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
			</div>
			[#if vendorStkCat?exists]
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="visible" class="col-sm-3 control-label">编码：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm number required" name="catC" id="catC" value="${vendorStkCat.id.catC}" maxlength=10 readonly="readonly">
							    <input type="hidden" id = "catFlg" name ="catFlg">
								<input type="hidden" id = "nameFlg" name ="nameFlg">
							</div>
							<span id="spancatC" class="help-inline col-sm-3">*</span>
						</div>
					</div>
					<div class="col-xs-5"> 
						<div class="form-group">
							<label for="sortby" class="col-sm-3 control-label">名称：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm required"
								id="name" name="name" value="${vendorStkCat.name}" maxlength=256>
							</div>
							<span id="spanName" class="help-inline col-sm-3">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="sortby" class="col-sm-3 control-label">排序号：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm number required"
								id="sortNo" name="sortNo" value="${vendorStkCat.sortNo}" maxlength=10>
							</div>
							<span class="help-inline col-sm-3">*</span>
						</div>
					</div>
					<div class="col-xs-5"> 
						<div class="form-group">
							<label for="sortby" class="col-sm-3 control-label">备注：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm required"
								id="remark" name="remark" value="${vendorStkCat.remark}" maxlength=256>
							</div>
							<span class="help-inline col-sm-3">*</span>
						</div>
					</div>
					[#else]
						<div class="row">
							<div class="col-xs-5">
								<div class="form-group">
									<label class="col-sm-4 control-label">数据出错，请刷新再试！</label>
								</div>
							</div>
						</div>
					[/#if]
				</div>
			</div>
		</form>
	</body>
</html>
<script>
$("#catC").change(function(){
var catC = this.value;
	$.ajax({
	      url:'${base}/vendorStk/checkCatC.jhtml',
	      sync:false,
	      type : 'post',
	      dataType : "json",
	      data :{catC:catC},
	      error : function(data) {
		    alert("网络异常");
	        return false;
	      },
	      success : function(data) {
	      	$("#spancatC").html(data.msg);
	      	if(data.msg=="已存在！"){
	      	$(".btn-danger").addClass("disabled","disabled"); 
	      }else{
	      	$(".btn-danger").removeClass("disabled","disabled"); 
	      }	
	      }
	    });
});

$("#name").change(function(){
	var name = this.value;
	$.ajax({
	      url:'${base}/vendorStk/checkName.jhtml',
	      sync:false,
	      type : 'post',
	      dataType : "json",
	      data :{name:name},
	      error : function(data) {
		    alert("网络异常");
	        return false;
	      },
	      success : function(data) {
	      $("#spanName").html(data.msg);
	      if(data.msg=="已存在！"){
	      	$(".btn-danger").addClass("disabled","disabled"); 
	      }else{
	      	$(".btn-danger").removeClass("disabled","disabled"); 
	      }	
	      }
	    });
});

function checkForm(){
		mgt_util.submitForm('#form');
}
</script>