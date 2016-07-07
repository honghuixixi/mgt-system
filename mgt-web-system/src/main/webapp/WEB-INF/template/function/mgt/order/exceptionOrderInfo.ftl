<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/exceptionOrderList.jhtml',
 					colNames:['','订单编号','配送员','客户编码','客户名称','订单类型','支付方式','交易状态','支付状态','操作'],
 					width:999,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:200},
				   		{name:'USER_NAME',align:"center",width:100},
				   		{name:'CUST_CODE',align:"center",width:100},
				   		{name:'CUST_NAME',align:"center",width:200},
				   		{name:'ORDER_TYPE',align:"center",width:100},
				   		{name:'STM_NAME',align:"center",width:100},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '待发货';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='RETURNSING'){
								return '退单中';
							}else if(data=='SUCCESS'){
								return '已完成';
							}else if(data=='CLOSE'){
								return '交易关闭';
							}else if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='WAITPAYMENT'){
								return '待支付';
							}else{
								return data;
							}
	   					}},
	   					{name:'PAY_STATUS',align:"center",width:100,editable:true,formatter:function(data){
							if(data=='WAITPAYMENT'){
								return '未支付';
							}else if(data=='PAID'){
								return '已支付';
							}else if(data=='PAYMENTPROCESS'){
								return '支付中';
							}else if(data=='REFUNDMENT'){
								return '已退款';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:100,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='900' jBox-height='300' href='${base}/order/exceptionOrderDetailUI.jhtml'>处理差异 </button>";
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
			<div id="currentDataDiv" action="menu">
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">订单编号</label>
		                    <input type="text" class="form-control" name="masNo" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">订单类型</label>
		                    <select class="form-control" name="orderType">
		                        <option value="">全部</option>
		                        <option value="LBP">LBP</option>
		                        <option value='FBP'>FBP</option>
		                    </select>
		                </div>
		                <div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id="exceptionOrder_query" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
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