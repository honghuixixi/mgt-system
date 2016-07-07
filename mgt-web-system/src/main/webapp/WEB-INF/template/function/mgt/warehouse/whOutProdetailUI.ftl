<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={pkNo:${pkNo}}
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/addedStkMas.jhtml',
					multiselect:false,
 					colNames:['商品编码','条码','商品名称','单位','数量'],
 					rowNum:1000,
				   	colModel:[	 
						{name:'STK_C',width:50},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
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