<!DOCTYPE html>
<html>
	<head>
		<title>运营中心信息修改</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	
	<body class="toolbar-fixed-top">
		<input type="hidden"  id="areaIds"  name="areaIds" value="${landmarkMas.areaId}" >
		<form class="form-horizontal" id="form"  method="post"  action="${base}/landMark/save.jhtml">
			<input type="hidden"  id="uuid"  name="uuid" value="${landmarkMas.uuid}" >
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
									name="code" disabled="disabled" value="${landmarkMas.code}" >
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
									name="name" value="${landmarkMas.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								业务员：
							</label>
							<div class="col-sm-4">
								<select  id="picNo" maxlength=30 name="picNo" class="form-control input-sm" value="">
										<option value="">请选择</option>
									[#list mgtEmployeeList as mgtEmployeeList]
										[#if mgtEmployeeList.USER_NO == landmarkMas.picNo]
											<option value="${mgtEmployeeList.USER_NO}" selected >${mgtEmployeeList.USER_NAME}</option>
										[#else]
											<option value="${mgtEmployeeList.USER_NO}">${mgtEmployeeList.USER_NAME}</option>
										[/#if]
									[/#list]
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
			                        <option value="Y" [#if landmarkMas.statusFlg=='Y']selected=selected[/#if]>启用</option>
			                        <option value="N" [#if landmarkMas.statusFlg=='N']selected=selected[/#if]>停用</option>
			                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group pad_top">
							<label style="padding-top:13px;" for="memo" class="col-sm-4 control-label">所属区域：</label>
						    <div class="col-sm-7 width_big">
					           <span class="area_list" style="display: block;float: left;overflow: hidden;padding-top: 8px;line-height:20px; width: 531px;">
              					*</span>
						    </div>
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
			                        <option value="">请选择...</option>
									[#if landMarkMasList?exists]
	        						[#list landMarkMasList as landMarkMasList]
			                        	[#if landMarkMasList.USER_NAME == landmarkMas.userName]
											<option value="${landMarkMasList.USER_NAME}" selected >${landMarkMasList.NAME}</option>
											[#else]
											<option value="${landMarkMasList.USER_NAME}">${landMarkMasList.NAME}</option>
										[/#if]
			                        [/#list]
			                        [/#if]
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
								<textarea class="form-control" id="description" name="description">${landmarkMas.description}</textarea>
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
	  			mgt_util.submitForm('#form');
    		}
	
	
	$().ready(function() {
				$(".isArea").live("change",function(){
				if($("select[name='areaId_select']").length == 3){
					$("select[name='areaId_select']").each(function(index,element){
						if(index == 2){
							if($(this).val()){
							$("#userName").find("option").remove(); 
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
											$('#userName').append("<option value=''>请选择...</option>"); 
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
			
			
	$(document).ready(function() {
		addAreaSelect($(".area_list"));
		var area =$("#areaIds").val();
		if(area!=null && area!=""){
			$.ajax({
            	type: 'GET',
            	contentType: 'application/json',
            	async: false,
            	url: "${base}/common/getArea.jhtml",
            	data: {areaID:area},
            	dataType: 'json',
            	success: function(data){  
                	if(data.message.type == "success"){
                    	var jobj = jQuery.parseJSON(data.content);
			       		// 重新加载区域数据
			        	$("#areaId").val(jobj.areaId);
        				$("#areaId").attr("treePath",jobj.treePath);
			        	loadArea();
                	} else {
                    	myAlert(data.message.content);
                	}           
            	},
	        	error: function(){
	            	myAlert(messages['shop.message.sysError']);
	        	}  
        	});
		}else{
			loadArea()
		}
	});
	
	// 加载区域选项
    function loadArea(){
	    $("#areaId").lSelect({
		    url:"${base}/common/areao.jhtml"
	    });
    }
     // 显示区域下拉列表
    function addAreaSelect(v){
        v.append('<input type="text"  id="areaId" name="areaId" treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
    }
</script>
