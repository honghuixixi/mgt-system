<!DOCTYPE html>
<html>
	<head>
		<title>手工对账</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" src="${base}/scripts/lib/layer/layer.js"></script>
	</head>
	<body class="toolbar-fixed-top">
		<!-- <form class="form-horizontal id="form"> -->
           <input type="hidden"  id="sn"  name="sn" value="${paybillFee.SN}" >
           <div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" id="subAccount">手工对账
				   
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>			

			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">日期：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybillFee.CHECK_DATE}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道ID：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybillFee.CHANNEL_ID}" readonly>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybillFee.MERCHANT_NO}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易笔数：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybillFee.TRAN_NUM}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易金额：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 id="tranAmt" value="${paybillFee.TRAN_AMT}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">实际到账：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required1 " maxlength=16 id="tranActamt" name="tranActamt" onkeyup="value=value.replace(/[^0-9.]/g,'')" value="${paybillFee.TRAN_ACTAMT}" >
							</div>
							<span style="color:red;">*</span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道费用：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required1 " maxlength=16 id="channelFee" name="channelFee" onkeyup="value=value.replace(/[^0-9.]/g,'')" value="${paybillFee.CHANNEL_FEE}" >
							</div>
							<span style="color:red;">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">调账状态：</label>
							<div class="col-sm-7">
								[#if paybillFee.ADJUST_STATE == 0]
									<input type="text" class="form-control input-sm required " maxlength=16 value="未调账" readonly>
								[#else]
									<input type="text" class="form-control input-sm required " maxlength=16 value="已调账" readonly>
								[/#if]
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">对账结果：</label>
							<div class="col-sm-7">
							[#if paybillFee.CHECK_RESULT_STATE == 1]
									<input type="text" class="form-control input-sm required " maxlength=16 value="平帐" readonly>
							[#else]
									<input type="text" class="form-control input-sm required " maxlength=16 value="不平" readonly>
							[/#if]
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">分账状态：</label>
							<div class="col-sm-7">
								[#if paybillFee.DISASM_STATE == Y]
										<input type="text" class="form-control input-sm required " maxlength=16 value="已分" readonly>
								[#else]
										<input type="text" class="form-control input-sm required " maxlength=16 value="未分" readonly>
								[/#if]
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">创建时间：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybillFee.CHECK_TIME}" readonly>
							</div>
						</div>
					</div>
				</div>

			</div>
		<!-- </form> -->
	</body>
</html>
<script type="text/javascript">
$(function(){
	$("#subAccount").click(function(){
		if($.trim($("#channelFee").val())==""){
			layer.tips('不能为空！', '#channelFee');
			return;
		}
		if($.trim($("#tranActamt").val())==""){
			layer.tips('不能为空！', '#tranActamt');
			return;
		}
		layer.alert('请确保填写的金额已到账（账户3110810013671106167），否则会造成支付失败！', {icon: 7},function(index){
			layer.close(index);
			$.ajax({
				url:'${base}/paybillFee/updateCheckAccount.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{channelFee:$("#channelFee").val(),tranActamt:$("#tranActamt").val(),sn:$("#sn").val()},
				success : function(data) {
					if(data){
						layer.alert('手工对账成功', {icon: 1},function(index){
							layer.close(index);
							//alert(window.top.frames[0].$("#isAbnormal").val());
							window.top.frames[0].queryData(window.top.frames[0].$("#isAbnormal").val());
							mgt_util.closejBox(this);
						});
						
					}else{
						layer.alert('手工对账失败', {icon: 5});
					}
				},
				error : function(data) {
					layer.alert('网络异常', {icon: 2}); 
					return false;
				}
			 });
			
		}); 
	   
	});
});
</script>
