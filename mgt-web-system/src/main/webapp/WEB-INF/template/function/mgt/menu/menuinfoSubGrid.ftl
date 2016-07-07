<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					//url:'${base}/menu/list.jhtml',
					//url:'${base}/order/list.jhtml',
 					colNames:['','名称','菜单地址','状态','排序'],
 					width:1000,
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:100},
				   		{name:'URL',width:150},
				   		{name:'VISIBLE',width:80,align:"center",editable:true,formatter:function(data){
							if(data==1){
								return '启用';
							}
							if(data==0){
								return '禁用';
							}else{
								return data;
							}
	   		            }},
				   		{name:'SORTBY',width:100}
				   	],
				   	subGridRowExpanded: function(subgrid_id, row_id) {
				   		var subgrid_table_id = subgrid_id + "_t";   // (3)根据subgrid_id定义对应的子表格的table的id  
						var subgrid_pager_id = subgrid_id + "_pgr"  // (4)根据subgrid_id定义对应的子表格的pager的id
						// (5)动态添加子报表的table和pager  
						$("#" + subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+subgrid_pager_id+"' class='scroll'></div>");
						// (6)创建jqGrid对象  
						$("#" + subgrid_table_id).jqGrid({
							url: "${base}/resource/resources.jhtml?memuID="+row_id,
							datatype: "json",
							colNames: ['编号','内部编码','名称','申请号'],
							colModel: [
								{name:"id",index:"id",width:80,key:true},
								{name:"internalNo",index:"internalNo",width:130},
								{name:"NAME",index:"name",width:80,align:"right"},
								{name:"applicationNo",index:"applicationNo",width:80,align:"right"}
							],
							jsonReader: {   // (8)针对子表格的jsonReader设置  
							    root:"records",  
							    total:"totalpage",
					   			page: "currentpage",
					   			records:"totalrecord", 
							    repeatitems : false  
							},  
							prmNames: {search: "search"},  
							viewrecords: true,  
							height: "100%",  
						});    
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
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
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
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="menu_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                 	<button type="button" class="btn btn-info add" id="menu_add"  data-toggle="jBox-win" href="${base}/menu/addMenuUI.jhtml">添加 </button>
		                <button type="button" class="btn btn-info edit" id="menu_edit" data-toggle="jBox-edit" href="${base}/menu/editMenuUI.jhtml">编辑 </button>
		                <button type="button" class="btn btn-info del" id="menu_del" data-toggle="jBox-remove" href="${base}/menu/delete.jhtml">删除 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>