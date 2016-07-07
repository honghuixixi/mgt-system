<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/bank/orderList.jhtml',
 					colNames:['','订单编号','订单总金额','订单状态','付款状态','查询流水号','交易金额'],
				   	colModel:[
				  	 	{name:'ID',index:'ID',width:0,hidden:true,hidden:true,key:true},
				   		{name:'MAS_NO',index:'MAS_NO',align:"center",width:70,key:true},
				   		{name:'AMOUNT',index:'AMOUNT',align:"center",width:50,key:true},
				   		{name:'STATUS_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '未发货';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='RETURNSING'){
								return '退单中';
							}else if(data=='SUCCESS'){
								return '交易成功';
							}else if(data=='CLOSE'){
								return '交易关闭';
							}else if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='WAITPAYMENT'){
								return '待支付';
							}else {
								return "";
							}
	   					}},
				   		{name:'PAY_STATUS',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='WAITPAYMENT'){
								return '未支付';
							}else if(data=='PAID'){
								return '已支付';
							}else if(data=='PAYMENTPROCESS'){
								return '支付中（部分付款）';
							}else if(data=='REFUNDMENT'){
								return '已退款';
							}else{
							return "";}
	   					}},
				   		{name:'QUERYID',index:'QUERYID',align:"center",width:60,key:true},
				   		{name:'TXNAMT',index:'TXNAMT',align:"center",width:50,key:true,formatter:function(data){
				   		       if(data==null){
				   		          return "";
				   		       }else{
				   		           return((data.replace(/\b(0+)/gi,"")*0.01).toFixed(2));
				   		       }
				   		      
							}}
				   		
				   		
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						
					}
				   	
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden" id="query-form">      
	                <div id="finishSt" class="" style="padding-top:0px;">
						<div class="form-group" id="custCodesDiv">
						<label class="control-label" style="padding-right:5px;">订单支付时间</label>
	                	<input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" >
						</div>
						<button type="button" class="btn btn-info" data-toggle="jBox-query" ><i class="icon-search"></i> 搜索</button>
						<button type="button" class="btn btn-info" id="updatByHand" onclick="down()" > 手动更新</button>
					</div>
	            </form>
	        </div>     
		    <table id="grid-table" >
		    </table>
		    <div id="grid-pager"></div>
   		</div>
    </body>
    
    <script>
function down(){
	$.jBox.confirm("确认手动下载吗?", "提示", function(v){
	if(v == 'ok'){
	 	$.ajax({
		    url: '${base}/bank/downOrder.jhtml',
			method:'post',
			dataType:'json',
			data:$("#query-form").serializeObjectForm(),
			sync:false,
			error : function(data) {
			alert("网络异常");
			return false;},
			success : function(data) {
			if(data.code==001){		
				top.$.jBox.tip('下载成功！', 'success');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				}
				else{
				top.$.jBox.tip('下载失败！', 'error');
				mgt_util.closejBox('jbox-win');
						return false;
				}
			}
		});	
	}});
}
    	
    
    
    </script>
    
</html>