<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>收货地址变更审核</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"S"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/addrareachgreq/list.jhtml',
 					colNames:['','店铺名称','申请日期','申请状态','申请理由','操作'],
				   	colModel:[
				  	 	{name:'PK_NO',index:'PK_NO',width:0,hidden:true,hidden:true,key:true},
				   		{name:'SHOP_NAME',index:'SHOP_NAME',align:"center",width:150,key:true},
				   		{name:'MASDATE',index:'AMOUNT',align:"center",width:200,key:true},
				   		{name:'STATUS_FLG',width:140,align:"center",editable:true,formatter:function(data){
							if(data=='S'){
								return '提交';
							}else if(data=='R'){
								return '拒绝';
							}else if(data=='P'){
								return '通过';
							}else {
								return "";
							}
	   					}},
				   		{name:'REQ_DESC',index:'REQ_DESC',align:"center",width:350,key:true},
				   		{name:'detail',index:'PK_NO',width:150,align:'center',sortable:false}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							var detail ="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show'  href='${base}/addrareachgreq/changedetail.jhtml'>明细</button>";
							if(rowData.STATUS_FLG=='S'){
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='shutdown("+rowData.CUST_CODE+")'>审核</button>";
							}else if(rowData.STATUS_FLG=='锁定'){
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"'  onclick='activated("+rowData.CUST_CODE+")'>启用</button>";
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
       	  <div class="main_heightBox1"></div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
    <script>
function down(){
	$.jBox.confirm("确认手动下载吗?", "提示", function(v){
	if(v == 'ok'){
	 	$.ajax({
		    url: '${base}/bank/downOrder.jhtml',
			method:'post',
			dataType:'json',
			data:$("#query-form").serializeObjectForm(),
			sync:false,
			error : function(data) {
			alert("网络异常");
			return false;},
			success : function(data) {
			if(data.code==001){		
				top.$.jBox.tip('下载成功！', 'success');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				}
				else{
				top.$.jBox.tip('下载失败！', 'error');
				mgt_util.closejBox('jbox-win');
						return false;
				}
			}
		});	
	}});
}
    	
    
    
    </script>
    
</html>