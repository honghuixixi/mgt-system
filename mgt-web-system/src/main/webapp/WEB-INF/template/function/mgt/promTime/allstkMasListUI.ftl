<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>查看所有有效的参加限时抢购商品页面</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"P"};
				mgt_util.jqGrid('#grid-table',{
				postData: postData,
					url:'${base}/prom/allstkMasList.jhtml',
					multiselect:false,
 					colNames:['','活动名称','促销起止时间','参与日期','供应商','编码','名称','单位','供应商价格','促销总量','抢购价','客户限购量'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
						{name:'REF_NO',width:'9%'},
						{name:'TIMELONG',width:'9%'},
						{name:'JOINDATE',width:'4%'},
				   		{name:'NAME',width:'7%'},
				   		{name:'STK_C',width:'3%'},
				   		{name:'STK_NAME',width:'10%'},
				   		{name:'UOM',width:'2%'},
				   		{name:'LIST_PRICE',width:'4%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.LIST_PRICE)).toFixed(2);
						}},
				   		{name:'MAX_QTY',width:'3%'},
				   		{name:'PROM_PRICE',width:'3%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.PROM_PRICE)).toFixed(2);
						}},
				   		{name:'SINGLE_CUST_QTY',width:'3%'},
				   	]
				});

				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
 
			function ss(){
				$("#promMasForm").submit();
			}
		</script>		
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<label class="control-label">商品名称或编码</label>
	            		<input type="text" class="form-control input-sm"  name="keyWord">
	            		<a href="#"  id="Promtime_search" data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()"> 关闭</button>
	                </span>
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/promTimeInfo.jhtml" id="promMasForm" method="post">
   		</form>
    </body>
</html>