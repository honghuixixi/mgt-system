<!DOCTYPE html>
<html>
	<head>
		<title>地标新增</title>
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
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<style>
		.new_select select{width:auto;display:inline-block;}
		</style>
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/landMark/add.jhtml">
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
								编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="code" maxlength=30
									name="code" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="name" maxlength=30
									name="name" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="picNo" class="col-sm-4 control-label">
								业务员：
							</label>
							<div class="col-sm-4">
								<select class="form-control" name="picNo">
			                        <option value="">请选择...</option>
									[#if mgtEmployeeList?exists]
	        						[#list mgtEmployeeList as mgtEmployeeList]
			                        <option value="${mgtEmployeeList.USER_NO}">${mgtEmployeeList.USER_NAME}</option>
			                        [/#list]
			                        [/#if]
			                    </select>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								状态：
							</label>
							<div class="col-sm-4">
								<select class="form-control required" name="statusFlg">
			                        <option value="">请选择...</option>
			                        <option value="Y">启用</option>
			                        <option value='N'>停用</option>
			                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-10">
						<div class="form-group">
							<label class="col-sm-4 control-label" style="width:96px;float:left;">
							区域:
							</label>
							<div class="new_select col-sm-7" style="float:left;padding-left:21px;">
								<input type="hidden" id="areaId" name="areaId"/>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<br/>
				[#include "/common/biaozhu.ftl" /]
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								配送店铺：
							</label>
							<div class="col-sm-4">
			                    <select class="form-control" name="userName" id="userName">
	                    			<option value="0"></option>
	                    		</select>
							</div>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
							描述:
							</label>
							<div class="new_select col-sm-7">
								<textarea class="form-control" id="description" name="description"></textarea>
							</div>
						</div>
					</div>
				</div>
				
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
function checkForm(){
	if (mgt_util.validate(form)){
	   $.ajax({
		 url:'${base}/landMark/findByCodeFlag.jhtml',
		 sync:false,
		type : 'post',
		dataType : "json",
		data :{code:$("#code").val()},
		error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(data.data){
				mgt_util.submitForm('#form');
			}else{
				top.$.jBox.tip('编码已存在！');
	 			return false;
			}
		}
	});	
  }
}

			$().ready(function() {
		  		var $areaId = $("#areaId");
		  		// 菜单类型选择
				$areaId.lSelect({
					url: "${base}/common/areao.jhtml"
				});
				
				$(".isArea").live("change",function(){
				if($("select[name='areaId_select']").length == 3){
					$("select[name='areaId_select']").each(function(index,element){
						if(index == 2){
							if($(this).val()){
								var value=$("#areaId").val();
								$.ajax({
									url: "${base}/landMark/selectOptions.jhtml",
									sync:false,
									type: "post",
									dataType: "json",
									data :{
										'value':value,
									},
									success: function(data) {
											$.each(data.otheroptions, function(value, name) {
												$('#userName').append("<option value='"+value+"'>"+name+"</option>"); 
											});
									}
								});
							
							}
						}
					});
				}
			});
				
			});
</script>