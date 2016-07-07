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
		<form class="form-horizontal" id="form" action="" style="width:1000px">
			<input type="hidden"id="id" name="id"  value="${order.pkNo}" >
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
                 <p class="p_no2">${order.masNo}</p>
              </td>
              <td width="200">
                 <p class="p_no1">订单状态：</p>
                 <p class="p_no2" style="text-align:left;">
			     [#import "/function/mgt/order/orderMacro.ftl" as orderStatus]
			     [@orderStatus.chinesesTatus status='${order.statusFlg}' /]
              </p>
            </td>
          </tr>
          <tr>
            <td width="200">
              <p class="p_no1">下单时间：</p>
              <p class="p_no2">${order.masDate}</p>
            </td>
            <td width="200"><p class="p_no1">配送方式：</p>
              <p class="p_no2">[#if order.deliveryType == "L"]快递[#else]自提[/#if]</p>
            </td>
          </tr>
          <tr>
            <td width="200"><p class="p_no1">收 货 人：</p>
              <p class="p_no1">${order.receiverName}</p></td>
            <td width="200">
				[#if order.receiverMobile?exists  && order.receiverMobile != 'null']
					<p class="p_no1">联系电话：</p><p class="">${order.receiverMobile}</p>
				[#else]
					<p class="p_no1">固定电话：</p><p class="">${order.receiverMobile}</p>
				[/#if]
            </td>
          </tr>
          <tr>
            <td colspan="2" width="670"><p class="p_no1">收货地址：</p>
              <p class="p_no2" style="width:500px;">${order.receiverAddress}</p></td>
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
        <td><strong>发货数量</strong></td>
        <td><strong>实收数量</strong></td>
        <td><strong>折零扣减金额</strong></td>
      </tr>
    </thead>
    <tbody>
	  [#list orderItemList as item]
	  <tr height="60">
	    <td width="100"><span>${item.stkC}</span></td>
	    <td width="101"><img src="${item.productThumbnail}" height="60" width="60" alt="商品图片" /></td>
	    <td width="201">${item.stkName}</td>
	    <td width="126"><span class="color_1">￥
	    [#if item.netPrice!=null]
	    ${item.netPrice?string("0.00")}
	    [/#if]
	    </span></td>
	    <td width="126" style="border-right:1px solid #ccc;"><span>${item.uomQty}件</span></td>
	    <td width="126" style="border-right:1px solid #ccc;"><span>${item.qty1}件</span></td>
	    <td width="126" style="border-right:1px solid #ccc;"><span>${item.qty2}件</span></td>
	    <td width="126"><span class="color_1">￥
	     [#if item.diffMiscAmt!=null]
	    ${item.diffMiscAmt?string("0.00")}
	    [/#if]
	    </span></td>
	  </tr>
	  [/#list]
      
    </tbody>
    <!--
    <tfoot>
      <tr>
        <td colspan="8" align="right">
          <p>商品总价：   <span>
          [#if order.amount!=null]
          ${order.amount?string("0.00")}
          [/#if]
          </span>
          </p>
          <p>运费：   <span> [#if order.freight!=null]${order.freight?string("0.00")}[/#if]</span></p>
          <p>合计：   <span>${(order.amount+order.freight)?string("0.00")}</span></p>
        </td>
      </tr>
    </tfoot>
    -->
  </table>
      </div>
    </div>
</div>
[#else]暂无订单数据
[/#if]
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	</body>
 
</html>