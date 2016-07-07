<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-B2B商品管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script  type="text/javascript">
			//chosen插件初始化，绑定元素
			$(function(){
	    		$("#brandC").chosen();
			});	
		
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",bcFlg:"${bcFlg}",custCode:"${custCode}"};
				mgt_util.jqGrid('#grid-table',{
					multiselect : false,
					mtype: "GET",
					postData: postData,
					url:'${base}/vendorStkDis/stkPriceDiscountData.jhtml',
	 				colNames:['','包装条码','名称','零售单位','包装单位','包装数量','供货量','价格','折扣','优惠价',''],
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:0,hidden:true,key:true},
				   		{name:'PLU_C',align:"center",index:'PLU_C',width:'12',key:true},
				   		{name:'NAME',align:"center",index:'NAME',width:'15',key:true},
				   		{name:'STD_UOM',align:"center",index:'STD_UOM',width:'6',sortable:false,key:true},
				   		{name:'UOM',align:"center",index:'UOM',width:'7',sortable:false,key:true},
				   		{name:'PACK_QTY',align:"center",index:'PACK_QTY',width:'7',sortable:false,key:true},
				   		{name:'SUPPLY_QTY',align:"center",index:'SUPPLY_QTY',width:'5',sortable:false,key:true},
				   		{name:'NET_PRICE',align:"center",index:'NET_PRICE',width:'7',key:true},
				   		{name:'DISCOUNT_NUM',index:'DISCOUNT_NUM',width:'10',align:'center',sortable:true,title:false},
					    {name:'DIS_NET_PRICE',index:'DIS_NET_PRICE',width:'10',align:'center',sortable:true,title:false},
					    {name:'DIS_CREATE_DATE',index:'DIS_CREATE_DATE',width:0,hidden:true,key:true}
				   	],
				   	gridComplete:function(){ 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i];
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="<input type='text' class='form-control input-sm' style='width:75px;' id='num"+id+"' value='"+rowData.DISCOUNT_NUM+"' onChange='setDisNum("+id+")'/>%";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { DISCOUNT_NUM: detail });
							detail ="<input type='text' class='form-control input-sm' style='width:75px;' id='pri"+id+"' value='"+rowData.DIS_NET_PRICE+"' onChange='setDisPri("+id+")'/>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { DIS_NET_PRICE: detail }); 
						} 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
						$('input[type=text]').keypress(function (e) {
							var code = (e.keyCode ? e.keyCode : e.which);
				            if (!$.browser.msie && (e.keyCode == 0x8))
				            {
				                return;
				            }
				            return code >= 48 && code <= 57 || code == 46;
						}).keyup(function(){
							var o = this.value;
							var v = String(parseFloat(o));
							if(v.length!=o.length && o.indexOf(".")!=o.lastIndexOf(".") && o.lastIndexOf(".")!=o.length-1){
								this.value = v;
							}
						}).bind("paste", function () {
					        var s = clipboardData.getData('text');
					        if (!/\D\./.test(s));
					        value = s.replace(/^0*/, '');
					        return false;
					    }).focus(function () {
				         	this.style.imeMode = 'disabled';
					    });
					} 
				   	
				   	
				});
				$("#searchText").keyup(function(event){
					if(event.keyCode == "13"){
		                $('#order_search').trigger("click");
		            }
				});
				$("#saveBtn").click(function(){
					$('#data').val(JSON.stringify(data));
					mgt_util.buttonDisabled();
					mgt_util.showMask('数据保存中....');
					var form = '#merge-form';
					$.ajax({
						url : $(form).attr('action'),
						type : 'post',
						dataType : 'json',
						data : mgt_util.formObjectJson(form),
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.buttonEnable();
							mgt_util.showMessage(jqXHR, data, function(s) {
									top.$.jBox.tip('保存成功！', 'success');
							});
							clearData();
						}
					});
				});
				
			});
			var data = new Array();
			function clearData(){
				data = new Array();
			}
			function setDisNum(id){
				var rowData = $('#grid-table').jqGrid('getRowData',id);
				var p = rowData.NET_PRICE;
				var num = $('#num'+id).val();
				var pri = mathround(p * num / 100,5);
				if(pri > p){
					pri = p;
					num = 100;
					$('#num'+id).val(num);
				}
				$('#pri'+id).val(pri);
				setData(id,p,num,pri,rowData.DIS_CREATE_DATE);
			}
			function setDisPri(id){
				var rowData = $('#grid-table').jqGrid('getRowData',id);
				var p = rowData.NET_PRICE;
				var pri = $('#pri'+id).val();
				var num = mathround(pri/p*100,7);
				if(pri > p){
					pri = p;
					num = 100;
					$('#pri'+id).val(pri);
				}
				$('#num'+id).val(num);
				setData(id,p,num,pri,rowData.DIS_CREATE_DATE);
			}
			function mathround(value,per){
				var pow = Math.pow(10,per);
				return Math.round(value*pow)/pow;
			}
			function setData(id,oriPrice,num,pri,createDate){
				var j = {};
				j.custName=$("#custName").val();
				j.discNum=num;
				j.netPrice=pri;
				j.orgNo=$("#orgNo").val();
				j.oriNetPrice=oriPrice;
				//alert(createDate);
				j.dateValue=parseInt(createDate);
				var idkey = {};
				idkey.custCode=$("#custCode").val();
				idkey.stkC=id;
				j.id = idkey;
				var exist = false;
				for(var i=0; i<data.length; i++){
					if(data[i].id.stkC==j.id.stkC){
						exist = true;
						data[i]=j;
						break;
					}
				}
				if(!exist){
					data.push(j);
				}
			}
		</script>
    </head>
    <body>
     <div class="body-container">
     	<div class="main_heightBox1">
		    <div class="currentDataDiv" action="menu">
		    	<div class="currentDataDiv_tit">
		           <button type="button" class="btn_divBtn float_btn" id="saveBtn">保 存</button>
		         </div>
		         <div class="form_divBox" style="display:block;overflow:inherit;">
		            <form class="form form-inline queryForm" id="query-form">
						<input type="hidden" id="customerNo" name="customerNo" value="${customerNo}"/>
			        	<input type="hidden" id="editedDiscountInfo" name="editedDiscountInfo"/>
			        	<div class="form-group">
		                	<input type="text" class="form-control" id="searchText" name="name" style="width:170px" value="请输入条码或编码或名称" class="form-control" onfocus="if(value=='请输入条码或编码或名称') {value=''}" onblur="if (value=='') {value='请输入条码或编码或名称'}">
                		</div>
			            	<div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id="order_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
			                </div>
					</form>
			     </div>
			</div>
        </div>
	    <table id="grid-table" ></table>
        <div id="grid-pager"></div>
        <form id="merge-form" action="${base}/vendorStkDis/merge.jhtml">
			<input type="hidden" id="custCode" name="custCode" value="${custCode}"/>
			<input type="hidden" id="custName" name="custName" value="${custName}"/>
			<input type="hidden" id="orgNo" name="orgNo" value="${orgNo}"/>
        	<input type="hidden" id="data" name="data"/>
		</form>
    </body>
</html>