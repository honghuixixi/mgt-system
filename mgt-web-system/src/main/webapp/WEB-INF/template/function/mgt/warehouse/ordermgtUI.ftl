<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>订单仓库管理</title>
		[#include "/common/commonHead.ftl" /]		
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
			$(document).ready(function(){
			
				$("a#order_print").removeClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		//新增行高值
	    		var rowHight =0;
			
				var postData={orderby:"CREATE_DATE",statusFlg:"WAITDELIVER",sub_status_radio:"WAITPRINT"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/orderlist.jhtml',
 					colNames:['','','默认线路','区域1+区域2+区域3','订单编号','订单类型','店铺名称','分拣状态','下单日期','备注','操作'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'REMARKS1',index:'REMARKS1',width:0,hidden:true,key:true},
				   		{name:'ROUTE_NAME',align:"center",width:90},
				   		{name:'OM_AREA',align:"center",width:90},
				   		{name:'MAS_NO',align:"center",width:172},
				   		{name:'ORDER_TYPE',align:"center",width:50},
				   		{name:'CUST_NAME',align:"center",width:122},
				   		{name:'PICK_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='N'){
								return '未分拣';
							}else if(data=='A'){
								return '分拣中';
							}else if(data=='Y'){
								return '分拣完成';
							}else{
								return '分拣完成';
							}
	   					}},
				   		{name:'OM_CREATE_DATE',align:"center",width:150},
				   		{name:'REMARKS',align:"center",width:150},
				   		{name:'detail',index:'PK_NO',width:120,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderdeliver.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};

						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
				
				//批量打印。获取多条选中的订单pkNo,后台拼装table元素	
				$("#order_print").click(function(){
					var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					if(ids==""){
						top.$.jBox.tip('请至少选择一条数据！','error');
						return false;
					}				
					//打印参数弹出窗口
					printInfo.Show();
			   });
				//“再次”批量打印。获取多条选中的订单pkNo,后台拼装table元素	
				$("#print_again").click(function(){
					var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					if(ids==""){
						top.$.jBox.tip('请至少选择一条数据！','error');
						return false;
					}				
					//打印参数弹出窗口
					printInfo.Show();
			   });
			   
			//打印参数设置对话框关闭
			$(".comPoP_head a").click(function() {
				printInfo.Close();
			}); 
			//打印参数设置对话框确定
			$(".comPoP_body a").click(function() {
				argument = $(".comPoP_body select").val();
				printInfo.Close();
				var selectedIds = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					for(var i=0;i<selectedIds.length;i++){
						var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
						//订单pkNo
						var pkNo = rowData.PK_NO;
						//动态拼接订单详情页面
						$.ajax({
							url:'${base}/order/getAjaxOrderDetailUI.jhtml?pkNo='+pkNo,
							sync:false,
							type : 'post',
							dataType : "json",
							data :{
								'pkNo':pkNo,
							},
							error : function(data) {
								alert("网络异常");
								return false;
							},
							success : function(data) {
							var html = '';
							$("#currentPrint").html('');
							if(data.message.type == "success"){
								html += '<div id="printdiv_h_';
								html += data.order.PK_NO;
								html +='" style="display:none">';
								html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">';
								html += '<tbody><tr><td style="text-align:left;float: left;" width="30%"><span style="white-space:nowrap;">编号：';
								html += data.order.MAS_NO;
								html += '</td><td style="text-align:left;float: left;" width="20%">日期：';
								var date = (new Date(parseFloat(data.order.CREATE_DATE))).format("yyyy-MM-dd")
								html += date;
								html += '</td><td style="text-align:left;float: left;;" width="50%">供应商：';
								html += data.order.VENDOR_CODE;
								html += '</td></tr><tr>';
								html += '<td  colspan="2">客户：';
								html += data.order.CUST_NAME;
								if(data.order.RECEIVER_MOBILE != null){
									html += '(';
									html += data.order.RECEIVER_MOBILE;
									html += ')</td>';
								}else if(data.order.RECEIVER_TEL != null){
									html += '(';
									html += data.order.RECEIVER_TEL;
									html += ')</td>';
								}
								if(data.order.EMPNAME!= null){
									html += '<td>业务员：';
									html += data.order.EMPNAME;
									if(data.order.EMPMOBILE != null){
										html += '(';
										html += data.order.EMPMOBILE;
										html += ')';
									}
									html += '</td>';
								}
								html += '</tr><tr>';
								html += '<td colspan="3">送货地址：';
								if(data.order.Area != null){
									html += data.order.Area;
								}
								html += data.order.RECEIVER_ADDRESS;
								html += '</td></tr>';
								if(data.order.REMARK5 != null){
									rowHight = 15;
									html += '<tr>';
									html += '<td colspan="3">';
									html += data.order.REMARK5;
									html += '</td></tr>';
								}
								html += '</tbody></table></div>';
								
								//table数据部分
								html += '<div id="printdiv_b_';
								html += data.order.PK_NO;
								html +='" style="display:none">';
								html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
								html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
								html += '<th align="center" width="5%" style="border:1px solid #000; border-right:none 0;">序号</th>';
     							html += '<th align="center" width="16%" style="border:1px solid #000; border-right:none 0;">条码/编码</th>';
    							html += '<th align="center" width="40%" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>';
     							html += '<th align="center" width="5%" style="border:1px solid #000; border-right:none 0;">单位</th>';
     							html += '<th align="center" width="8%" style="border:1px solid #000; border-right:none 0;">订单数</th>';
     							html += '<th align="center" width="8%" style="border:1px solid #000; border-right:none 0;">发货数</th>';
     							html += '<th align="center" width="8%" style="border:1px solid #000; border-right:none 0;">价格</th>';
    							html += '<th align="center" width="10%" style="border:1px solid #000;">金额小计</th></tr></thead><tbody>';
    				
    						$.each(data.order.orderItem,function(n, Item) {
    							html += '<tr height="15" bgColor="#ffffff">';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.ITEM_NO;
    							html += '</td>';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							if(null==Item.PLU_C) {
    								html += Item.STK_C;
								} else {
									html += Item.PLU_C;
								}    								
    							html += '</td>';
    							html += '<td align="left" colspan="2" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.STK_NAME;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.UOM;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.UOM_QTY;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							if(null!=Item.QTY1) {
    								html += Item.QTY1;
    							}else{
    								html += '';
    							}
    							html += '</td>';
								html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">'+currency_0(Item.NET_PRICE,true)+'</td>';
								html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    							if(null!=Item.QTY1) {
    								html += currency_0(Item.NET_PRICE * Item.QTY1,true);
    							}else{
    								html += currency_0(Item.NET_PRICE * Item.UOM_QTY,true);
    							}
    							html += '</td></tr>';

							});
							    html += '<tr height="15" bgColor="#ffffff"><td colspan="9" align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">订单总金额：';
								html += currency_0(data.order.AMOUNT,true); 
    							html += '&nbsp;&nbsp;+&nbsp;&nbsp;运费：';
								html += currency_0(data.order.FREIGHT,true);
								html += '&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;已支付金额：';
								html += currency_0(data.alPayNum.alSum,true);
								html += '&nbsp;&nbsp;(';
								if(data.alPayNum.coup != 0){
									html += '&nbsp优惠：';
									html += currency_0(data.alPayNum.coup,true);
								}
								if(data.alPayNum.point != 0){
									html += '&nbsp;&nbsp;积分：';
									html += currency_0(data.alPayNum.point,true);
								}
								if(data.alPayNum.ol != 0){
									html += '&nbsp;&nbsp;银行卡：';
									html += currency_0(data.alPayNum.ol,true);
								}
								if(data.alPayNum.acc != 0){
									html += '&nbsp;&nbsp;余额：';
									html += currency_0(data.alPayNum.acc,true);
								}
	
    							html += '&nbsp;)</td></tr>';
    							html += '<tr><td colspan="5" align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">物恋网  WWW.11WLW.CN，全国统一服务热线：400-6699-008</td><td colspan="4"align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">应支付总金额：';
								html += currency_0(data.order.AMOUNT + data.order.FREIGHT - data.alPayNum.alSum,true);
    							html += '&nbsp;&nbsp;&nbsp;</td></tr>';
    							html += '</tbody><tfoot><tr><td colspan="9" height="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注：';
    							if(data.order.REMARK != null){
									html += data.order.REMARK;
								}
    							html += '</td></tr><tr><td colspan="4" height="10"></td></tr><tr><td colspan="2" align="right">送货员：</td><td colspan="5" align="right">客户签字： </td></tr><tr><td colspan="9" height="10"></td></tr>';
    							html += '</tfoot></table></div>';
								
								$("#currentPrint").append(html);
								//直接打印
								prn1_print(data.order.PK_NO,data.order.ORDER_TYPE,data.order.LNAME); 
								//打印预览
								//prn1_preview(data.order.PK_NO,data.order.ORDER_TYPE,data.order.LNAME);
						}else{
							top.$.jBox.tip('系统错误', 'error');
	 						return false;
						}
					  }
				   });
				}				
			});
		//预览功能
    	function prn1_preview(pkNo,type,vName) {
       		PrintMytable(pkNo,type,vName);
        	LODOP.PREVIEW();
    	};
						
		//打印后自动更改订单状态
		function autoUpdateStatus(pkNo,type){
			 $.ajax({
				url:'${base}/order/autoUpdateStatus.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'pkNo':pkNo,
					'type':type,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					$('#grid-table').trigger("reloadGrid");
				}
			  });	
			} 
			   	
    	//直接打印功能
    	function prn1_print(pkNo,type,vName) {
       		PrintMytable(pkNo,type,vName);
			if (LODOP.PRINT()){
				autoUpdateStatus(pkNo,'WAITDELIVER');
			}else{ 
		   		alert("打印操作出现错误！！"); 
		   	}       		
    	};
    	//打印表格功能的实现函数
    	function PrintMytable(pkNo,type,vName) {
        	LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        	LODOP.PRINT_INIT("打印工作名称");
        	LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
        	LODOP.SET_PRINT_PAGESIZE(1,"210mm",argument,"");
        	LODOP.ADD_PRINT_TEXT(30, 200, 500, 30, "物恋网·"+vName+"送货单("+type+")");
        	LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        	LODOP.SET_PRINT_STYLEA(1, "FontSize", 14);
        	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        	LODOP.ADD_PRINT_TEXT(35, 50, 200, 22, "第#页/共&页");
        	LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        	LODOP.ADD_PRINT_TABLE(115+rowHight, "0%", "100%","100%", document.getElementById("printdiv_b_"+pkNo).innerHTML);
       	 	LODOP.ADD_PRINT_HTM(58, "0%", "100%", "100%", document.getElementById("printdiv_h_"+pkNo).innerHTML);
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.ADD_PRINT_BARCODE(26,650,120,95,"QRCode",pkNo);//二维码各参数含义(Top,Left,Width,Height,BarCodeType,BarCodeValue);	
			LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",3);//二维码版本
			LODOP.SET_PRINT_STYLEA(0,"QRCodeErrorLevel","L");//二维码识别容错等级（L/M/H）
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.SET_PRINT_STYLEA(0,"LinkedItem",1);
    	};
	});
	//批量发货
		function orderPicking(){
			var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
			if(ids==""){
				top.$.jBox.tip('未选择数据，不可提交！','error');
				return false;
			}
			$.jBox.confirm("确认执行操作?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : "${base}/warehouse/allPicking.jhtml",
						type :'post',
						dataType : 'json',
						data : 'pkno=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
								data, function(s) {
									if (s) {
										top.$.jBox.tip(data.msg,'success');
										mgt_util.refreshGrid("#grid-table");
									}
								});
							}
						});
					}
				})
			} 
