<!DOCTYPE html>
<html>
	<head>
		<title>修改页面</title>
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
	<input type="hidden" id="newrowid" name="newrowid"  value="${newrowid}"/> 
		<form class="form-horizontal" id="form"  method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" onClick="sub()" >
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" onClick="closes()">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 	        <div class="page-content">
 	        <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkC" class="col-sm-4 control-label">
								商品编码：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="stkC" readonly="true" name="stkC" class="form-control required" value="${stkMas.stkC}" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
 	        	<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								商品名称：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="stkName" readonly="true" name="stkName" class="form-control required" value="${stkMas.name}" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								商品数量：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="qty" name="qty" class="form-control required digits" value="${qty}" maxlength='8' min="1"/> 
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								条码：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="pluC" readonly="true" name="pluC" class="form-control required" value="${stkMas.pluC}"/> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								价格：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="netPrice" readonly="true" name="netPrice" class="form-control required" value="${stkMas.netPrice}" /> 
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								单位：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="uom" readonly="true" name="uom" class="form-control required" value="${stkMas.uom}"/> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								规格：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="modle" readonly="true" name="modle" class="form-control required" value="${stkMas.modle}"/> 
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
</html>
   <script type="text/javascript">
   			
    		function sub(){
    			if (mgt_util.validate(form)){
    				window.parent.setCell($("#newrowid").val(),$("#qty").val());
   		    		window.parent.window.jBox.close();
   		    	}
    		}
    		function closes(){
				window.parent.window.jBox.close();
			}
    </script>