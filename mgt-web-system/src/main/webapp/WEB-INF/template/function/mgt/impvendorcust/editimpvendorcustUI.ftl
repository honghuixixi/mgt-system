<!DOCTYPE html>
<html>
	<head>
		<title>客户新增</title>
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
		<form class="form-horizontal" id="form"  method="post"  action="${base}/impvendorcust/update.jhtml">
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
								客户编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="userName" maxlength=16
									name="userName" value="${vendorCust.userName}" >
									<input type="hidden" id="pkNo" name="pkNo" value="${vendorCust.pkNo}">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">客户名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="name" maxlength=30
									name="name" value="${vendorCust.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">客户类型：</label>
						    <div class="col-sm-7">
								<select class="form-control input-sm required" id="custType" name="custType" >
									<option value="">请选择</option>
										[#if typeList?exists] 
  											[#list typeList as type]
    											<option value="${type.custType}" [#if type.custType==vendorCust.custType]selected = "selected"[/#if]>${type.name}</option>
  											[/#list]
										[/#if]
								</select>
						    </div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">客户负责人：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="crmPic" maxlength=30
									name="crmPic" value="${vendorCust.crmPic}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group pad_top">
							<label style="padding-top:13px;" for="memo" class="col-sm-4 control-label">所属区域：</label>
						    <div class="col-sm-7 width_big">
					           <span class="area_list" style="display: block;float: left;overflow: hidden;padding-top: 8px;line-height:20px; width: 531px;">
              					</span>
						    </div>
						   
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">客户地址：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm required " id="crmAddress1" maxlength=30
									name="crmAddress1" value="${vendorCust.crmAddress1}" >
						    </div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">类别：</label>
							<div class="col-sm-7">
							<input type="text" class="form-control input-sm required " id="accCat2" maxlength=30
									name="accCat2" value="${vendorCust.accCat2}" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">电话：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm" id="crmTel" maxlength=30
									name="crmTel" value="${vendorCust.crmTel}" >
						    </div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">邮编：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  zipCode" id="crmZip" maxlength=30
									name="crmZip" value="${vendorCust.crmZip}" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">业务员：</label>
						    <div class="col-sm-7">
						    <input type="text" class="form-control input-sm " id="picUserName" maxlength=30
									name="picUserName" value="${vendorCust.picUserName}" >
						    </div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">Email：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  email" id="emailAddr" maxlength=30
									name="emailAddr" value="${vendorCust.emailAddr}" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">传真：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm " id="crmFax" maxlength=30
									name="crmFax" value="${vendorCust.crmFax}" >
						    </div>
						    
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">商户编码：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm required " id="vendorCode" maxlength=30
									name="vendorCode" value="${vendorCust.vendorCode}" >
						    </div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">备注：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  " id="remark" maxlength=30
									name="remark" value="${vendorCust.remark}" >
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
			if($("#oldcustCode").val()!=$("#custCode").val()){
	   			$.ajax({
		 			url:'${base}/vendorCust/findByCustFlag.jhtml',
		 			sync:false,
					type : 'post',
					dataType : "json",
					data :{custCode:$("#custCode").val()},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						if(data.data){
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
						}else{
							alert("编码已存在");
	 						return false;
						}
					}
				});	
			}else{
	  			mgt_util.submitForm('#form');
    		}
  		}
	}

	function checkFormAdd(){
		if (mgt_util.validate(form)){
			if($("#oldcustCode").val()!=$("#custCode").val()){
	   			$.ajax({
		 			url:'${base}/vendorCust/findByCustFlag.jhtml',
		 			sync:false,
					type : 'post',
					dataType : "json",
					data :{custCode:$("#custCode").val()},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						if(data.data){
							$('#form').ajaxSubmit({
								success: function (html, status) {
	   								top.$.jBox.tip('保存成功！', 'success');
	   								top.$.jBox.refresh = true;
	   								resetAll()
	   								//mgt_util.closejBox('jbox-win');
								},error : function(data){
									top.$.jBox.tip('系统异常！', 'error');
									top.$.jBox.refresh = true;
									//mgt_util.closejBox('jbox-win');
									return;
								}
							});
						}else{
							alert("编码已存在");
	 						return false;
						}
					}
				});	
			}else{
	  			mgt_util.submitForm('#form');
    		}
  		}
	}
	
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
		var attr = $("#custAttr").val();
		var areaIds = $("#areaIds").val();
		if(attr=="P"){
			var ared="";
			$.ajax({
				url:'${base}/vendorCust/getAreaAll.jhtml',
		 		async: false,
				type : 'post',
				dataType : "json",
				data :{areaID:areaIds},
				success : function(datas) {
						ared= datas.data;
				}
			});
			$("#areaId").val(areaIds);
			$("#custCode").attr("readonly","readonly");
			$("#custName").attr("readonly","readonly");
			$("#custType").attr("readonly","readonly");
			$("#crmPic").attr("readonly","readonly");
			$(".area_list").html(ared);
			$("#crmAddress1").attr("readonly","readonly");
			$("#crmZip").attr("readonly","readonly");
			$("#crmTel").attr("readonly","readonly");
			$("#emailAddr").attr("readonly","readonly");
			$("#crmFax").attr("readonly","readonly");
			$("#urlAddr").attr("readonly","readonly");
			$("#createdBy").attr("readonly","readonly");
			$("#imgUrl").attr("readonly","readonly");
			$("#reMark").attr("readonly","readonly");
			$("#payTerms").attr("readonly","readonly");
		}else if(attr=="O"){
			$("#custCode").attr("readonly","readonly");
		}
	});
	
	//清空
	function resetAll(){
		var createdBy= $("#createdBy").val();
		$("#form :input").not(":button, :submit, :reset, :hidden").val("").removeAttr("checked").remove("selected");
		$("#createdBy").val(createdBy);
		$("#custAttr").val("");
		$("#areaIds").val("");
			// 删除区域下拉列表
    		removeAreaSelect($(".area_list"))
			//加载区域控件
			addAreaSelect($(".area_list"));
			loadArea()
	}
	

	// 加载区域选项
    function loadArea(){
	    $("#areaId").lSelect({
		    url:"${base}/common/area.jhtml"
	    });
    }
     // 显示区域下拉列表
    function addAreaSelect(v){
        v.append('<input type="text"  id="areaId" name="areaId" treePath="${treePath}" value="${vendorCust.areaId}" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
    }
    
   	function validateData(obj){
				if (/\D/.test($(obj).val())) {
					$(obj).val(1);
				}
			}
</script>