</script>
</head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1 main_controls1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form"> 
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist" style="overflow:hidden;position:inherit;">
							<li role="presentation" id="WAITDELIVER" class="sub_status_but active"><a href="#"> 待发货订单</a></li>					
							<li role="presentation" id="DELIVERED" class="sub_status_but"><a href="#"> 已发货订单</a></li>						
							<li role="presentation" id="SUCCESS" class="sub_status_but"><a href="#"> 已完成订单</a></li>
						</ul>
					</div>
					<div class="currentDataDiv_tit">
						<span class="open_btn" id="advanced_search"></span>
						<button type="button" class="btn_divBtn edit"  id="order_inprocess" data-toggle="jBox-location" href="${base}/warehouse/viewmap.jhtml" >查看位置 </button>
						<div class="form-group" style="margin-right:5px;">
						<button type="button" class="btn_divBtn edit"  id="order_stop" data-toggle="jBox-change-order" href="${base}/warehouse/cancelorder.jhtml" style="float:right; margin-left:5px; display:inline;">终止订单</button>
						<button type="button" class="btn_divBtn"  id="print_again" style="margin-left:5px;">再次打印 </button>
					</div>
						<button type="button" class="btn_divBtn sr-only"  id="order_deliver" onclick="orderPicking()">批量发货</button>
					<a class="btn_divBtn sr-only edit"  id="order_print" >批量打印 </a>
					<div class="control">
						<label class="radio"><input class="control_rad" type="radio" name="sub_status_radio" value="WAITPRINT" id="userCheck" checked="checked"><span>待打印</span></label>
						<label class="radio"><input class="control_rad" type="radio" name="sub_status_radio" value="WAITDELIVER"  ><span>待发货</span></label>
					</div>
					<div id="pickcheck" class="radio">&nbsp;&nbsp;&nbsp;&nbsp;<input class="control_rad" name="pickedCheckbox" type="checkbox"/>&nbsp;<span>已拣货完成的订单</span></div>
					</div>
					<div class="search_cBox">
						<div class="form-group">
		                 	<button type="button" class="btn_divBtn sr-only" id="suporder_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
	                </div>
	            	<div class="form_divBox">
						<div class="form-group" style="float:left;margin-right:0;" >
							<label class="control-label">订单号：</label>
							<input type="text" class="form-control" name="masNo" style="width:120px;">
						</div>
						<div class="form-group" style="float:left;margin-right:0;">
							<label class="control-label">店铺：</label>
							<input type="text" class="form-control" name="shopName" id="shopName" style="width:80px;" >
						</div>
					</div>
					
	        		<div class="form_divBox">
		                <div id="finishSt" class="">
		                	<table class="finishS_tab">
		                		<tr>
		                			<td width="260" align="left"><label class="control-label" style="padding-right:5px;">路线：</label>
										<input type="text" class="form-control" name="routeName" id="routeName" style="width:130px;" >
									</td>
		                			<td align="left"><label class="control-label">区域：</label>
										<input type="hidden" name="areaId" id="areaId" >
									</td>
		                		</tr>
		                	</table>
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" id="stock_search" data-toggle="jBox-query">搜 索 </button>
						</div>
	        		</div>
	            </form>
	        </div>
	       <div id="currentPrint">
	       </div>
	      </div>
	      <div style="clear:both;"></div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {

		//区域选择下拉框
  		$().ready(function() {
  			var $areaId = $("#areaId");
  			// 文章类型选择
			$areaId.lSelect({
			url: "${base}/common/area.jhtml"
			});
		});
		
		var butten = function(){ //循环为每一行添加业务事件 
			var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
			for(var i=0; i<ids.length; i++){ 
				var id=ids[i]; 
				detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderdeliver.jhtml'>明细 </button>";
				detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderpicking.jhtml'>发货</button>";
				//var rowData = $('#grid-table').jqGrid('getRowData',ids[i]);
				//var arryre = rowData.REMARKS1.split('^');
				//if(arryre[0] == 'Y'){
					//detail = detail + "<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/warehouse/cancelorder.jhtml'>终止订单 </button>";
				//}
				jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
			};
			//table数据高度计算
			cache=$(".ui-jqgrid-bdivFind").height();
			tabHeight($(".ui-jqgrid-bdiv").height()); 
		} 
		
		var butten2 = function(){ //循环为每一行添加业务事件 
			var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
			for(var i=0; i<ids.length; i++){ 
				var id=ids[i]; 
				detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderdeliver.jhtml'>明细 </button>";
				jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
			};
			//table数据高度计算
			cache=$(".ui-jqgrid-bdivFind").height();
			tabHeight($(".ui-jqgrid-bdiv").height());
		}
	
	    // 子状态单选框事件，改变隐藏域select值并提交表单
	    $('input[name=sub_status_radio]').on("click",function(){
	    	var checkVal;
	    	// 控制“打印”按钮
	    	if("WAITPRINT" == $(this).val()){
	    		if($('input[name=pickedCheckbox]').attr("checked")){
	    			checkVal = 'Y';
	    		}else{
	    			checkVal = 'N';
	    		}
	    		$("a#order_print").removeClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		$("#order_deliver").addClass("sr-only");
	    		var postData={sub_status_radio:"WAITPRINT",statusFlg:"WAITDELIVER",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
	    		.trigger("reloadGrid");
	    	}else{
	    		if($('input[name=pickedCheckbox]').attr("checked")){
	    			checkVal = 'Y';
	    		}else{
	    			checkVal = '';
	    		}
	    		$("a#order_print").addClass("sr-only");
	    		$("#print_again").removeClass("sr-only");
	    		$("#order_deliver").removeClass("sr-only");
	    		var postData={sub_status_radio:"",statusFlg:"WAITDELIVER",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten}).trigger("reloadGrid");
	    	}
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=subStatus]").val($(this).val());
	        $("#suporder_search").click(); 
	    });	
	    
	    // 子状态(“已拣货订单”)单选框事件，改变隐藏域select值并提交表单
	    $('input[name=pickedCheckbox]').on("click",function(){
	    	var checkVal;
	    	if($('input[name=pickedCheckbox]').attr("checked")){
	    		checkVal = 'Y';
	    	}else{
	    		checkVal = '';
	    	}
	    	var temp = $('input[name="sub_status_radio"]:checked').val();
	    	// 控制“打印”按钮
	    	if("WAITPRINT" == temp){
	    		$("a#order_print").removeClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		var postData={sub_status_radio:"WAITPRINT",statusFlg:"WAITDELIVER",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
	    		.trigger("reloadGrid");
	    	}else{
	    		$("a#order_print").addClass("sr-only");
	    		$("#print_again").removeClass("sr-only");
	    		var postData={sub_status_radio:"",statusFlg:"WAITDELIVER",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten}).trigger("reloadGrid");
	    	}
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=subStatus]").val($(this).val());
	        $("#suporder_search").click(); 
	    });	
	
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("WAITDELIVER" == $(this).attr("id")){
	    		$("#order_deliver").addClass("sr-only");
	    		$("button#order_inprocess").removeClass("sr-only");
	    		$("button#order_stop").removeClass("sr-only");
	    		$("a#order_print").removeClass("sr-only");
	    		$("div.control").removeClass("sr-only");
	    		$("#pickcheck").removeClass("sr-only");
	    		$("#userCheck").attr("checked","checked");
	    		$("#print_again").addClass("sr-only");
	    	}else{
	    		$("#order_deliver").addClass("sr-only");
	    		$("button#order_inprocess").addClass("sr-only");
	    		$("button#order_stop").addClass("sr-only");
	    		$("div.control").addClass("sr-only");
	    		$("#pickcheck").addClass("sr-only");
	    		$('input[name=pickedCheckbox]').removeAttr("checked");
	    		$("a#order_print").addClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("select[name=subStatus]").val("");
	    	// 切换table时， 清空搜索框
	    	$("input[name=masNo]").val('');
	    	$("input[name=shopName]").val('');
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#suporder_search").click(); 
	        
          	var idVal=$(this).attr('id');
  			$('#grid-table').GridUnload();//重绘
	    	if(idVal=='DELIVERED' || idVal=='SUCCESS'){
	    		var postData={orderby:'CREATE_DATE',statusFlg:idVal};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/orderlist.jhtml',
 					colNames:['','','订单编号','店铺名称','地址','电话','金额','分拣状态','下单日期','操作'],
 					rowList:[10,20,50],
				   		colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'ORDER_TYPE',index:'ORDER_TYPE',width:0,hidden:true},
				   		{name:'MAS_NO',align:"center",width:220},
				   		{name:'CUST_NAME',align:"center",width:180},
				   		{name:'RECEIVER_ADDRESS',align:"center",width:180},
				   		{name:'RECEIVER_MOBILE',align:"center",width:180},
				   		{name:'AMOUNT',align:"center",width:80},
				   		{name:'PICK_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='N'){
								return '未分拣';
							}else if(data=='A'){
								return '分拣中';
							}else if(data=='Y'){
								return '分拣完成';
							}else{
								return '分拣完成';
							}
	   					}},
				   		{name:'OM_CREATE_DATE',align:"center",width:180},
				   		{name:'detail',index:'PK_NO',width:180,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderdeliver.jhtml'>明细 </button>";
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							var orderType = rowData.ORDER_TYPE;
							if(idVal=='DELIVERED' && 'FBP' != orderType){
								detail = detail + "<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderpicking.jhtml'>修改 </button>";
							}
							if(idVal=='DELIVERED' && 'FBP' == orderType){
								detail = detail + "<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/warehouse/canceldeliver.jhtml'>撤销 </button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});	  
	    	}else{
	    		var postData={orderby:"CREATE_DATE",statusFlg:"WAITDELIVER",sub_status_radio:"WAITPRINT"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/orderlist.jhtml',
 					colNames:['','默认线路111','区域1+区域2+区域3','订单编号','订单类型','店铺名称','分拣状态','下单日期','备注','操作'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'ROUTE_NAME',align:"center",width:90},
				   		{name:'OM_AREA',align:"center",width:90},
				   		{name:'MAS_NO',align:"center",width:172},
				   		{name:'ORDER_TYPE',align:"center",width:50},
				   		{name:'CUST_NAME',align:"center",width:122},
				   		{name:'PICK_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='N'){
								return '未分拣';
							}else if(data=='A'){
								return '分拣中';
							}else if(data=='Y'){
								return '分拣完成';
							}else{
								return '分拣完成';
							}
	   					}},
				   		{name:'OM_CREATE_DATE',align:"center",width:150},
				   		{name:'REMARKS',align:"center",width:150},
				   		{name:'detail',index:'PK_NO',width:120,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/orderdeliver.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
	    	}
	    });
	});
</script>
</html>