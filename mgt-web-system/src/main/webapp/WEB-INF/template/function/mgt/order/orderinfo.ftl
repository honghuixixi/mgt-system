<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商户管理-订单管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				var argument;//打印参数全局变量
    			var LODOP; //打印函数全局变量 
    			var barCodeValue; //订单二维码 
    			//新增行高值
	    		var rowHight =0;
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/list.jhtml',
 					colNames:['','订单编号','状态','订单金额','收货人名称','收货人手机','配送方式','下单日期','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '待发货';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='RETURNSING'){
								return '退单中';
							}else if(data=='SUCCESS'){
								return '交易成功';
							}else if(data=='CLOSE'){
								return '交易关闭';
							}else if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='WAITPAYMENT'){
								return '待支付';
							}else{
								return data;
							}
	   					}},
					   	{name:'', width:100,formatter:function(value,row,index){
					   		if(index.MISC_PAY_AMT != null&&index.PAY_AMOUNT != null){
								return ''+(index.AMOUNT+index.FREIGHT-index.MISC_PAY_AMT-index.ALPAY)+'';
							}else if(index.MISC_PAY_AMT != null&&index.PAY_AMOUNT == null){
								return ''+(index.AMOUNT+index.FREIGHT-index.MISC_PAY_AMT)+'';
							}else if(index.MISC_PAY_AMT == null&&index.PAY_AMOUNT != null){
								return ''+(index.AMOUNT+index.FREIGHT-index.ALPAY)+'';
							}else{
								return ''+(index.AMOUNT+index.FREIGHT)+'';
						  	}
						  }
						},   					
				   		{name:'RECEIVER_NAME',align:"center",width:90},
				   		{name:'RECEIVER_MOBILE',align:"center",width:120},
				   		{name:'STM_NAME',width:110,align:"center", editable:true},
				   		{name:'OM_CREATE_DATE',width:150,align:"center", editable:true},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/order/orderDetailUI.jhtml'>详情 </button>";
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
								//预览
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
    	//直接打印功能
    	function prn1_print(pkNo,type,vName) {
       		PrintMytable(pkNo,type,vName);
			LODOP.PRINT();   		
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
</script>		
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" style="padding:0px 0 0 10px;">
				<div style="display:block;" class="form_divBox">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">订单编号</label>
		                    <input type="text" class="form-control" name="masNo" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">订单状态</label>
		                    <select class="form-control" name="statusFlg">
		                        <option value="">全部</option>
		                        <option value="WAITDELIVER">待发货</option>
		                        <option value='DELIVERED'>已发货</option>
		           <!--         <option value='RETURNSING'>退单中</option>   -->
		                        <option value='SUCCESS'>交易成功</option>
		                        <option value='CLOSE'>交易关闭</option>
		                        <option value='INPROCESS'>处理中</option>
		                        <option value='WAITPAYMENT'>待支付</option>
		                    </select>
		                </div>
		            </form>
	            </div>
	            <div id="currentPrint">
	       		</div>
		        <div class="search_cBox">
			        <div class="form-group">
	                 	<button type="button" class="btn_divBtn" id="order_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	          <!--      <a class="btn btn-info edit" id="print_all" style="float:right; margin-left:400px; display:inline-block;">批量打印 </a>				-->
	                </div>
                </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>