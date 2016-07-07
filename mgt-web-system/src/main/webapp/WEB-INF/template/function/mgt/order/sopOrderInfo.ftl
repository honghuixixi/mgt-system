<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-SOP订单管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;margin-top:4px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
				//新增行高值
	    		var rowHight =0;
				var statusFlg = $(".active").attr("id");
				var postData={orderby:"CREATE_DATE",statusFlg:statusFlg,sub_status_radio:""};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/sopOrderList.jhtml',
 					colNames:['','订单编号','状态','订单金额','店铺名称','分拣状态','支付方式','下单日期','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '未接收';
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
				   		{name:'AMOUNT',width:100,align:"center", editable:true, formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   		{name:'CUST_NAME',align:"center",width:220},
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
				   		{name:'STM_NAME',align:"center",width:120},
				   		{name:'OM_CREATE_DATE',width:150,align:"center", editable:true},
				   		{name:'', width:80,align:"center",formatter:function(value,row,index){
				   			if(index.STM_NAME =='货到付款'){
								   	if(index.STATUS_FLG =='WAITDELIVER'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">修改</button>&nbsp;'
									}else if(index.STATUS_FLG =='INPROCESS'){
										if(index.SUB_STATUS =='WAITDELIVER'){
											return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">修改 </button>&nbsp;'+'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderPicking.jhtml">发货</button>';
										}else{
											return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">修改</button>&nbsp;'
										}
									}else if(index.STATUS_FLG =='DELIVERED'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细</button>&nbsp;'+'<button type="button" class="btn btn-info del"    onClick=editSopStatus("'+index.PK_NO+'","INPROCESS")   href="${base}/order/editSopStatus.jhtml">撤销</button>';
									}
							}else{
									if(index.STATUS_FLG =='WAITDELIVER'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细</button>&nbsp;'
									}else if(index.STATUS_FLG =='INPROCESS'){
										if(index.SUB_STATUS =='WAITDELIVER'){
											return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细 </button>&nbsp;'+'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderPicking.jhtml">发货</button>';
										}else{
											return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细</button>&nbsp;'
										}
									}else if(index.STATUS_FLG =='DELIVERED'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细</button>&nbsp;'+'<button type="button" class="btn btn-info del"    onClick=editSopStatus("'+index.PK_NO+'","INPROCESS")   href="${base}/order/editSopStatus.jhtml">撤销</button>';
									}
							}
							if(index.STATUS_FLG =='SUCCESS'){
								return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/sopOrderDetailUI.jhtml">明细</button>&nbsp;'
							}
						  }
						},
				   	],
				});
				$(".change-ul li").click(function(){
						$(".change-ul li").removeClass("cur");
						$(this).addClass("cur");
				});
				$("input").blur(function(){
						$(".change-ul li").removeClass("cur");
				});
				$("select").blur(function(){
						$(".change-ul li").removeClass("cur");
				});
			tabHeight();
				
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
	
	var format = function(time, format){
			    var t = new Date(time);
			    var tf = function(i){return (i < 10 ? '0' : '') + i};
			    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
			        switch(a){
			            case 'yyyy':
			                return tf(t.getFullYear());
			                break;
			            case 'MM':
			                return tf(t.getMonth() + 1);
			                break;
			            case 'mm':
			                return tf(t.getMinutes());
			                break;
			            case 'dd':
			                return tf(t.getDate());
			                break;
			            case 'HH':
			                return tf(t.getHours());
			                break;
			            case 'ss':
			                return tf(t.getSeconds());
			                break;
			        }
			    })
			}
				function getWeek(){
				var myDate = new Date();
				var date = new Date(myDate-(myDate.getDay()-1)*86400000);
				var dateOne = date.getTime()-7*24*60*60*1000;//上周一
				var dateSeven = date.getTime()-24*60*60*1000;//上周日
				form1.startDate.value=format(dateOne, 'yyyy-MM-dd');
				form1.endDate.value=format(dateSeven, 'yyyy-MM-dd');
				var startDate = $("input[name='startDate']").val();
		        var endDate = $("input[name='endDate']").val();
		        var postData={statusFlg:"SUCCESS",startDate:startDate,endDate:endDate};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData}).trigger("reloadGrid");
				}
				
				function getLastMonth(){
					var date=new Date();//上个月第一天
				    date.setFullYear(date.getFullYear());
				    date.setMonth(date.getMonth()-1);
					date.setDate(1);
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
					var date1=new Date();//上个月最后一天
			        date1.setFullYear(date1.getFullYear());
			        date1.setMonth(date1.getMonth());
					date1.setDate(0);
					form1.endDate.value = format(date1.getTime(), 'yyyy-MM-dd');
					var startDate = $("input[name='startDate']").val();
			        var endDate = $("input[name='endDate']").val();
			        var postData={statusFlg:"SUCCESS",startDate:startDate,endDate:endDate};
		    		$('#grid-table').jqGrid('setGridParam',{postData:postData}).trigger("reloadGrid");
				}
				
				function getMonth(){
					var date=new Date();//今天
					form1.endDate.value = format(date.getTime(), 'yyyy-MM-dd');
				 	date.setDate(1);//当前月的第一天
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
				}
				
				function getMonths(){
				getMonth();
				var startDate = $("input[name='startDate']").val();
		        var endDate = $("input[name='endDate']").val();
		        var postData={statusFlg:"SUCCESS",startDate:startDate,endDate:endDate};
        		$('#grid-table').jqGrid('setGridParam',{postData:postData}).trigger("reloadGrid");
				}
				
		//批量完成订单
		function orderUpdate(){
			var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
			if(ids==""){
				top.$.jBox.tip('未选择数据，不可提交！','error');
				return false;
			}
			$.jBox.confirm("确认执行操作?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : "${base}/order/sopOrderUpdate.jhtml",
						type :'post',
						dataType : 'json',
						data : 'pkno=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
								data, function(s) {
									if ("1"==data.code) {
										top.$.jBox.tip('成功完成订单！','success');
										mgt_util.refreshGrid("#grid-table");
									}else if("2"==data.code){
										top.$.jBox.tip('存在已绑定物流人员的订单！','error');
									}
								});
							}
						});
					}
				})
			} 
	
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
						url : "${base}/order/sopAllPicking.jhtml",
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
          <div class="main_heightBox1"  style="display:block;">
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" style=" overflow:hidden" id="query-form"  name="form1">
					<div class="control-group sub_status" style="position:relative;">
						<div class="form-group sr-only" >
		                    <select class="form-control" name="statusFlg" id ="sssssss">
		                        <option value="WAITDELIVER">待接收订单</option>
		                        <option value="INPROCESS">待发货订单</option>
		                        <option value='DELIVERED'>已发货订单</option>
		                        <option value='SUCCESS'>已完成订单</option>
		                    </select>
	                	</div>					
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="WAITDELIVER" class="sub_status_but active"><a href="#">待接收订单</a></li>					
							<li role="presentation" id="INPROCESS" class="sub_status_but"><a href="#">待发货订单</a></li>
							<li role="presentation" id="DELIVERED" class="sub_status_but"><a href="#">已发货订单</a></li>
							<li role="presentation" id="SUCCESS" class="sub_status_but"><a href="#">已完成订单</a></li>				
						</ul>
					</div>
					<div class="currentDataDiv_tit">
					<div id="date" class="sr-only">
           			<ul class="change-ul" style="list-style:none;">
						<li  onClick="getWeek()">上周</li>
						<li  onClick="getLastMonth()">上个月</li>
						<li class="cur" style="margin-right:10px;"  onClick="getMonths()">本月</li>
					</ul>
	                 <div class="form-group">
						<label class="control-label" style="margin-top:0;">订单时间:</label>
						<input  style="margin-top:0;width:90px;"  type="text" class="form-control" id="startDate" name="startDate" value="${startDate}" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
					 </div>
					 <div class="form-group">
						<span class="control-label"  style="margin-top:0;" >至</span>
						<input  style="margin-top:0;width:90px;"  type="text" class="form-control" id="endDate" name="endDate" value="${endDate}" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
					 </div>
					 <div class="form-group">
		                    <label class="control-label" style="margin-top:0;" >订单编号:</label>
		                    <input style="margin-top:0;width:90px;" type="text" class="form-control"  name="masNo" style="width:170px;">
		                </div>
		                <!--
		                <div class="form-group">
		                    <select class="form-control required" id="userNo" name="userNo" style="width:120px;margin-top:0;">
								<option value="">全部店铺</option>
							[#if list ??]
						         [#list list as user]
			                          <option value='${user.USER_NO}'>${user.CUST_NAME}</option>
								[/#list]
							[/#if]
							</select>
		                </div>
		                -->
		                <div class="form-group">
		                    <label class="control-label" style="margin-top:0;" >店铺名称:</label>
		                    <input style="margin-top:0;width:90px;" type="text" class="form-control"  name="userNo" id="userNo" style="width:170px;">
		                </div>
					<div class="search_cBox">
						<button type="button" class="search_cBox_btn sr-only" id="soporder_search" data-toggle="jBox-query">搜 索 </button>
	                </div>
					 </div>
					 <div class="form-group" style="margin-right:5px;">
						<button type="button" class="btn_divBtn edit"  id="order_inprocess" data-toggle="jBox-change-order" href="${base}/order/editStatus.jhtml?type=VENDORCONFIRM">接收订单 </button>
						<a class="btn_divBtn sr-only edit"  id="order_print" >批量打印 </a>	
						<button type="button" class="btn_divBtn sr-only"  id="order_deliver" onclick="orderPicking()">批量发货</button>
						<button type="button" class="btn_divBtn sr-only"  id="print_again">再次打印 </button>
						<button type="button" class="btn_divBtn sr-only"  id="order_over" data-toggle="jBox-change-order" href="${base}/order/cancelorder.jhtml">取消订单 </button>	
						<button type="button" class="btn_divBtn sr-only"  id="order_single_finish" data-toggle="jBox-edit" href="${base}/order/sopDetailsInfo.jhtml">完成订单</button>	
					</div>
						<button type="button" class="btn_divBtn sr-only"  id="order_finish" onclick="orderUpdate()">批量完成订单 </button>	
						<div class="control sr-only">
							<label class="radio"><input class="control_rad" type="radio" name="sub_status_radio" value="WAITPRINT" id="userCheck" checked="checked"><span>待打印</span></label>
							<label class="radio"><input class="control_rad" type="radio" name="sub_status_radio" value="WAITDELIVER"  ><span>待发货</span></label>
						</div>
						<div id="pickcheck" class="radio sr-only">&nbsp;&nbsp;&nbsp;&nbsp;<input class="control_rad" name="pickedCheckbox" type="checkbox"/>&nbsp;<span>已拣货完成的订单</span>
						</div>
						<div id="tempdate" class="sr-only" style="display:inline;float:right">	
							<div class="form-group">
								<label class="control-label" style="margin-top:0;">订单时间:</label>
								<input  style="margin-top:0;width:90px;"  type="text" class="form-control" id="beginDate"  onfocus="WdatePicker({maxDate:$('#overDate').val(),dateFmt:'yyyy-MM-dd'});" >
							 </div>
							 <div class="form-group">
								<span class="control-label"  style="margin-top:0;" >至：</span>
								<input  style="margin-top:0;width:90px;"  type="text" class="form-control" id="overDate"  onfocus="WdatePicker({minDate:$('#beginDate').val(),dateFmt:'yyyy-MM-dd'});" >
							 </div>
							<a class="btn_divBtn sr-only"  href="#" id="order_trans" url="${base}/order/transOrder.jhtml">导出 </a>
						</div>
						</div>
					</div>
	            </form>
	        </div>
	       <div id="currentPrint">
	       </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
   		<input type="hidden" id="orderProcess" value="">
    </body>
    
<script type="text/javascript">
	$().ready(function() {
	    // 子状态单选框事件，改变隐藏域select值并提交表单
	    $('input[name=sub_status_radio]').on("click",function(){
	    	var checkVal;
	    	// 控制“打印”按钮
	    	if("WAITPRINT" == $(this).val()){
	    		if($('input[name=pickedCheckbox]').attr("checked")){
	    			checkVal = 'Y';
	    		}else{
	    			checkVal = '';
	    		}
	    		$("a#order_print").removeClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		$("#order_deliver").addClass("sr-only");
	    		var postData={sub_status_radio:"WAITPRINT",statusFlg:"INPROCESS",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData})
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
	    		var postData={sub_status_radio:"WAITDELIVER",statusFlg:"INPROCESS",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData}).trigger("reloadGrid");
	    	}
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=subStatus]").val($(this).val());
	        $("#soporder_search").click(); 
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
	    		$("#order_deliver").addClass("sr-only");
	    		var postData={sub_status_radio:"WAITPRINT",statusFlg:"INPROCESS",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData})
	    		.trigger("reloadGrid");
	    	}else{
	    		$("a#order_print").addClass("sr-only");
	    		$("#print_again").removeClass("sr-only");
	    		$("#order_deliver").removeClass("sr-only");
	    		var postData={sub_status_radio:"WAITDELIVER",statusFlg:"INPROCESS",pickCheckValue:checkVal};
	    		$('#grid-table').jqGrid('setGridParam',{postData:postData}).trigger("reloadGrid");
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
	    	if("INPROCESS" == $(this).attr("id")){
	    		//初始化导出的开始结束时间
　　				$("#beginDate").val(new Date().format("yyyy-MM-dd"));
　　				$("#overDate").val(new Date().format("yyyy-MM-dd"));
	    		$("a#order_print").removeClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		$("#order_deliver").addClass("sr-only");
	    		$("#order_over").removeClass("sr-only");
	    		$("#pickcheck").removeClass("sr-only");
	    		$("#order_trans").removeClass("sr-only");
	    		$("#tempdate").removeClass("sr-only");
	    		$("#orderProcess").val("INPROCESS");
	    		$("div.control").removeClass("sr-only");
	    		$("#userCheck").attr("checked","checked");
	    	}else{
	    		$("#order_print").addClass("sr-only");
	    		$("#print_again").addClass("sr-only");
	    		$("#order_deliver").addClass("sr-only");
	    		$("#order_over").addClass("sr-only");
	    		$("#pickcheck").addClass("sr-only");
	    		$("#order_trans").addClass("sr-only");
	    		$("#tempdate").addClass("sr-only");
	    		$("div.control").addClass("sr-only");
	    	}
	    	// 控制“接收订单”按钮
	    	if("WAITDELIVER" == $(this).attr("id")){
	    		$("button#order_inprocess").removeClass("sr-only");
	    		$("button#order_over").addClass("sr-only");
	    		$("#pickcheck").addClass("sr-only");
	    		$("#order_trans").addClass("sr-only");
	    		$("#tempdate").addClass("sr-only");
	    	}else{
	    		$("button#order_inprocess").addClass("sr-only");
	    	}
	    	// 控制“完成订单”按钮
	    	if("DELIVERED" == $(this).attr("id")){
	    		$("button#order_finish").removeClass("sr-only");
	    		$("button#order_single_finish").removeClass("sr-only");
	    		//初始化导出的开始结束时间
　　				$("#beginDate").val(new Date().format("yyyy-MM-dd"));
　　				$("#overDate").val(new Date().format("yyyy-MM-dd"));
	    		$("#order_trans").removeClass("sr-only");
	    		$("#tempdate").removeClass("sr-only");
	    		$("#orderProcess").val("DELIVERED");
	    	}else{
	    		$("button#order_finish").addClass("sr-only");
	    		$("button#order_single_finish").addClass("sr-only");
	    	}
	    	// 控制“已完成订单”按钮
	    	if("SUCCESS" == $(this).attr("id")){
	    		$("#date").removeClass("sr-only");
	    		$("#soporder_search").removeClass("sr-only");
	    		getMonth();
		        }else{
		        $("#date").addClass("sr-only");
	    		$("#soporder_search").addClass("sr-only");
		        }
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#soporder_search").click(); 
	    });
	    
	    	$("#order_trans").click(function(){
					var type = $("#orderProcess").val();
					var beginDate = $("#beginDate").val();
					var overDate = $("#overDate").val();
					var subStatus = $('input[name="sub_status_radio"]:checked').val();
					var url = $(this).attr("url");
					window.location.href=url+'?beginDate='+beginDate+'&overDate='+overDate+'&subStatus='+subStatus+'&type='+type;
				});
	});
	
	 //撤销SOP订单
	 function editSopStatus(obj,status){
	   			$.jBox.confirm("确认撤销订单吗?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在设置数据，请稍等...');
					$.ajax({
						url : '${base}/order/editSopStatus.jhtml',
						type :'post',
						dataType : 'json',
						data : 'id=' + obj+'&status='+status,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								if (s) {
									top.$.jBox.tip('撤销成功！','success');
									mgt_util.refreshGrid($("#grid-table"));
								}
							});
						}
					});
				}
			});
	   }
</script>
</html>