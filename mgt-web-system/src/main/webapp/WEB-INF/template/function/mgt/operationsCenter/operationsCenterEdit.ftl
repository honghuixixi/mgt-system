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
		<style>
			.yyzx_xgBox .form-group .width_big .input-sm{width:auto;}
			.yyzx_xgBox .form-horizontal .width_left{width:80px;text-align:left;}
			.yyzx_xgBox table tr td{padding:8px 0;}
			.yyzx_topBox{width:100%;}
			.yyzx_topBox .col-xs-5{width:50%;padding-left:0px;}
			.yyzx_sfxg{position:relative;}
			.yyzx_sfxg span{display:inline-blcok;position:absolute;width:40px;text-align:center;cursor:pointer;height:26px;line-height:26px;color:#fff;left:0;top:0;background:#fb9f28;border-radius:5px;z-index:1;}
			.yyzx_sfxg .on{border:solid 1px #ccc;background:#fff;z-index:2;color:#333;}
			.yyzx_sfxg .sfxg_rspan{left:34px;}
		</style>
		<script>
			$(function(){
				if($("#shi").hasClass("on")){
					$("#hqFlg").val("N");
				}else{
					$("#hqFlg").val("Y");
				}
				$(".yyzx_sfxg span").click(function(){
					if( $(".yyzx_sfxg span").hasClass("on") ){
						$(".yyzx_sfxg span").addClass("on");
						$(this).removeClass("on");
						if($("#shi").hasClass("on")){
							$("#hqFlg").val("N");
						}else if($("#fou").hasClass("on")){
							$("#hqFlg").val("Y");
						}
					}else{
						alert(1);
					}
				});
			});
		</script>
	</head>
	
	<body>
		<input type="hidden"  id="areaIds"  name="areaIds" value="${user.areaId}" >
		<div class="yyzx_xgBox">
		<form class="form-horizontal" id="form"  method="post"  action="${base}/operationsCenter/save.jhtml">
			<div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div class="page-content">
				<div class="yyzx_topBox">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="userName" class="col-sm-4 control-label width_left" style="line-height:28px;">
								登录账号：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="userName" maxlength =16 readonly="readonly" name="userName" value="${user.userName}">
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="userNo" class="col-sm-4 control-label width_left" style="line-height:28px;">
								客户编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="userNo" maxlength =16 readonly="readonly" name="userNo" value="${userNo}">
							</div>
						</div>
					</div>
				</div>
				
				<div class="yyzx_xgtit">资料修改</div>
				<div style="clear:both;"></div>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="33%">
						<div class="form-group">
						    <label for="name" class="col-sm-4 control-label width_left">总部身份：</label>
							<div class="col-sm-5 yyzx_sfxg">
							<input type="hidden" id="hqFlg" name="hqFlg"/>
								<span id="shi" [#if user.hqFlg=='N']class="on sfxg_rspan"[/#if]>是</span><span id="fou" [#if user.hqFlg=='Y']class="on sfxg_rspan"[/#if]>否</span>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</td>
				    <td width="34%">
					    <div class="form-group">
						    <label for="name" class="col-sm-4 control-label width_left">企业名称：</label>
							<div class="col-sm-5">
								<input type="text" class="form-control input-sm required " id="name" maxlength=30
									name="name" value="${user.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</td>
				    <td width="33%">
						<div class="form-group">
						    <label for="crmPic" class="col-sm-4 control-label width_left">联系人：</label>
							<div class="col-sm-5">
								<input type="text" class="form-control input-sm required " id="crmPic" maxlength=30
									name="crmPic" value="${user.crmPic}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</td>
				  </tr>
				  <tr>
				    <td>
						<div class="form-group">
						    <label for="crmMobile" class="col-sm-4 control-label width_left">联系电话：</label>
							<div class="col-sm-5">
								<input type="text" class="form-control input-sm required " id="crmMobile" maxlength=30
									name="crmMobile" value="${user.crmMobile}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</td>
				    <td colspan="2">
				    	<div class="form-group pad_top">
							<label style="padding-top:13px;" for="memo" class="col-sm-3 control-label width_left">所属区域：</label>
						    <div class="col-sm-6 width_big">
					           <span class="area_list" style="display: block;float: left;overflow: hidden;padding-top: 8px;line-height:20px; width: 531px;color:#d16e6c;">
              					*</span>
						    </div>
						</div>
				    </td>
				  </tr>
				  <tr>
				    <td>
						<div class="form-group">
						    <label for="email" class="col-sm-4 control-label width_left">邮箱：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm" id="email" maxlength=30
									name="email" value="${user.email}" >
							</div>
						</div>
					</td>
				    <td>
						<div class="form-group">
						    <label for="crmZip" class="col-sm-4 control-label width_left">邮编：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm" id="crmZip" maxlength=30
									name="crmZip" value="${user.crmZip}" >
							</div>
						</div>
					</td>
				    <td>
						<div class="form-group">
						    <label for="crmFax" class="col-sm-4 control-label width_left">传真：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm" id="crmFax" maxlength=30
									name="crmFax" value="${user.crmFax}" >
							</div>
						</div>
					</td>
				  </tr>
				  <tr>
				    <td colspan="3">
						<div class="form-group">
						    <label for="address" class="col-sm-4 control-label width_left">地址：</label>
							<div class="col-sm-6">
								<input type="text" class="form-control input-sm" id="address" maxlength=30
									name="address" value="${user.crmAddress1}" >
							</div>
						</div>
					</td>
				  </tr>
				  <tr>
				    <td colspan="3">
				    	<div class="form-group">
							<label for="reMark" class="col-sm-4 control-label width_left">
							备注:
							</label>
							<div class="new_select col-sm-6">
								<textarea class="form-control" id="reMark" name="reMark" value="${employee.memo}">${employee.memo}</textarea>
							</div>
						</div>
				    </td>
				  </tr>
				</table>
				
			</div>
		</form>
		</div>
	</body>
</html>
<script type="text/javascript">
	function checkForm(){
	  			mgt_util.submitForm('#form');
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
		    url:"${base}/common/areao.jhtml"
	    });
    }
     // 显示区域下拉列表
    function addAreaSelect(v){
        v.append('<input type="text"  id="areaId" name="areaId" treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
    }
</script>
