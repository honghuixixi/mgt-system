<!DOCTYPE html>
<html>
	<head>
		<title>运营中心新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<style>
		.new_select select{width:auto;display:inline-block;}
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

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/operationsCenter/add.jhtml">
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
								账号：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="userName" maxlength=30
									name="userName" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								密码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="userPassword" maxlength=30
									name="userPassword" value="" >
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
								企业名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="name" maxlength=30
									name="name" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<!--<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								总部身份：
							</label>
							<div class="col-sm-4">
								<select class="form-control required" name="hqFlg">
			                        <option value="">请选择...</option>
			                        <option value="Y">是</option>
			                        <option value='N'>否</option>
			                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>-->
						<div class="form-group">
						    <label for="name" class="col-sm-4 control-label width_left">总部身份：</label>
							<div class="col-sm-5 yyzx_sfxg" style="margin-left:20px;">
							<input type="hidden" id="hqFlg" name="hqFlg"/>
								<span id="shi" class="on sfxg_rspan">是</span><span id="fou">否</span>
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
								联系人：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="crmPic" maxlength=30
									name="crmPic" value="" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								联系电话：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="crmMobile" maxlength=30
									name="crmMobile" value="" >
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
							所属区域:
							</label>
							<div class="new_select col-sm-7" style="float:left;padding-left:21px;">
								<input type="hidden" id="areaId" name="areaId" />
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
								邮箱：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm addRoleByName" id="email" maxlength=30
									name="email" value="" >
							</div>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								邮编：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm addRoleByName" id="crmZip" maxlength=30
									name="crmZip" value="" >
							</div>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								传真：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm addRoleByName" id="crmFax" maxlength=30
									name="crmFax" value="" >
							</div>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								地址：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm addRoleByName" id="address" maxlength=30
									name="address" value="" >
							</div>
						</div>
					</div>
				</div>
				<br/>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
							备注:
							</label>
							<div class="new_select col-sm-7">
								<textarea class="form-control" id="reMark" name="reMark"></textarea>
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
		 url:'${base}/operationsCenter/findByNameFlag.jhtml',
		 sync:false,
		type : 'post',
		dataType : "json",
		data :{userName:$("#userName").val()},
		error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(data.data){
				mgt_util.submitForm('#form');
			}else{
				top.$.jBox.tip('账号已存在！');
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
			});
</script>