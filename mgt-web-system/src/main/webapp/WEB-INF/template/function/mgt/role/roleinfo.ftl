<!DOCTYPE html>
<html lang="zh-cn" class="html_ofh">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-角色信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/role/list.jhtml',
 					colNames:['','角色名称','所属商户','状态','描述','操作'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',align:"center",width:160},
				   		{name:'MERCHANT_NAME',align:"center",width:160},
				   		{name:'STATUS',width:60,align:"center",editable:true,formatter:function(data){
							if(data==1){
								return '启用'; 
							}
							if(data==0){
								return '禁用';
							}else{
								return data;
							}
	   					}},
				   		{name:'MEMO',width:160,align:"center", editable:true},
			   			{name:'',width:200,align:"center",editable:true,formatter:function(value,row,index){
					 
					 	return '<button type="button" class="btn btn-info edit"   onClick=editRoleUI("'+index.ID+'")  href="${base}/employee/editEmployeeUI.jhtml">编辑 </button>&nbsp;<button type="button" class="btn btn-info edit"    onClick=editRoleResourceUI("'+index.ID+'")  href="${base}/role/addRoleResourceUI.jhtml">分配资源</button>&nbsp;<button type="button" class="btn btn-info del"  onClick=editRoleUserUI("'+index.ID+'")  href="${base}/role/addRoleUserUI.jhtml" jBox-width="1212" jBox-height="560">分配人员</button>';
					   	}}
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
       			<div id="currentDataDiv" action="role">
					<div class="currentDataDiv_tit">
						<div class="form-group">
		    		    	<button type="button" class="btn_divBtn add" id="role_add" data-toggle="jBox-win" href="${base}/role/addRoleUI.jhtml">添加 </button>
		    		        <button type="button" class="btn_divBtn del"  id="role_del" data-toggle="jBox-remove-role" href="${base}/role/delete.jhtml">删除 </button>
		    		        <button type="button" class="btn_divBtn edit" id="role_modifyScopeToPrivate"  data-toggle="jBox-modify-scope" href="${base}/role/modifyRoleScope.jhtml?scope=3">设置私有</button>
		    		    	<button type="button" class="btn_divBtn edit"  id="role_modifyScopeToPublic" data-toggle="jBox-modify-scope" href="${base}/role/modifyRoleScope.jhtml?scope=2" jBox-width="1212" jBox-height="560">设置公有</button>
		    		    </div>
					</div>
					<div class="form_divBox" style="display:block;">
			            <form class="form form-inline queryForm" id="query-form"> 
			                <div class="form-group">
			                    <label class="control-label">角色名称</label>
			                    <input type="text" class="form-control" name="name" style="width:120px;">
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
		                 	<button type="button" class="search_cBox_btn" id="role_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
			        </div>
		        </div>
       		</div>    
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>

<SCRIPT>
function editRoleUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '编辑',
							url : '${base}/role/editRoleUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
}
function editRoleResourceUI(obj){
		mgt_util.showjBox({
							width : 360,
							height : 500,
							title : '编辑',
							url : '${base}/role/addRoleResourceUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
}
function editRoleUserUI(obj){
		mgt_util.showjBox({
							width : 1212,
							height : 560,
							title : '编辑',
							url : '${base}/role/addRoleUserUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
}
</SCRIPT>