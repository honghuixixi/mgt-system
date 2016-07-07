<!DOCTYPE html>
<html>
	<head>
		<title>菜单修改</title>
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
		<form class="form-horizontal" id="form" action="${base}/menu/edit.jhtml" method="POST">
			<input type="hidden" name="id" id="id" value="${menu.id}"> 
			<input type="hidden"   id="oldSortby" value="${menu.sortby}"> 
			<input type="hidden"   id="imgSrc" name="imgSrc" value="${menu.imgSrc}"> 
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
								<input type="text" class="form-control input-sm required " name="name" value="${menu.name}"  maxlength=50>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="pId" class="col-sm-4 control-label">
								菜单URL：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm" name="url"  value="${menu.url}"  maxlength=200 >
							</div>
						</div>
					</div>
				</div>
				</div>
		
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="url" class="col-sm-4 control-label">
								父菜单 ：
							</label>
							<div class="col-sm-7" >
							    <select class="form-control required" id="pId" name="pId" >
									<option value="-1" selected="selected">&nbsp;</option>
[#if menuList?exists] 
  [#if pIdFlag==false && menu.PId !='-1' ]
    [#list menuList as menus]
      [#if menu.id!=menus.id] 
        <option value="${menus.ID}" [#if menu.PId==menus.ID] selected="selected" [/#if]>${menus.NAME}</option>
      [/#if]
    [/#list]
  [/#if]
[/#if]
								</select>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="icon" class="col-sm-4 control-label">
								状态：
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="visible" name="visible" >
									<option value="1" [#if menu.visible==1]selected="selected"[/#if]>启用</option>
									<option value="0" [#if menu.visible==0]selected="selected"[/#if]>禁用</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>

			 	<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="orderby" class="col-sm-4 control-label">排序：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm  required menuorderBy"
									name="sortby" id="sortby"  value="${menu.sortby}"  maxlength=6 >
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
    var oldSortby=$("#oldSortby").val();
	var sortby=$("#sortby").val();
	if(sortby!=oldSortby){
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
    }else{
	  mgt_util.submitForm('#form');
    }
  }
}
</script>