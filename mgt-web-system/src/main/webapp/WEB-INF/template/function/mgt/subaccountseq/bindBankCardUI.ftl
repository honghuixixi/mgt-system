<!DOCTYPE html>
<html>
	<head>
		<title>资源新增</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"
			action="${base}/subaccountseq/bindBankCard.jhtml" method="post">
			<input type="hidden" name="subaccountId" value="${id}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger"  data-toggle="jBox-call" data-fn="checkForm">保存
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
							<label for="bankType" class="col-sm-4 control-label">
								银行：
							</label>
							<div class="col-sm-7">
						<select class="form-control required" id="bankType" name="bankType">
						   			[#list bankTypeInfos as bankTypeInfo]
								    <option value="${bankTypeInfo.bankType}">${bankTypeInfo.bankName}</option>
								    [/#list]
							    </select>							
							    </div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardname" class="col-sm-4 control-label">
								户名：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardname" maxlength=30 >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

					<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								账号：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno" maxlength=30 >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankName" class="col-sm-4 control-label">
								开户行：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankName" maxlength=128 >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
		</form>
	</body>
</html>
<script>

function checkForm(){
  if (mgt_util.validate(form)){
	  $('.btn.btn-danger').addClass('disabled').attr('disabled', true);
$('#form').ajaxSubmit({
			success: function (html, status) {
					if(html.code == "001"){
	   					top.$.jBox.tip('添加成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   		        }
	   		        else if(html.code == "002") {
	   		        	top.$.jBox.tip('卡号重复，请重新输入！', 'error');
	   			    $('.btn.btn-danger').removeClass('disabled').attr('disabled', false);
	   		        	 return;
	   			    }
			},error : function(data){
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
			}
		});
    }
}
</script>