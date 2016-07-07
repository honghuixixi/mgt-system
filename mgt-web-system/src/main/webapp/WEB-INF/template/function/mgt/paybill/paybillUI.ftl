<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/paybill/detail.jhtml?batchId=${batchId}',
 					colNames:['','订单号','客户编码','客户名称','状态','支付状态','配送员','订单金额','实付金额'],
 					width:800,
 					rownumbers : false,
 					rowNum:2147483647,
				   	colModel:[
				   		{name:'PK_NO',index:'ID',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',width:100},
				   		{name:'CUST_CODE',width:60},
				   		{name:'CUST_NAME', width:160},	
				   		{name:'STATUS_FLG',width:60,align:"center",editable:true,formatter:function(value,row,index){
						return '已收货';
	   		            }},
				   		{name:'PAY_STATUS',width:60,align:"center",editable:true,formatter:function(value,row,index){
						return '未支付';
	   		            }},
	   		            {name:'LOGISTICUSERNAME', width:80},
	   		            {name:'AMOUNT', width:60},
	   		            {name:'ACTUALAMOUNT', width:60,formatter:function(value,row,index){
	   		            var actualAmount=index.AMOUNT;
						if(null!=index.MISC_PAY_AMT){
						actualAmount=actualAmount-index.MISC_PAY_AMT;
						}
						if(null!=index.DIFF_MISC_AMT){
							actualAmount=actualAmount-index.DIFF_MISC_AMT;
						}
						if(null!=index.FREIGHT){
						actualAmount=actualAmount+index.FREIGHT;
						}
						return  actualAmount.toFixed(2);;
	   		            }}
				   	],
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>