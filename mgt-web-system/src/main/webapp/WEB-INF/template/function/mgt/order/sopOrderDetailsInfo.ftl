<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>确认客户收货结果</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			//差异金额
			var chayi = 0;
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/sopDetailsList.jhtml?pkNo=${pkNo}',
					multiselect: false,
 					colNames:['','','','商品','商品名称','单位','订单数量','发货数量','收货数量','抹零/扣减','差异类型','说明','金额小计'],
 					rowNum:2147483647,
 					width:838,
 					autowidth: false,  
		            shrinkToFit: true,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'NET_PRICE',width:0,hidden:true,key:true},
				   		{name:'MAS_PK_NO',width:0,hidden:true,key:true},
				   		{name:'STK_C',align:"center",width:70},
				   		{name:'STK_NAME',align:"center",width:70},
				   		{name:'UOM',align:"center",width:30,},
				   		{name:'UOM_QTY',align:"center",width:50,},
				   		{name:'QTY1',align:"center",width:50},
				   		{name:'SJQTY',align:"center",width:50,editable: true,
				   			formatter:function(cellvalue, options, rowObject){
								return "<input type='text' id='qty2"+options.rowId+"' value='"+cellvalue+"'  onBlur=s1('"+options.rowId+"',this) >";
				   			}
				   		},
				   		{name:'DIFF_MISC_AMT',align:"center",width:60,editable: true,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue==null){
				   					cellvalue=0
				   				}
								return "<input type='text' id='dma"+options.rowId+"' value='"+cellvalue+"' onBlur=s2('"+options.rowId+"',this) >";
				   			}},
				   		{name:'ODR_CODE',align:"center",width:60,},
				   		{name:'DIFF_REMARK',align:"center",width:80,editable: true,
				   			formatter:function(cellvalue, options, rowObject){
								return "<input type='text' id='dr"+options.rowId+"'  onBlur=s3('"+options.rowId+"',this) maxlength=80>";
				   			}},
				   		{name:'detail',align:"center",width:80,
				   			formatter:function(cellvalue, options, rowObject){
				   				var detail= Number(rowObject.SJQTY)*Number(rowObject.NET_PRICE)
				   				if(isNaN(detail)){
            						detail=cellvalue;
            					}
								return detail;
				   			}},
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						var num = 0;
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							num =num+Number(rowData.detail);
							
							ODR_CODE="<select type='select' id='sel"+id+"' class='catcname'> <option value='' >无</option>"
							[#if list?exists && list?size>0]
							[#list list as odr]
								ODR_CODE= ODR_CODE+"<option value='${odr.ODR_CODE}'";
								if(rowData.ODR_CODE == '${odr.ODR_CODE}'){
									ODR_CODE= ODR_CODE+ "selected";
								}
								ODR_CODE= ODR_CODE+">${odr.ODR_DESC}</option>";
							[/#list]
						    [/#if]
							ODR_CODE= ODR_CODE+"<select>";
							jQuery("#grid-table").jqGrid('setRowData', id, { ODR_CODE: ODR_CODE}); 
						} 
						numAll(num.toFixed(2));
					}
				});
				
			});
			
			
			
			function s1(s,ss){
				var rowData = $('#grid-table').jqGrid('getRowData',s);
				//var uomQty=rowData.UOM_QTY;
				var uomQty=rowData.QTY1;
				var dma = $('#dma'+rowData.PK_NO).val()
				var netPrice = rowData.NET_PRICE;
				var qty2 = ss.value;
				var regu = "^[0-9]+$";
				var re = new RegExp(regu);
				$("#flg").val("Y");
				if(Number(qty2)>Number(uomQty)){
					alert("实际收货数量大于订单数量，请确认!")
					$('#qty2'+rowData.PK_NO).val(uomQty)
					return false;
				}
				if (qty2.search(re) != -1) {
					
				} else {
					top.$.jBox.tip('请输入正确');
					$('#qty2'+rowData.PK_NO).val(1)
					$("#flg").val("N");
					return false;
				}
				if(isNaN(Number(qty2))){
            		qty2=0;
            	}
				if(isNaN(Number(netPrice))){
            		netPrice=0;
            	}
				var detail = Number(qty2)*Number(netPrice)-Number(dma);
				chayi = chayi+Number(dma);
				$("#grid-table").jqGrid("setRowData",s,{"detail":detail.toFixed(2)}); 
				total()
			}
			
			function s2(s,ss){
				var rowData = $('#grid-table').jqGrid('getRowData',s);
				var dma =  ss.value;
				var netPrice = rowData.NET_PRICE;
				var qty2 =$('#qty2'+rowData.PK_NO).val()
				$("#flg").val("Y");
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(dma)){
					top.$.jBox.tip('请输入正确');
					$('#dma'+rowData.PK_NO).val(0)
					$("#flg").val("N");
					return;
				}
				if(Number(dma) > Number(netPrice)){
            		top.$.jBox.tip('扣减金额不可大于等于商品单价!');
					$('#dma'+rowData.PK_NO).val(0)
					$("#flg").val("N");
					return;
            	}
				
				if(isNaN(Number(netPrice))){
            		netPrice=0;
            	}
				
            	if(isNaN(Number(qty2))){
            		qty2=0;
            	}
				var detail = Number(qty2)*Number(netPrice)-Number(dma);
				chayi = chayi+Number(dma);
				$("#grid-table").jqGrid("setRowData",s,{"detail":detail.toFixed(2)}); 
				total()
			}
			
        	function saveRows() {
            	var grid = $("#grid-table");
            	var ids = grid.jqGrid('getDataIDs');
            	var miscPayAmt =$("#miscPayAmt").val();
            	var amount =$("#amount").val();
            	var cpValue =$("#cpValue").val();
				var p1="[";
				var masPkNo;
				var diffRemark="";
				if($("#flg").val()=='N'){
					top.$.jBox.tip('输入数据有误，不能确认');
					$("#flg").val('Y');
					return false;
				}
				

				if(Number($("#numAmount").val())==0 || Number($("#numAmount").val())>Number(cpValue)){
					for (var i = 0; i < ids.length; i++) {
            			var rowData = $('#grid-table').jqGrid('getRowData',ids[i]);
                		var p2 = "{qty2:"+$('#qty2'+rowData.PK_NO).val()+",diffMiscAmt:"+$('#dma'+rowData.PK_NO).val()+",diffRemark:'"+$('#dr'+rowData.PK_NO).val()+"',pkNo:"+rowData.PK_NO+",odrCode:'"+$('#sel'+rowData.PK_NO).val()+"'}";
            			p1+=p2;
            			if(i!=ids.length-1){
            				p1+=","
            			}else{
            				p1+="]"
            			}
            			masPkNo=rowData.MAS_PK_NO;
            		}
            		$.ajax({
            			url:'${base}/order/sopDetailsUpdate.jhtml',
            			type : 'post',
						dataType : 'json',
						data:{data:p1,id:masPkNo,amount:$("#amount").val(),num:$("#num").val()},
						error : function(data) {
								alert("网络异常");
								return false;
							},
						success : function(data) {
							if(data.code==2){ 
								top.$.jBox.tip('该订单已绑定物流人员！','error');
							}else{
								top.$.jBox.tip('成功完成订单！','success');
								top.$.jBox.close();
								mgt_util.refreshGrid("#grid-table");
							}
						}
            		});
				}else{
					top.$.jBox.tip('由于收货金额小于优惠券金额，无法收货。');
					return false;
				}
        	}
        	
        	function total(){
        		var grid = $("#grid-table");
            	var ids = grid.jqGrid('getDataIDs');
            	var cpValue =$("#cpValue").val();
            	var num=0;
            	for (var i = 0; i < ids.length; i++) {
            		var rowData = $('#grid-table').jqGrid('getRowData',ids[i]);
            		if(rowData.detail==""){
            			rowData.detail=0
            		}
            		if(isNaN(rowData.detail)){
            			rowData.detail=0;
            		}
            		num = Number(num)+Number(rowData.detail);
            	}
            	
            	numAll(num.toFixed(2))
        	}
        	
        	function numAll(num){
        		var amount = $("#amount").val();
        		var miscPayAmt =$("#miscPayAmt").val();
        		var freight =$("#freight").val();
        		var diffMiscAmt = chayi;
        		var cpValue =$("#cpValue").val();
        		
        		if(miscPayAmt=="" || miscPayAmt ==null){
        			miscPayAmt=0
        		}
        		if(freight=="" || freight ==null){
        			freight=0
        		}
        		if(diffMiscAmt=="" || diffMiscAmt ==null){
        			diffMiscAmt=0
        		}
        		//订单+运费
        		var numAmount=Number(amount)+Number(freight);
        		//优惠金额
        		var numMiscPayAmt=Number(miscPayAmt);
        		//差异金额
        		var numDiffMiscAmt=Number(diffMiscAmt);
        		//实际金额
        		var numAll=Number(num)-Number(miscPayAmt)+Number(freight);
        		
        		$("#num").val(Number(num).toFixed(2));//不包含运费、优惠券
        		$("#numAmount").val(numAmount.toFixed(2));//不包含优惠卷金额
        		
        		$("#total1").html(numAmount.toFixed(2));
        		$("#total2").html(numMiscPayAmt.toFixed(2));
        		$("#total3").html(numDiffMiscAmt.toFixed(2));
        		$("#total").html(numAll.toFixed(2));
        		
        	}
        	
        	top.$.jBox.refresh = true;
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="menu" >
			 		 <input type="hidden" id="cpValue" value="${cpValue}"/>
	                 <input type="hidden" id="miscPayAmt" value="${miscPayAmt}"/>
	                 <input type="hidden" id="freight" value="${freight}"/>
	                 <input type="hidden" id="amount" value="${amount}"/>
	                 <input type="hidden" type="numAmount" id="numAmount"/>
	                 <input type="hidden" type="num" id="num"/>
	                 <input type="hidden" id="flg" value="Y"/>
	                <div id="finishSt" class="" style="padding-top:5px; text-align:left;padding-right:20px;">
						订单金额：<span id="total1"></span>&nbsp;&nbsp;&nbsp;&nbsp;优惠金额：<span id="total2"></span>&nbsp;&nbsp;&nbsp;&nbsp;差异金额：<span id="total3">
						</span>&nbsp;&nbsp;&nbsp;&nbsp;实收金额：<span id="total"></span></span>&nbsp;&nbsp;&nbsp;&nbsp;
						<button type="button" class="btn_divBtn" onclick="saveRows()" >确认 </button>
					</div>
			    </button>
	        </div>     
		    <table id="grid-table" >
   		</div>    </body>
</html>