<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/productlist.jhtml?mergeNo='+${masNo},
					multiselect:false,
 					colNames:['','商品编码','条码','商品名称','单位','数量','发货数量','净价','小计'],
 					rowNum: 1000,
 					cellLayout:0,
				   	colModel:[	
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true}, 
						{name:'STK_C',width:40},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'QTY1', width:40,formatter:function(data,row,rowObject){
				   				var netPrice = rowObject.NET_PRICE;
				   				var stkQty = rowObject.STK_QTY;
						   		tmp = rowObject.STK_QTY;
						   		if (!tmp && typeof(tmp)!="undefined" && tmp!=0){  
						   			tmp = '';
						   		}
								return '<input type="text" class="deliverQty" price="'+netPrice+'" stkQty = "'+stkQty+'" name="qty" pkNo="'+rowObject.PK_NO+'"  value="'+tmp+'">';
							}},
					   	{name:'NET_PRICE', width:40,formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
					   	{name:'SUB', width:40,formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}}
				   	],
				});
				$("input.deliverQty").live("change",function(){
					//alert(1);
					$this = $(this);
					var xiaoji = Number($this.attr('price')) * Number($this.val());
					$this.parent().siblings("[aria-describedby='grid-table_SUB']").html(xiaoji);
				});
			});
			
			function checkForm(){
				var str = "";
				var object = document.getElementsByName("qty");
				 for ( var  i = 0 ;i < object.length;i ++ ){
					if(object[i].value  == ''){
						top.$.jBox.tip('发货数量不能为空');
						return false;
					}
					if(/\D/.test(object[i].value)){
						top.$.jBox.tip('请输入正确数量！');
						return false;
					}
					var stkQty = $(object[i]).attr("stkQty");
					
					if(Number(object[i].value) > Number(stkQty)){
						top.$.jBox.tip('发货数量不能多于当前汇总单数量！');
						return false;
					}
						
					if(i != object.length-1){
						str =str + object[i].getAttribute('pkNo')+","+object[i].value+";";
					}else{
						str =str + object[i].getAttribute('pkNo')+","+object[i].value;
					}
				 }
				$("#masNo").val(${masNo});
				$("#items").val(str);
				 mgt_util.submitForm('#form');
			}
		</script>
    </head>
    <body>
    	<div class="body-container">  
    		<div id="currentDataDiv" action="resource" style="padding:10px 10px 0;">
				<div class="btn-group pull-right">
					<button class="btn btn-danger" data-toggle="jBox-call"
						data-fn="checkForm">
						发货
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
                <div class="form-group">
                    <label class="control-label">商品信息（当前汇总单所包含的商品）</label>
                </div>
	        </div>
	        <div style="clear:both;height:10px;font-size:10px;"></div>
		    <table id="grid-table" >
		    </table>
       		<form class="form-horizontal" id="form" action="${base}/order/deliverorder.jhtml"> 
						<input id="masNo" name="masNo" type="hidden">
						<input id="items" name="items" type="hidden">
				 		    		    
			</form>
   		</div>
    </body>
</html>