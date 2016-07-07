<!DOCTYPE html>
<html>
	<head>
		<title>仓库、配送点修改</title>
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
		.row{margin-top:15px;}
		</style>
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/warehouse/editSave.jhtml">
            <input id="WHC" name="WHC" type="hidden" value="${WHC}">
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
					<div class="col-xs-6">
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">
								编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required addRoleByName" id="whC" maxlength=30
									name="whC" value="${whMas.whC}" readonly>
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
								<input type="text" class="form-control input-sm required addRoleByName" id="name" maxlength=30
									name="name" value="${whMas.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				[#include "/common/biaozhu.ftl" /]
				<div class="row">
					<div class="col-xs-6">
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">类型：</label>
							<div class="col-sm-7">
	                    		<select data-placeholder="请选择类型" class="form-control" name="whType" id="whType">
	                        		[#if whMas.dsFlg = "Y"]
	                        			<option value="Y" selected>配送站</option>
	                        			<option value="N">仓库</option>
	                        		[#else]	
	                        			<option value="Y">配送站</option>
	                        			<option value="N" selected>仓库</option>
	                        		[/#if]	
	                    		</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								仓库属性：
							</label>
							<div class="col-sm-7">
	                    		<select data-placeholder="请选择仓库属性" class="form-control" name="owner" id="owner">
	                        		[#if whMas.fbpLbpFlg = "Y"]
	                        			<option value="Y" selected>平台库</option>
	                        			<option value="N">自有库</option>
	                        		[#else]	
	                        			<option value="Y">平台库</option>
	                        			<option value="N" selected>自有库</option>
	                        		[/#if]	
	                    		</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-6">
						<div class="form-group">
							<label for="name" class="col-sm-3 control-label">
								地址：
							</label>
							<div class="col-sm-7">
								<textarea class="form-control input-sm required addRoleByName" id="address1" name="address1">${whMas.address1}</textarea>
							</div>
							<span class="help-inline col-sm-1">*</span>
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
		url:'${base}/warehouse/findByWhC.jhtml',
		sync:false,
		type : 'post',
		dataType : "json",
		data :{
			whC:$("#whC").val(),
			WHC:'${WHC}',
		},
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
</script>