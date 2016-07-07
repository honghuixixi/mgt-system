<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>客户退货单处理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				$('#grid-table').GridUnload();
				var postData={Flg:"INPROCESS"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/returnOrderList.jhtml',
 					colNames:['','退货单号','配送员','客户编码','客户名称','退单类型','交易状态','操作'],
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',width:200},
				   		{name:'NAME',width:130},
				   		{name:'CUST_CODE',width:150},
				   		{name:'CUST_NAME',width:180},
				   		{name:'ORDER_TYPE',width:150},
				   		{name:'STATUS_FLG',width:180,editable:true,formatter:function(data){
							if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='SUCCESS'){
								return '已完成';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.ORDER_TYPE=='FBP'){
								detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show' href='${base}/warehouse/receiveOrderInfo.jhtml'>收货</button>";
							}else if(rowData.ORDER_TYPE="LBP"){
								detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show' href='${base}/warehouse/deliverOrderInfo.jhtml'>发货</button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
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
	            <form class="form form-inline queryForm" style=" overflow:hidden" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="INPROCESS" class="sub_status_but active"><a> 待处理客户退货单</a></li>					
							<li role="presentation" id="DELIVERED" class="sub_status_but"><a> 已发货客户退货单</a></li>						
							<li role="presentation" id="SUCCESS" class="sub_status_but"><a> 已完成客户退货单</a></li>
						</ul>
					</div>
	            </form>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
$().ready(function() {
	// 状态面包屑事件，改变隐藏域select值并提交表单
    $("li.sub_status_but").on("click",function(){
    					$('#grid-table').GridUnload();//重绘
    					if("INPROCESS" == $(this).attr("id")){
    						$("li.sub_status_but").removeClass("active");
	    				$(this).addClass("active");
	    				$('#grid-table').GridUnload();

	    				var postData={Flg:"INPROCESS"};
						mgt_util.jqGrid('#grid-table',{
							postData: postData,
							url:'${base}/warehouse/returnOrderList.jhtml',
								colNames:['','退货单号','配送员','客户编码','客户名称','退单类型','交易状态','操作'],
								rowList:[],
						   	colModel:[
						   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
						   		{name:'MAS_NO',width:200},
						   		{name:'NAME',width:130},
						   		{name:'CUST_CODE',width:150},
						   		{name:'CUST_NAME',width:180},
						   		{name:'ORDER_TYPE',width:150},
						   		{name:'STATUS_FLG',width:180,editable:true,formatter:function(data){
									if(data=='INPROCESS'){
										return '处理中';
									}else if(data=='DELIVERED'){
										return '已发货';
									}else if(data=='SUCCESS'){
										return '已完成';
									}
			   					}},
						   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
						   	],
						   	gridComplete:function(){ //循环为每一行添加业务事件 
							var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
								for(var i=0; i<ids.length; i++){ 
									var id=ids[i]; 
									var rowData = $('#grid-table').jqGrid('getRowData',id);
									if(rowData.ORDER_TYPE=='FBP'){
										detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/receiveOrderInfo.jhtml'>收货</button>";
									}else if(rowData.ORDER_TYPE="LBP"){
										detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/deliverOrderInfo.jhtml'>发货</button>";
									}
									jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
								};
								//table数据高度计算
								cache=$(".ui-jqgrid-bdivFind").height();
								tabHeight($(".ui-jqgrid-bdiv").height());
							} 
						   	
						});
    	
     					   } 
					    	else if("DELIVERED" == $(this).attr("id")){
					        	$("li.sub_status_but").removeClass("active");
						    	$(this).addClass("active");
						    	$('#grid-table').GridUnload();
					
						    	var postData={Flg:"DELIVERED"};
								mgt_util.jqGrid('#grid-table',{
									postData: postData,
									url:'${base}/warehouse/returnOrderList.jhtml',
										colNames:['','退货单号','配送员','客户编码','客户名称','退单类型','交易状态'],
										rowList:[],
								   	colModel:[
								   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
								   		{name:'MAS_NO',width:200},
								   		{name:'NAME',width:130},
								   		{name:'CUST_CODE',width:150},
								   		{name:'CUST_NAME',width:180},
								   		{name:'ORDER_TYPE',width:150},
								   		{name:'STATUS_FLG',width:180,editable:true,formatter:function(data){
											if(data=='INPROCESS'){
												return '处理中';
											}else if(data=='DELIVERED'){
												return '已发货';
											}else if(data=='SUCCESS'){
												return '已完成';
											}
					   					}}
								   	],
								   	gridComplete:function(){ //循环为每一行添加业务事件 
										//table数据高度计算
										cache=$(".ui-jqgrid-bdivFind").height();
										tabHeight($(".ui-jqgrid-bdiv").height());
									} 
								});}
        
			                    else if("SUCCESS" == $(this).attr("id")){
					        	$("li.sub_status_but").removeClass("active");
						    	$(this).addClass("active");
						    	$('#grid-table').GridUnload();
					
						    	var postData={Flg:"SUCCESS"};
								mgt_util.jqGrid('#grid-table',{
									postData: postData,
									url:'${base}/warehouse/returnOrderList.jhtml',
										colNames:['','退货单号','配送员','客户编码','客户名称','退单类型','交易状态'],
										rowList:[],
								   	colModel:[
								   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
								   		{name:'MAS_NO',width:200},
								   		{name:'NAME',width:130},
								   		{name:'CUST_CODE',width:150},
								   		{name:'CUST_NAME',width:180},
								   		{name:'ORDER_TYPE',width:150},
								   		{name:'STATUS_FLG',width:180,editable:true,formatter:function(data){
											if(data=='INPROCESS'){
												return '处理中';
											}else if(data=='DELIVERED'){
												return '已发货';
											}else if(data=='SUCCESS'){
												return '已完成';
											}
					   					}}
								   	],
								   	gridComplete:function(){ //循环为每一行添加业务事件 
										//table数据高度计算
										cache=$(".ui-jqgrid-bdivFind").height();
										tabHeight($(".ui-jqgrid-bdiv").height());
									} 
								});
					        }
    			});
});
</script>
</html>