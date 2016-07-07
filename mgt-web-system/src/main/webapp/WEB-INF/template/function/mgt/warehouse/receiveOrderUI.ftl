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
		<form class="form-horizontal" id="form" action="${base}/warehouse/receiveReturnOrder.jhtml" style="width:1000px">
			<input id="id" name="pkNo" type="hidden" value="${pkNo}">
		</form>
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
					<div class="btn-group">
						<button class="btn btn-red" data-toggle="jBox-submit" data-form="#form">
						收货
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
					<button class="btn btn-red" data-toggle="jBox-close">关闭
						<i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
					</div>
				</div>
			</div>			
[#if orderItemList?exists]		
<div class="page-content">
    <div class="safe_right"> 
      <div>
        <table class="price_bill" cellpadding="0" cellspacing="0" >
    <thead>
      <tr height="25">
        <td><strong>商品编码</strong></td>
        <td><strong>条码</strong></td>
        <td><strong>商品名称</strong></td>
        <td><strong>单位</strong></td>
        <td><strong>退货数量</strong></td>
      </tr>
    </thead>
    <tbody>
	  [#list orderItemList as item]
	  <tr height="60">
	    <td width="100"><span>${item.STK_C}</span></td>
	    <td width="101"><span>${item.PLU_C}</span></td>
	    <td width="201">${item.STK_NAME}</td>
	    <td width="126"><span>${item.UOM}</span></td>
	    <td width="126">${item.STK_QTY}<span></span></td>
	  </tr>
	  [/#list]
      
    </tbody>
  </table>
      </div>
    </div>
</div>
[#else]暂无订单数据
[/#if]
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	</body>
</html>