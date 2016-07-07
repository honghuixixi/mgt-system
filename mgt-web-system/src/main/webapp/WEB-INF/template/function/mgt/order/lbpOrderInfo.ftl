<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>客户退货单处理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={statusFlg:"DELIVERED"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/lbplist.jhtml',
 					colNames:['','退单号','配送员','客户编码','客户名称','退单类型','交易状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:200},
				   		{name:'NAME',align:"center",width:100},
				   		{name:'CUST_CODE',align:"center",width:180},
				   		{name:'CUST_NAME',align:"center",width:180},
				   		{name:'ORDER_TYPE',align:"center",width:80},
				   		{name:'STATUS_FLG',align:"center",width:180,editable:true,formatter:function(data){
							if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='SUCCESS'){
								return '已收货';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.STATUS_FLG=='已发货'){
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/lbpReceiveUI.jhtml'>收货 </button>";
							}else{
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/lbpReceiveUI.jhtml'>明细 </button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
				
					$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
         <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form">      
				    <div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="DELIVERED" class="sub_status_but active"><a href="#"> 待收货客户退货单</a></li>					
							<li role="presentation" id="SUCCESS" class="sub_status_but"><a href="#"> 已收货客户退货单</a></li>
						</ul>
				    </div>			
				    <div class="form-group sr-only" >
	                    <label class="control-label">订单状态</label>
	                    <select class="form-control" name="statusFlg">
	                        <option value="">全部</option>
	                        <option value="DELIVERED">待收货客户退货单</option>
	                        <option value="SUCCESS">已待收货客户退货单</option>
	                    </select>
					</div>
					<div id="finishSt" class="sr-only">
					<button type="button" class="btn btn-info" id="order_search" data-toggle="jBox-query">搜 索 </button>
					</div>
	            </form>
	        </div>
	      </div>    
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but a").on("click",function(){
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("DELIVERED" == $(this).parent().attr("id")){
	    	}else{
	    	
	    	}
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).parent().addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parent().parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).parent().attr("id"));
	        $("#order_search").click(); 
	    });
	});
</script>
</html>