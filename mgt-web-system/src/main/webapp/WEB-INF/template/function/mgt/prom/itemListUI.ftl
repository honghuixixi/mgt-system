<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
 	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/itemList.jhtml',
					multiselect:false,
 					colNames:['','商品编码','商品名称','规格','单位','商品价格','促销价格','促销数量','单客户限购量','赠品条件','开始时间','结束时间','单据号码','活动名称'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
						{name:'STK_C',width:'6%'},
				   		{name:'STK_C',width:'16%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'MODLE',width:'4%'},
				   		{name:'UOM',width:'4%'},
				   		{name:'NET_PRICE',width:'6%'},
				   		{name:'PROM_PRICES',width:'6%'},
				   		{name:'MAX_QTY',width:'6%'},
				   		{name:'SINGLE_CUST_QTY',width:'8%'},
				   		{name:'BASE_QTY',width:'6%'},
				   		{name:'BEGIN_DATE',width:'8%',formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
							}},
			   		{name:'END_DATE',width:'8%', formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
							}},
				   		{name:'MAS_NO',width:'9%'},
				   		{name:'REF_NO',width:'16%'}
				   	]
				});

				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});

			 
				

			});
 
			
 
					
					
 
					function ss(){
// 					$.jBox.confirm("确认要保存该数据?", "提示", function(v){
// 					if(v == 'ok'){
// 						mgt_util.showMask('正在保存数据，请稍等...');
// 						setTimeout(function () { 
//         					mgt_util.hideMask();
//     					}, 1000);
						
// 					}
// 					});
 
					$("#promMasForm").submit();
					}
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <!-- 搜索条 -->
	            <div class="currentDataDiv_tit"></div>
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<input type="text" class="form-control input-sm required" value="请输入条码或编码名称"  name="nameOrStkc" onFocus="if(value==defaultValue){value='';}">
	            		<a href="#"  data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()" > 关闭</button>
	                </span>
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   <form action="${base}/prom/promInfo.jhtml" id="promMasForm" method="post">
   		</form>
   	 
    </body>
</html>
 


