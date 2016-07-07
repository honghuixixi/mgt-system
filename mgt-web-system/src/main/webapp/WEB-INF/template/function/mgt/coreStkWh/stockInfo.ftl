<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>库存管理</title>
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
					url:'${base}/coreStkWh/stockList.jhtml',
 					colNames:['商品编码','商品名称','条码','单位','库存数量','预留数量'],
				   	colModel:[
				   		{name:'STK_C',index:'STK_C',width:0,key:true},
				   		{name:'STK_NAME',align:"center",width:300},
				   		{name:'PLU_C',align:"center",width:180},
				   		{name:'UOM',align:"center",width:100},
				   		{name:'STK_QTY',align:"center",width:100},
				   		{name:'RES_QTY',width:100,align:'center'} 
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
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
					     <div class="form-group">
		                    <input type="text" class="form-control" name="queryParam" style="width:250px;"  placeholder="请输入商品编码/条码/名称进行查询">
		                </div>
		                <div class="form-group">
		            		<label class="control-label">仓库:</label>
		                    <select class="form-control" name="whC" style="margin-right: 4px;width:150px;">
		                    <option value="">请选择...</option>
		                    [#list whlist as wh]
		                    	<option value="${wh.WH_C}">${wh.NAME}</option>
		                    [/#list]
							</select>
	                    </div>
		                <div class="form-group">
		                <div class="search_cBox">
		                    <!--这里的id和资源中配置的值需要一致。-->
		                 	<button type="button" class="search_cBox_btn" id="stock_query" data-toggle="jBox-query"><i class="icon-search "></i> 搜 索 </button>
		                </div>
		                </div>
		            </form>
		        </div>
	        </div>
	      </div>     
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>