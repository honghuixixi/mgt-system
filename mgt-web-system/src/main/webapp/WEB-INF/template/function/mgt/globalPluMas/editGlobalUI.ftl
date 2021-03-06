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
	<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
	<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
	<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/base64.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor-min.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	<script>	
		//chosen插件初始化，绑定元素
		$(function(){
    		$("#BRAND_C").chosen();
		});					
		//页面加载时触发jq富文本编辑框插件				
		var editor;
		KindEditor.ready(function(K) {
			editor = K.create('#kindcontent', {
				filePostName: "file",
				langType: 'zh_CN',
				syncType: "form",
				filterMode: false,
				pagebreakHtml: '<hr class="pageBreak" \/>',
				fileManagerJson:  "${base}/uploadImage",
				uploadJson: "${base}/upload/imageUpload.jhtml?type=Y",
				allowFileManager : true,
				afterChange: function() {
					this.sync();
				}
			});
		});
	</script>
   <script  type="text/javascript">
		$(document).ready(function(){
			$("#catId").lSelect({
				url: "${base}/stkCategory/catType.jhtml"
			});
			$("#b2cCatId").lSelect({
				url: "${base}/globalPluMas/catType.jhtml"
			});
		});
		
		function checkForm(){
				if (mgt_util.validate(addform)){
					if($(".imgclass").length <1){
						top.$.jBox.tip('商品图片不能为空');
						return false;
					}
					mgt_util.submitForm('#addform');
			  	}
			}
		</script>
    </head>
    <body>
       <div class="body-container">
   		<form class="form-horizontal" action="${base}/globalPluMas/save.jhtml" id="addform" name="addForm">
   		<div class="box-revise">
   		 	<div class="box-revise-list">
   		 		<h3>基本资料</h3>
   		 		<div class="revise-padBox">
	   		 		<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td height="40" width="25%">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">条码</label>
                			<input type="text" class="form-control"  name="pluC" id="PLU_C" value="${gpm.pluC}" style="width:120px;" readonly="readonly">
                			<input type="hidden" name="editFlg" value="${gpm.statusFlg}">
						</td>
					    <td colspan="2" width="30%" align="left">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">最小零售单位</label>
	            			<input type="text" class="form-control maxUomLength" maxlength='16' name="stdUom" id="STD_UOM" style="width:120px;" value="${gpm.stdUom}">
						</td>
						<td width="45%" align="left">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">品牌</label>
	            			<select class="form-control" style="width:120px;" name="brandC" id="BRAND_C" value="${gpm.brandC}">
		                        [#list brandList as brand]
									 [#if brand.brandC == gpm.brandC]
									 	<option value='${brand.brandC}' selected>${brand.name}</option>
									 	[#else]
									 	<option value='${brand.brandC}'>${brand.name}</option>
									 [/#if]
								[/#list]
		                    </select>
						</td>
					  </tr>
					  <tr>
					    <td colspan="2" width="50%" height="40">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品名称</label>
                			<input type="text" class="form-control" name="name" id="NAME" value="${gpm.name}" style="width:300px;">
						</td>
						<td align="left" colspan="2" width="50%" class="sh_tdBox">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">状态 </label>
							<!--span标签上加上sh_spanr这个类名则显示的是未审核状态， 删掉这个类名则是已审核状态-->
							[#if gpm.statusFlg == "Y"]
	                		<span class="sh_span">已审核<i></i></span>
	                		[#else]
	                		<span class="sh_span">未审核<i></i></span>
	                		[/#if]
						</td>
					  </tr>
					   
					  <tr>
					    <td colspan="4" width="100%" height="40">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">B2B平台分类</label>
                			<input type="hidden" id="catId" name="catId" value="${b2bCatId}" treePath = "${b2bTreePath}"/>
						</td>
					  </tr>
					  <tr>
						<td colspan="4" width="100%">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">B2C平台分类</label>
							<input type="hidden" id="b2cCatId" name="b2cCatId" value="${b2cCatId}" treePath = "${b2cTreePath}"/>
						</td>
						</tr>
					</table>
				</div>
   		 	</div>
   		 	[#include "/common/imgUpload.ftl" /]
	 		<div class="box-revise-list maT10">
   		 		<h3>商品详情</h3>
   		 		<div class="revise-padBox">
   		 			<textarea class="form-control" style="width: 531px; height: 364px;" name="description" id="kindcontent">${gpm.description}</textarea>
   		 		</div>
   		 	</div>
	 		<!--发布取消按钮-->
	 		<div class="upload-btnBox"><a class="upload-btna1" href="#" data-toggle="jBox-call"  data-fn="checkForm">发布</a><a href="#" onclick="mgt_util.closejBox('jbox-win');">取消</a></div>
	 	</div>
    </body>
</html>