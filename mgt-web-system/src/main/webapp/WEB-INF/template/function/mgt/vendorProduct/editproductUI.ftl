<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品信息管理</title>
	[#include "/common/commonHead.ftl" /]
	<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
	<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
   <script  type="text/javascript">
		$(document).ready(function(){
   			//商家编码是否存在
			jQuery.validator.addMethod("vendorStkCExt", function(value, element) { 
			var flg;
				$.ajax({
					url: '${base}/vendorPro/checkvendorstkc.jhtml?vendorStkC='+value+'&pluC='+${gpm.pluC},
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
		});
   			
   		function checkForm(){
			if (mgt_util.validate(addform)){
				 var baseStk = $('input[name="baseStk"]:checked').val();
				 if(typeof(baseStk) == 'undefined'){
				 	top.$.jBox.tip('请指定基准库存！','error');
				 	return false;
				 }
				$("#baseStkC").val(baseStk);
				editName();
				var rownum = $("#packTab tr").length;
				 if(rownum == '0'){
				 	top.$.jBox.tip('请添加包装单位！','error');
				 	return false;
				 }
				var str ="";
				 $("input[name='stkNameExt']").each(function(i,val) {
					str = str+$(val).val()+",";
				});
				$("#stkNameExts").val(str);
				mgt_util.submitForm('#addform');
		  	}
		}
		//校验完成前所有input的name属性不同，校验完成后，name改会分组状态
		function editName(){
			$("input.pack").each(function(i,val) {
				$(val).attr('name',$(val).attr('namestr'));
			});
		}
	</script>
    </head>
    <body>
       <div class="body-container">
   		 <form class="form-horizontal" action="${base}/vendorPro/update.jhtml"  id="addform" name="addForm" method="POST">
   		 <div class="box-revise">
   		 	<div class="box-revise-list">
   		 		<h3>基本资料</h3>
   		 		<div class="revise-padBox">
	   		 		<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td height="40" width="33%">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品条码</label>
	            			<input type="text" class="form-control"  name="pluC" id="PLU_C" value="${gpm.pluC}" style="width:120px;" readonly="readonly">
	            			<input type="hidden" name="editFlg" id="editFlg" value="Y"/>
	            			<input type="hidden" name="baseStkC" id="baseStkC"/>
	            			<input type="hidden" name="stkNameExts" id="stkNameExts"/>
	            			<input type="hidden" name="bcFlg" id="bcFlg" value='${bcFlg}'/>
						</td>
					    <td width=34%"" align="center">
					    	<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">最小零售单位</label>
	                		<input type="text" readonly="readonly" class="form-control maxUomLength" maxlength='16' name="stdUom" id="STD_UOM" style="width:60px;" value="${gpm.stdUom}">
					    </td>
					    <td width="33%" align="right">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品品牌</label>
	            			<select class="form-control" disabled="true" style="width:120px;" name="brandC" id="BRAND_C" value="${gpm.brandC}">
		                        [#list brandList as brand]
									 [#if brand.id.brandC == gpm.brandC]
									 	<option value='${brand.id.brandC}' selected>${brand.name}</option>
									 	[#else]
									 	<option value='${brand.id.brandC}'>${brand.name}</option>
									 [/#if]
								[/#list]
		                    </select>
						</td>
					  </tr>
					  <tr>
					    <td colspan="3">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="50%" height="40">
										<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品名称</label>
	                					<input type="text" readonly="readonly" class="form-control" value="${gpm.name}" style="width:300px;">
									</td>
									<td align="right">
										<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">平台分类</label>
										<input type="text" readonly="readonly" class="form-control" id="CAT_NAME" value="${catName}" style="width:310px;">
									</td>
								</tr>
							</table>
						</td>
					  </tr>
					  <tr>
					    <td height="40" width="33%;">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">创建时间 </label>
							<input type="text" readonly="readonly" class="form-control" value="${sm.createDate?string("yyyy-MM-dd HH:mm:ss")}" style="width:180px;">
						</td>
					    <td align="center" width="34%;">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">上架时间 </label>
							[#if sm.shelfDate??]
								<input type="text" readonly="readonly" class="form-control" value="${sm.shelfDate?string("yyyy-MM-dd HH:mm:ss")} " style="width:180px;">
								[#else]
								<input type="text" readonly="readonly" class="form-control" style="width:180px;">
                			[/#if]
						</td>
					    <td align="right" style="position:relative;" width="33%;">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">是否上下架</label>
	                		[#if sm.epFlg == 'Y']
                				<span class="ynBtn-f"></span><font class="ynBtn-s">是</font>
            				[#else]
                				<span class="ynBtn-f"></span><font class="ynBtn-s">否</font>
            				[/#if]
						</td>
					  </tr>
					  <tr>
					    <td height="40" width="33%;">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商家编码</label>
	                		<input type="text" class="form-control required char vendorStkCExt" maxlength="32" name="vendorStkC" style="width:120px;" value="${sm.vendorStkC}">
						</td>
					    <td width="34%" align="center">
					    	<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品分类</label>
	                		<select class="form-control required" name="vendorCatC" style="width:120px;" value="${sm.vendorCatC}">
		                        [#list catList as cat]
									 [#if cat.id.catC == sm.vendorCatC]
									 	<option value='${cat.id.catC}' selected>${cat.name}</option>
									 	[#else]
									 	<option value='${cat.id.catC}'>${cat.name}</option>
									 [/#if]
								[/#list]
		                    </select>
					    </td>
					    <td width="33%" align="right">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;"> FBP类型</label>
	                		<select class="form-control" name="ref6" style="width:120px;">
	            				<option value=''>请选择</option>
		                        [#list ref6List as ref]
		                        [#if ref.REF_CODE == sm.ref6]
		                        	<option value='${ref.REF_CODE}' selected>${ref.NAME}</option>
		                        	[#else]
									<option value='${ref.REF_CODE}'>${ref.NAME}</option>
		                        [/#if]
								[/#list]
		                    </select>
						</td>
					  </tr>
					</table>
				</div>
   		 	</div>
   		 	<div class="box-revise-list maT10">
				<h3>商品图片</h3>
				<div class="revise-padBox">
					<dl class="revise-uploadDl" id="imgDiv">
						[#if imgList ??]
						[#list imgList as img]
							<dd><img class="imgclass" src="${img.serverUrl}${img.smallPath}" width="96" height="96" /><input type="hidden" name="saveImg" value="${img.smallPath}" pkNo="${img.pkNo}"></dd>
						[/#list]
						[/#if]
					</dl>
				</div>
			</div>
   		 	[#include "/function/mgt/vendorProduct/editPack.ftl" /]
	 		<div class="box-revise-list maT10">
   		 		<h3>商品详情</h3>
   		 		<div class="revise-padBox">
   		 			${gpm.description}
   		 		</div>
   		 	</div>
	 		<!--发布取消按钮-->
	 		<div class="upload-btnBox"><a class="upload-btna1" href="#" data-toggle="jBox-call"  data-fn="checkForm">发布</a><a href="#" onclick="mgt_util.closejBox('jbox-win');">取消</a></div>
	 	</div>
            </form>
    </body>
</html>
 



