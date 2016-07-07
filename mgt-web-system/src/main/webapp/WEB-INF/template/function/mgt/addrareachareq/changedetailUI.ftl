<!DOCTYPE html>
<html>
	<head>
		<title>角色新增</title>
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
		<form class="form-horizontal" id="form" action="${base}/addrareachgreq/save.jhtml">
			<input type="hidden" name="pkNo" id="pkNo" value="${aacq.pkNo}"/>
			<input type="hidden" name="statusFlg" id="statusFlg" >
           <div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call" id="pass" data-fn="checkForm">通过 
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-call" id="refuse" data-fn="checkForm">
					拒绝 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>	
			
			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								申请店铺：
							</label>
							<div class="col-sm-7">
								${aacq.shopName}
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								申请日期：
							</label>
							<div class="col-sm-7">
								${reqDate}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原地址详情：
							</label>
							<div class="col-sm-7">
								${am.address1}
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新地址详情：
							</label>
							<div class="col-sm-7">
							<input type="hidden" id="amId" name="amId" value="${am.pkNo}">
								${aacq.newAddress}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原联系人：
							</label>
							<div class="col-sm-7">
								${am.pic}
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新联系人：
							</label>
							<div class="col-sm-7">
								${aacq.newPic}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原手机：
							</label>
							<div class="col-sm-7">
								${am.mobile}
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新手机：
							</label>
							<div class="col-sm-7">
								${aacq.newMobile}</label>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原电话：
							</label>
							<div class="col-sm-7">
								${am.tel}
							</div>
						</div>
					</div>
					
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新电话：
							</label>
							<div class="col-sm-7">
								${aacq.newTel}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原地址区域：
							</label>
							<div class="col-sm-7">
								${srcMap.FULLNAME}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新地址区域：
							</label>
							<div class="col-sm-7">
								${destMap.FULLNAME}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								变更理由：
							</label>
							<div class="col-sm-7">
								${aacq.reqDesc}
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								原业务员：
							</label>
							<div class="col-sm-7">
								${srcname}
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								新业务员：
							</label>
							<div class="col-sm-7">
								<select  class="form-control" name="pic" id="pic">
			                    	<option value=''>请选择</option>
			                    	[#list userList as user]
			                    	<option value='${user.USER_NO}'>${user.USER_NAME}</option>
			                    	[/#list]
			                    </select>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">
								审批意见：
							</label>
							<div class="col-sm-7">
								<textarea id="approveDesc" name = "approveDesc" rows="3" width="600px"></textarea>
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
	
		var id = $(this).attr("id");
		if(id=="pass"){
			$("#statusFlg").val("P");
			mgt_util.submitForm('#form');
		}else{
			$("#statusFlg").val("R");
			var approveDesc = $("#approveDesc").val();
			if(isEmpty(approveDesc)){
				top.$.jBox.tip('请填写审核意见');
			}else{
				mgt_util.submitForm('#form');
			}
		}
	}
	//一个判断的函数
	function isEmpty(s1)
	{
	    var sValue = s1 + "";
	    var test = / /g;
	    sValue = sValue.replace(test, "");
	    return sValue==null || sValue.length<=0;
	}
</script>
