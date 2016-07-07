<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-客服管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
        <link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script  type="text/javascript">
			$(function(){
	   			$("#userNo").chosen();
			});
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/vendorServiceProvider/list.jhtml',
 					colNames:['','客服名称','用户名','供应商编码','类型',/* '工作时间',*/'状态','排序','日期','操作'],
 					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'SERVICE_NAME',align:"center",width:150},
				   		{name:'NAME',align:"center",width:150},
				   		{name:'VENDOR_CODE',align:"center",width:150},
				   		/* {name:'WORK_TIME',align:"center",width:350,editable:true,formatter:function(value,row,index){
							return index.WORK_TIME_FROM+" 至 "+index.WORK_TIME_TO;
	   					}}, */
	   					{name:'TYPE',align:"center",width:100,editable:true,formatter:function(data){
							if(data=='1'){
								return '售前';
							}else if(data=='2'){
								return '售中';
							}else if(data == '3'){
								return '售后';
							}else{
								return '未知类型';
							}
	   					}},
				   		{name:'ACTIVE_FLG',align:"center",width:100,editable:true,formatter:function(data){
							if(data=='A'){
								return '启用中';
							}else if(data=='P'){
								return '已停用';
							}
	   					}},
	   					{name:'SORT_NO',align:"center",width:100},
				   		{name:'CREATE_DATE',align:"center",width:180},
				   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false} 
				   	],
			   		gridComplete:function(){ //循环为每一行添加业务事件 
						var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.ACTIVE_FLG=='启用中'){
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' onclick=editStatus("+id+",'P')>停用</button>";
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='edit("+id+");'>修改</button>";
							}else{
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' onclick=editStatus("+id+",'A')>启用 </button>";
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='deleteItem("+id+");'>删除</button>";
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='edit("+id+");'>修改</button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
			      } 
				   	
				});
				
				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			//添加客服
			function addVendorService(){
				mgt_util.showjBox({
		 			width : 800,
		 			height : 450,
		 			title : '添加客服',
		 			url : '${base}/vendorServiceProvider/addUI.jhtml',
		 			grid : $('#grid-table')
		 		});
			}
			//预览
			function preview(){
				mgt_util.showjBox({
		 			width : 211,
		 			height : 390,
		 			title : '客服预览',
		 			url : '${base}/vendorServiceProvider/preview.jhtml',
		 			grid : $('#grid-table')
		 		});
			}
			//启用/停用客服
			function editStatus(id,status){
				var tips = "";
				if(status=='P'){
					tips="确认停用该客服吗?";
				}else if(status=='A'){
					tips="确认启用该客服吗?";
				}else{
					tips="确认此操作吗?"
				}
		   		$.jBox.confirm(tips, "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在设置数据，请稍等...');
						$.ajax({
							url : '${base}/vendorServiceProvider/editStatus.jhtml',
							type :'post',
							dataType : 'json',
							data : 'id=' + id+'&status='+status,
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										top.$.jBox.tip(data.msg,data.code);
										mgt_util.refreshGrid($("#grid-table"));
									}
								});
							}
						});
					}
			    }); 
		   }
			
			//编辑客服
			function edit(id){
				mgt_util.showjBox({
		 			width : 800,
		 			height : 450,
		 			title : '添加客服',
		 			url : '${base}/vendorServiceProvider/addUI.jhtml?id='+id,
		 			grid : $('#grid-table')
		 		});
			}
			
		   //删除客服
		   function deleteItem(id){
			   $.jBox.confirm("确认删除该客服吗?", "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在删除数据，请稍等...');
						$.ajax({
							url : '${base}/vendorServiceProvider/delete.jhtml',
							type :'post',
							dataType : 'json',
							data : 'id=' + id,
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										top.$.jBox.tip('删除成功！','success');
										mgt_util.refreshGrid($("#grid-table"));
									}
								});
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
			<div id="currentDataDiv" action="menu" >
				<div class="currentDataDiv_tit">
					<form class="form form-inline queryForm" style="overflow:hidden;">
		            	<div class="form-group" style="margin-right:10px;padding-left:10px;padding-top:0px;">
			            	<button type="button" class="search_cBox_btn btn btn-info" onclick="addVendorService()">添加</button>
			            	<button type="button" class="search_cBox_btn btn btn-info" onclick="preview()">预览</button>
			            </div>
			         </form>
			    </div>
               	<div class="form_divBox" style="display:block;overflow:inherit;">
               		<form class="form form-inline queryForm" id="query-form">
						<label class="control-label">客服名称</label>
						<div class="form-group">
							<input type="text" class="form-control" name="serviceName" style="width:120px;">
						</div>
						<label class="control-label">状态</label>
						<div class="form-group">
							<select class="form-control required" id="activeFlg" name="activeFlg" style="width:120px;">
								<option value="">全部</option>
								<option value='A'>启用中</option>
								<option value='P'>已停用</option>
							</select>
						</div>
						<label class="control-label">用户名</label>
						<div class="form-group" style="margin-top:11px;">
		                   <select class="form-control required" id="userNo" name="userNo" style="width:120px;">
								<option value="">全部</option>
								[#if users ??]
							         [#list users as user]
				                          <option value='${user.userNo}'>${user.name}</option>
									[/#list]
								[/#if]
							</select>
		                </div>
					</form>
					<div class="search_cBox">
						<button style="margin-top:8px;" type="button" class="btn_divBtn" id="order_search" data-toggle="jBox-query">搜 索 </button>
					</div>
				</div>
						
	        </div>
	      </div>    
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>