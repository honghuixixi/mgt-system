<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title> 
[#include "/common/commonHead.ftl" /]
<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<script src="${base}/scripts/lib/plugins/js/index.js"></script>
<script>
$(function(){
	pullLeftH()
});
function pullLeftH(){
	var domtH = $(document).height();
	var divBoxH = domtH - 20;
	$(".pullLeft-box").css({height:divBoxH,overflow:"auto"});
	$(".pullRight-box").css("height",divBoxH);
	$(".pullLeft-box dl dd").click(function(){
		$(".pullLeft-box dl dd").removeClass("active");
		$(this).addClass("active");
	});
}
$(window).resize(function() {
    pullLeftH();
});

$(window).scroll(function() {
    pullLeftH();
})
$(window).click(function() {
    pullLeftH();
})
</script>
<style>
#smallIframe{height:99%;overflow-y:hidden;}
</style>
</head>
<body style="margin:0;padding:0;">
	<!-- menu begin -->
	<div class="pull-left pullLeft-box" style="position:absolute;top:10px;left:0;">
		<dl class="pull-leftDl">
			<dt>供应商</dt>
			<dd class="active"><a href="${base}/statistics/list.jhtml?type='vendorWaitReceive'" class="" target="smallIframe"><i
			class="icon-minus"></i>待接收[${oms.VENDORWAITRECEIVE}]</a></dd>
			<dd ><a href="${base}/statistics/list.jhtml?type='vendorWaitDeliver'" class="" target="smallIframe"><i
			class="icon-minus"></i>待发货[${oms.VENDORWAITDELIVER}]</a></dd>
		</dl>
		<dl class="pull-leftDl">
			<dt>仓库</dt>
			<dd ><a href="${base}/statistics/list.jhtml?type='warehouseWaitReceive'" class="" target="smallIframe"><i
			class="icon-minus"></i>待接收[${oms.WAREHOUSEWAITRECEIVE}]</a></dd>
			<dd ><a href="${base}/statistics/list.jhtml?type='warehouseWaitDeliver'" class="" target="smallIframe"><i
			class="icon-minus"></i>待发货[${oms.WAREHOUSEWAITDELIVER}]</a></dd>
			<dd ><a href="${base}/statistics/list.jhtml?type='warehouseException'" class="" target="smallIframe"><i
			class="icon-minus"></i>异常处理[${oms.WAREHOUSEEXCEPTION}]</a></dd>
		</dl>
		
		<dl class="pull-leftDl">
			<dt>物流</dt>
			<dd ><a href="${base}/statistics/list.jhtml?type='logisticsWaitDistribution'" class="" target="smallIframe"><i
			class="icon-minus"></i>待配送[${oms.LOGISTICSWAITDISTRIBUTION}]</a></dd>
			<dd ><a href="${base}/statistics/list.jhtml?type='logisticsDistribution'" class="" target="smallIframe"><i
			class="icon-minus"></i>配送中[${oms.LOGISTICSDISTRIBUTION}]</a></dd>
		</dl>

		<dl class="pull-leftDl">
			<dt>财务</dt>
			<dd ><a href="${base}/statistics/list.jhtml?type='waitCollection'" class="" target="smallIframe"><i
			class="icon-minus"></i>待收款[${oms.WAITCOLLECTION}]</a></dd>
			<dd ><a href="${base}/statistics/list.jhtml?type='financeException'" class="" target="smallIframe"><i
			class="icon-minus"></i>异常处理[${oms.FINANCEEXCEPTION}]</a></dd>
		</dl>
	</div>
	<div class="pullRight-box" style="padding-left:200px;margin:0;">
		<iframe src="${base}/statistics/list.jhtml?type='vendorWaitReceive'" id="smallIframe"
			name="smallIframe" scrolling="auto" width="100%" background:#fff;" frameborder="0" noresize></iframe>
	</div>
</body>
</html>
