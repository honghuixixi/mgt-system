<!DOCTYPE html>
<html>
	<head>
		<title>菜单新增</title>
		[#include "/common/commonHead.ftl" /]
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
		<form class="form-horizontal" id="form" action="${base}/menu/add.jhtml" method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
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
							<label for="name" class="col-sm-4 control-label">
								菜单名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="name" name="name" maxlength=20>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								菜单URL：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" name="url" id="url" maxlength=200>
							</div>
						</div>
					</div>
				</div>	
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="pId" class="col-sm-4 control-label">
								父菜单 ：
							</label>
							<div class="col-sm-7">
							    <select class="form-control required" id="pId" name="pId">
									<option value="-1">&nbsp;</option>
									[#if menuList?exists]
									  [#list menuList as menu]
										<option value="${menu.ID}">${menu.NAME}</option>
									  [/#list]
									[/#if]
								</select>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
						    <label for="visible" class="col-sm-4 control-label">状态：</label>
							<div class="col-sm-7">
									<select class="form-control required" id="visible" name="visible">
									<option value="1">启用</option>
									<option value="0">禁用</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="sortby" class="col-sm-4 control-label">排序：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm number required"
								id="sortby" name="sortby" value="" maxlength=6>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>

                    <div class="col-xs-5">
                        <div class="form-group">
                            <label for="pId" class="col-sm-4 control-label">
                                所属模块 ：
                            </label>
                            <div class="col-sm-7">
                                <select class="form-control required" id="moduleId" name="moduleId">
									[#if mgtModuleList?exists]
										[#list mgtModuleList as module]
											<option value="${module.PK_NO}">${module.NAME}</option>
										[/#list]
									[/#if]
                                </select>
                            </div>
                            <span class="help-inline col-sm-1">*</span>
                        </div>
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
    $.ajax({
      url:'${base}/menu/orderBySelect.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{sortby:$("#sortby").val()},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
        if(data.data==0){
		  mgt_util.submitForm('#form');
		}else{
		  alert("排序号已存在");
		  return false;
		}
      }
    }); 
  }
}
</script>