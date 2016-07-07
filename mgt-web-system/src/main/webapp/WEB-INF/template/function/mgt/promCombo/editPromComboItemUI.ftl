<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>套装定义页面</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promitemLists={};
		var promPriceLists={};
		var maxQtyLists={};
		[#list promItemList as promitem] 
			promitemLists['${promitem.STK_C}']='${promitem.PK_NO}';
			promPriceLists['${promitem.STK_C}']='${promitem.PROM_PRICE}';
			maxQtyLists['${promitem.STK_C}']='${promitem.BASE_QTY}';
		[/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/PromComboList.jhtml?pkNo=${pkNo}&selectType='+$("#selectTypeVal").val(),
					multiselect:false,
 					colNames:['','编码','名称','规格','单位','售价','套装价格','套装数量','操作'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
				   		{name:'STK_C',width:'8%'},
				   		{name:'NAME',width:'32%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'MODLE',width:'6%'},
				   		{name:'UOM',width:'5%'},
				   		{name:'NET_PRICE',width:'8%'},
				   		{name:'STK_C',width:'8%', formatter:function(data,row,rowObject){
				   			if(null!=promPriceLists[rowObject.STK_C]&&promPriceLists[rowObject.STK_C]!=undefined){
					 		return '<input type="text" id="promPrice'+data+'"  pkNo="'+promitemLists[rowObject.STK_C]+'" netPrice="'+rowObject.NET_PRICE+'" onBlur="checkUpdatePrice(this);" value="'+promPriceLists[rowObject.STK_C]+'">';
				   			}else{
					 		return '<input type="text" id="promPrice'+data+'" netPrice="'+rowObject.NET_PRICE+'" onBlur=checkPrice(this) >';
				   			}
					 		}},
				   		{name:'STK_C',width:'8%', formatter:function(data,row,rowObject){
				   				if(null!=maxQtyLists[rowObject.STK_C]&maxQtyLists[rowObject.STK_C]!=undefined){
								return '<input type="text" id="maxQty'+data+'" pkNo="'+promitemLists[rowObject.STK_C]+'"  onkeyup=digitalVerification(this) onblur=updateQty(this) value="'+maxQtyLists[rowObject.STK_C]+'">';
						   				}else{
								return '<input type="text" id="maxQty'+data+'"  onkeyup=digitalVerification(this)>';
						   				}
						}},
						{name:'',width:'15%',align:"center",editable:true,formatter:function(value,row,rowObject){
							var str = '';
							var stv = $("#selectTypeVal").val();
							if(stv=='1'){
								str += '<button type="button" class="btn btn-info edit"   onClick=addMasComboList("'+rowObject.STK_C+'","false","")  >删除</button>';
							}else{
								str += '<button type="button" class="btn btn-info edit"   onClick=addMasComboList("'+rowObject.STK_C+'","true","'+rowObject.NET_PRICE+'")  >添加</button>';
							}
								return str;
						 }}
				   	]
				});
			});
			
			//实时校验数量
			function digitalVerification(obj){
				if(/\D/.test(obj.value)){
					top.$.jBox.tip('只能输入数字！');
					obj.value=1;
				}
				if((obj.value).length>4){
					top.$.jBox.tip('只能输入小于等于4 位数数字！');
					obj.value=1;
				}
				if(Number(obj.value)==0){
					top.$.jBox.tip('数量不能为0！');
					obj.value=1;
				}
				if(!(/^[1-9]*[1-9][0-9]*$/).test(obj.value)){
					top.$.jBox.tip('请输入正整数数量！');
					obj.value='';
				}				
			}
			
			//实时修改商品数量
			function updateQty(obj){
					$.ajax({
						url:'${base}/prom/ajaxUpdateComboItem.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							pkNo: $(obj).attr("pkNo"),
							baseQty: $(obj).val(),
							masPkNo:${pkNo},
						},
						success : function(data) { 
							if(data.code==001){
								top.$.jBox.tip('修改成功！', 'success');
							}
						}
					});				
			}
			var sign = true;
			function addMasComboList(obj,addFlags,netPrice){
			if(!sign){
				return false;
			}
					var masCode = '${promMas.masCode}';
					var stkC = '${stkC}';
					var promPrice = $("#promPrice"+obj).val();
					var	maxQty = $("#maxQty"+obj).val();
					if(null==promPrice||''==promPrice){
						top.$.jBox.tip('请输入套装金额！');
						return;
					}else if(stkC==obj){
						top.$.jBox.tip('套装内源商品禁止操作！');
						return;
					}else if(parseFloat(netPrice)<parseFloat(promPrice)){
						top.$.jBox.tip('促销金额必须小于商品金额！');
						return;
					}else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(promPrice)){
					 	top.$.jBox.tip('请输大于0的数字');
					 	return;
					}else if(null==maxQty||''==maxQty){
						top.$.jBox.tip('请输入套装内该商品数量！');
						maxQty=1;
						return;
					}else{
					$.ajax({
						url:'${base}/prom/addMasComboList.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							stkC : obj,
							addFlag: addFlags,
							maxQty: $("#maxQty"+obj).val(),
							promPrice: $("#promPrice"+obj).val(),
							pkNo : '${pkNo}'
						},
						success : function(data) { 
								
								if(addFlags=='true'){
									sign = false;
									top.$.jBox.tip('添加商品成功！','success');
								}else{
									top.$.jBox.tip('删除商品成功！','success');
								}
								var promItemArrays=data.data;
									promitemLists={};
									promPriceLists={};
									maxQtyLists={};
								for(var i=0;i<promItemArrays.length;i++){
									promitemLists[promItemArrays[i].STK_C]=promItemArrays[i].PK_NO;
									promPriceLists[promItemArrays[i].STK_C]=promItemArrays[i].PROM_PRICE;
									maxQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].BASE_QTY;
								}
								$("#grid-table").jqGrid('setGridParam',{  
							        datatype:'json',  
							        postData:$("#queryForm").serializeObjectForm(), //发送数据  
							        page:1  
							    }).trigger("reloadGrid");
							}
						});
					}}

			
			//实时校验价格
			function checkPrice(obj){
				var oldPrice = $(obj).attr("netPrice");
				var promPrice = $(obj).val();
				
				if(promPrice==obj){
					top.$.jBox.tip('价格不能为空！');
					obj.value=oldPrice;
				}
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(promPrice)){
					top.$.jBox.tip('只能输入数字！');
					obj.value=oldPrice;
				}
				if(Number(obj.value)==0){
					top.$.jBox.tip('价格不能为0！');
					obj.value=oldPrice;
				}
				//if(parseFloat(oldPrice)<parseFloat(promPrice)){
				//	top.$.jBox.tip('促销价格不能大于商品原价格');
				//	obj.value=1;
				//}
				obj.value=formatCurrency(obj.value);
			}			
					
					//实时校验并跟新价格
					function checkUpdatePrice(obj){
						var oldPrice = $(obj).attr("netPrice");
						var promPrice = $(obj).val();
						if(null==obj){
							return;
						}else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
					 		top.$.jBox.tip('请输入数字');
					 		return;
						}else if(Number(obj.value)==0){
					 		top.$.jBox.tip('价格不能为0');
					 		return;
						//}
						//else if(parseFloat(oldPrice)<parseFloat(promPrice)){
					 		//top.$.jBox.tip('促销价格不能大于商品原价格');
					 		//return;
					 	}else{
						    obj.value=formatCurrency(obj.value);
						    if(Number(obj.value)==0){
						    	obj.value=0.01;
						    }
						    //实时修改商品价格
						    $.ajax({
								url:'${base}/prom/ajaxUpdateComboItem.jhtml',
								type : 'post',
								dataType : 'json',
								data : {
									pkNo: $(obj).attr("pkNo"),
									promPrice: $(obj).val(),
									masPkNo:${pkNo},
								},
								success : function(data) { 
									if(data.code==001){
										top.$.jBox.tip('修改成功！', 'success');
									}
								}
							});	
					 	}
					 }
 
					function ss(){
						$("#promMasForm").submit();
					}
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <!-- 搜索条 -->
	            <div class="currentDataDiv_tit"><h4>套装名称:${promMas.refNo }&nbsp;&nbsp;开始时间:${promMas.beginDate?string("yyyy-MM-dd")}&nbsp;&nbsp;结束时间:${promMas.endDate?string("yyyy-MM-dd")}</h4></div>
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
	                 	<button type="button" class="btn_divBtn" id='' data-toggle="jBox-query-promCombo-mas"  ><i class="icon-search"></i> <span id="sreachFlagSpan">添加商品</span> </button>
	                </div>
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/promComboInfo.jhtml" id="promMasForm" method="post">
   		</form>
    </body>
</html>