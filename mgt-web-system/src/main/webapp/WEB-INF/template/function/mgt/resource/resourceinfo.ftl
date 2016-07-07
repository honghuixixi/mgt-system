<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-资源信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/resource/list.jhtml',
 					colNames:['','名称','地址','值','状态','所属菜单'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:100},
				   		{name:'URL',width:150},
				   		{name:'VALUE', width:100},
				   		{name:'STATUS',width:80,align:"center",editable:true,formatter:function(data){
							if(data==1){
								return '启用';
							}
							if(data==0){
								return '禁用';
							}else{
								return data;
							}
	   		            }},
				   		{name:'MENUNAME',width:80,align:"center",editable:true}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
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
			<div id="currentDataDiv" action="resource">
			   <div class="currentDataDiv_tit">
			   		<div class="form-group">
	                 	<button type="button" class="btn_divBtn add" id='resource_add' data-toggle="jBox-win" href="${base}/resource/addResourceUI.jhtml">添加 </button>
		                <button type="button" class="btn_divBtn edit" id='resource_edit' data-toggle="jBox-edit" href="${base}/resource/editResourceUI.jhtml">编辑 </button>
		                <button type="button" class="btn_divBtn del" id='resource_del' data-toggle="jBox-remove-resource" href="${base}/resource/delete.jhtml">删除 </button>
	                </div>
			   </div>
			   <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">资源名称</label>
		                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">所属菜单名称</label>
		                    <input type="text" class="form-control" name="menuname" id="name" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="status">
		                        <option value="">全部</option>
		                        <option value="1">启用</option>
		                        <option value='0'>禁用</option>
		                    </select>
		                </div>
		             </form>
	            </div>
	            <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id='resource_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>