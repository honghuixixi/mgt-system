<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>金融交易对账</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/layer/layer.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
		$(document).ready(function(){
			mgt_util.jqGrid('#grid-table',{
					url:'${base}/paybillFee/PaybillAndOrderMasList.jhtml?batchidNo='+$("#batchid").val(),
					colNames:['订单号','订单日期','订单销售或退单','下单用户','总数量','订单总金额','实付资金','子订单编号','收款方','订单类型'],
					multiselectWidth:'1',
 					rownumWidth:'12',
					multiselect:false,
				   	colModel:[
				   		{name:'MAS_NO',align:"center",width:0,hidden:true,key:true},
				   		{name:'MAS_DATE',align:"center",width:60, formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
				   		{name:'MAS_CODE',align:"center",width:60},
				   		{name:'CUST_NAME',align:"center",width:60},
				   		{name:'QTY',align:"center",width:60},
				   		{name:'AMOUNT',align:"center",width:60},
				   		{name:'PAYAMT',align:"center",width:60},
				   		{name:'REF_PK_NO',align:"center",width:60},
				   		{name:'VENDOR_NAME',align:"center",width:60},
				   		{name:'ORDER_TYPE',align:"center",width:60},
				   	],
			   	gridComplete:function(){ //循环为每一行添加业务事件 
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
				} 				   	
			});
		});
</script>
<style type="text/css"> 
	.redlink{
		font-size:14px;
		color:blue;
	}
</style>
</head>
    <body>
    	<input type="hidden" name="batchid" id="batchid" value="${batchidNo}" />
	    <div class="body-container">
          <div class="main_heightBox1 main_controls1">
			<div id="currentDataDiv" action="menu" >
		           <div>
		           		<table>
		           			<tr>
		           				<td>&nbsp;&nbsp;交易流水：${paybill.SN}</td>
		           				<td>支付日期：${paybill.TRAN_DATE}</td>
		           				<td>渠道编号：${paybill.CHANNEL_ID}</td>
		           				<td>渠道账号：${paybill.MERCHANT_NO}</td>
		           			</tr>
		           			<tr>
		           				<td>&nbsp;&nbsp;交易分类：${paybill.TRAN_TYPE}</td>
		           				[#if paybill.PAY_STATE == 03]
									<td>支付状态：已支付</td>
								[#else]
									<td>支付状态：未支付</td>
								[/#if]
		           				<td colspan="2" >付款方客户编号：${paybill.PAYERCUST_ID}</td>
		           			</tr>
		           		</table>
		           </div>
	        </div>
	       <div id="currentPrint">
	       </div>
	      </div>
	      <div style="clear:both;"></div>
		  <table id="grid-table" style="word-break:break-all; word-wrap:break-word;"></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>
<script  type="text/javascript">
</script>