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
		
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/returnmergeorder/save.jhtml">
			<input id="id" name="pkNo" type="hidden" value="${pkNo}">
		</form>
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
				[#if type=='N']
					<div class="btn-group">
						<button class="btn btn-red btn-danger" data-toggle="jBox-call" data-fn="checkForm">
							生成退货单
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
					 [/#if]
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
        <td><strong>单价</strong></td>
        <td><strong>收货数量</strong></td>
        <td><strong>发货数量</strong></td>
        <td><strong>退货数量</strong></td>
      </tr>
    </thead>
    <tbody>
	  [#list orderItemList as item]
	  <tr height="60" >
	    <td width="100" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.STK_C}</td>
	    <td width="101" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.PLU_C}</td>
	    <td width="201" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.STK_NAME}</td>
	    <td width="126" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.UOM}</td>
	    <td width="126" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.NET_PRICE}</td>
	    <td width="126" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.QTY2}</td>
	    <td width="126" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.OQTY2}</td>
	    <td width="126" [#if item.DIFF > 0]style="font-weight:bold;color:red"[/#if]>${item.DIFF}</td>
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
	<script type="text/javascript">
			function checkForm(){
				mgt_util.submitForm('#form');
			}
	</script>
</html>