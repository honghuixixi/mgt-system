<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>物流管理-客户收货结果调整</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/logistics/adjustList.jhtml',
 					colNames:['','','','','','订单号','状态','客户','配送员','订单金额','单据时间','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CN',width:0,hidden:true,key:true},
				   		{name:'CN2',width:0,hidden:true,key:true},
				   		{name:'CN3',width:0,hidden:true,key:true},
				   		{name:'CN4',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:70},
				   		{name:'STATUS_FLG',align:"center",width:30,
				   			editable:true,formatter:function(data){
								if(data=='DELIVERED'){
									return '发货中';
								}else if(data=='SUCCESS'){
									return '交易成功';
								}
				   			}
				   		},
				   		{name:'CUST_NAME',align:"center",width:70},
				   		{name:'NAME',align:"center",width:40},
				   		{name:'AMOUNT',align:"center",width:40},
				   		{name:'CREATE_DATE',align:"center",width:80,formatter : function(data){
                            if(!isNaN(data) && data){
                            	data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                         },
                         {name:'detail',width:50,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show'  href='${base}/logistics/detailsInfo.jhtml'>调整</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail });
						} 
					}
					
				});
				
				//table数据高度计算
				tabHeight();
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
	                <div id="finishSt" class="" style="padding-top:0px;">
						<div class="form-group" id="custCodesDiv">
						<label class="control-label">订单号</label>
						<input type="text" class="form-control digits" id="masNo"  name="masNo" style="width:120px;" maxlength=32 />
						<label class="control-label">配送员</label>
						<input type="text" class="form-control digits" id="logisticsName"  name="logisticsName" style="width:120px;" maxlength=32 />
						<label class="control-label" style="padding-right:5px;">创建时间从</label>
	                	<input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
	                	<label class="control-label">到</label>
	                	<input type="text" class="form-control" name="endDate" id="endDate" style="width:120px;" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
						</div>
					</div>
	            </form>
	        </div>
	      </div>   
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
</html>