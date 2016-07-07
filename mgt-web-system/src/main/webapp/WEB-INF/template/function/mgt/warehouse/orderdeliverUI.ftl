<!DOCTYPE html>
<html>
	<head>
		<title>角色修改</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="" >
			<input type="hidden"id="id" name="id"  value="${order.PK_NO}" >
		</form>
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
					<div class="btn-group">
			<!--		<button  id="preview" class="btn btn-red">
							打印
						</button>
			-->
					</div>
				</div>
			</div>			
[#if order?exists]		
<div class="page-content">
    <div class="safe_right"> 
      <div>
        <table width="670" border="0" class="print_detail tr">
          <tr>
              <td width="200">
                 <p class="p_no1">订单编号：</p>
                 <p class="p_no2">${order.get("MAS_NO")}</p>
              </td>
              <td width="200">
                 <p class="p_no1">订单状态：</p>
                 <p class="p_no2" style="text-align:left;">
			     [#import "/function/mgt/order/orderMacro.ftl" as orderStatus]
			     [@orderStatus.chinesesTatus status='${order.get("STATUS_FLG")}' /]
              </p>
            </td>
          </tr>
          <tr>
            <td width="200">
              <p class="p_no1">下单时间：</p>
              <p class="p_no2">${order.get("OM_CREATE_DAT")}</p>
            </td>
            <td width="200"><p class="p_no1">配送方式：</p>
              <p class="p_no2">[#if order.get("DELIVERY_TYPE") == "L"]快递[#else]自提[/#if]</p>
            </td>
          </tr>
          <tr>
            <td width="200"><p class="p_no1">收 货 人：</p>
              <p class="p_no1">${order.get("RECEIVER_NAME")}</p></td>
            <td width="200">
				[#if order.get("RECEIVER_MOBILE")?exists  && order.get("RECEIVER_MOBILE") != 'null']
					<p class="p_no1">联系电话：</p><p class="">${order.get("RECEIVER_MOBILE")}</p>
				[#else]
					<p class="p_no1">固定电话：</p><p class="">${order.get("RECEIVER_TEL")}</p>
				[/#if]
            </td>
          </tr>
          <tr>
             <td colspan="2"><p class="p_no1">支付方式：</p>
              <p class="p_no2" style="width:500px;">${order.get("STM_NAME")}[#if order.get("DELIVERY_TYPE") == "S"](${order.get("SC_ADDRESS")})[/#if]</p></td>
          </tr>
          <tr>
            <td colspan="2" width="670"><p class="p_no1">收货地址：</p>
              <p class="p_no2" style="width:500px;">${order.get("RECEIVER_ADDRESS")}</p></td>
          </tr>
        </table>
        <table class="price_bill" cellpadding="0" cellspacing="0" >
    <thead>
      <tr height="25">
        <td><strong>编码</strong></td>
        <td><strong>图片</strong></td>
        <td><strong>商品名称</strong></td>
        <td><strong>价格</strong></td>
        <td><strong>数量</strong></td>
        [#if order.get("STATUS_FLG") == "SUCCESS"]
         <td><strong>实际发货数</strong></td>
        <td><strong>实际收货数</strong></td>
        [#elseif order.get("STATUS_FLG") == "DELIVERED"]
         <td><strong>实际发货数</strong></td>
        [/#if]
      </tr>
    </thead>
    <tbody>
	  [#list order.get("orderItem") as item]
	  <tr height="60">
	    <td width="100"><span>${item.ITEM_NO}</span></td>
	    <td width="101"><img src="${item.PRODUCT_THUMBNAIL}" height="60" width="60" alt="商品图片" /></td>
	    <td width="201">${item.STK_NAME}</td>
	    <td width="126"><span class="color_1">￥${item.NET_PRICE?string("0.00")}</span></td>
	    <td width="126" style="border-right:1px solid #ccc;"><span>${item.UOM_QTY}${item.UOM}</span></td>
	    [#if order.get("STATUS_FLG") == "DELIVERED"]
	     <td width="126" style="border-right:1px solid #ccc;"><span>${item.QTY1}&nbsp;&nbsp;${item.UOM}</span>
	    </td>
	    [#elseif order.get("STATUS_FLG") == "WAITDELIVER"]
	    	<td width="126" style="border-right:1px solid #ccc;"><span><input name="qty" type="text" class="deliverQty" style="width:50px" align="middle" pkno="${item.PK_NO}" qtypre="${item.UOM_QTY}" value="${(item.QTY1??)?string(item.QTY1,item.UOM_QTY)}">&nbsp;&nbsp;${item.UOM}</span>
	    [#elseif order.get("STATUS_FLG") == "SUCCESS"]
	    	<td width="126" style="border-right:1px solid #ccc;"><span>${item.QTY1}&nbsp;&nbsp;${item.UOM}</span>
	    	<td width="126" style="border-right:1px solid #ccc;"><span>${item.QTY2}&nbsp;&nbsp;${item.UOM}</span>
	    [/#if]
	  </tr>
	  [/#list]
    </tbody>
  </table>
      </div>
    </div>
</div>
[#else]暂无订单数据
[/#if]
<!--打印订单预览div-->
<div style="display:none">     
	[@orderStatus.OrderPrint print=order couponMas=couponMas/]
</div>
<!--打印+预览按钮div-->
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	</body>
<script type="text/javascript">
	$().ready(function() {
	    var argument;//打印参数全局变量
	    var pkNo = ${order.get("PK_NO")};
    	var LODOP; //打印函数全局变量 
    	var barCodeValue = pkNo; //订单条形码值 
		//打印+预览按钮js
		$("#preview").click(function() {
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
				//prn1_preview(pkNo);	//打印预览+打印
        		prn1_print(pkNo);	//直接打印
			});
		//打印预览功能
    	function prn1_preview() {
       		PrintMytable();
        	LODOP.PREVIEW();
    	};
  						
		//更改订单状态
		function autoEditStatus(pkNo,type){
			 $.ajax({
				url:'${base}/order/autoEditStatus.jhtml',
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
    	function prn1_print(pkNo) {
       		PrintMytable();
			if (LODOP.PRINT()){
				autoEditStatus(pkNo,'VENDORPRINT');
			}else{ 
		   		alert("打印操作出现错误！！"); 
		   	}       		
    	};
    	//打印表格功能的实现函数
    	function PrintMytable() {
        	LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        	LODOP.PRINT_INIT("打印工作名称");
        	LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
        	LODOP.SET_PRINT_PAGESIZE(1,"210mm",argument,"");
        	LODOP.ADD_PRINT_TEXT(30, 310, 300, 30, "千平万安送货单");
        	LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        	LODOP.ADD_PRINT_TEXT(42, 630, 200, 22, "第#页/共&页");
        	LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        	LODOP.ADD_PRINT_TABLE(165, "0%", "100%","100%", document.getElementById("printdiv_b").innerHTML);
       	 	LODOP.ADD_PRINT_HTM(58, "0%", "100%", "100%", document.getElementById("printdiv_h").innerHTML);
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.ADD_PRINT_BARCODE(60,620,120,95,"QRCode",barCodeValue);//二维码各参数含义(Top,Left,Width,Height,BarCodeType,BarCodeValue);	
			LODOP.SET_PRINT_STYLEA(0,"QRCodeVersion",3);//二维码版本
			LODOP.SET_PRINT_STYLEA(0,"QRCodeErrorLevel","L");//二维码识别容错等级（L/M/H）
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.SET_PRINT_STYLEA(0,"LinkedItem",1);
    	};
 	}); 
</script>
</html>