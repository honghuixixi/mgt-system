<!DOCTYPE html>
<html>
	<head>
		<title>商户参数新增</title>
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
		<form class="form-horizontal" id="form" action="${base}/mgtSettingDtl/addUserSetting.jhtml" method="post">
		<input type="hidden" id="itemNo" name="itemNo" value="${itemNo}"/>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call"  data-fn="checkForm">保存
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
						    <label for="status" class="col-sm-4 control-label">是否是设置项：</label>
							<div class="col-sm-7">
								<select class="form-control required" id="defFlg" name="defFlg">
									<option value="Y">是</option>
									<option value="N">否</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="no" class="col-sm-4 control-label">
								设置值：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm "
									name="defValue"  id="defValue"  maxlength="128" value=""  >
							</div>
						</div>
					</div>
				</div>

				

			</div>
		</form>
	</body>
</html>

<script>
//验证表单并提交form
	function checkForm(){
		if (mgt_util.validate(form)){
    	 	$('#form').ajaxSubmit({
    			success: function (html, status) {
    					    window.parent.location.reload();
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

