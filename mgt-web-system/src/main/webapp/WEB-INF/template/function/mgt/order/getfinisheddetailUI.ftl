<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/productlist.jhtml?mergeNo='+${masNo},
					multiselect:false,
 					colNames:['商品编码','条码','商品名称','单位','数量','发货数量','收货数量'],
 					rowNum: 1000,
				   	colModel:[	 
						{name:'STK_C',width:30},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'QTY1', width:40},
				   		{name:'QTY2', width:40}
				   	],
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       		<div id="currentDataDiv" action="resource" style="padding:10px 10px 0;">
	                <div class="form-group">
	                    <label class="control-label">商品信息（当前汇总单所包含的商品）</label>
	                </div>
	        </div>
	        <div style="clear:both;height:10px;font-size:10px;"></div>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>