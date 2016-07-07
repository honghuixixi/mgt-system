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
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="visible" class="col-sm-3 control-label">编码：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm number required" name="catC" id="catC" value="" maxlength=10>
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
								id="name" name="name" value="" maxlength=256>
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
								id="sortNo" name="sortNo" value="" maxlength=10>
							</div>
							<span class="help-inline col-sm-3">*</span>
						</div>
					</div>
					<div class="col-xs-5"> 
						<div class="form-group">
							<label for="sortby" class="col-sm-3 control-label">备注：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm required"
								id="remark" name="remark" value="" maxlength=256>
							</div>
							<span class="help-inline col-sm-3">*</span>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
</html>
<script>
$("#catC").blur(function(){
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
	      	$("#catFlg").val("Y");
	       if(data.msg=="可以使用！"){
	      	$("#catFlg").val("Y");
	      }else{
	     	$("#catFlg").val("N");
	      }	
	      }
	    });
});

$("#name").blur(function(){
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
	      if(data.msg=="可以使用！"){
	      $("#nameFlg").val("Y");
	      }else{
	      $("#nameFlg").val("N"); 
	      }	
	      }
	    });
});

function checkForm(){
	if($("#nameFlg").val() == 'Y' && $("#catFlg").val() == 'Y'){
		mgt_util.submitForm('#form');
	}else if($("#catFlg").val() == 'Y' && $("#nameFlg").val() != 'Y'){
		top.$.jBox.tip("请正确填写名称", 'error');
	}else if($("#catFlg").val() != 'Y' && $("#nameFlg").val() == 'Y'){
		top.$.jBox.tip("请正确填写编码", 'error');
	}else{
		top.$.jBox.tip("请填写完整信息", 'error');
	}
}
</script>