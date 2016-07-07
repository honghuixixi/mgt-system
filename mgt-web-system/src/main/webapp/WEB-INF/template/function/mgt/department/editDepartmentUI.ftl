<!DOCTYPE html>
<html>
	<head>
		<title>修改部门信息</title>
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
		<form class="form-horizontal" id="form" action="${base}/department/edit.jhtml">
			<input type="hidden"  name="id" value="${department.id}">
			<input type="hidden"  name="departCode" value="${department.departCode}">
			<input type="hidden"  name="seq" value="${department.seq}">
			<input type="hidden"  name="pId" value="${department.pId}">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
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
							<label for="className" class="col-sm-4 control-label">
								部门名称
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" maxlength="255" name="name"
									value="${department.name}" >
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="no" class="col-sm-4 control-label">
								简称
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm "
									name="simpName" maxlength="32" value="${department.simpName}" >
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label">
								状态
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="status" name="status">
									<option value="1" [#if department.status=='1']selected="selected"[/#if]>启用</option>
									<option value="0" [#if department.status=='0']selected="selected"[/#if]>禁用</option>
								</select>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label">
								是否店
							</label>
							<div class="col-sm-7" style="padding-bottom:2px;">
							    <input type="radio" style="margin-bottom:2px;height:20px;width:20px;" name="isStore" value="0" onclick="hideRidio()" [#if department.isStore==0]checked="checked"[/#if]><span style="height:30px;width:40px;">否</span>
								<input type="radio" style="margin-bottom:2px;height:20px;width:20px;" name="isStore" value="1"  onclick="getRadio()" [#if department.isStore==1]checked="checked"[/#if]><span style="height:30px;width:40px;">是</span>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row" id="dimeView" style="display:[#if department.isStore=='1']block[#else]none[/#if];">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="no" class="col-sm-4 control-label">
								维度
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm "
									name="dimension" maxlength="30" id="dimension" value="${department.dimension}" >
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label">
								经度
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm "
										name="longitude" maxlength="30" id="longitude" value="${department.longitude}" >
							</div>
						</div>
					</div>
				</div>
			    <div class="row">
				    <div class="col-xs-5">
						<div class="form-group">
							<label for="description" class="col-sm-4 control-label">
								描述
							</label>
							<div class="col-sm-7"   >
							 <textarea class="form-control" maxlength="500" style="width: 500px; height: 164px;" name ="memo">${department.memo}</textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
	<script type="text/javascript">
	    function getRadio(){
			$("#dimeView").css('display','block'); 
		}

		function hideRidio(){
			$("#dimeView").css('display','none'); 
			$("#dimension").attr("value","");
			$("#longitude").attr("value","");
		}
	</script>
</html>
