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
					url:'${base}/b2bRouteMas/list.jhtml',
 					colNames:['','线路编码','线路名称','状态','描述','操作'],
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'ROUTE_CODE',width:100},
				   		{name:'ROUTE_NAME',width:100},
				   		{name:'STATUS_FLG', width:50,align:"center",formatter:function(data){
							if(data=='N'){
								return '禁用';
							}else if(data=='Y'){
								return '启用';
							}}
							},
				   		{name:'REMARK',width:150},
				   		{name:'detail',index:'UUID',width:50,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
				   	var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.STATUS_FLG=='禁用'){
							detail ="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.UUID+"' data-toggle='jBox-change-order' href='${base}/b2bRouteMas/updateFlg.jhtml'>启用</button>";
							}else{
							detail ="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.UUID+"' data-toggle='jBox-change-order' href='${base}/b2bRouteMas/updateFlg.jhtml'>禁用</button>";
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
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
					<div class="form-group">
		                 	<button type="button" class="btn_divBtn add" id="menu_add"  data-toggle="jBox-win" href="${base}/b2bRouteMas/b2bRouteMasAddUI.jhtml">新增 </button>
			                <button type="button" class="btn_divBtn edit" id="menu_edit" data-toggle="jBox-edit" href="${base}/b2bRouteMas/edit.jhtml">修改 </button>
			                <button type="button" class="btn_divBtn del" id="order_deliver" onclick="deleteB2bRouteMas()">删除 </button>
		             </div>
				</div>
				<!--<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">名称</label>
		                    <input type="text" class="form-control" name="name" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="visible">
		                        <option value="">全部</option>
		                        <option value="1">启用</option>
		                        <option value='0'>禁用</option>
		                    </select>
		                </div>
		            </form>
		         </div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="menu_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	             	</div>
	         	</div>-->
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
			if(ids.length>1){
				top.$.jBox.tip('不能多选！','error');
				return false;
			}
			$.jBox.confirm("确认执行删除操作?", "提示", function(v){
				if(v == 'ok'){
				
						$.ajax({
							url : "${base}/b2bRouteMas/delete.jhtml",
							type :'post',
							dataType : 'json',
							data : 'id=' + ids,
							success : function(data) {
							if(data.code==100){
										top.$.jBox.tip(data.msg, 'success');
										$('#grid-table').trigger("reloadGrid");
									}else{
										top.$.jBox.tip(data.msg, 'error');
										return false;
									}
							}
							});
							
							}
						});
					}
</script>