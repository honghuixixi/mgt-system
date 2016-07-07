<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>运维管理-员工位置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/userlastlocation/list.jhtml',
 					colNames:['','登陆名称','工作人员姓名','创建日期','纬度','经度','所处位置名'],
				   	colModel:[
				   	   
				   		{name:'USER_NO',index:'ID',hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",},
				   		{name:'NAME',align:"center",},
				   		{name:'CREATE_DATE',align:"center",},
				   		{name:'LATITUDE',align:"center",editable:true},
				   		{name:'LONGITUDE',align:"center",editable:true},
				   		{name:'LOCATION',align:"center",editable:true,width:"300"}
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
			<div class="form_divBox" style="display:block">
	            <form class="form form-inline queryForm"  id="query-form"> 
	                <div class="form-group">
	                    <label class="control-label">登陆名称</label>
	                    <input type="text" class="form-control" name="userName" id="userName" style="width:120px;" >
	                </div>
	                <div class="form-group">
	                    <label class="control-label">工作人员名称</label>
	                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
	                </div>
	            	<div class="search_cBox">
		                <div class="form-group">
		                 	<button type="button" class="search_cBox_btn" id='userlastlocation_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
		                </div>
	                </div>
	            </form>		   
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>