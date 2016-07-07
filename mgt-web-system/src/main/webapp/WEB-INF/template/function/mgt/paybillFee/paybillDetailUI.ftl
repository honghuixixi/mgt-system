<!DOCTYPE html>
<html>
	<head>
		<title>交易记录对账详情</title>
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
           <input type="hidden"  id="sn"  name="sn" value="${paybill.PK_NO}" >
           <div class="navbar-fixed-top" id="toolbar">
			    <!-- <button class="btn btn-danger" id="subAccount">手工对账
				   
			    </button> -->
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
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.TRAN_DATE}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道ID：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.CHANNEL_ID}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">创建日期：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.CREATE_TIME}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道结算日：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.CHECKDATE}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">渠道名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.MERCHANT_NO}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易类型：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.TRAN_TYPE}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">子类型：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 id="tranAmt" value="${paybill.TRAN_SUBTYPE}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易金额：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.TRANAMOUNT}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">收款方：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required1 " maxlength=16  value="${paybill.PAYEECUST_NAME}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">付款方：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required1 " maxlength=16  value="${paybill.PAYERCUST_NAME}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">付款方账号：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.payercust_id}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">收款方账号：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.PAYEECUST_ID}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易说明：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.TRAN_NOTE}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">状态：</label>
							<div class="col-sm-7">
								[#if paybill.STATE == 02]
										<input type="text" class="form-control input-sm required " maxlength=16 value="已交易" readonly>
								[#else]
										<input type="text" class="form-control input-sm required " maxlength=16 value="未交易" readonly>
								[/#if]
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">支付状态：</label>
							<div class="col-sm-7">
								[#if paybill.PAY_STATE == 03]
										<input type="text" class="form-control input-sm required " maxlength=16 value="已支付" readonly>
								[#else]
										<input type="text" class="form-control input-sm required " maxlength=16 value="未支付" readonly>
								[/#if]
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">归集状态：</label>
							<div class="col-sm-7">
								[#if paybill.RECHARGE_STATE == 3]
										<input type="text" class="form-control input-sm required " maxlength=16 value="已归集" readonly>
								[#else]
										<input type="text" class="form-control input-sm required " maxlength=16 value="未归集" readonly>
								[/#if]
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">分账状态：</label>
							<div class="col-sm-7">
								[#if paybill.PAY_STATE == N]
										<input type="text" class="form-control input-sm required " maxlength=16 value="已分账" readonly>
								[#else]
										<input type="text" class="form-control input-sm required " maxlength=16 value="未分账" readonly>
								[/#if]
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">交易流水号：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.SN}" readonly>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">发起方客户编号：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.SRCCUST_ID}" readonly>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-4 control-label">返回码：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required " maxlength=16 value="${paybill.BANK_RESULTCODE}" readonly>
							</div>
						</div>
					</div>
				</div>
				
			</div>
		<!-- </form> -->
	</body>
</html>
<script type="text/javascript">
</script>
