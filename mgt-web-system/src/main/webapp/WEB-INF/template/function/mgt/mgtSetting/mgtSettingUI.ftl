<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-系统参数设置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/mgtSetting/mgtSettingList.jhtml',
 					colNames:['','编号','名称','描述','默认设置项','默认值','是否允许用户设置','排序','操作'],
				   	colModel:[
				   		{name:'ITEM_NO',index:'ITEM_NO',width:0,hidden:true,key:true},
				   		{name:'ITEM_NO',width:150},
				   		{name:'MENU_NAME',width:100},
				   		{name:'DESCRIPTION', width:100},
				   		{name:'DEF_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data== 'Y'){
								return '是';
							}
							if(data== 'N'){
								return '否';
							}else{
								return data;
							}
	   		            }},
				   		{name:'DEF_VALUE',width:80},
				   		{name:'USER_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data== 'Y'){
								return '是';
							}
							if(data== 'N'){
								return '否';
							}else{
								return data;
							}
	   		            }},
	   		            {name:'SORT_NO', width:100},
	   		          {name:'detail',index:'STK_C',width:80,align:'center',sortable:false}	   		     
				   	],
			    	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							console.log(ids[i]);
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/mgtSetting/mgtSettingEditUI.jhtml'>编辑 </button>";
							//detail ="<a href='#' style='color:#f60' data-toggle='jBox-show' onclick='showDetail("+ id +")' >详情</a>"; 
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
			<div id="currentDataDiv" action="resource">
	            <div class="currentDataDiv_tit">
	                <div class="form-group">
	                 	<button type="button" class="btn_divBtn add" id='resource_add' data-toggle="jBox-win" href="${base}/mgtSetting/mgtSettingAddUI.jhtml">添加</button>
		                <!--  <button type="button" class="btn_divBtn edit" id='resource_edit' data-toggle="jBox-edit" href="${base}/mgtSetting/mgtSettingEditUI.jhtml">编辑 </button> -->
		                <button type="button" class="btn_divBtn del" id='resource_del' data-toggle="jBox-remove-resource" href="${base}/mgtSetting/mgtSettingDelete.jhtml">删除 </button>
	                </div>
	            </div> 
	            <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  id="query-form">
		            	<div class="form-group">
		                    <label class="control-label">编号</label>
		                    <input type="text" class="form-control" name="itemNo" id="itemNo" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">菜单名称</label>
		                    <input type="text" class="form-control" name="menuName" id="menuName" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">是否允许用户设置</label>
		                    <select class="form-control" name="userFlg">
		                        <option value="">全部</option>
		                        <option value="Y">是</option>
		                        <option value="N">否</option>
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