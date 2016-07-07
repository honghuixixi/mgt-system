<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>菜单信息预览</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/menu/list.jhtml',
 					colNames:['','名称','菜单地址','状态','排序'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:100,align:"center"},
				   		{name:'URL',width:150,align:"center"},
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
				   		{name:'SORTBY',width:100,align:"center"}
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
		<script type="text/javascript">  
		  	$().ready(function() {
		  		var $acId = $("#acId");
		  		// 菜单类型选择
				$acId.lSelect({
					url: "${base}/mgt/mgtType.jhtml"
				});
			});
  		</script> 
		
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style="width:1000px" name="query" id="query-form"> 
	        			<div class="form-group">
		                    <label class="control-label">一级菜单</label>
	           				<input type="hidden" id="acId" name="acId" />
	        			</div>
		                <div class="form-group">
	    		        	<button type="button" class="btn_divBtn edit" id="info_edit" data-toggle="jBox-edit" href="${base}/mgt/mgtMenuDetail.jhtml">编辑 </button>
	    		        </div> 
		            </form>
		            <div class="search_cBox">
		            	<div class="form-group">
		                 	<button type="button" class="btn_divBtn" id="info_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
		            </div>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>