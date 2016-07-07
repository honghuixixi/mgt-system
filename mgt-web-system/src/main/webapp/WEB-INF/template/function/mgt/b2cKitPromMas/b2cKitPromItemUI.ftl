<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
	var promitemLists={};
	var kitQtyLists={};
	var settlePriceLists={};
	[#list promItemList as promitem] 
		promitemLists['${promitem.STK_C}']='${promitem.MAS_PK_NO}';
		kitQtyLists['${promitem.STK_C}']='${promitem.KIT_QTY}';
		settlePriceLists['${promitem.STK_C}']='${promitem.SETTLE_PRICE}';
	[/#list] 
	$(document).ready(function(){
		mgt_util.jqGrid('#grid-table',{
			url:'${base}/b2cKitPromMas/b2cKitPromItemList.jhtml?pkNo=${pkNo}&selectType='+$("#selectTypeVal").val(),
			multiselect:false,
			colNames:['','','商品名称','商品编码','商品条码','零售标价','零售净价','零售标价','零售净价','促销数量','成交价'],
		   	colModel:[	 
			   	{name:'',width:30,formatter:function(value,row,rowObject){
			   			if(null!=promitemLists[rowObject.STK_C]){
							return '<input type="checkbox"  id="promCheckBox'+rowObject.STK_C+'" value="'+rowObject.STK_C+'" onclick="addPromItem(this)" checked=checked>';
				   		}else{
							return '<input type="checkbox"  id="promCheckBox'+rowObject.STK_C+'" value="'+rowObject.STK_C+'" onclick="addPromItem(this)" >';

					   	}
						}},
				{name:'STK_C',index:'ID',width:20,hidden:true,key:true},
		   		{name:'NAME',width:200},
				{name:'STK_C',width:200},
		   		{name:'PLU_C',width:200},
		   		{name:'LIST_PRICE',width:180,hidden:true},
		   		{name:'NET_PRICE',width:180,hidden:true},
		   		{name:'POS_LIST_PRICE',width:180,hidden:true},
		   		{name:'POS_NET_PRICE',width:180,hidden:true},
		   		{name:'STK_C', width:180,formatter:function(data,row,rowObject){
		   				if(null!=kitQtyLists[rowObject.STK_C]&kitQtyLists[rowObject.STK_C]!=undefined){
							return '<input type="text" id="kitQty'+data+'"   onkeyup="validateData(this)" onBlur="addPromCheckBox('+data+')" value="'+kitQtyLists[rowObject.STK_C]+'">';
		   				}else{
							return '<input type="text" id="kitQty'+data+'"    onkeyup="validateData(this)" onBlur="addPromCheckBox('+data+')"';
		   				}
						}},
		   		{name:'STK_C', width:180,formatter:function(data,row,rowObject){
		   				if(null != settlePriceLists[rowObject.STK_C]){
							return '<input type="text" id="settlePrice'+data+'"    onBlur="addPromCheckBox('+data+')"  value="'+settlePriceLists[rowObject.STK_C]+'">';
		   				}else{
							return '<input type="text" id="settlePrice'+data+'"    onBlur="addPromCheckBox('+data+')" ';
		   				} 
						}},
		   	],
			gridComplete:function(){ //循环为每一行添加业务事件 
				var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
					for(var i=0; i<ids.length; i++){ 
						var id=ids[i]; 
						var rowData = $('#grid-table').jqGrid('getRowData',id);
						if (rowData.LIST_PRICE != "") {
							jQuery("#grid-table").setGridParam().showCol("LIST_PRICE").trigger("reloadGrid");
						}
						if (rowData.NET_PRICE != "") {
							jQuery("#grid-table").setGridParam().showCol("NET_PRICE").trigger("reloadGrid");
						}
						if (rowData.POS_LIST_PRICE != "") {
							jQuery("#grid-table").setGridParam().showCol("POS_LIST_PRICE").trigger("reloadGrid");
						}
						if (rowData.POS_NET_PRICE != "") {
							jQuery("#grid-table").setGridParam().showCol("POS_NET_PRICE").trigger("reloadGrid");
						}
					} 
				} 
			});
	})
	
	function validateData(obj){
		if (/\D/.test($(obj).val())) {
			$(obj).val(1);
		}
	}
	function addPromItem(obj){
		var kitQty = $("#kitQty"+obj.value).val();
		var settlePrice = $("#settlePrice"+obj.value).val();
		if(null==kitQty||''==kitQty){
			top.$.jBox.tip('请输入促销数量！');
			obj.checked=false;
			return;
		}  
		if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(settlePrice)||Number(settlePrice)==0){
			top.$.jBox.tip('请输入大于0的正确价格！');
			obj.checked=false;
			return;
		}  
		if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(settlePrice)||Number(settlePrice)==0){
			top.$.jBox.tip('请输入大于0的正确价格！');
			obj.checked=false;
			return;
		}  
		if(null==settlePrice||''==settlePrice){
			top.$.jBox.tip('请输入结算价！');
			obj.checked=false;
			return;
		}  
		$.ajax({
			url:'${base}/b2cKitPromMas/addB2cKitPromItem.jhtml',
			type : 'post',
			dataType : 'json',
			data : {
				stkC : obj.value,
				addFlag: obj.checked,
				kitQty: $("#kitQty"+obj.value).val(),
				settlePrice: $("#settlePrice"+obj.value).val(),
				pkNo : '${pkNo}'
				},
			success : function(data) { 
					top.$.jBox.tip('编辑商品成功！','success');
					var promItemArrays=data.data;
						promitemLists={};
						kitQtyLists={}; 
						settlePriceLists={}; 
					for(var i=0;i<promItemArrays.length;i++){
						promitemLists[promItemArrays[i].STK_C]=promItemArrays[i].MAS_PK_NO;
						kitQtyLists[promItemArrays[i].STK_C]=promItemArrays[i].KIT_QTY;
						settlePriceLists[promItemArrays[i].STK_C]=promItemArrays[i].SETTLE_PRICE;
						}
				}
		});
			
		}
	
	
	function addPromCheckBox(obj){
			setTimeout(function(){
				$("#promCheckBox"+obj).attr('checked',true);
				var promCheckBox = document.getElementById("promCheckBox"+obj);
				addPromItem(promCheckBox);
			},1000);

	}
	
	function ss(){
		$.jBox.confirm("确认要保存该数据?", "提示", function(v){
		if(v == 'ok'){
			mgt_util.showMask('正在保存数据，请稍等...');
			setTimeout(function () { 
				mgt_util.hideMask();
			}, 1000);
			
		}
		});
		}
   </script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="resource" style="position:relative;">
				<div class="currentDataDiv_tit">
					 <div class="form-group">
	                 	<button type="button" class="btn_divBtn" id='' data-toggle="jBox-query-kitProm-item"  ><i class="icon-search"></i> <span id="sreachFlagSpan">添加商品</span> </button>
	                </div>
				</div>
				<div class="form_divBox" style="display:block;padding:10px 0;">
					 <!-- 搜索条 -->
		            <form class="form form-inline queryForm"  id="query-form">
		            	<!-- <span class="form-group" style="float:right">
		                 	<button type="button" class="btn btn-info" id='' onClick="ss()" > 确定</button>
		                </span> -->
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
		            <div class="search_cBox">
						  <div class="form-group">
		                 	<button type="button" class="search_cBox_btn" id='' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索</button>
		                </div>
					</div>
				</div>
	           
	        </div>
	        <div style="clear:both;"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>
 



