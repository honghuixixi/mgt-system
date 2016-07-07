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
					url:'${base}/b2bRouteMas/b2bRouteLinelist.jhtml',
 					colNames:['','线路名称','概况','操作'],
				   	colModel:[
				   		{name:'ROUTE_CODE',index:'ROUTE_CODE',width:0,hidden:true,key:true},
				   		{name:'ROUTE_NAME',width:100},
				   		{name:'SURVEY',width:300},
				   		{name:'detail',width:100} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
				   	var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.ROUTE_CODE+"' jBox-width='1000' data-toggle='jBox-show' href='${base}/b2bRouteMas/b2bRouteStklistUI.jhtml'>商品详情</button>";
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
				
				$("#lineLocation").click(function(){
					var ids = jQuery("#grid-table").jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请选择一条记录！');
						return;
					} else if (ids.length > 5) {
						top.$.jBox.tip('选择记录不能超过5条！');
						return;
					}
					//var rowData = $('#grid-table').jqGrid('getRowData',ids);
					//var postData = {custCode:rowData.ROUTE_CODE,areaId:$("#areaId").val(),allSeachTex:$("#allSeachTex").val(),withoutPic:$("#withoutPic").val(),custType:$("#custType").val(),startDate:$("#startDate").val(),endDate:$("#endDate").val(),custName:$("#custName").val(),spUserName:$("#spUserName").val(),showFlg:$("#showFlg").val()};
					//var ss = JSON.stringify(postData); 
					var url = '${base}/b2bRouteMas/lineLocationUI.jhtml?routeCode='+ids;
					window.location.href = url;
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
					<div class="form-group">
		                 	<button type="button" class="btn_divBtn" id="lineLocation">线路调整 </button>
		             </div>
				</div>
				
	        </div>
	     </div>
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