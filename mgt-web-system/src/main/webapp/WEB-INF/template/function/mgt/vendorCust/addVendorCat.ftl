<!DOCTYPE html>
<html>
	<head>
		<title>客户分类新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	<input type="hidden"  id="oldcatc"  name="oldcatc" value="${catC}" >
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/vendorCust/addVendorCat.jhtml">
		<input type="hidden"  id="orgNo"  name="orgNo" value="${vendorCat.orgNo}" >
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
								代码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="catC" maxlength=16
									name="catC" value="${catC}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

					<div class="col-xs-5">
						<div class="form-group">
						    <label for="status" class="col-sm-4 control-label">名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " id="catName" maxlength=30
									name="catName" value="${vendorCat.catName}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">折扣：</label>
						    <div class="col-sm-7">
					            <input type="text" class="form-control input-sm required discNum" id="discNum" maxlength=30
									name="discNum" value="${vendorCat.discNum}" >
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
