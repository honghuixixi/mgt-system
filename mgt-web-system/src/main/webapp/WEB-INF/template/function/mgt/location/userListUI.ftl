<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>位置信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/location/userquery.jhtml',
 					colNames:['','用户名','用户姓名','用户类型','联系电话','操作'],
				   	colModel:[
					{name:'USER_NO',index:'ID',width:0,hidden:true,key:true},
				   		{name:'USER_NAME',width:100},
				   		{name:'NAME',width:150},
				   		{name:'TYPE', width:100},
				   		{name:'CRM_MOBILE',width:80,align:"center",editable:true},
				   		{name:'detail',index:'USER_NO',width:80,align:'center',sortable:false} 
				   	],
			   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1312' jBox-height='760' href='${base}/location/showlocation.jhtml'>详情 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
					<button type="button" class="btn btn-info btn_divBtn" id="search_location" data-toggle='jBox-show' jBox-width='1312' jBox-height='760' href="${base}/location/shoplist.jhtml">店铺位置</button>
				</div>
				<div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm" style="width:1000px" name="query" id="query-form"> 
	        			<div class="form-group">
		                    <label class="control-label">用户姓名</label>
		                    <input type="text" class="form-control" name="userName" id="userName" style="width:120px;" >
		                </div>
		           		<div class="search_cBox">
		                <div class="form-group">
		                 	<button type="button" class="search_cBox_btn" id='search_location' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
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