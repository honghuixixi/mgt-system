<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={pkNo:${pkNo},masCode:"${masCode}",vendorCode:"${vendorCode}"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/itemListQuery.jhtml',
 					colNames:['商品编码','条码','商品名称','单位','待发货数量','发货量'],
 					multiselect:false,
 					rowNum:1000,
				   	colModel:[	 
						{name:'STK_C',index:'STK_C',width:50,hidden:false,key:true},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'QTY1', width:40,formatter:function(data,row,rowObject){
						   		//默认单据商品数量
						   		stkQty = rowObject.STK_QTY;
						   		if (!stkQty && typeof(stkQty)!="undefined" && stkQty!=0){  
						   			stkQty = '';
						   		}
								return '<input type="text" class="deliverQty" stkQty="'+stkQty+'" name="qty" pkNo="'+rowObject.STK_C+'"  value="'+stkQty+'">';
							}},
				   	],
				  });
			});
			
			//检查填写数量是否空，且为数字	
			function checkForm(){
				var str = "";
				var object = document.getElementsByName("qty");
				 for ( var  i = 0 ;i < object.length;i ++ ){
					//实际填写数量
				 	var stkQty = $(object[i]).attr('stkQty');
				 	
					if(object[i].value == 0){
						top.$.jBox.tip('商品数量不能为空');
						return false;
					}
					//数值验证
					if(/\D/.test(object[i].value)){
						top.$.jBox.tip('请输入正确数量！');
						return false;
					}	
					//数值非0开头
//					if(/[1-9][0-9]{0,5}/ig.test(object[i].value)){
//						top.$.jBox.tip('数值不能以0开始！');
//						return false;
//					}
					//数值位数10位	
					if(object[i].value.match(/\d/g).length>10){
						top.$.jBox.tip('输入数量值过大,超过10 位！');
						return false;
					}	
					if(Number(object[i].value) > Number(stkQty)){
						top.$.jBox.tip('发货数量不能大于订单数量');
						return false;
					}
					if(i != object.length-1){
						str =str + object[i].getAttribute('pkNo')+","+object[i].value+";";
					}else{
						str =str + object[i].getAttribute('pkNo')+","+object[i].value;
					}
				 }
				$("#pkNo").val(${pkNo});
				$("#items").val(str);
				mgt_util.submitForm('#form');
			}	
		</script>
    </head>
    <body>
       <div class="body-container">
		    <table id="grid-table" >
		    </table>
       		<form class="form-horizontal" id="form" action="${base}/warehouse/deliverReceive.jhtml"> 
				<input id="pkNo" name="pkNo" type="hidden">
				<input id="items" name="items" type="hidden">
				<input id="masCode" name="masCode" type="hidden" value=${masCode}>
				<input id="vendorCode" name="vendorCode" type="hidden" value=${vendorCode}>
				<input id="whC" name="whC" type="hidden" value=${whC}>
				<input id="statusFlg" name="statusFlg" type="hidden" value=${statusFlg}>
				<div class="btn-group pull-right">
					<div class="btn-group">
						<button id="addStk" class="btn btn-danger" data-toggle="jBox-call"
							data-fn="checkForm">
							确认
						</button>
					</div>
				</div>	        		    		    
			</form>
   		</div>
    </body>
</html>