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
		 <script  type="text/javascript">
			function checkForm(){
			var str = "";
			sum = 0;
		var object = document.getElementsByName("uomQty");
		var objectprice = document.getElementsByName("price");
		for ( var  i = 1 ;i < object.length+1;i ++ ){
		 var price = document.getElementById("price"+i).value;
		 var exp = /^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;	
		if( !exp.test(price)){
			top.$.jBox.tip('价格不能为空，价格最多保留两位小数');
			return false;
		}
		 var uomQty = document.getElementById("uomQty"+i).value;
		 sum+=Number(price)*Number(uomQty);
		 }
		 for ( var  i = 0 ;i < object.length;i ++ ){
			if(object[i].value  == ''){
				top.$.jBox.tip('发货数量不能为空');
				return false;
			}
			if(/\D/.test(object[i].value)){
				top.$.jBox.tip('请输入正确数量！');
				return false;
			}
			if(Number(sum) < Number(${order.get("MISC_PAY_AMT")})){
						top.$.jBox.tip('总金额不能小于优惠金额');
						return false;
			}
			if(i != object.length-1){
				str =str + object[i].getAttribute('pkno')+","+object[i].value+","+objectprice[i].value+";";
			}else{
				str =str + object[i].getAttribute('pkno')+","+object[i].value+","+objectprice[i].value;
			}
		 }
		$("#items").val(str);
			mgt_util.submitForm('#form');
			}
		 </script>
	</head>
	<body>
		<form style="width:100%;" class="form-horizontal" id="form" action="${base}/order/editStkQty.jhtml" >
		<input id="items" name="items" type="hidden">
			<input type="hidden"id="id" name="id"  value="${order.PK_NO}" >
			<div class="navbar-fixed-top" id="toolbar">
			[#if (order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="WAITDELIVER")||(order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="INPROCESS")]
				    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm"> 保存
					    <i class="fa-save align-top bigger-125 fa-on-right"></i>
				    </button>
				    [#else]
        	[/#if]
					<button class="btn btn-warning" data-toggle="jBox-close">
						关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
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
             <td width="200"><p class="p_no1">支付方式：</p>
              <p class="p_no2">${order.get("STM_NAME")}[#if order.get("DELIVERY_TYPE") == "S"](${order.get("SC_ADDRESS")})[/#if]</p></td>
          </tr>
          <tr>
            <td colspan="2" width="670"><p class="p_no1">收货地址：</p>
              <p class="p_no2" style="width:500px;">${order.get("RECEIVER_ADDRESS")}</p></td>
          </tr>
          [#if order.get("REMARK") != null]
          <tr>
             <td  colspan="2" width="670">
             	<p class="p_no1">备注：</p>
              	<p class="p_no2" style="width:500px;">${order.get("REMARK")}</p>
             </td>
          </tr>
         [/#if]
        </table>
        <table  id= "tableid" class="price_bill" cellpadding="0" cellspacing="0" >
    <thead>
      <tr height="25">
        <td><strong>编码</strong></td>
        <td><strong>图片</strong></td>
        <td><strong>商品名称</strong></td>
        <td><strong>价格</strong></td>
        <td><strong>订单数量</strong></td>
        [#if (order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="WAITDELIVER")||(order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="INPROCESS")]
        <td><strong>修改订单数量</strong></td>
        [/#if]
        [#if order.get("STATUS_FLG")=="DELIVERED"||order.get("STATUS_FLG")=="SUCCESS"]
        <td><strong>发货数量</strong></td>
        [/#if]
      </tr>
    </thead>
    <tbody>
	  [#list order.get("orderItem") as item]
	  <tr height="60">
	    <td width="50" align="center"><span>${item.ITEM_NO}</span></td>
	    <td width="101" align="center"><img src="${item.PRODUCT_THUMBNAIL}" height="60" width="60" alt="商品图片" /></td>
	    <td width="201" align="center">${item.STK_NAME}</td>
	    
	    <td width="126" align="center" style="border-right:1px solid #000;"><span>￥<input type="text" class="number" style="width:100px;height:25px" [#if showFlg== "Y"] [#else]disabled="disabled"[/#if] pkno="${item.PK_NO}" id="price${item.ITEM_NO}" name="price" value="${item.NET_PRICE?string("0.00")}"/></span></td>
	   
	    <!--<td width="126" id="price${item.ITEM_NO}" align="center" class="color_1">￥${item.NET_PRICE?string("0.00")}</td>-->
	    
	    <td width="126" align="center" style="border-right:1px solid #000;">${item.UOM_QTY}${item.UOM}</td>
	    [#if (order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="WAITDELIVER")||(order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="INPROCESS")]
	    <td width="126" align="center" style="border-right:1px solid #000;"><span><input type="text" style="width:100px;height:25px" pkno="${item.PK_NO}" id="uomQty${item.ITEM_NO}" name="uomQty" value="${item.UOM_QTY}"/>${item.UOM}</span></td>
        [/#if]
	    [#if order.get("STATUS_FLG")=="DELIVERED"||order.get("STATUS_FLG")=="SUCCESS"]
	    <td width="126" align="center" style="border-bottom:1px solid #000;">${item.QTY1}${item.UOM}</td>
        [/#if]
	  </tr>
	  [/#list]
      
    </tbody>
    <tfoot>
      <tr>
      	[#if (order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="WAITDELIVER")||(order.get("STM_NAME") == "货到付款" && order.get("STATUS_FLG")=="INPROCESS")]
        	<td colspan="6" align="right">
        [#elseif order.get("STATUS_FLG")=="DELIVERED"||order.get("STATUS_FLG")=="SUCCESS"]
       	 	<td colspan="6" align="right">
        [#else]
       	 	<td colspan="5" align="right">
        [/#if]
          <p>商品总价：   <span>${order.get("AMOUNT")?string("0.00")}</span></p>
          <p>运费：   <span>${order.get("FREIGHT")?string("0.00")}</span></p>
          <p>合计：   <span>${(order.get("AMOUNT")+order.get("FREIGHT"))?string("0.00")}</span></p>
        </td>
      </tr>
    </tfoot>
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

		</form>
	</body>
</html>