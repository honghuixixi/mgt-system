[#if notifyMessage??]
${notifyMessage}
[#else]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.payment.notify")}[#if systemShowPowered] - Powered By SHOP++[/#if]</title>
<meta name="author" content="QPWA" />
<meta name="copyright" content="qpwa" />
<link rel="shortcut icon" href="${base}/resources/shop/images/16.ico" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/payment.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<link href="${base}/resources/shop/css/new/public.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/new/index2015-style.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<script src="${base}/resources/shop/js/new/jquery.cookies.2.2.0.min.js" type="text/javascript"></script>
<script src="${base}/resources/shop/js/new/index2015.js" type="text/javascript"></script>
<!-- myjs -->
<script src="${base}/resources/shop/js/new/myjquery_index2015.js" type="text/javascript"></script>
</head>
<body>
	[#include "/shop/include/header_new.ftl"]
	<div class="container payment">
		<div class="span24">
			<div class="title">
				[#if payment.status == "wait"]
					${message("shop.payment.waitTitle")}
				[#elseif payment.status == "success"]
					[#if payment.type == "payment"]
						${message("shop.payment.orderTitle")}
					[#elseif payment.type == "recharge"]
						${message("shop.payment.depositTitle")}
					[/#if]
				[#elseif payment.status == "failure"]
					${message("shop.payment.failureTitle")}
				[/#if]
			</div>
			<div class="bottom">
				[#if payment.type == "payment"]
					<a href="${base}/member/order/view.jhtml?sn=${payment.order.sn}">${message("shop.payment.viewOrder")}</a>
				[#elseif payment.type == "recharge"]
					<a href="${base}/member/deposit/list.jhtml">${message("shop.payment.deposit")}</a>
				[/#if]
				| <a href="${base}/">${message("shop.payment.index")}</a>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>
[/#if]