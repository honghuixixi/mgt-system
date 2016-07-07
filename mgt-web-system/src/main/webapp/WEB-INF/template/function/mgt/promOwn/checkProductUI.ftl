<!DOCTYPE html>
<html>
	<head>
	    <meta charset="utf-8" />
		<title>审核商品信息</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		
	</head>
	<body class="toolbar-fixed-top">
						
	[#if stkMasOwn?exists]		
	<form class="form-horizontal details_w" id="queryForm" >
	    <div class="page-content">
    				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
						 <input id="uuid" name="uuid" value='${stkMasOwn.uuid}' type="hidden"/>
							<label for="name" class="col-sm-4 control-label">
								登陆名字：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="userName" name="userName" value='${stkMasOwn.userName}' maxlength=32>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								条码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" id="pluc" name="pluc" value='${stkMasOwn.pluc}' maxlength=128>
							</div>
						</div>
					</div>
				</div>
				
				
				
				
				
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								商品名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required"  id="name" name="name" value='${stkMasOwn.name}' maxlength=512>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								单位：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" id="uom" name="uom" value='${stkMasOwn.uom}' maxlength=8>
							</div>
						</div>
					</div>
				</div>
				
				
				
				
					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								用户商品类别：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required"  id="catc" name="catc" value='${stkMasOwn.catc}' maxlength=16>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								毛利率：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number " id="gpRate" name="gpRate" value='${stkMasOwn.gpRate}' >
							</div>
						</div>
					</div>
				</div>
				
				
				
				
					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								进价：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number "  id="purPrice" name="purPrice" value='${stkMasOwn.purPrice}'>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								零售标价：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number " id="posListPrice" name="posListPrice" value='${stkMasOwn.posListPrice}'>
							</div>
						</div>
					</div>
				</div>
				
				
				
				
				
						<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								折扣：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number"  id="posDiscNum" name="posDiscNum" value='${stkMasOwn.posDiscNum}' maxlength=20>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								零售净价：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number" id="posNetPrice" name="posNetPrice" value='${stkMasOwn.posNetPrice}' maxlength=200>
							</div>
						</div>
					</div>
				</div>
				
				
					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								商品缩略图片：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm " id="producThumbails" name="producThumbails" value='${stkMasOwn.producThumbails}' maxlength=512>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
							商品图片：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" id="productImgs" name="productImgs" value='${stkMasOwn.productImgs}' maxlength=512>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								系统商品类别：
							</label>
							<div class="col-sm-7">
							<span class="cat_list width_big" style="display: block;float: left;overflow: hidden;line-height:20px; width: 531px;">
							<input type="hidden" class="form-control input-sm" id="catId" name="catId" value='${stkMasOwn.catId}'>
							</div>
						</div>
					</div>
				</div>
					
				</div>	
    
   	     <div style="padding-top:20px">
   	     
        <button type=button class="btn btn-info edit" style="margin-right:150px;margin-left:150px;"  onclick='editPro()'>更新商品 </button>
        <button type=button class="btn btn-info edit" onclick='checkPro()'>审核通过 </button>
       
        </div>
    </form>
</div> 
  [/#if]
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div> 
</body>
<script type="text/javascript">
function editPro(){
	$.jBox.confirm("确认修改吗?", "提示", function(v){
	if(v == 'ok'){
		  if (mgt_util.validate(queryForm)){
	 	$.ajax({
		    url: '${base}/promown/editProduct.jhtml',
			method:'post',
			dataType:'json',
			data:mgt_util.formObjectJson($("#queryForm")),
			sync:false,
			error : function(data) {
			alert("网络异常");
			return false;},
			success : function(data) {
			if(data.code==001){		
				top.$.jBox.tip('保存成功！', 'success');
				top.$.jBox.refresh = true;
				}
				else{
				top.$.jBox.tip('保存失败！', 'error');
						return false;
				}
			}
		});	
	}}});
}

function checkPro(){
	$.jBox.confirm("确认修改吗?", "提示", function(v){
	if(v == 'ok'){
		if (mgt_util.validate(queryForm)){
	 	$.ajax({
		    url: '${base}/promown/editProductStatus.jhtml',
			method:'post',
			dataType:'json',
			data:mgt_util.formObjectJson($("#queryForm")),
			sync:false,
			error : function(data) {
			alert("网络异常");
			return false;},
			success : function(data) {
			if(data.code==001){		
				top.$.jBox.tip('审核成功！', 'success');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				}
				else{
				top.$.jBox.tip('审核失败！', 'error');
				mgt_util.closejBox('jbox-win');
						return false;
				}
			}
		});	
	}}});
}

// 加载商品类別选项
function loadCat(){

  $("#catIds").lSelect({
		url:"${base}/category/stkCate.jhtml"
	});
}
// 显示下拉列表
function addCatSelect(v){
   v.append('<input type="text"  id="catIds" name="catId"  treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
}

$(document).ready(function(){
    addCatSelect($(".cat_list"));
	var catId =$("#catId").val();
	if(catId=="-1"){
	    loadCat();
	}else{
		 $.ajax({
	        	type: 'GET',
	        	contentType: 'application/json',
	        	async: false,
	        	url: "${base}/category/getCat.jhtml",
	        	data: {catId:catId},
	        	dataType: 'json',
	        	success: function(data){  
	            	if(data.message.type == "success"){
	                	var jobj = jQuery.parseJSON(data.content);
			       		// 重新加载区域数据
			        	$("#catIds").val(jobj.catId);
	    				$("#catIds").attr("treePath",jobj.treePath);
	    				loadCat();
	            	} else {
	                	myAlert(data.message.content);
	            	}           
	        	},
	        	error: function(){
	            	myAlert(messages['shop.message.sysError']);
	        	}  
	    	});
		
	}
});




</script>
</html>