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
	<body>
		<form style="padding:0;" class="form-horizontal" id="form" action="${base}/warehouse/picking.jhtml" >
			<input id="items" name="items" type="hidden">
			<input id="id" name="id" type="hidden" value="${order.get("PK_NO")}">
		</form>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-red btn-danger" data-toggle="jBox-call"
				data-fn="checkForm">
				发货
				<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-red" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>		
[#if order?exists]		
<div class="page-content">
    <div style="width:100%;overflow:hidden;padding-bottom:40px;"> 
      <div>
        <table width="100%" border="0" class="print_detail tr">
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
        <td><strong>实际发货数</strong></td>
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
	    [#if item.QTY1 != ""]
	    	<td width="126" style="border-right:1px solid #000;"><span><input name="qty" type="text" class="deliverQty" style="width:50px" align="middle" pkno="${item.PK_NO}" qtypre="${item.QTY1}" value="${item.QTY1}">&nbsp;&nbsp;${item.UOM}</span>
	    [#else]
	    	<td width="126" style="border-right:1px solid #000;"><span><input name="qty" type="text" class="deliverQty" style="width:50px" align="middle" pkno="${item.PK_NO}" qtypre="${item.UOM_QTY}" value="${item.UOM_QTY}">&nbsp;&nbsp;${item.UOM}</span>
	    [/#if]	    
	    </td>
	  </tr>
	  [/#list]
      
    </tbody>
  </table>
      </div>
    </div>
</div>
[#else]暂无订单数据
[/#if]
<!--打印+预览按钮div-->
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	</body>
<script type="text/javascript">
 	function checkForm(){
		var str = "";
		var object = document.getElementsByName("qty");
		 for ( var  i = 0 ;i < object.length;i ++ ){
			if(object[i].value  == ''){
				top.$.jBox.tip('发货数量不能为空');
				return false;
			}
			if(/\D/.test(object[i].value)){
				top.$.jBox.tip('请输入正确数量！');
				return false;
			}	
			if(Number(object[i].value) > Number(object[i].getAttribute("qtypre"))){
				top.$.jBox.tip('发货数量不能大于订单数量');
				return false;
			}
			if(i != object.length-1){
				str =str + object[i].getAttribute('pkno')+","+object[i].value+";";
			}else{
				str =str + object[i].getAttribute('pkno')+","+object[i].value;
			}
		 }
		$("#items").val(str);
		
		$.ajax({
		url:"${base}/warehouse/orderremarks.jhtml?id="+$("#id").val(),
		async:true,
		success:function(data) {
			var remarks = data.remarks;
			var arryre = remarks.split('^');
			if(arryre[0] == 'N'){
				top.$.jBox.tip(arryre[1]);
				return false;
			}else{
				mgt_util.submitForm('#form');
			}
		}
		});
	}
</script>
</html>