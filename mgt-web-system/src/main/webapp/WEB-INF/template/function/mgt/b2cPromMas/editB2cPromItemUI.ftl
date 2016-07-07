<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promitemLists={};
		var promPriceLists={};
		var settlePriceLists={};
		var maxQtyLists={};
		var maxCountQtyLists={};
		var singleCustQtyLists={};
		[#list promItemList as promitem] 
		promitemLists['${promitem.STK_C}']='${promitem.MAS_PK_NO}';
		promPriceLists['${promitem.STK_C}']='${promitem.PROM_PRICE}';
		settlePriceLists['${promitem.STK_C}']='${promitem.SETTLE_PRICE}';
		maxQtyLists['${promitem.STK_C}']='${promitem.MAX_QTY}';
		maxCountQtyLists['${promitem.STK_C}']='${promitem.MAX_CUST_COUNT}';
		singleCustQtyLists['${promitem.STK_C}']='${promitem.MAX_CUST_QTY}';
		 [/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/b2cPromMas/masList.jhtml?pkNo=${pkNo}&selectType='+$("#selectTypeVal").val(),
					multiselect:false,
 					colNames:['','','商品名称','商品编码','商品价格','单位','促销价格','结算价','促销数量','单个客户可购买量','单个客户可购买次数'],
				   	colModel:[	 
				   	{name:'',width:20,formatter:function(value,row,rowObject){
					   			if(null!=promitemLists[rowObject.STK_C]){
							return '<input type="checkbox"  id="promCheckBox'+rowObject.STK_C+'" value="'+rowObject.STK_C+'" onclick="addPromItem(this)" checked=checked>';
						   			}else{
							return '<input type="checkbox"  id="promCheckBox'+rowObject.STK_C+'" value="'+rowObject.STK_C+'" onclick="addPromItem(this)" >';

							   			}
						   		}},
						{name:'STK_C',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:200},
						{name:'STK_C',width:100},
				   		{name:'LIST_PRICE', width:100},
				   		{name:'UOM', width:80},
				   		{name:'STK_C', width:120,formatter:function(data,row,rowObject){
				   			if(null!=promPriceLists[rowObject.STK_C]&&promPriceLists[rowObject.STK_C]!=undefined){
					 		return '<input type="text" id="promPrice'+data+'"  onBlur=checkPrice(this) value="'+promPriceLists[rowObject.STK_C]+'">';
				   			}else{
					 		return '<input type="text" id="promPrice'+data+'"  onBlur=checkPrice(this) >';
				   			}
					 		}},
					 	{name:'STK_C', width:120,formatter:function(data,row,rowObject){
				   			if(null!=settlePriceLists[rowObject.STK_C]&&settlePriceLists[rowObject.STK_C]!=undefined){
					 		return '<input type="text" id="settlePrice'+data+'"  onBlur=checkPrice(this) value="'+settlePriceLists[rowObject.STK_C]+'">';
				   			}else{
					 		return '<input type="text" id="settlePrice'+data+'"  onBlur=checkPrice(this) >';
				   			}
					 		}},
				   		{name:'STK_C', width:120,formatter:function(data,row,rowObject){
				   				if(null!=maxQtyLists[rowObject.STK_C]&maxQtyLists[rowObject.STK_C]!=undefined){
									return '<input type="text" id="maxQty'+data+'"   onkeyup=digitalVerification(this) value="'+maxQtyLists[rowObject.STK_C]+'">';
				   				}else{
									return '<input type="text" id="maxQty'+data+'"   onkeyup=digitalVerification(this)>';
				   				}
								}},
						{name:'STK_C', width:160,formatter:function(data,row,rowObject){
				   				if(null!=singleCustQtyLists[rowObject.STK_C]&singleCustQtyLists[rowObject.STK_C]!=undefined){
									return '<input type="text" id="singleCustQty'+data+'"   onkeyup=digitalVerification(this) value="'+singleCustQtyLists[rowObject.STK_C]+'">';
				   				}else{
									return '<input type="text" id="singleCustQty'+data+'"   onkeyup=digitalVerification(this)>';
				   				}
								}},
				   		{name:'STK_C', width:160,formatter:function(data,row,rowObject){
					   		if(null!=maxCountQtyLists[rowObject.STK_C]&maxCountQtyLists[rowObject.STK_C]!=undefined){
									return '<input type="text" id="maxCountQty'+data+'"   onkeyup=digitalVerification(this)   onBlur=addPromCheckBox('+data+')  value="'+maxCountQtyLists[rowObject.STK_C]+'">';
					   		}else{
									return '<input type="text" id="maxCountQty'+data+'"   onkeyup=digitalVerification(this)   onBlur=addPromCheckBox('+data+') >';
					   		}
								}}
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
			
					function digitalVerification(obj){
			if(/\D/.test(obj.value)){
			top.$.jBox.tip('只能输入数字！');
			obj.value=1;
			}
			}
			
			function addPromCheckBox(obj){
						setTimeout(function(){
			$("#promCheckBox"+obj).attr('checked',true);
			var promCheckBox = document.getElementById("promCheckBox"+obj);
			 addPromItem(promCheckBox);
						},1000);
			
			}
				function addPromItem(obj){
					var promPrice = $("#promPrice"+obj.value).val();
					var settlePrice = $("#settlePrice"+obj.value).val();
					var	maxQty = $("#maxQty"+obj.value).val();
					var	singleCustQty = $("#singleCustQty"+obj.value).val();
					var maxCountQty = $("#maxCountQty"+obj.value).val();
					if(null==promPrice||''==promPrice){
					top.$.jBox.tip('请输入促销金额！');
					obj.checked=false;
					return;
					} 
					else if(null==settlePrice||''==settlePrice){
					top.$.jBox.tip('请输入结算价！');
					obj.checked=false;
					return;
					}   
					else if(null==maxQty||''==maxQty){
					top.$.jBox.tip('请输入促销数量！');
					obj.checked=false;
					return;
					}  
					else if(null==singleCustQty||''==singleCustQty){
					top.$.jBox.tip('请输入单个客户可购买数量！');
					obj.checked=false;
					return;
					}else if(null==maxCountQty||''==maxCountQty){
					top.$.jBox.tip('请输入单个客户可购买次数！');
					obj.checked=false;
					return;
					}else if(parseInt(singleCustQty)>parseInt(maxQty)){
					top.$.jBox.tip('单个客户购买数量不能大于促销总数！');
					obj.checked=false;
					return;
					}  
					
					else{
					$.ajax({
						url:'${base}/b2cPromMas/addMasList.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							stkC : obj.value,
							addFlag: obj.checked,
							maxQty: $("#maxQty"+obj.value).val(),
							promPrice: $("#promPrice"+obj.value).val(),
							settlePrice: $("#settlePrice"+obj.value).val(),
							singleCustQty: $("#singleCustQty"+obj.value).val(),
							maxCountQty: $("#maxCountQty"+obj.value).val(),
							pkNo : '${pkNo}'
							},
						success : function(data) { 
								if(data.code == '002'){
									top.$.jBox.tip('该商品已加入其他促销活动,添加失败！','error');
								}else{
									top.$.jBox.tip('编辑商品成功！','success');
									var promItemArrays=data.data;
									promitemLists={};
									promPriceLists={};
									settlePriceLists={};
									maxQtyLists={};
									singleCustQtyLists={};
									maxCountQtyLists={};
								for(var i=0;i<promItemArrays.length;i++){
									promitemLists[promItemArrays[i].STK_C]=promItemArrays[i].MAS_PK_NO;
									promPriceLists[promItemArrays[i].STK_C]=promItemArrays[i].PROM_PRICE;
									settlePriceLists[promItemArrays[i].STK_C]=promItemArrays[i].SETTLE_PRICE;
									maxQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].MAX_QTY;
									singleCustQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].MAX_CUST_QTY;
									maxCountQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].MAX_CUST_COUNT;
									}
								
								}
								
						}
			});
					
					}}
					
					
					function checkPrice(obj){ 
						if(null==obj){
							return;
						}else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
							top.$.jBox.tip('请输入正确');
							obj.value=1;
						}else{
						 	obj.value=formatCurrency(obj.value);
						}
					}
 
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="resource" style="position:relative;padding:10px 0;">
				 <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form">
		            	<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1" >
		                <div class="form-group">
		                    <label class="control-label">商品名称</label>
		                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">商品编码</label>
		                    <input type="text" class="form-control" name="stkc" id="stkc" style="width:120px;" >
		                </div>
		            </form>
	            </div>
	            <div class="search_cBox">
	              <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id='search_b2cstk' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索</button>
	                 	<button type="button" class="search_cBox_btn" id='searchAddB2CProm' data-toggle="jBox-query-prom-mas"  ><i class="icon-search"></i> <span id="sreachFlagSpan">添加商品</span> </button>
	                 	
	                </div>
	            </div>
	        </div>
	        <div style="clear:both;"></div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
  	
   		</div>
    </body>
</html>
 



