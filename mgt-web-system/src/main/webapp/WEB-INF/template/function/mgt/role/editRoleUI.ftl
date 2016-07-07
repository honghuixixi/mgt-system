<!DOCTYPE html>
<html>
	<head>
		<title>角色修改</title>
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
		<form class="form-horizontal" id="form" action="${base}/role/add.jhtml">
			<input type="hidden"id="id" name="id"  value="${role.id}" >
			<input type="hidden"id="visible" name="visible"  value="${role.visible}" >
			<input type="hidden"id="merchantCode" name="merchantCode"  value="${role.merchantCode}" >
			<input type="hidden" class="form-control input-sm required" id="oldname" name="oldname"  value="${role.name}" >
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call"
					data-fn="checkForm">
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								角色名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="name" maxlength=30 name="name"  value="${role.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
								<label for="sex" class="col-sm-4 control-label">
								状态：
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="status" name="status">
									<option  value="1" [#if role.status==1]selected="selected"[/#if] >启用</option>
									<option  value="0" [#if role.status==0]selected="selected"[/#if] >禁用</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="memo" class="col-sm-4 control-label">
								描述：
							</label>
							<div class="col-sm-7">
 <textarea class="form-control" style="width: 531px; height: 164px;" name="memo"  maxlength=300 >${role.memo}</textarea>
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
    if($("#oldname").val()!=$("#name").val()){
	  $.ajax({
        url:'${base}/role/findByNameFlag.jhtml',
        sync:false,
        type : 'post',
        dataType : "json",
        data :{name:$("#name").val()},
        error : function(data) {
	      alert("网络异常");
	      return false;
        },
        success : function(data) {
	      if(data.data){
            mgt_util.submitForm('#form');
	      }else{
		    alert("角色名称已存在");
		    return false;
	      }
        }
      });	
    }else{
	  mgt_util.submitForm('#form');
    }
  }
}
</script>
