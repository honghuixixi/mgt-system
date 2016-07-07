<!DOCTYPE html>
<html>
	<head>
		<title>信用支付人员信息修改</title>
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
		<form class="form-horizontal" id="form" action="${base}/credit/saveCreditPayment.jhtml">
		
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
								配送员名字：
							</label>
							<div class="col-sm-7">
							
							<select class="form-control" style="width:120px;" name="accountName" id="accountName" >
		                        [#list userList as user]
									 	<option value='${user.userName}'>${user.name}</option>
								[/#list]
		                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								手机号码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="deliverMobile" maxlength=16
									name="deliverMobile"  >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-3 control-label">最大信用额度：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="creditMaximum" maxlength=30
									name="creditMaximum"  >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">当前信用额度：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm required " id="creditCurrent" maxlength=30
									name="creditCurrent" >
						    </div>
						    <span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				
				<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">最长借款期限：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="cREDIT_TERM" maxlength=30
									name="cREDIT_TERM"  >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">当保人：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="guarantee" maxlength=30
									name="guarantee" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">押金：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="guarantee" maxlength=30
									name="deposit" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">月工资收入：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="guarantee" maxlength=30
									name="conthlyIncome"  >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				
				<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">创建人：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="createBy" maxlength=30
									name="createBy"  >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">创建时间：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm required" id="createDate" maxlength=30
									name="createDate" >
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
if($("#oldcatc").val()!=$("#catC").val()){
	   $.ajax({
		 url:'${base}/vendorCust/findByCatFlag.jhtml',
		 sync:false,
		type : 'post',
		dataType : "json",
		data :{catC:$("#catC").val(),catName:$("#catName").val()},
		error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(!data.data){
				top.$.jBox.tip("代码已存在");
	 			return false;
			}
			if(data.success){
				top.$.jBox.tip("名称已存在");
	 			return false;
			}
			mgt_util.submitForm('#form');
		}
	});	
	}else{
	  mgt_util.submitForm('#form');
    }
  }


}
</script>
