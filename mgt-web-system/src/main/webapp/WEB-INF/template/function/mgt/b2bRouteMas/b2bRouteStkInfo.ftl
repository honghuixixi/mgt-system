<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-菜单信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/b2bRouteMas/b2bRouteStklist.jhtml?routeCode=${routeCode}',
					width:1000,
 					autowidth: false,
 					colNames:['','商品编码','商品条码','商品名称','单位','数量','金额','体积','重量'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'STK_C',align:"center",width:80},
				   		{name:'PLU_C',align:"center",width:130},
				   		{name:'STK_NAME',align:"center",width:250},
				   		{name:'UOM',align:"center",width:80},
				   		{name:'UOM_QTY',align:"center",width:80},
				   		{name:'NET_PRICE',align:"center",width:80},
				   		{name:'WEIGHT',align:"center",width:80},
				   		{name:'VOLUMN',align:"center",width:80} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>
<script type="text/javascript">
	function deleteB2bRouteMas(){
			var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
			if(ids==""){
				top.$.jBox.tip('未选择数据，不可提交！','error');
				return false;
			}
			if(ids.length>5){
				top.$.jBox.tip('最多选取5条线路！','error');
				return false;
			}
</script>