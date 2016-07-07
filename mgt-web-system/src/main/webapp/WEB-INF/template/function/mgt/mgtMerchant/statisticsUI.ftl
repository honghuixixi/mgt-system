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
	$("li.sub_status_but").on("click",function(){
		//商户分析
		if("merchantStatistics" == $(this).attr("id")) { 
			$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		var reqUrl = "${base}/merchant/statisticCharts.jhtml";
    		$("#smallIframe").attr('src',reqUrl);
		}
		//商户分析报表
		if("merchantStatisticsReport" == $(this).attr("id")) {
			$("li.sub_status_but").removeClass("active");
		    $(this).addClass("active");
		    var reqUrl = "${base}/operationsCenter/operatorMapData.jhtml";
		    $("#smallIframe").attr('src',reqUrl);
		}
		//商户分析地图
		if("merchantStatisticsByMap" == $(this).attr("id")) {
			$("li.sub_status_but").removeClass("active");
		    $(this).addClass("active");
		    var reqUrl = "${base}/operationsCenter/operatorMap.jhtml";
		    $("#smallIframe").attr('src',reqUrl);
		}
		
		
	});
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
		<div class="control-group sub_status" style="position:relative;">
			<ul class="nav nav-pills" role="tablist">
				<li role="presentation" id="merchantStatistics" class="sub_status_but active"><a href="#">商户分析曲线图</a></li>
				<li role="presentation" id="merchantStatisticsReport" class="sub_status_but"><a href="#">商户分析报表</a></li>					
				<li role="presentation" id="merchantStatisticsByMap" class="sub_status_but"><a href="#">商户分布图</a></li>						
			</ul>
		</div>
		<iframe src="${base}/merchant/statisticCharts.jhtml" id="smallIframe"
			name="smallIframe" scrolling="auto" width="100%" background:#fff;" frameborder="0" noresize></iframe>
	</div>
</body>
</html>
