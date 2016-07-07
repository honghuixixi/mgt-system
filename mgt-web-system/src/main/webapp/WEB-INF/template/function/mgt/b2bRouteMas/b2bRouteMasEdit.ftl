<!DOCTYPE html>
<html>
	<head>
		<title>运营中心信息修改</title>
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
		<form class="form-horizontal" id="form"  method="post"  action="${base}/b2bRouteMas/save.jhtml">
			<input type="hidden"  id="uuid"  name="uuid" value="${b2bRouteMas.uuid}" >
			<input type="hidden"   id="oldRouteCode" value="${b2bRouteMas.routeCode}">
			<input type="hidden"  id="logisticCode"  name="logisticCode" value="${b2bRouteMas.logisticCode}" >
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
								线路编码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="routeCode" maxlength=30
									name="routeCode"  value="${b2bRouteMas.routeCode}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								线路名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="routeName" maxlength=30
									name="routeName" value="${b2bRouteMas.routeName}" >
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
								状态：
							</label>
							<div class="col-sm-4">
								<select class="form-control required" name="statusFlg">
			                        <option value="">请选择...</option>
			                        <option value="Y" [#if b2bRouteMas.statusFlg=='Y']selected=selected[/#if]>启用</option>
			                        <option value="N" [#if b2bRouteMas.statusFlg=='N']selected=selected[/#if]>停用</option>
			                    </select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								备注：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" id="remark" maxlength=30
									name="remark"  value="${b2bRouteMas.remark}" >
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
			var oldRouteCode=$("#oldRouteCode").val();
			var routeCode=$("#routeCode").val();
				if(routeCode!=oldRouteCode){
				   $.ajax({
					 url:'${base}/b2bRouteMas/findByCodeFlag.jhtml',
					 sync:false,
					type : 'post',
					dataType : "json",
					data :{routeCode:$("#routeCode").val(),logisticCode:$("#logisticCode").val()},
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
			}else{
			  mgt_util.submitForm('#form');
		    }	
		  }
		}
</script>
