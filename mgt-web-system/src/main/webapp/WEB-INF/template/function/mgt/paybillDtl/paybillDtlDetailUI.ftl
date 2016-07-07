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
					url:'${base}/paybillDtl/detail.jhtml?subOrderId=${subOrderId}',
 					colNames:['','商品编码','商品名称','单位','数量','净价','小计'],
 					width:800,
 					rowNum:2147483647,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'STK_C',width:80},
				   		{name:'STK_NAME',width:160},
				   		{name:'UOM', width:30},	
				   		{name:'UOM_QTY',width:60},
	   		            {name:'LIST_PRICE', width:80},
	   		            {name:'', width:60,formatter:function(value,row,index){
	   		            var uomqty=index.UOM_QTY;
	   		            var price=index.LIST_PRICE;
						return  uomqty*price;
	   		            }}
				   	],
				});
			});
				$(document).ready(function(){
				mgt_util.jqGrid('#grid-tables',{
					url:'${base}/paybillDtl/list.jhtml?subOrderId=${subOrderId}',
 					colNames:['','订单日期','送货日期','付款日期','对账日期'],
 					width:800,
 					rowNum:2147483647,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,align:"center",hidden:true,key:true},
				   		{name:'CREATE_TIME',align:"center",width:175,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }},
				   		{name:'',align:"center",width:175,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }},
				   		{name:'PAY_TIME', align:"center",width:175,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }},	
				   		{name:'CHECK_DATE',align:"center",width:175,formatter : function(data){
                            return data;
                            }}
				   	],
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       <p style="font-size:20px;">物流详情</p>
		    <table id="grid-tables" >
		    </table>
       <p style="font-size:20px;">订单详情</p>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>