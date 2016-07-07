<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promitemLists={};
		var promPriceLists={};
		var maxQtyLists={};
		var singleCustQtyLists={};
		var baseQtyLists={};
		[#list promItemList as promitem] 
		promitemLists['${promitem.STK_C}']='${promitem.PK_NO}';
		promPriceLists['${promitem.STK_C}']='${promitem.PROM_PRICE}';
		maxQtyLists['${promitem.STK_C}']='${promitem.MAX_QTY}';
		singleCustQtyLists['${promitem.STK_C}']='${promitem.SINGLE_CUST_QTY}';
		baseQtyLists['${promitem.STK_C}']='${promitem.BASE_QTY}';
		
		 [/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/masList.jhtml?pkNo=${pkNo}&selectType='+$("#selectTypeVal").val(),
					multiselect:false,
 					colNames:['','商品名称','规格','商品编码','商品价格','单位','供应商','促销价格','促销数量','单个客户可购买量','赠品条件','操作'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
				   		{name:'NAME',width:'20%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'MODLE',width:'4%'},
						{name:'STK_C',width:'8%'},
				   		{name:'NET_PRICE',width:'6%'},
				   		{name:'UOM',width:'3%'},
				   		{name:'OLD_CODE',width:'8%'},
				   		{name:'STK_C',width:'6%', formatter:function(data,row,rowObject){
				   			if(null!=promPriceLists[rowObject.STK_C]&&promPriceLists[rowObject.STK_C]!=undefined){
					 		return '<input type="hidden" id="promPrice'+data+'"  value="'+promPriceLists[rowObject.STK_C]+'">'+promPriceLists[rowObject.STK_C];
				   			}else{
					 		return '<input type="text" id="promPrice'+data+'"  onBlur=checkPrice(this) >';
				   			}
					 		}},
				   		{name:'STK_C',width:'6%', formatter:function(data,row,rowObject){
				   				if(null!=maxQtyLists[rowObject.STK_C]&maxQtyLists[rowObject.STK_C]!=undefined){
								return '<input type="hidden" id="maxQty'+data+'"   value="'+maxQtyLists[rowObject.STK_C]+'">'+maxQtyLists[rowObject.STK_C];
						   				}else{
								return '<input type="text" id="maxQty'+data+'"   onkeyup=digitalVerification(this)>';
						   				}
						}},
				   		{name:'STK_C',width:'12%', formatter:function(data,row,rowObject){
					   		if(null!=singleCustQtyLists[rowObject.STK_C]&singleCustQtyLists[rowObject.STK_C]!=undefined){
							return '<input type="hidden" id="singleCustQty'+data+'"     value="'+singleCustQtyLists[rowObject.STK_C]+'">'+singleCustQtyLists[rowObject.STK_C];
					   		}else{
							return '<input type="text" id="singleCustQty'+data+'"   onkeyup=digitalVerification(this)    >';
					   		}
						}}
						,
						{name:'BASEQTY',width:'20%', formatter:function(data,row,rowObject){
					   		if(null!=baseQtyLists[rowObject.STK_C]&baseQtyLists[rowObject.STK_C]!=undefined){
							return '<input type="hidden" id="baseQty'+rowObject.STK_C+'"       value="'+baseQtyLists[rowObject.STK_C]+'">'+baseQtyLists[rowObject.STK_C];
					   		}else{
							return '<input type="text" id="baseQty'+rowObject.STK_C+'"   onkeyup=digitalVerification(this)  VALUE="赠品条件的说明:5 代表满5赠送" onFocus=if(value==defaultValue){value="";} >';
					   		}
						}}
						,
						{name:'',width:'8%',align:"center",editable:true,formatter:function(value,row,rowObject){
							 var str = '';
							var stv = $("#selectTypeVal").val();
							if(stv=='1'){
								str += '<button type="button" class="btn btn-info edit"   onClick=addPromItem("'+rowObject.STK_C+'","false","")  >删除</button>';
							var masCode = '${promMas.masCode}';
									if("WEBPROMB"==masCode){
										
								str +='<button type="button" class="btn btn-info edit"   onClick=giftPromItem("'+rowObject.STK_C+'")  href="${base}/employee/editEmployeeUI.jhtml">赠品</button>';
									}
							}
							else{
								str += '<button type="button" class="btn btn-info edit"   onClick=addPromItem("'+rowObject.STK_C+'","true","'+rowObject.NET_PRICE+'")  >添加</button>';
							}

									return str;
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

				var masCode = '${promMas.masCode}';
				if("WEBPROMB"!=masCode){
					$("#grid-table").setGridParam().hideCol("BASEQTY").trigger("reloadGrid");
				}
				

			});
			
					function digitalVerification(obj){
			if(/\D/.test(obj.value)){
			top.$.jBox.tip('只能输入数字！');
			obj.value=0;
			}
			}
			
 
				function addPromItem(obj,addFlags,netPrice){
					var masCode = '${promMas.masCode}';
					var promPrice = $("#promPrice"+obj).val();
					var	maxQty = $("#maxQty"+obj).val();
					var	singleCustQty = $("#singleCustQty"+obj).val();
					var	baseQty = $("#baseQty"+obj).val();
					if(null==promPrice||''==promPrice){
					top.$.jBox.tip('请输入促销金额！');
					//obj.checked=false;
					return;
					}
					else if(parseFloat(promPrice)<=0){
						top.$.jBox.tip('促销金额不能小于0！');
						//obj.checked=false;
						return;
					}
					else if(parseFloat(netPrice)<parseFloat(promPrice) && 'WEBPROMA' ==masCode){
						top.$.jBox.tip('促销金额必须小于商品金额！');
						//obj.checked=false;
						return;
						
					}
					else if(null==maxQty||''==maxQty){
					top.$.jBox.tip('请输入促销数量！');
					//obj.checked=false;
					return;
					}  
					else if(null==singleCustQty||''==singleCustQty){
					top.$.jBox.tip('请输入单个客户可购买数量！');
					//obj.checked=false;
					return;
					}else if(parseInt(singleCustQty)>parseInt(maxQty)&&parseInt(maxQty)!=0){
					top.$.jBox.tip('单个客户购买数量不能大于促销总数！');
					//obj.checked=false;
					return;
					}else if("WEBPROMB"==masCode&&(null==baseQty||''==baseQty||/\D/.test(baseQty)))  {
							top.$.jBox.tip('请输入赠品数量！');
							return;
					}
					else if("WEBPROMB"==masCode&&(parseInt(baseQty)<1)){
							top.$.jBox.tip('赠品数量不能小于1！');
							return;
					}
					else{
					$.ajax({
						url:'${base}/prom/addMasList.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							stkC : obj,
							addFlag: addFlags,
							maxQty: $("#maxQty"+obj).val(),
							promPrice: $("#promPrice"+obj).val(),
							singleCustQty: $("#singleCustQty"+obj).val(),
							baseQty:$("#baseQty"+obj).val(),
							pkNo : '${pkNo}'
							},
						success : function(data) { 
								if(addFlags=='true'){
								top.$.jBox.tip('添加商品成功！','success');
								}else{
									top.$.jBox.tip('删除商品成功！','success');
								}
								var promItemArrays=data.data;
									promitemLists={};
									promPriceLists={};
									maxQtyLists={};
									singleCustQtyLists={};
									baseQtyLists={};
								for(var i=0;i<promItemArrays.length;i++){
									promitemLists[promItemArrays[i].STK_C]=promItemArrays[i].PK_NO;
									promPriceLists[promItemArrays[i].STK_C]=promItemArrays[i].PROM_PRICE;
									maxQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].MAX_QTY;
									singleCustQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].SINGLE_CUST_QTY;
									baseQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].BASE_QTY;
									}
								$("#grid-table").jqGrid('setGridParam',{  
							        datatype:'json',  
							        postData:$("#queryForm").serializeObjectForm(), //发送数据  
							        page:1  
							    }).trigger("reloadGrid");
						}
			});
					
					}}
					
					
					function checkPrice(obj){ 
					if(null==obj){
					return;
					}
					 else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
					 top.$.jBox.tip('请输入正确金额');
					obj.value=1;
					 }else{
					 obj.value=formatCurrency(obj.value);
					 }
					 
					 }
 
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
	            <div class="currentDataDiv_tit"><h4>活动名称:${promMas.refNo }&nbsp;&nbsp;开始时间:${promMas.beginDate?string("yyyy-MM-dd")}&nbsp;&nbsp;结束时间:${promMas.endDate?string("yyyy-MM-dd")}</h4></div>
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<input type="text" class="form-control input-sm required" value="请输入商品条码或编码或名称"  name="nameOrStkc" onFocus="if(value==defaultValue){value='';}">
	            		<a href="#"  data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()" > 关闭</button>
	                </span>
	            	<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1"  >
	                
	                <div class="form-group" style="float:right;">
	                 	<button type="button" class="btn_divBtn" id='' data-toggle="jBox-query-prom-mas"  ><i class="icon-search"></i> <span id="sreachFlagSpan">添加商品</span> </button>
	                 	
	                </div>
	                
	                
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
   		<form action="${base}/prom/editGiftUI.jhtml" id="promGiftForm" method="post">
   		<input type="hidden" name="pkNo" id="pkNo" value="${pkNo}">
   	    <input type="hidden" name="stkC" id="stkC">
   		</form>
    </body>
</html>
<script>
function giftPromItem(obj){
	$("#stkC").val(obj);
	$("#promGiftForm").submit();
}

</script> 



