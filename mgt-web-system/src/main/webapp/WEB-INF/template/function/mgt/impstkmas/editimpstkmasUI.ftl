<!DOCTYPE html>
<html>
	<head>
		<title>客户分类新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	<input type="hidden"  id="oldcatc"  name="oldcatc" value="${catC}" >
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/impstkmas/update.jhtml">
		<input type="hidden"  id="pkNo"  name="pkNo" value="${ism.pkNo}" >
		<input type="hidden"  id="impUserName"  name="impUserName" value="${ism.impUserName}" >
		<input type="hidden"  id="checkFlg"  name="checkFlg" value="${ism.checkFlg}" >
		<input type="hidden"  id="remark"  name="remark" value="${ism.remark}" >
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
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								条形码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required number" maxlength="13" id="pluC" maxlength=16
									name="pluC" value="${ism.pluC}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">商品名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required nameLength" maxlength="170" id="name" maxlength=30
									name="name" value="${ism.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								规格：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="modle" maxlength=16
									name="modle" value="${ism.modle}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">零售单位：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required maxUomLength" maxlength="16" id="stdUom" maxlength=30
									name="stdUom" value="${ism.stdUom}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								商品扩展名：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  " id="stkNameExt" maxlength=16
									name="stkNameExt" value="${ism.stkNameExt}" >
							</div>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">品牌：</label>
							<div class="col-sm-7">
								<select class="form-control input-sm required" name="brandC" id="BRAND_C" >
		                				<option value=''>请选择</option>
				                        [#list brandList as brand]
				                        	[#if brand.brandC = ism.brandC]
				                        		<option value='${brand.brandC}' selected>${brand.name}</option>
				                        	[#else]
				                        		<option value='${brand.brandC}'>${brand.name}</option>
				                        	[/#if]
										[/#list]
				                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								条形码（箱码）：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="packPluC" maxlength=16
									name="packPluC" value="${ism.packPluC}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">单位：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="uom" maxlength=30
									name="uom" value="${ism.uom}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								参考售价：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="listPrice" maxlength=16
									name="listPrice" value="${ism.listPrice}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">售价：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="netPrice" maxlength=30
									name="netPrice" value="${ism.netPrice}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								商家商品编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required char vendorStkCExt" id="vendorStkC" maxlength=16
									name="vendorStkC" value="${ism.vendorStkC}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">商家分类：</label>
							<div class="col-sm-7">
								<select class="form-control input-sm" name="vendorCatC" id="vendorCatC" >
		                				<option value=''>请选择</option>
				                        [#list catList as cat]
				                        	[#if cat.id.catC = ism.vendorCatC]
				                        		<option value='${cat.id.catC}' selected>${cat.name}</option>
				                        	[#else]
				                        		<option value='${cat.id.catC}'>${cat.name}</option>
				                        	[/#if]
										[/#list]
				                    </select>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								货品供应商：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="oldCode" maxlength=16
									name="oldCode" value="${ism.oldCode}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">可供货数量：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="supplyQty" maxlength=30
									name="supplyQty" value="${ism.supplyQty}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group pad_top">
							<label style="padding-top:13px;" for="memo" class="col-sm-4 control-label">平台分类：</label>
						    <div class="col-sm-7 width_big">
					           <span class="cat_list" style="display: block;float: left;overflow: hidden;padding-top: 8px;line-height:20px; width: 531px;">
              					</span>
						    </div>
						   
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">图片张数：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm" id="picQty" maxlength=30
									name="picQty" value="${ism.picQty}" >
						    </div>
						</div>
					</div>
				</div>

			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
	// 显示区域下拉列表
    function addCatSelect(v){
        v.append('<input type="text"  id="catId" name="catId" treePath="${stkCategory.treePath}" value="${ism.catId}" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
    }
	$(document).ready(function(){
		addCatSelect($(".cat_list"));
		$("#catId").lSelect({
			url: "${base}/stkCategory/catType.jhtml"
		});
	});
function checkForm(){
if (mgt_util.validate(form)){
if($("#oldcatc").val()!=$("#catC").val()){
	   $.ajax({
		 url:'${base}/vendorCust/findByCatFlag.jhtml',
		 sync:false,
		type : 'post',
		dataType : "json",
		data :{catC:$("#catC").val(),catName:$("#catName").val()},
		error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(!data.data){
				top.$.jBox.tip("代码已存在");
	 			return false;
			}
			if(data.success){
				top.$.jBox.tip("名称已存在");
	 			return false;
			}
			mgt_util.submitForm('#form');
		}
	});	
	}else{
	  mgt_util.submitForm('#form');
    }
  }
$(document).ready(function(){
			//商家编码是否存在
			jQuery.validator.addMethod("vendorStkCExt", function(value, element) { 
			var flg;
				$.ajax({
					url: '${base}/vendorPro/checkvendorstkc.jhtml?vendorStkC='+value,
					type: 'GET',
					cache: false,
					async: false,
					success: function(data) {
						if (data.ex == 'N') {
							flg = true;
						}else{
							flg = false ;
						}
					}
				});
				return flg;
			}, "该编码已存在");
})
}
</script>
