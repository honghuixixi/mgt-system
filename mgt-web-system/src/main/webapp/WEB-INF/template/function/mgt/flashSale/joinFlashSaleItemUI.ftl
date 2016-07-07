<!DOCTYPE html>
<html>
    <head>
        <title>用户信息管理平台</title>
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>        
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promitemLists={};
		var promPriceLists={};
		var listPriceLists={};
		var maxQtyLists={};
		var singleCustQtyLists={};
		var beginDateLists={};
		[#list promItemList as promitem] 
		promitemLists['${promitem.PK_NO}']='${promitem.PK_NO}';
		promPriceLists['${promitem.PK_NO}']='${promitem.PROM_PRICE}';
		listPriceLists['${promitem.PK_NO}']='${promitem.LIST_PRICE}';
		maxQtyLists['${promitem.PK_NO}']='${promitem.MAX_QTY}';
		singleCustQtyLists['${promitem.PK_NO}']='${promitem.SINGLE_CUST_QTY}';
		beginDateLists['${promitem.PK_NO}']='${promitem.BEGIN_DATE}';
		[/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/joinFlashSaleItemList.jhtml?pkNo=${pkNo}&selectType=1',
					multiselect:false,
 					colNames:['','商品编码','商品名称','单位','售价','抢购价','促销总量','单个客户可购买量','参与日期','审核结果','操作'],
				   	colModel:[	 
						{name:'PK_NO',width:'0%',index:'ID',hidden:true,key:true},
						{name:'STK_C',width:'8%'},
				   		{name:'NAME',width:'20%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'UOM',width:'3%'},
						{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
					 		return '<input type="hidden" id="listPrice'+data+'" value="'+rowObject.LIST_PRICE+'">'+rowObject.LIST_PRICE;
				 		}},
						{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
				   			if(null!=promPriceLists[rowObject.PK_NO] && promPriceLists[rowObject.PK_NO]!=undefined && stv=='1'){
					 			return '<input type="hidden" id="promPrice'+data+'"  disabled="disabled" value="'+promPriceLists[rowObject.PK_NO]+'">'+promPriceLists[rowObject.PK_NO];
				   			}else{
				   				if('${promMas.allowanceType}'=='R'){
				   					var str = formatCurrency(Number(rowObject.NET_PRICE) * (1-Number('${promMas.allowanceValue}')/100));
						 			return '<input type="text" id="promPrice'+data+'" disabled="disabled"  onBlur=checkPrice(this,'+rowObject.NET_PRICE+') value="'+str+'">';
								}else{
					 				return '<input type="text" id="promPrice'+data+'" maxlength="12" onBlur=checkPrice(this,'+rowObject.NET_PRICE+') >';
								}
				   			}
				 		}},
				   		{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
				   			if(null!=maxQtyLists[rowObject.PK_NO] && maxQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="maxQty'+data+'"   value="'+maxQtyLists[rowObject.PK_NO]+'">'+maxQtyLists[rowObject.PK_NO];
						   	}else{
								return '<input type="text" id="maxQty'+data+'" maxlength="12"  onBlur=digitalVerification(this)>';
						   	}
						}},
				   		{name:'PK_NO',width:'12%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
					   		if(null!=singleCustQtyLists[rowObject.PK_NO] && singleCustQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="singleCustQty'+data+'"  value="'+singleCustQtyLists[rowObject.PK_NO]+'">'+singleCustQtyLists[rowObject.PK_NO];
					   		}else{
								return '<input type="text" id="singleCustQty'+data+'"  onBlur=digitalVerification(this)>';
					   		}
						}},
						{name:'BIGIN_DATE_IN',width:'12%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
							if(null!=beginDateLists[rowObject.PK_NO] && beginDateLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="beginDate'+rowObject.PK_NO+'"     value="'+beginDateLists[rowObject.PK_NO]+'">'+beginDateLists[rowObject.PK_NO];
							}else{
								return '<input type="text" id="beginDate'+rowObject.STK_C+'" onfocus="WdatePicker({skin:\'whyGreen\',dateFmt:\'yyyy-MM-dd\',minDate:\'new Date()\',maxDate:\'${promMas.endDate?string("yyyy-MM-dd")}\'})" value=""/>';
							}
						}},
						{name:'STATUS_FLG', width:'10%',align:"center",formatter:function(data){
							if(data=='P'){
								return '已通过';
							}else if(data=='A'){
								return '待审核';
							}else if(data=='R'){
								return '已拒绝';
							}else{
							    return '';
							}}
						},						
						{name:'',width:'8%',align:"center",editable:true,formatter:function(value,row,rowObject){
							var str = '';
							if(rowObject.STATUS_FLG!='P'){
								return str += '<button type="button" class="btn btn-info edit"   onClick=addPromItem("'+rowObject.PK_NO+'","false","")  >删除</button>';
							}else{
								return str += '--';
							}
						 }}
				   	],
				});

				//点击“查看已添加商品”按钮，清空搜索框
				$("#changeBox").click(function(){
					$("#nameOrStkc").val('请输入商品条码或编码或名称');
				});
		
		//点击“查看已添加商品”按钮,切换不表格		
		$(function(){
 		$("#changeBox").click(function(){
 			var stv = $("#selectTypeVal").val();
	    	if('1'==stv){
	    		$("#selectTypeVal").val("2");
				$("#sreachFlagSpan").text("查看参与该活动商品");
				
  				$('#grid-table').GridUnload();//重绘
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/joinFlashSaleItemList.jhtml?pkNo=${pkNo}&selectType=2',
					multiselect:false,
 					colNames:['','商品编码','商品名称','单位','售价','抢购价','促销总量','单个客户可购买量','参与日期','操作'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
						{name:'STK_C',width:'8%'},
				   		{name:'NAME',width:'20%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'UOM',width:'3%'},
						{name:'STK_C',width:'6%', formatter:function(data,row,rowObject){
					 		return '<input id="listPrice'+data+'"  onBlur=checkOldPrice(this,'+rowObject.NET_PRICE+','+data+')  value="'+rowObject.NET_PRICE+'">';
				 		}},
						{name:'STK_C',width:'6%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
				   			if(null!=promPriceLists[rowObject.PK_NO] && promPriceLists[rowObject.PK_NO]!=undefined && stv=='1'){
					 			return '<input type="hidden" id="promPrice'+data+'"  disabled="disabled" value="'+promPriceLists[rowObject.PK_NO]+'">'+promPriceLists[rowObject.PK_NO];
				   			}else{
				   				if('${promMas.allowanceType}'=='R'){
				   					var str = formatCurrency(Number(rowObject.NET_PRICE) * (1-Number('${promMas.allowanceValue}')/100));
						 			return '<input type="text" id="promPrice'+data+'" disabled="disabled"  onBlur=checkPrice(this,'+rowObject.NET_PRICE+') value="'+str+'">';
								}else{
					 				return '<input type="text" id="promPrice'+data+'" onBlur=checkPrice(this,'+rowObject.NET_PRICE+') >';
								}
				   			}
				 		}},
				   		{name:'STK_C',width:'6%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
				   			if(null!=maxQtyLists[rowObject.PK_NO] && maxQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="maxQty'+data+'"   value="'+maxQtyLists[rowObject.PK_NO]+'">'+maxQtyLists[rowObject.PK_NO];
						   	}else{
								return '<input type="text" id="maxQty'+data+'" maxlength="12"  onBlur=digitalVerification(this)>';
						   	}
						}},
				   		{name:'STK_C',width:'12%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
					   		if(null!=singleCustQtyLists[rowObject.PK_NO] && singleCustQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="singleCustQty'+data+'"  value="'+singleCustQtyLists[rowObject.PK_NO]+'">'+singleCustQtyLists[rowObject.PK_NO];
					   		}else{
								return '<input type="text" id="singleCustQty'+data+'" maxlength="12"  onBlur=digitalVerification(this)>';
					   		}
						}},
						{name:'BIGIN_DATE_IN',width:'12%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
							if(null!=beginDateLists[rowObject.PK_NO] && beginDateLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="beginDate'+rowObject.PK_NO+'"     value="'+beginDateLists[rowObject.PK_NO]+'">'+beginDateLists[rowObject.PK_NO];
							}else{
								return '<input type="text" id="beginDate'+rowObject.STK_C+'" onfocus="WdatePicker({skin:\'whyGreen\',dateFmt:\'yyyy-MM-dd\',minDate:\'new Date()\',maxDate:\'${promMas.endDate?string("yyyy-MM-dd")}\'})" value=""/>';
							}
						}},
						{name:'',width:'8%',align:"center",editable:true,formatter:function(value,row,rowObject){
							return '<button type="button" class="btn btn-info edit"   onClick=addPromItem("'+rowObject.STK_C+'","true","'+rowObject.NET_PRICE+'")  >添加</button>';
						 }}
				   	],
				});  				
	    	}else{
	    		$("#selectTypeVal").val("1");
				$("#sreachFlagSpan").text("添加商品");
				
	    		$('#grid-table').GridUnload();//重绘
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/joinFlashSaleItemList.jhtml?pkNo=${pkNo}&selectType=1',
					multiselect:false,
 					colNames:['','商品编码','商品名称','单位','售价','抢购价','促销总量','单个客户可购买量','参与日期','审核结果','操作'],
				   	colModel:[	 
						{name:'PK_NO',width:'0%',index:'ID',hidden:true,key:true},
						{name:'STK_C',width:'8%'},
				   		{name:'NAME',width:'20%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'UOM',width:'3%'},
						{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
					 		return '<input type="hidden" id="listPrice'+data+'" value="'+rowObject.LIST_PRICE+'">'+rowObject.LIST_PRICE;
				 		}},
						{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
				   			if(null!=promPriceLists[rowObject.PK_NO] && promPriceLists[rowObject.PK_NO]!=undefined && stv=='1'){
					 			return '<input type="hidden" id="promPrice'+data+'"  disabled="disabled" value="'+promPriceLists[rowObject.PK_NO]+'">'+promPriceLists[rowObject.PK_NO];
				   			}else{
				   				if('${promMas.allowanceType}'=='R'){
				   					var str = formatCurrency(Number(rowObject.NET_PRICE) * (1-Number('${promMas.allowanceValue}')/100));
						 			return '<input type="text" id="promPrice'+data+'" disabled="disabled"  onBlur=checkPrice(this,'+rowObject.NET_PRICE+') value="'+str+'">';
								}else{
					 				return '<input type="text" id="promPrice'+data+'" onBlur=checkPrice(this,'+rowObject.NET_PRICE+') >';
								}
				   			}
				 		}},
				   		{name:'PK_NO',width:'6%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
				   			if(null!=maxQtyLists[rowObject.PK_NO] && maxQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="maxQty'+data+'"   value="'+maxQtyLists[rowObject.PK_NO]+'">'+maxQtyLists[rowObject.PK_NO];
						   	}else{
								return '<input type="text" id="maxQty'+data+'" maxlength="12"  onBlur=digitalVerification(this)>';
						   	}
						}},
				   		{name:'PK_NO',width:'12%', formatter:function(data,row,rowObject){
				   			var stv = $("#selectTypeVal").val();
					   		if(null!=singleCustQtyLists[rowObject.PK_NO] && singleCustQtyLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="singleCustQty'+data+'"  value="'+singleCustQtyLists[rowObject.PK_NO]+'">'+singleCustQtyLists[rowObject.PK_NO];
					   		}else{
								return '<input type="text" id="singleCustQty'+data+'" maxlength="12"  onBlur=digitalVerification(this)>';
					   		}
						}},
						{name:'BIGIN_DATE_IN',width:'12%', formatter:function(data,row,rowObject){
							var stv = $("#selectTypeVal").val();
							if(null!=beginDateLists[rowObject.PK_NO] && beginDateLists[rowObject.PK_NO]!=undefined && stv=='1'){
								return '<input type="hidden" id="beginDate'+rowObject.PK_NO+'"     value="'+beginDateLists[rowObject.PK_NO]+'">'+beginDateLists[rowObject.PK_NO];
							}else{
								return '<input type="text" id="beginDate'+rowObject.STK_C+'" onfocus="WdatePicker({skin:\'whyGreen\',dateFmt:\'yyyy-MM-dd\',minDate:\'new Date()\',maxDate:\'${promMas.endDate?string("yyyy-MM-dd")}\'})" value=""/>';
							}
						}},
						{name:'STATUS_FLG', width:'10%',align:"center",formatter:function(data){
							if(data=='P'){
								return '已通过';
							}else if(data=='A'){
								return '待审核';
							}else if(data=='R'){
								return '已拒绝';
							}else{
							    return '';
							}}
						},						
						{name:'',width:'8%',align:"center",editable:true,formatter:function(value,row,rowObject){
							 var str = '';
							if(rowObject.STATUS_FLG!='P'){
								return str += '<button type="button" class="btn btn-info edit"   onClick=addPromItem("'+rowObject.PK_NO+'","false","")  >删除</button>';
							}else{
								return str += '--';
							}
						 }}
				   	],
				});	    			
	    	}
 		});
 		});
 								
	});

			function digitalVerification(obj,netPrice,stkC){
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
					top.$.jBox.tip('请输入正确数量！');
					obj.value='';
				}
				if(!(/^[1-9]*[1-9][0-9]*$/).test(obj.value)){
					top.$.jBox.tip('请输入正整数数量！');
					obj.value='';
				}
			}
			
			function addPromItem(obj,addFlags,netPrice){
					var masCode = '${promMas.masCode}';
					var promPrice = $("#promPrice"+obj).val();
					var listPrice = $("#listPrice"+obj).val();
					var	maxQty = $("#maxQty"+obj).val();
					var	singleCustQty = $("#singleCustQty"+obj).val();
					var	beginDate = $("#beginDate"+obj).val();
					if(null==promPrice||''==promPrice){
						top.$.jBox.tip('请输入抢购价！');
						return;
					}
					else if(null==beginDate||''==beginDate){
						top.$.jBox.tip('请输入参与日期！');
						return;
					}
					else if(parseFloat(promPrice)<0){
						top.$.jBox.tip('请输入不小于0的抢购价！');
						return;
					}
					else if(parseFloat(netPrice)<parseFloat(promPrice)){
						top.$.jBox.tip('促销金额必须小于商品金额！');
						return;
					}
					else if(null==maxQty||''==maxQty){
						top.$.jBox.tip('请输入促销总量！');
						return;
					}  
					else if(null==singleCustQty||''==singleCustQty){
						top.$.jBox.tip('请输入单个客户可购买数量！');
						return;
					}else if(parseInt(singleCustQty)>parseInt(maxQty)&&parseInt(maxQty)!=0){
						top.$.jBox.tip('单个客户购买数量不能大于促销总量！');
						return;
					}
					else{
					$.ajax({
						url:'${base}/prom/addeletePromItem.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							stkC : obj,
							addFlag: addFlags,
							maxQty: $("#maxQty"+obj).val(),
							promPrice: $("#promPrice"+obj).val(),
							listPrice: $("#listPrice"+obj).val(),
							singleCustQty: $("#singleCustQty"+obj).val(),
							beginDate: $("#beginDate"+obj).val(),
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
									listPriceLists={};
									maxQtyLists={};
									singleCustQtyLists={};
									beginDateLists={};
								for(var i=0;i<promItemArrays.length;i++){
									promitemLists[promItemArrays[i].PK_NO]=promItemArrays[i].PK_NO;
									promPriceLists[promItemArrays[i].PK_NO]=promItemArrays[i].PROM_PRICE;
									listPriceLists[promItemArrays[i].PK_NO]=promItemArrays[i].LIST_PRICE;
									maxQtyLists[promItemArrays[i].PK_NO]=promItemArrays[i].MAX_QTY;
									singleCustQtyLists[promItemArrays[i].PK_NO]=promItemArrays[i].SINGLE_CUST_QTY;
									beginDateLists[promItemArrays[i].PK_NO]=new Date(promItemArrays[i].BEGIN_DATE).format('yyyy-MM-dd');
									}
								$("#grid-table").jqGrid('setGridParam',{  
							        datatype:'json',  
							        postData:$("#queryForm").serializeObjectForm(), //发送数据  
							        page:1  
							    }).trigger("reloadGrid");
							}
						});
					
					}}
					
					//抢购价校验
					function checkPrice(obj,oldPrice){ 
						if(null==obj){
							obj.value=formatCurrency(oldPrice);
						}else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
							 top.$.jBox.tip('请输入正确抢购金额');
							 obj.value='';
						}else if(obj.value>oldPrice){
							 top.$.jBox.tip('抢购价大于零售价');
							 obj.value='';
					 	}else{
					 		obj.value=formatCurrency(obj.value);
					 	}
					 }
					
					//售价价校验，并且根据修改的售价，确定促销价
					function checkOldPrice(obj,oldPrice,id){ 
						if(null==obj){
							obj.value=formatCurrency(oldPrice);
						}else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
							 top.$.jBox.tip('请输入正确售价金额');
							 obj.value=formatCurrency(oldPrice);
						}else if(Number(obj.value)<0.01){
							 top.$.jBox.tip('请输入大于0.01的金额');
							 obj.value=formatCurrency(oldPrice);
						}else if(obj.value>oldPrice){
							 top.$.jBox.tip('售价价大于原始零售价');
							 obj.value=formatCurrency(oldPrice);
					 	}else{
					 		obj.value=formatCurrency(obj.value);
					 			//动态修改促销价
					 			if('${promMas.allowanceType}'=='R'){
				   					var str = formatCurrency(Number(obj.value) * (1-Number('${promMas.allowanceValue}')/100));
						 			$("#promPrice"+id).val(str);
								}
					 	}
					 }
 
					function ss(){
						$("#findFlashSale").submit();
					}
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <!-- 搜索条 -->
	            <div class="currentDataDiv_tit" style="height:auto;">
	            	<h4 style="line-height:26px;">活动主题:${promMas.refNo }&nbsp;&nbsp;开始时间:${promMas.beginDate?string("yyyy-MM-dd")}&nbsp;&nbsp;结束时间:${promMas.endDate?string("yyyy-MM-dd")}&nbsp;&nbsp;
	            		[#if '${promMas.allowanceType}'=='']
	            			无
	            		[#else]
	            			[#if '${promMas.allowanceType}'=='V']
	            				差额补贴
	            			[#else]
	            				百分比补贴
	            				${promMas.allowanceValue}%
	            			[/#if]
	            		[/#if]
	            	</h4>
	            </div>
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<input type="text" class="form-control input-sm required" value="请输入商品条码或编码或名称"  name="nameOrStkc" id="nameOrStkc" onFocus="if(value==defaultValue){value='';}">
	            		<a href="#"  data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()" > 限时抢购活动列表</button>
	                </span>
	            	<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1"  >
	                
	                <div class="form-group" style="float:right;">
	                 	<button type="button" class="btn_divBtn" id='changeBox'><i class="icon-search"></i> <span id="sreachFlagSpan">添加商品</span> </button>
	                </div>
	                
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/findFlashSale.jhtml" id="findFlashSale" method="post">
   		</form>
    </body>
</html>