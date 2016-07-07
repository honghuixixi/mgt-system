<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/masList.jhtml',
 					colNames:['','商品名称','商品价格','促销价格','促销数量'],
 					width:998,
				   	colModel:[	 
						{name:'STK_C',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:150},
				   		{name:'NET_PRICE', width:100},
				   		{name:'STK_C', width:100,formatter:function(data){
					 		return '<input type="text"  value="'+data+'">';
					 		}},
				   		{name:'STK_C', width:100,formatter:function(data){
						return '<input type="text"  value="'+data+'">';
							 
							 
								}}
				   	]
				});

				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
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
	            <!-- 搜索条 -->
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	                <div class="form-group">
	                    <label class="control-label">商品名称</label>
	                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
	                </div>
	          
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id='' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
  	
   		</div>
    </body>
</html>
 



