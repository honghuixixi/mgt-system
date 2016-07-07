<!DOCTYPE html>
<html>
	<head>
		<title>ERP与MGT存储过程调用</title>
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
		<div class="page-content">
			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label">
							存储过程：
						</label>
						 <div class="col-sm-7" style="width:531px;margin-left:114px;margin-top:-20px;">
				            <p>CREATE OR REPLACE PACKAGE GEO_INIT IS</p>
							<p>PROCEDURE init(p_vendor_code IN VARCHAR2,p_step OUT NUMBER,p_msg OUT VARCHAR2);</p>
							<p>END;</p>
					    </div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label class="col-sm-4 control-label">
							参数列表：
						</label>
						 <div class="col-sm-7" style="width:531px;margin-left:114px;margin-top:-20px;">
						 	<p>p_vendor_code：${userName} </p>
					    </div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<div class="col-sm-7" style="width:531px;margin-left:38px;">
							<button id="ERPProcedure" class="btn btn-danger" data-toggle="jBox-call" data-fn="callProcedure();">执行
							    <i class="fa-save align-top bigger-125 fa-on-right"></i>
						    </button>
					    </div>
					</div>
				</div>
			</div>
			<div class="row" style="margin-top:20px;">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="memo" class="col-sm-4 control-label">返回结果：</label>
					    <div class="col-sm-7">
				            <textarea class="form-control" id="resultMsg" style="width: 531px; height: 164px;" name="memo" maxlength=300>
				            </textarea>
					    </div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
<script type="text/javascript">
function callProcedure(){
	$.ajax({
		 url:'${base}/procedure/call.jhtml',
		 sync:false,
		type : 'post',
		dataType : "json",
		error : function(data) {
			alert("网络异常");
			return false;
		},
		success : function(data) {
			if(data.success){
				if(data.msg==""|| data.msg == null){
					top.$.jBox.tip("执行成功，返回数据为空!", 'success');
				}
				$("#resultMsg").val(data.msg);
			}else{
				top.$.jBox.tip(data.msg, 'error');
			}
		}
	});	
}
</script>
