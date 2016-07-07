<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-菜单信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/operationsCenter/list.jhtml',
 					colNames:['','','','运营中心编码','企业名称','联系人','联系电话','所在区域','创建时间','状态','操作'],
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:0,hidden:true,key:true},
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'HQ',index:'HQ',width:0,hidden:true},
				   		{name:'USER_NAME',width:100},
				   		{name:'NAME',width:150,align:"center"},
				   		{name:'CRM_PIC',width:100,align:"center"},
				   		{name:'CRM_MOBILE',width:100,align:"center"},
				   		{name:'AREA_NAME',width:150,align:"center"},
				   		{name:'CREATE_DATE',align:"center",width:150,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            if(data!=null){
                            return data;
                            }else{
                            return "";
                            }
                            }
                        },
				   		{name:'SHOW_FLG', width:50,align:"center",formatter:function(data){
							if(data=='N'){
								return '停用';
							}else if(data=='Y'){
								return '启用';
							}}
							},
				   		{name:'detail',index:'PLU_C',width:250,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
				   	var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' data-toggle='jBox-show'  href='${base}/operationsCenter/edit.jhtml'>修改</button>&nbsp<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' data-toggle='jBox-show'  href='${base}/operationsCenter/operationsCenterDetail.jhtml'>详情</button>";
							if(rowData.SHOW_FLG=='停用'){
							detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' data-toggle='jBox-change-order' href='${base}/operationsCenter/updateFlg.jhtml?showFlg=Y'>启用</button>";
							}else{
							detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' data-toggle='jBox-change-order' href='${base}/operationsCenter/updateFlg.jhtml?showFlg=N'>停用</button>";
							}
							if(rowData.HQ=='Y'){
							detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' data-toggle='jBox-show'  href='${base}/operationsCenter/operationsCenterArea.jhtml'>分配区域</button>";
							detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' onClick=addEmployeeRoleUI('"+rowData.ID+"')>分配角色</button>";
							}
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
			
			$().ready(function() {
		  		var $areaId = $("#areaId");
		  		// 菜单类型选择
				$areaId.lSelect({
					url: "${base}/common/areao.jhtml"
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
						<div class="form-group">
		    		    	<button type="button" class="btn_divBtn add" id="role_add" data-toggle="jBox-win" href="${base}/operationsCenter/addUI.jhtml">新增 </button>
		    		    </div>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		        		<div class="form-group">
			                    <label class="control-label">企业名称:</label>
		           				<input  class="form-control" id="name" style="width:150px;" name="name" value="" placeholder="请输入企业名称"/>
	        			</div>
		                <div class="form-group">
			                    <label class="control-label">区域:</label>
		           				<input type="hidden" id="areaId" name="areaId" />
		        		</div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="showFlg">
		                        <option value="">全部</option>
		                        <option value="Y">启用</option>
		                        <option value='N'>禁用</option>
		                    </select>
		                </div>
		            </form>
		         </div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="menu_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	             	</div>
	         	</div>
	        </div>
	     </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
	<SCRIPT type="text/javascript">
	function addEmployeeRoleUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '分配角色',
							url : '${base}/employee/addEmployeeRoleUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   }
	</SCRIPT>
</html>