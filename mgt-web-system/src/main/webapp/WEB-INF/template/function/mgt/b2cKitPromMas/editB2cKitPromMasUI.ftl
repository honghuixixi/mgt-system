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
				<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
				<script type="text/javascript">
		   $(document).ready(function(){
		   		$("#imgsrc").show();
		   		$("#file").hide();
				//$('#reupload').hide();
				$('#cancel').hide();
				$("#reupload").click(function(){
					$("#file").show();
					$("#imgsrc").hide();
					$("#cancel").show();
					$(this).hide();
				});
				
				$("#cancel").click(function(){
					$("#file").hide();
					$("#imgsrc").show();
					$("#cancel").hide();
					$("#reupload").show();
				});
	 	  });
		function ajaxFileUpload() {
			$.ajaxFileUpload({
				url : "${base}/upload/imageUpload.jhtml",
				secureuri : false,
				data : {
					filePre : "feedback",
					p : new Date()
				},
				fileElementId : "file",
				dataType : "json",
				success : function(data) {
					if (data.status == "success") {
						$("#fullPath").val(data.fullPath);
						$("#file").hide();
						var fileUpload = document.getElementById("file").value; 
						if (fileUpload != "")
						 {
						  var obj = document.getElementById('file') ;
						  obj.outerHTML=obj.outerHTML; 
						  }
						var fllUrl = '${base}'+'/uploadImage/'+data.fullUrl;
						$("#imgsrc").attr("src",fllUrl);
						$("#imgsrc").show();
						$("#cancel").hide();
						$("#reupload").show();
					}
					switch(data.message){
					 //解析上传状态
						case "-1" : 
							alert("上传文件不能为空!");
						    break;
						case "1" : 
							alert("上传失败!");
						    break;
						case "2" : 
							alert("文件超过上传大小!");
						    break;
						case "3" : 
							alert("文件格式错误!");
						    break;
						case "4" : 
							alert("上传文件路径非法!");
						    break;
						case "5" :
							alert("上传目录没有写权限!");
						    break;
					}
				},
				error : function(data) {
					alert("上传失败！");
				}
			});
		}
		</script>
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/b2cKitPromMas/editB2cKitPromMas.jhtml" method="POST">
		    <input type="hidden" name="fullPath" id="fullPath" value=''/>
			<input type="hidden" id="pkNo" name="pkNo" value="${b2cKitPromMas.pkNo}"/>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 	        <div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="beginDate" class="col-sm-4 control-label">
								起始时间：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="beginDate" name="dateFrom" class="form-control required" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})" style="width:200px;" value="${b2cKitPromMas.dateFrom?string('yyyy-MM-dd HH:00:00')}"/> 
							</div>
						</div>
						
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								结束时间：
							</label>
							<div class="col-sm-7">
		      				<input type="text" id="endDate" name="dateTo" class="form-control required"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}',dateFmt:'yyyy-MM-dd',readOnly:true})"style="width:200px;" value="${b2cKitPromMas.dateTo?string('yyyy-MM-dd HH:00:00')}"/>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="kitName" class="col-sm-4 control-label">
								套餐名称：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="kitName" name="kitName" class="form-control required" value="${b2cKitPromMas.kitName}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="promPrice" class="col-sm-4 control-label">
								价格：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="promPrice" name="promPrice" class="form-control required number" value="${b2cKitPromMas.promPrice}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="maxQty" class="col-sm-4 control-label">
								最大可供应套餐数量：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="maxQty" name="maxQty" class="form-control required number" value="${b2cKitPromMas.maxQty}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="maxCustQty" class="col-sm-4 control-label">
								单个客户最大可购买套餐数量：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="maxCustQty" name="maxCustQty" class="form-control required number" value="${b2cKitPromMas.maxCustQty}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="maxCustCount" class="col-sm-4 control-label">
								单个客户最大可购买次数：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="maxCustCount" name="maxCustCount" class="form-control required number" value="${b2cKitPromMas.maxCustCount}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="couponFlg" class="col-sm-4 control-label">
								补贴方：
							</label>
							<div class="col-sm-7">
		      					<select class="form-control input-sm required" id="couponFlg" name="couponFlg" >
		      						<option value="P"[#if b2cKitPromMas.couponFlg = "P"] selected=selected[/#if]>平台</option>
		      						<option value="V"[#if b2cKitPromMas.couponFlg = "V"] selected=selected[/#if]>供应商或店铺</option>
		      					</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="promCode" class="col-sm-4 control-label">
								促销代码：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="promCode" name="promCode" class="form-control required abc" value="${b2cKitPromMas.promCode}"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="accCode" class="col-sm-4 control-label">
								供应方：
							</label>
							<div class="col-sm-7">
		      					<select class="form-control input-sm required" id="accCode" name="accCode" >
		      						[#if b2cKitPromItem?exists && b2cKitPromItem?size == 0]<!-- 未添加条目，可以修改 -->
			      						<option value="">请选择</option>
			      						[#if userList?exists]
			      						[#list userList as user]
			      						<option value="${user.USER_NO}" [#if user.USER_NO == b2cKitPromMas.accCode]selected="selected"[/#if]>${user.NAME}</option>
			      						[/#list]
			      						[/#if]
		      						[#else]<!-- 添加了条目，不可修改 -->
		      							[#if userList?exists]
			      						[#list userList as user]
			      						[#if user.USER_NO == b2cKitPromMas.accCode]
			      						<option value="${b2cKitPromMas.accCode}" >${user.NAME}</option>
			      						[/#if]
			      						[/#list]
			      						[/#if]
		      						[/#if]
		      						
		      					</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">图片：</label>
						    <div class="col-sm-7">
						    <img id="imgsrc" name="imgsrc" src="${b2cKitPromMas.thumbnail}" hight="40px" width="80px"/>
						    <div id="fileUpload" name="fileUpload">
								<input class="control-label" type="file" id="file" name="file" onchange="ajaxFileUpload();"/>
							<div>	
					        <a id = "reupload" name= "reupload" >重新上传</a>
							<a id = "cancel" name= "cancel" >取消</a>
						    </div>
						</div>
					</div>
				</div>
				 <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="note" class="col-sm-4 control-label">
								备注：
							</label>
							<div class="col-sm-7">
		      					<textarea id="note" name="note"  class="form-control"  style="width: 531px; height: 164px;">${b2cKitPromMas.note}</textarea>
							</div>
						</div>
					</div>
				</div>
				<input style="display: none" type="text" id="statusFlg" name="statusFlg" class="form-control" value="A"/>
			</div>
		</form>
	</body>
</html>
   <script>
    function checkForms(){ 
    	 if (mgt_util.validate(form)){
       				top.$.jBox.open("iframe:${base}/prom/addProm.jhtml?beginDate="+$('#beginDate').val()+"&endDate="+$('#endDate').val()+"&spNote="+$('#spNote').text(), "选择商品", 960, 650, {
   						border : 0,
   						persistent : true,
   						iframeScrolling : 'no',
   						buttons : {}
   					});
   					
    	 }
    }
    
    function checkForm(){
    	if (mgt_util.validate(form)){
    		$('#form').ajaxSubmit({
    			success: function (html, status) {
    						top.$.jBox.tip('保存成功！', 'success');
    						top.$.jBox.refresh = true;
    						mgt_util.closejBox('jbox-win');
    					},error : function(data){
    						top.$.jBox.tip('系统异常！', 'error');
    						top.$.jBox.refresh = true;
    						mgt_util.closejBox('jbox-win');
    						return;
    					}
    		});
    	}
    	
	}
    </script>