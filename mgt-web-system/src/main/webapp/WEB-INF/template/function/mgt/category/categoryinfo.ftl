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
					url:'${base}/category/list.jhtml',
 					colNames:['','分类名称','上级分类','创建时间','排序','等级'],
 					width:999,
				   	colModel:[
					{name:'CAT_ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'CAT_NAME',width:100},
				   		{name:'PARENT_NAME',width:150},
				   		{name:'CREATE_DATE', width:100,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd hh:mm:ss');
								}},
				   		{name:'SORT_NO',width:80,align:"center",editable:true},
				   		{name:'GRADE',width:80,align:"center",editable:true}
				   	]
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
			<div id="currentDataDiv" action="resource">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	                <div class="form-group">
	                    <label class="control-label">分类名称</label>
	                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
	                </div>
	           
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id='category_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	                 	<button type="button" class="btn btn-info add" id='category_add' data-toggle="jBox-win" href="${base}/category/addCategoryUI.jhtml">添加 </button>
		                <button type="button" class="btn btn-info edit" id='category_edit' data-toggle="jBox-edit" href="${base}/category/editCategoryUI.jhtml">编辑 </button>
		                <button type="button" class="btn btn-info del" id='category_del' data-toggle="jBox-remove-category" href="${base}/category/delete.jhtml">删除 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>