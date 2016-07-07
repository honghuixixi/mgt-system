<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<script type="text/javascript" src="${base}/scripts/lib/DatePicker/WdatePicker.js"></script>
	[#include "/common/commonHead.ftl" /]
	<style type="text/css">
		body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
		#allmap {height:500px; width: 100%;}
		#control{width:100%;}
	</style>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=DDb12a84344b679c799680268e263ad7"></script>
	<title>用户定位</title>
</head>
<body>
	<div id="allmap"></div>
	<input type="hidden" name = ids id=ids value="${ids}">
</body>
</html>
<script type="text/javascript">
	
	// 百度地图API功能
	var map = new BMap.Map("allmap");
	var point = new BMap.Point(116.404, 39.915);
	
	$(document).ready(function(){
		$.ajax({
			url: '${base}/warehouse/shoplocation.jhtml',
			type: "GET",
			dataType: "json",
			data :{
				'ids':$("#ids").val(),
				},
			cache: false,
			error: function(message) {
			},
			success: function(message) {
				var list = message.list;
				for(var i in list){
					var location = list[i];
					addMarker(new BMap.Point(location.LONGITUDE, location.LATITUDE),new BMap.Label(location.NAME,{offset:new BMap.Size(20,-10)}),"red");
				}
			}
		});
	});
	
	map.centerAndZoom(point, 12);
	map.enableScrollWheelZoom(true);
	
	
	// 编写自定义函数,创建标注
	function addMarker(point,label,color){
		//设置marker图标为水滴
		var marker = new BMap.Marker(point, {
		  // 指定Marker的icon属性为Symbol
		  icon: new BMap.Symbol(BMap_Symbol_SHAPE_POINT, {
		    scale: 1,//图标缩放大小
		    fillColor: color,//填充颜色
		    fillOpacity: 0.8//填充透明度
		  })
		});
		map.addOverlay(marker);
		marker.setLabel(label);
	}
</script>

