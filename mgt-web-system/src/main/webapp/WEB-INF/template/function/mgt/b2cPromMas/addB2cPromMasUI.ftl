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
		<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>	
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor-min.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
	</head>
 <script>
   $(document).ready(function(){
			$('#reupload').hide();
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
			
			addAreaSelect($(".area_list"));
			loadArea();
   });
   
   	// 加载区域选项
	function loadArea(){
		$("#areaId").lSelect({
			isArea:"on",
    		url:"${base}/common/areao.jhtml"
		});
	}
	// 显示区域下拉列表
	function addAreaSelect(v){
		v.append('<input type="text"  id="areaId" name="areaId"  treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
	}
   
   //ajax 实现文件上传 
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
    function checkForms(){ 
    	 if (mgt_util.validate(form)){
	    	if($("#fullPath").val() ==''){
						 	top.$.jBox.tip('请上传商品图片！','error');
						 	return false;
			}
    	 	$.ajax({
					type: "POST",
					url:  '${base}/b2cPromMas/existByPromCode.jhtml',
					async:false,
					type : 'post',
					data: {
					   promCode:$("#promCode").val(),
					   pkNo:null
					},
					dataType : "json",
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success: function(data){
						if(data){
							if(data.code=="001"){
								$.jBox.tip('促销编号已经存在！');
								return;
							}else if(data.code=="002"){
								mgt_util.submitForm('#form');
							}
						}else{
							$.jBox.tip('请刷新重试，或联系管理员！');
							return;
						
						}
					}
				});
   					
    	 }
    }
    </script>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/b2cPromMas/addB2cPromMas.jhtml" method="POST">
			<input type="hidden" name="fullPath" id="fullPath" value=''/>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call"  data-fn="checkForms">
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 	        <div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="promCode" class="col-sm-4 control-label">
								促销编码：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="promCode" name="promCode" class="form-control required"   /> 
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="noCarts" class="col-sm-4 control-label">
								是否可加入购物车：
							</label>
							<div class="col-sm-7">
		      					<input  type="radio"  style="margin-bottom:2px;height:30px;width:40px;" name="noCarts" value="N"  checked="checked"><span style="height:30px;width:40px;">否</span>
							    <input  type="radio"  style="margin-bottom:2px;height:30px;width:40px;" name="noCarts" value="Y" ><span style="height:30px;width:40px;">是</span>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="dateFrom" class="col-sm-4 control-label">
								开始时间：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="dateFrom" name="dateFrom" class="form-control required" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"  /> 
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="dateTo" class="col-sm-4 control-label">
								结束时间：
							</label>
							<div class="col-sm-7">
		      				<input type="text" id="dateTo" name="dateTo" class="form-control required"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'dateFrom\')}',dateFmt:'yyyy-MM-dd',readOnly:true})" />
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								优惠贴补：
							</label>
							<div class="col-sm-7">
								<select class="form-control input-sm required" id="couponFlg" name="couponFlg" style="width:200px;" >
									<option value="P" selected = "selected">网站平台</option>
									<option value="V" >供应商</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">图片：</label>
						    <div class="col-sm-7">
						    	<img id="imgsrc" name="imgsrc"  hight="40px" width="80px"/>
							    <div id="fileUpload" name="fileUpload">
									<input class="control-label" type="file" id="file" name="file" onchange="ajaxFileUpload();"/>
								<div>	
					        	<a id = "reupload" name= "reupload" >重新上传</a>
								<a id = "cancel" name= "cancel" >取消</a>
						    </div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
						
					</div>
				</div>
				</div>
				</div>
	 			<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="spNote" class="col-sm-4 control-label">备注：</label>
						    <div class="col-sm-7">
					            <textarea class="form-control" style="width: 531px; height: 164px;" name="note" id="note" maxlength=300></textarea>
						    </div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
</html>
  