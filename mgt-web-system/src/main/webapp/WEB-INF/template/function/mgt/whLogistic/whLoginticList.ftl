<!DOCTYPE html>
<html lang="zh-cn">
    <head>
    	<meta charset="utf-8" />
        <title>仓库管理-仓库/物流维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/warehouse/whLogisticList.jhtml',
 					colNames:['ID','编码','名称','地址','类型','仓库属性','状态','操作'],
				   	colModel:[
				   		{name:'WH_C',index:'WH_C',width:30,hidden:true,key:true},
						{name:'WH_C',align:"center",width:50},
						{name:'NAME',align:"center",width:80},
				   		{name:'ADDRESS1',align:"center",width:150},
				   		{name:'DS_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){
								return '配送站';
							}else if(data=='N'){
								return '仓库';
	   						}else{
								return '未定义';
	   						}
	   					}},
				   		{name:'FBP_LBP_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){
								return '平台库';
							}else if(data=='N'){
								return '自有库';
	   						}else{
								return '未定义';
	   						}
	   					}},
				   		{name:'ACTIVE_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){
								return '活动';
							}else if(data=='N'){
								return '禁用';
	   						}else{
								return '未定义';
	   						}
	   					}},
				   		{name:'detail',width:70,align:'center',sortable:false} ,
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.ACTIVE_FLG=='活动'){
								detail="<button type='button' class='btn btn-info changeFlg'  id='"+id+"' flg='N'>禁用 </button>"
							}else if(rowData.ACTIVE_FLG=='禁用'){
								detail="<button type='button' class='btn btn-info changeFlg'  id='"+id+"' flg='Y'>启用</button>"
							}
							detail +="<button type='button' class='btn btn-info edit' id='"+rowData.WH_C+"' data-toggle='jBox-show'  href='${base}/warehouse/editLogisticArea.jhtml'>配送区域</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}				   	
				});
				
			// 改变仓库禁用启用状态
			$(".changeFlg").live("click",function(){
				var id = $(this).attr("id");
				var activeFlg = $(this).attr("flg");
				var str = "";
				if(activeFlg=='N'){
					str="确认‘禁用’该仓库吗?";
				}else if(activeFlg=='Y'){
					str="确认‘启用’该仓库吗?";
				}
				$.jBox.confirm(str,"提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/warehouse/isActiveFlg.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'id':id,
								'activeFlg':activeFlg
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
								if(data.code==100){
									top.$.jBox.tip('操作成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
								}else{
									top.$.jBox.tip('操作失败！', 'error');
									return false;
								}
							}
						});
					}
				});
			});
		});

	//修改按钮
	function edit(){
		var id = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
		var rowData = $('#grid-table').jqGrid('getRowData',id);
		if(id.length<=0){
			top.$.jBox.tip('未选择数据！','error');
			return false;
		}		
		if(id.length>1){
			top.$.jBox.tip('只能选择一条数据操作！','error');
			return false;
		}
		if(rowData.WH_C=='${accCode}'){
			top.$.jBox.tip('该仓库不允许修改！','error');
			return false;
		}		
        mgt_util.showjBox({
        	width : 1000,
        	height : 500,
        	title : '编辑',
       	    url : '${base}/warehouse/edit.jhtml?whC='+rowData.WH_C,
            grid : $('#grid-table')
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
		    		    <button type="button" class="btn_divBtn add" id="role_add" data-toggle="jBox-win" href="${base}/warehouse/addAreaWhUI.jhtml" jBox-width="1000" jBox-height="500">新增 </button>
		    		    <button type="button" class="btn_divBtn add" id="role_add" onclick="edit()" jBox-width="1000" jBox-height="500">修改</button>
		    		</div>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		        		<div class="form-group">
			                    <label class="control-label">仓库/配送站名称:</label>
		           				<input  class="form-control" id="name" style="width:150px;" name="name" value="" placeholder="请输入仓库/配送站名称"/>
	        			</div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="activeFlg">
		                        <option value="">全部</option>
		                        <option value="Y">活动</option>
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