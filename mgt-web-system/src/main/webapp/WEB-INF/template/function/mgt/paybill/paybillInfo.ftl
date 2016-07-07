<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>财务管理-电子账单</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>		
		<script  type="text/javascript">
			$(document).ready(function(){
			var userName='${userName}';
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/paybill/list.jhtml',
 					colNames:['','创建时间','交易分类','名称','批次号','对方','交易身份','交易金额','交易状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CREATE_TIME',align:"center",width:250,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                        },
				   		{name:'TRAN_TYPE',align:"center",width:'220',
				   		editable:true,formatter:function(data){
							if(data=='9001'){
								return '第三方支付平台收款';
							}else if(data=='9002'){
								return '资金归集';
							}else if(data=='9003'){
								return '批量代付';
							}else{
								return '';
							}
	   					}
				   		},
				   		{name:'TRAN_NOTE',align:"center",width:180},
				   		{name:'BATCHID',align:"center",width:300},
				   		{name:'',align:"center",width:140,formatter:function(value,row,index){
				   		if(userName==index.PAYERCUST_ID){
				   		return index.PAYEECUST_NAME;
				   		}else{
				   		return index.PAYERCUST_NAME;
				   		}
				   		}},
				   		{name:'PAYERCUST_ID',align:"center",width:140,formatter:function(value,row,index){
				   		if(userName==index.PAYERCUST_ID){
				   		return '支出';
				   		}else{
				   		return '收入';
				   		}
				   		}},
				   		{name:'TRANAMOUNT',align:"center",width:110},
				   		{name:'STATE',align:"center",width:'130',
				   		editable:true,formatter:function(data){
							if(data=='10'){
								return '未支付';
							}else if(data=='00'){
								return '待支付';
							}else if(data=='01'){
								return '支付中';
							}else if(data=='02'){
								return '支付成功';
							}else if(data=='03'){
								return '支付失败';
							}
	   					}
				   		},
				   		{name:'detail',index:'PK_NO',width:130,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
				   		
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.PAYERCUST_ID=='收入'){
							detail ="<button type='input' name='"+rowData.TRANAMOUNT+"' class='btn btn-info edit shouru' id='"+rowData.BATCHID+"' data-toggle='jBox-show' href='${base}/paybill/paybillDetailUI.jhtml'>详情</button>";
							}else{
							detail ="<button type='input' name='"+rowData.TRANAMOUNT+"' class='btn btn-info edit zhichu' id='"+rowData.BATCHID+"' data-toggle='jBox-show' href='${base}/paybill/paybillDetailUI.jhtml'>详情</button>";
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
				init_h();
				alert(111);
				
				
			});
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="currentDataDiv_tit">
				    <div class="form-group"  >
                    	<button type='button' class='btn_divBtn edit' id="user_edit_dept">统计金额</button>
                    </div>
                    <span class="open_btn"></span>
				</div>
				<div class="form_divBox">
		            <form class="form form-inline queryForm" id="query-form">
						<div class="form-group">
							<label class="control-label">交易时间:</label>
							<input type="text" class="form-control" id="startDate" name="startDate" style="width:95px;" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
						</div>
						<div class="form-group">
							<span class="control-label" style="color:#6c6c6c;padding-right:10px;vertical-align:middle;">至</span>
							<input type="text" class="form-control" id="endDate" name="endDate" style="width:95px;" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
						</div>
						<div class="form-group" style="margin-left:50px;">
		                    <label class="control-label">交易状态:</label>
		                    <select class="form-control" name="state">
		                        <option value="">全部状态</option>
		                        <option value="10">未支付</option>
		                        <option value="00">待支付</option>
		                        <option value="01">支付中</option>
		                        <option value="02">支付成功</option>
		                        <option value="03">支付失败</option>
		                    </select>
	                    </div>
	                    <div class="form-group" >
		                    <label class="control-label">交易分类:</label>
		                    <select class="form-control" name="tranType" style="width:95px;">
		                        <option value="">全部</option>
		                        [#list tranType as type]
		                        <option value="${type.CODE}">${type.NAME}</option>
		                        [/#list]
		                    </select>
	                    </div>
	                    </br>
	                    <div class="form-group">
							<label class="control-label">金额范围:</label>
							<input type="text" class="form-control" name="minMoney" style="width:95px;" />
						</div>
						<div class="form-group">
							<span class="control-label" style="color:#6c6c6c;padding-right:10px;vertical-align:middle;">至</span>
							<input type="text" class="form-control" name="maxMoney" style="width:95px;" />
						</div>
						<div class="form-group" style="margin-left:50px;">
	                    	<label class="control-label">资金流向:</label>
		                    <select class="form-control" name="tradeType" style="width:91px;">
		                        <option value="">全部</option>
		                        <option value="1">收入</option>
		                        <option value="2">支出</option>
		                    </select>
	                    </div>
	                    <div class="search_cBox">
		                    <div class="form-group"  >
		                    	<button type="button" class="search_cBox_btn" id="order_search" data-toggle="jBox-query">搜 索 </button>
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
    
<script type="text/javascript">
	$("#user_edit_dept").click(function(){
	var sum = 0;
	var sums = 0;
	$(".shouru").each(function(){
	var value = $(this).attr("name");
	sum+=parseFloat(value);
	});
	$(".zhichu").each(function(){
	var values = $(this).attr("name");
	sums+=parseFloat(values);
	});
	$.jBox("<div style='height:30px;'>&nbsp;</div><center><h4 >收入："+sum.toFixed(2)+"&nbsp;&nbsp;&nbsp;  支出："+sums.toFixed(2)+"</h4></center>",{title: "统计金额",
    width: 320,
    height: 160,
	}); 
});
</script>
</html>