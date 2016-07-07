<!DOCTYPE html>
<html>
	<head>
		<title>添加客服</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script  type="text/javascript">
			$(function(){
	   			$("#userNo").chosen();
			});	
	 	</script>
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/vendorServiceProvider/add.jhtml">
			<input type="hidden" id="pkNo" name="pkNo" value="${vendorServiceProvider.pkNo}"/>
			<input type="hidden" id="createDate" name="createDate" value="${(vendorServiceProvider.createDate?string('yyyy-MM-dd HH:mm:ss'))!''}"/>
            <input type="hidden" name="activeFlg" value="${vendorServiceProvider.activeFlg}"/>
            <div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>	

			<div class="page-content" style="margin-left:10px;">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								客服名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="serviceName" maxlength=30
									name="serviceName" value="${vendorServiceProvider.serviceName}" onblur="return IsChinese();">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">状态：</label>
							<div class="col-sm-7">
								<select class="form-control required" id="activeFlg" name="activeFlg" disabled="disabled" >
									[#if vendorServiceProvider.activeFlg = 'P']
										<option value="P" selected>禁用</option>
										<option value="A">启用</option>
		                        	[#else]
		                        		<option value="A" selected>启用</option>
		                        		<option value="P">禁用</option>
		                        	[/#if]
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row" style="margin-top:10px;">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								客服类型：
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="type" name="type">
									<option value="">全部</option>
									<option value="1" [#if vendorServiceProvider.type = '1'] selected [/#if]>售前</option>
									<option value="2" [#if vendorServiceProvider.type = '2'] selected [/#if]>售中</option>
									<option value="3" [#if vendorServiceProvider.type = '3'] selected [/#if]>售后</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">分配用户：</label>
							<div class="col-sm-7">
								<select class="form-control required" id="userNo" name="userNo" style="width:165px;">
									<option value="">全部</option>
										[#if users ??]
									        [#list users as user]
					                        	[#if user.userNo = vendorServiceProvider.userNo]
					                        		<option value='${user.userNo}' selected>${user.name}</option>
					                        	[#else]
					                        		<option value='${user.userNo}'>${user.name}</option>
					                        	[/#if]
											[/#list]
										[/#if]
										
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row" style="margin-top:10px;">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								排序：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="sortNO" maxlength=30
									name="sortNO" value="${vendorServiceProvider.sortNO}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<!-- <div class="row" style="margin-top:10px;">
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">工作时间：</label>
							<div class="col-sm-7">
								<input type="text" id="workTimeFrom" name="workTimeFrom" maxlength=30  value="" class="form-control input-sm required">
								<script type="text/javascript"> 
								$(function(){
							         $("#workTimeFrom").bind("click",function(){
							             WdatePicker({doubleCalendar:true,dateFmt:'HH:mm:ss',autoPickDate:true,onpicked:function(){workTimeTo.click();}});
							         });
							         $("#workTimeTo").bind("click",function(){
							             WdatePicker({doubleCalendar:true,minDate:$('#workTimeFrom').val(),dateFmt:'HH:mm:ss',autoPickDate:true});
							         });
								});
								</script>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">至：</label>
							<div class="col-sm-7">
								<input type="text" id="workTimeTo" name="workTimeTo" maxlength=30  value="" class="form-control input-sm required">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div> -->
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
//判断输入的字符是否为中文    
function IsChinese(){     
	var str = $("#serviceName").val().trim();  
	if(str.length != 0){    
		reg=/^[\u0391-\uFFE5]+$/;    
		if(!reg.test(str)){    
		    alert("格式不正确，请输入中文!");
		    return false;
		}else if(str.length != 2){
			alert("只能输入两个中文，请重新输入!");
			return false;
		}
		return true;
	}
} 

function checkForm(){
	if (mgt_util.validate(form) && IsChinese()){
		//新增客服
		if($("#pkNo").val()==''){
			 $.ajax({
				 url:'${base}/vendorServiceProvider/findByNameFlag.jhtml',
				 sync:false,
				type : 'post',
				dataType : "json",
				data :{name:$("#serviceName").val()},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.data){
						mgt_util.submitForm('#form');
					}else{
						alert("客服名称已存在");
			 			return false;
					}
				}
			});	
		}else{
			//修改客服
			$.ajax({
				url:'${base}/vendorServiceProvider/findByPkNo.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{pkNo:$("#pkNo").val()},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if($("#serviceName").val() != data.serviceName){
						$.ajax({
							url:'${base}/vendorServiceProvider/findByNameFlag.jhtml',
							sync:false,
							type : 'post',
							dataType : "json",
							data :{name:$("#serviceName").val()},
							error : function(data) {
								alert("网络异常");
								return false;
							},
							success : function(item) {
								if(item.data){
									mgt_util.submitForm('#form');
								}else{
									alert("客服名称已存在");
									return false;
								}
							}
						});
					}else{
						mgt_util.submitForm('#form');
					}
				}
			});
		}
	  
  }
}
</script>
