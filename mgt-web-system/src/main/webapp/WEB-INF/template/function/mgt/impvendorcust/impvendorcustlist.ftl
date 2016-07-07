<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-客户信息维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
				$("#check").click(function(){
					$.ajax({
						url:"${base}/impvendorcust/check.jhtml",
						async:false,
						success: function(data){
							 $("#grid-table").jqGrid('setGridParam',{  
					            postData:{} //发送数据  
					        }).trigger("reloadGrid"); //重新载入  
					        top.$.jBox.tip('检查完成！', 'success');
						}
					});
				});
				
				$("#exportStk").click(function(){
					$.ajax({
						url:"${base}/impvendorcust/exportvendorcust.jhtml",
						async:false,
						success: function(data){
							 $("#grid-table").jqGrid('setGridParam',{  
					            postData:{} //发送数据  
					        }).trigger("reloadGrid"); //重新载入  
					        top.$.jBox.tip('导入完成！', 'success');
						}
					});
				});
			
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/impvendorcust/vendorcustlist.jhtml',
 					colNames:['','商户编码','客户编码','客户名称','客户类型','地区','电话','类别','业务员','状态','描述','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'VENDOR_CODE',align:"center",width:'6%'},
				   		{name:'USER_NAME',align:"center",width:'4%'},
				   		{name:'NAME',align:"center",width:'9%'},
				   		{name:'CUST_NAME',align:"center",width:'5%'},
				   		{name:'IVC_AREA',align:"center",width:'3%'},
				   		{name:'CRM_TEL',align:"center",width:'4%'},
				   		{name:'CAT_NAME',align:"center",width:'4%'},
				   		{name:'PIC_USER_NAME',align:"center",width:'4%'},
				   		{name:'CHECK_FLG',align:"center",width:'3%',formatter:
				   			function(cellvalue, options, rowObject){
					   			if(cellvalue=='N'){
					   				  return "未检查";
					   			}else if(cellvalue=='Y'){
					   		  		 return "可导入";
					   			}else if(cellvalue=='E'){
					   		  		 return "错误";
					   			}else if(cellvalue=='P'){
					   		  		 return "已导入";
					   			}
					   		}
				   		},
				   		{name:'CHECK_REMARK',align:"center",width:'9%'},
				   		{name:'detail',index:'PK_NO',width:'4%',align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.CHECK_FLG == '未检查' || rowData.CHECK_FLG == '错误'){
								var detail = "&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show'  href='${base}/impvendorcust/editimpvendorcustUI.jhtml'>修改</button>";
								jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
							}
						} 
					} 
				   	
				});
				tabHeight();
			});
			
			$(function($) {
				$(".selectli").click(function(){
					$this = $(this);
					$(".cur").removeClass("cur");
					$this.addClass("cur");
					var id = $this.attr("id");
					
					var checkFlg;
					if(id == 'all'){
						checkFlg = "";
					}else if(id == 'exception'){
						checkFlg = "E";
					}else if(id == 'notImport'){
						checkFlg = "X";
					}else if(id == 'imported'){
						checkFlg = "P";
					}
					$("#grid-table").jqGrid('setGridParam',{
		            	postData:{"checkFlg":checkFlg},
		        	}).trigger('reloadGrid'); 
				});
				
				$(".toUrl").click(function(){
					var grid = $("#grid-table");
	   				var ids = grid.jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请至少选择一条记录！');
						return;
					}
					var url = $(this).attr("url");
					url = url + '?id=' + ids;
					mgt_util.showjBox({
						width : 800,
						height : 500,
						title : $(this).html(),
						url : url,
						grid : grid
					});
				});
				
				$(".toRemove").click(function(){
					var grid = $("#grid-table");
	   				var ids = grid.jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请选择至少一条记录！');
						return;
					}
					var url = $(this).attr("url");
					window.location.href=url+'?ids='+ids;
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="currentDataDiv_tit" style="height:auto;">
					<form class="form form-inline "  id="query-form1">
						<div class="btn-group">
						   <button type="button" class="btn btn-default dropdown-toggle btn_divBtn" 
						      data-toggle="dropdown">
						                   导入导出 <span class="caret"></span>
						   </button>
						   <ul class="dropdown-menu" role="menu">
						      <li><a href="${base}/impvendorcust/exprotvendorcustUI.jhtml" data-toggle="jBox-win">导入excel</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/impvendorcust/exportExcel.jhtml" class="toRemove">导出excel</a></li>
						   </ul>
						</div>
		           <button type="button" id="check" class="btn_divBtn del float_btn"  href="#">检查</button>
		            <button type="button" id="exportStk" class="btn_divBtn del float_btn"  href="#">导入系统</button>
		            <button type="button" class="btn_divBtn edit float_btn"  id="role_modifyScopeToPublic" data-toggle="jBox-remove" 
		            href="${base}/impvendorcust/removes.jhtml">删除 </button>
		            </form>
		            <div style="width:100%;overflow:hidden;">
	           			<ul class="change-ul" style="list-style:none;padding:4px 15px 0 0;float:left;">
    						<li class="selectli cur" style="margin-right:10px;" id="all">全部</li>
    						<li class="selectli " id="exception">异常客户</li>
    						<li class="selectli" id="notImport">未导入客户</li>
    						<li class="selectli" id="imported">已导入客户</li>
  						</ul>
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