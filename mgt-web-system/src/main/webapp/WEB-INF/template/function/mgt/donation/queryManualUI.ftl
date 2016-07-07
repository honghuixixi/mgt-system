<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>营销管理-赠品发放</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					autowidth : true,
					width:900,
 					autowidth: false,  
		            shrinkToFit: true,
					//rownumbers : false,
					url:'${base}/donation/userList.jhtml?userids='+window.parent.getids(),
 					colNames:['','客户编码','客户名称'],
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:0,hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",width:50},
				   		{name:'NAME',align:"center",width:50}
				   	]
				});
				//table数据高度计算
				tabHeight();
				//$(".ui-jqgrid-bdiv").css("height","auto");
				$("#donationGrant").click(function(){
					window.location.href = "${base}/donation/userList.jhtml";
				});
				window.parent.sss(); 
			});
			
			function sub(){
   				var grid = $("#grid-table");
	   			var ids = grid.jqGrid('getGridParam', 'selarrrow');
	   			var page ="ids="+ids+"&flg=M"
	   			var condition = "手工查询";
	   			window.parent.document.getElementById("condition").value=condition;
   				window.parent.queryAll(page); 
   				window.parent.window.jBox.close();
  			 }
   			function closes(){
   				window.parent.window.jBox.close();
   			}
		</script>
		<style>
			//.ui-jqgrid .ui-jqgrid-bdiv{overflow:hidden;height:auto;}
		</style>
    </head>
    <body>
       
   		<div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
		               <div class="form-group">
		                    <label class="control-label">客户名称</label>
		                    <input type="text" class="form-control" name="name" id="name" placeholder="请输入客户编码、名称查询" style="width:180px;">
		                </div>
		                
	                	<div class="form-group">
	                    	<!--这里的id和资源中配置的值需要一致。-->
	                 		<button type="button" class="search_cBox_btn" id="" data-toggle="jBox-query" data-form="#query-form"><i class="icon-search"></i> 搜 索 </button>
	                		 <button type="button" class="btn_divBtn" onclick="sub()" >确定</button>
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