<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" src="${base}/scripts/lib/DatePicker/WdatePicker.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/reconciliationa.jhtml',
 					colNames:['','订单编号','网关交易号','订单金额','平台金额','收货人手机','平台收费','下单日期','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CHAR_MAS_NO',align:"center",width:180},
				   		{name:'DEAL_ID',width:100,align:"center"},
				   		{name:'AMOUNT',width:100,align:"left", editable:true, formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   		{name:'ORDER_AMOUNT',align:"center",width:90},
				   		{name:'RECEIVER_MOBILE',align:"center",width:120},
				   		{name:'FEE',width:110,align:"center", editable:true},
				   		{name:'OM_CREATE_DATE',width:150,align:"center", editable:true},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/orderDetailUI.jhtml'>详情 </button>";
							//detail ="<a href='#' style='color:#f60' data-toggle='jBox-show' onclick='showDetail("+ id +")' >详情</a>"; 
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
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
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	                 <div class="form-group">
	                    <label class="control-label">开始时间</label>
	                    <input type="text" class="form-control" name="startDate" style="width:120px;" onfocus="WdatePicker();" >
	                </div>
	                <div class="form-group">
	                    <label class="control-label">结束时间</label>
	                    <input type="text" class="form-control" name="endDate" style="width:120px;" onfocus="WdatePicker();" >
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>