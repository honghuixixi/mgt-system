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
					url:'${setting.cacheUrl}',
 					colNames:['缓存名称','长度','操作'],
 					rowNum:-1,
 					rowList:[100],
 					width:999,
				   	colModel:[
				   		{name:'cacheName',align:"center",width:180},
				   		{name:'size',align:"center",width:180},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
					var cacheNames = jQuery("#grid-table").jqGrid('getCol','cacheName',false);//获取某列的值
					for(var i=0; i<ids.length; i++){ 
						var id=ids[i]; 
						var cacheName = cacheNames[i];
						detail ="<button type='button' class='btn btn-info edit' id='"+cacheName+"'>清空 </button>";
						jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
					} 
					} 
				   	
				});
				
				$(".btn-info").live("click",function(){
					var $this = $(this);
					var name = $this.attr("id");
					$.ajax({
						url: '${setting.cacheClearUrl}',
						type: "GET",
						data: {
							name: name
						},
						dataType: "json",
						cache: false,
						success: function(date) {
							$("#grid-table").trigger("reloadGrid")
						}
					});
				});
				
			});
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="menu">
	           
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>