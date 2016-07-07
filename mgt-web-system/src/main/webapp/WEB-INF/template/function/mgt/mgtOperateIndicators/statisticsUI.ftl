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
	pullRightH();
});
function pullRightH(){
	var domtH = $(document).height();
	var divBoxH = domtH - 20;
	$(".pullRight-box").css("height",divBoxH);
}
$(window).resize(function() {
    pullRightH();
});

$(window).scroll(function() {
    pullRightH();
})
$(window).click(function() {
    pullRightH();
})
</script>
<style>
#smallIframe{height:500px;overflow-y:hidden;}
</style>
</head>
<body style="margin:0;padding:0;">
	<div class="pullRight-box" style="padding-left:10px;margin:0;">
		<iframe src="${base}/operateIndicators/statisticCharts.jhtml" id="smallIframe"
			name="smallIframe" scrolling="auto" width="100%" background:#fff;" frameborder="0" noresize></iframe>
	</div>
</body>
</html>
