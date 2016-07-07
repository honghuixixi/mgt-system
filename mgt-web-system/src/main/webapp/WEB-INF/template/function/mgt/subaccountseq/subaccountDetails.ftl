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
			action="${base}/subaccountseq/takeCash.jhtml" method="post">
			<input type="hidden" name="subaccountId" value="${subaccount.id}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger"  data-toggle="jBox-call" data-fn="checkForm">确认提现
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
							<label for="bankcardno" class="col-sm-4 control-label">
								总金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.amount }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								状态：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno" [#if subaccount.state=='00' ] value="有效"[/#if] [#if subaccount.state=='01' ] value="冻结"[/#if] [#if subaccount.state=='02' ] value="注销"[/#if]  readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								可提现金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.cashAmount }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								不可提现金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.uncashAmount }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								可提现冻结金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.freezeCashAmount }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								不可提现冻结金额：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.freezeUncashAmount }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								总积分：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno"  value="${subaccount.points }" readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="bankcardno" class="col-sm-4 control-label">
								账户性质：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="bankcardno" [#if subaccount.property=='1' ] value="个人" [/#if][#if subaccount.property=='2' ] value="企业" [/#if] readonly="readonly">
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				</div>
		</form>
	</body>
</html>
<script>

function checkForm(){
  if (mgt_util.validate(form)){
	  var tranamount = $('#tranamount').val();
	  var cashAmount='${subaccount.amount}';
	  if(cashAmount<=0){
		  top.$.jBox.tip('账户没有余额，不能提现！', 'error');
	 	  return;  
	  }
	  if(parseFloat(cashAmount)<parseFloat(tranamount)){
		  top.$.jBox.tip('金额不足，请重新输入！', 'error');
	 	  return;
	  }
	  
		$.jBox.confirm("确认提现?", "提示", function(v){
			if(v == 'ok'){
	  $('.btn.btn-danger').addClass('disabled').attr('disabled', true);
$('#form').ajaxSubmit({
			success: function (html, status) {
					if(html.code == '001'){
	   					top.$.jBox.tip('添加成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   		        }
	   		        else if(html.code == '002'){
	   		        	top.$.jBox.tip('余额不足！', 'error');
	   		        	 
	   		        	 return;
	   			    }
	   			    $('.btn.btn-danger').removeClass('disabled').attr('disabled', false);
			},error : function(data){
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
			}
		});
			}
		});
    }
}
 
</script>