<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>物流管理-重新分配订单</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={allotre:"Y",orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/logistics/allotList.jhtml',
 					colNames:['','','','','','线路','订单号','状态','客户','订单金额','单据时间','操作','备注'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CN',width:0,hidden:true,key:true},
				   		{name:'CN2',width:0,hidden:true,key:true},
				   		{name:'CN3',width:0,hidden:true,key:true},
				   		{name:'CN4',width:0,hidden:true,key:true},
				   		{name:'ROUTE_NAME',align:"center",width:'30'},
				   		{name:'MAS_NO',align:"center",width:80},
				   		{name:'STATUS_FLG',align:"center",width:40,
				   			editable:true,formatter:function(data){
								if(data=='DELIVERED'){
									return '发货中';
								}
				   			}
				   		},
				   		{name:'CUST_NAME',align:"center",width:80},
				   		{name:'AMOUNT',align:"center",width:50},
				   		{name:'CREATE_DATE',align:"center",width:60,formatter : function(data){
                            if(!isNaN(data) && data){
                            	data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                         },
				   		{name:'detail',width:40,align:'center',sortable:false},
				   		{name:'remark',width:50,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.CN2<0){
								detail ="错误数据";
								remark ="订单金额错误";
							}else if(rowData.CN3>0){
								detail ="错误数据";
								remark ="出库数量为0"
							}else if(rowData.CN4>0){
								detail ="";
								remark ="用户提交订单数量和出库数量不同"
							}else{
								remark =""
								detail ="";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail });
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { remark: remark });
							
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						} 
						
					}
				   	
				});
			});
			function orderUpdate(){
				var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				if(ids.length<=0){
					top.$.jBox.tip('请选择数据！', 'error');
					return false;
				}
				 $.jBox.confirm("确认撤销吗?", "提示", function(v){
			 		if(v == 'ok'){
			 			$.ajax({
						url:'${base}/logistics/userUpdate.jhtml?ids='+ids,
						sync:false,
						type : 'post',
						dataType : "json",
						data :{
							'logisticUserCode':''
						},
						error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
							$('#grid-table').trigger("reloadGrid");
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
					<button type="button" class="btn_divBtn"  onclick="orderUpdate()" ><i class="btn_info_icon btn_icon1"></i>撤销分配 </button>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
		                <div id="finishSt" class="" style="padding-top:0px;">
							<div class="form-group" id="custCodesDiv">
								<label class="control-label" style="padding-right:5px;">线路</label>
								<select class="form-control " id="routeCode" name="routeCode" style="width:120px;">
									<option value="">请选择</option>
									[#if routeList?exists] 
										[#list routeList as route]
											<option value="${route.ROUTE_CODE}">${route.ROUTE_NAME}</option>
										[/#list]
									[/#if]
								</select>
								<label class="control-label">订单号</label>
								<input type="text" class="form-control digits" id="masNo"  name="masNo" maxlength=32 />
								<label class="control-label" style="padding-right:5px;">创建时间从</label>
			                	<input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
			                	<span class="control-label">~</span>
			                	<input type="text" class="form-control" name="endDate" id="endDate" style="width:120px;" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >						
							</div>
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" data-toggle="jBox-query" >搜 索</button>
							<button type="button" class="search_cBox_btn" data-toggle="jBox-query" >清 空</button>
						</div>
		            </form>
		       	</div>
		       	<div style="clear:both;"></div>
	        </div>
	      </div>  
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>