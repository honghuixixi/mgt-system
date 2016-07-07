<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/promown/prolist.jhtml',
 					colNames:['','店铺名字','条码','名称','单位','商品类别','毛利率','进价','零售价','操作'],
 					width:999,
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",width:90},
				   		{name:'PLU_C',align:"center",width:90},
				   		{name:'NAME',align:"center",width:90},
				   		{name:'UOM',align:"center",width:90},
				   		{name:'CAT_C',align:"center",width:90},
				   		{name:'GP_RATE',align:"center",width:90},
				   		{name:'PUR_PRICE',align:"center",width:90},
				   		{name:'POS_LIST_PRICE',align:"center",width:90},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   		],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/promown/checkProductUI.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
	
						} 
					} 
				   	
				});

				$("#searchbtn").click(function(){
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
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
		  	<div id="consoleDlg"></div>
   		</div>
    </body>
</html>