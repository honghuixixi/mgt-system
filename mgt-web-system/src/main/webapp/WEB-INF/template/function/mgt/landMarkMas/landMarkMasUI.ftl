<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>地标管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/landMark/list.jhtml',
 					colNames:['','编码','名称','描述','所在区域','负责人','合作配送店铺','状态','创建时间','操作'],
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'CODE',width:100},
				   		{name:'NAME',width:150,align:"center"},
				   		{name:'DESCRIPTION',width:100,align:"center"},
				   		{name:'AREA_NAME',width:150,align:"center"},
				   		{name:'PIC_NAME',width:100,align:"center"},
				   		{name:'USER_NAME',width:150,align:"center"},
				   		{name:'STATUS_FLG', width:80,align:"center",formatter:function(data){
							if(data=='N'){
								return '停用';
							}else if(data=='Y'){
								return '启用';
							}}
						},
				   		{name:'CREATE_DATE',align:"center",width:180,formatter : function(data){
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
				   		{name:'detail',index:'PLU_C',width:200,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
				   	var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="<button type='button' class='btn btn-info edit' id='"+rowData.UUID+"' data-toggle='jBox-show' jBox-width='1000' jBox-height='500' href='${base}/landMark/edit.jhtml'>修改</button>";
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
					url: "${base}/common/area.jhtml"
				});
			});
			
			//删除
		function deleteLandMarkMas(){
			var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
			if(ids==""){
				top.$.jBox.tip('未选择数据，不可提交！','error');
				return false;
			}
			if(ids.length>1){
				top.$.jBox.tip('不能多选！','error');
				return false;
			}
			$.jBox.confirm("确认执行删除操作?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : "${base}/landMark/delete.jhtml",
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data) {
						if(data.code==100){
									top.$.jBox.tip(data.msg, 'success');
									$('#grid-table').trigger("reloadGrid");
								}else{
									top.$.jBox.tip(data.msg, 'error');
									return false;
								}
						}
								});
							}
						});
					}
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
						<div class="form-group">
		    		    	<button type="button" class="btn_divBtn add" id="role_add" data-toggle="jBox-win" href="${base}/landMark/landMarkMasAddUI.jhtml" jBox-width="1000" jBox-height="500">新增 </button>
		    		        <!--<button type="button" class="btn_divBtn del" id="menu_del" data-toggle="jBox-remove" href="${base}/landMark/delete.jhtml">删除 </button>-->
		    		        <button type="button" class="btn_divBtn"  id="order_deliver" onclick="deleteLandMarkMas()">删除</button>
		    		        <button type="button" class="btn_divBtn del" id="menu_del" data-toggle="jBox-change-order" href="${base}/landMark/editStatusFlgY.jhtml">启用 </button>
		    		        <button type="button" class="btn_divBtn del" id="menu_del" data-toggle="jBox-change-order" href="${base}/landMark/editStatusFlgN.jhtml">停用</button>
		    		    </div>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		        		<div class="form-group">
			                    <label class="control-label"></label>
		           				<input  class="form-control" id="key" style="width:150px;" name="key" value="" placeholder="输入编码或名称查询"/>
	        			</div>
		                <div class="form-group">
			                    <label class="control-label">区域:</label>
		           				<input type="hidden" id="areaId" name="areaId" />
		        		</div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="statusFlg">
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
</html>