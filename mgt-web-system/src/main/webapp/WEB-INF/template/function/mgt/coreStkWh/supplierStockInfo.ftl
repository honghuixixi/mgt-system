<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-供应商库存管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={};
				mgt_util.jqGrid('#grid-table',{
				    multiselect:false,
					postData: postData,
					url:'${base}/coreStkWh/supplierStockList.jhtml',
 					colNames:['商品编码','商品名称','条码','单位','金额','库存数量','预留数量','操作'],
				   	colModel:[
				   		{name:'STK_C',index:'STK_C',align:"center",width:0,key:true},
				   		{name:'STK_NAME',align:"center",width:280},
				   		{name:'PLU_C',align:"center",width:180},
				   		{name:'UOM',align:"center",width:100},
				   		{name:'NET_PRICE',align:"center",width:100},
				   		{name:'STK_QTY',align:"center",width:100},
				   		{name:'RES_QTY',width:100,align:'center'} ,
				   		{name:'detail',index:'PK_NO',width:120,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							var stkC = rowData.STK_C;
							detail ="<button type='button' class='btn btn-info edit' id='"+stkC+"' data-toggle='jBox-show' href='${base}/coreStkWh/supplierStockDetailUI.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
				});
				
				//table数据高度计算
				tabHeight();
				
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form">      
					    <div class="form-group">
					    	<label class="control-label">筛选条件:</label>
		                    <input type="text" class="form-control" name="queryParam" style="width:250px;"  placeholder="请输入商品编码/条码/名称进行查询">
		                </div>
		                <!--
		                <div class="form-group">
		            		<label class="control-label">仓库:</label>
		                    <select class="form-control" name="whC" style="margin-right: 4px;width:150px;">
		                    <option value="">请选择...</option>
		                    [#list whlist as wh]
		                    	<option value="${wh.WH_C}">${wh.NAME}</option>
		                    [/#list]
							</select>
	                    </div>
	                    -->
	                    <!--这里的id和资源中配置的值需要一致。-->
		            </form>
		            <div class="search_cBox">
		            	<button type="button" class="btn_divBtn" id="supplier_stock_query" data-toggle="jBox-query"> 搜 索 </button>
		            </div>
	            </div>
	        </div>
	      </div>    
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>