<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>库存管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={};
				mgt_util.jqGrid('#grid-table',{
				    multiselect:false,
					postData: postData,
					url:'${base}/coreStkWh/productWhList.jhtml?stkC='+'${stkC}',
 					colNames:['商品编码','商品名称','条码','单位','金额','库存数量','预留数量','仓库'],
 					width:800,
				   	colModel:[
				   		{name:'STK_C',index:'STK_C',align:"center",width:100,key:true},
				   		{name:'STK_NAME',align:"center",width:200},
				   		{name:'PLU_C',align:"center",width:130},
				   		{name:'UOM',align:"center",width:50},
				   		{name:'NET_PRICE',align:"center",width:70},
				   		{name:'STK_QTY',align:"center",width:70},
				   		{name:'RES_QTY',width:70,align:'center'} ,
				   		{name:'NAME',width:150,align:'center'} ,
				   	]
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