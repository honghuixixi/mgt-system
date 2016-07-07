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
<div class="body-container">
  <div class="main_heightBox1">
	<div id="currentDataDiv" action="menu" >
		<div class="btn_diva_box"></div>
		<div class="currentDataDiv_tit">
			<button type="button" class="btn btn-info btn_divBtn" onclick="history.back();">返回客户列表页</button>
		</div>
    </div>
  </div> 
  <div class="map_box">
   			<div class="map_left">
				<ul id="addressUl">
<!-- 					<li> -->
<!-- 						<span>1</span> -->
<!-- 						<div class="map_contPbox"> -->
<!-- 							<p title="华联生活超市（肖家河分店）">华联生活超市（肖家河分店）</p> -->
<!-- 							<p title="北京海淀区颐和园路5号北京海淀区颐和园路5号">北京海淀区颐和园路5号北京海淀区颐和园路5号</p> -->
<!-- 						</div> -->
<!-- 					</li> -->
					 
				</ul>
			</div>
   			<div class="map_right"><div id="allmap"></div></div>
   		</div>
</div>
</body>
</html>
<script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("allmap");
	var point = new BMap.Point(116.404, 39.915);
	
	map.centerAndZoom(point, 12);
	map.enableScrollWheelZoom(true);
	
	var size = new BMap.Size(10, 20);
	map.addControl(new BMap.CityListControl({
	    anchor: BMAP_ANCHOR_TOP_LEFT,
	    offset: size
	}));
	
	$(document).ready(function(){
		[#list map.items as location]
			[#if (location.LONGITUTDE)?? ]
				map.centerAndZoom(new BMap.Point('${location.LONGITUTDE}','${location.LATITUDE}' ), 12);
			[/#if]
			addMarker(new BMap.Point('${location.LONGITUTDE}','${location.LATITUDE}' ),new BMap.Label('${location.CUST_NAME}',{offset:new BMap.Size(20,-10)}),'${location_index}');
			var i = Number('${location_index}')+1;
			var createDate = '${location.CREATE_DATE}';
			var date=new Date(createDate);
			$("#addressUl").append('<li>'+
			'<span>'+i+'</span>'+
			'<div class="map_contPbox">'+
			'	<p title="'+'${location.CUST_NAME}'+'"><font>'+'${location.CUST_NAME}'+'</font><em>'+createDate+'</em></p>'+
			'	<p title="">'+'${location.CRM_ADDRESS1}'+'</p>'+
			'</div>'+
			'</li>')
			
		[/#list]
	});
	
	
	// 编写自定义函数,创建标注
	function addMarker(point,label,color){
		var myIcon = new BMap.Icon("${base}/styles/images/makers.png", new BMap.Size(23, 30), {
				    offset: new BMap.Size(10, 30),
				    imageOffset: new BMap.Size(0, 0 - color * 30)

				  });
    	 var m1 = new BMap.Marker(point,{icon: myIcon,title:color})
         map.addOverlay(m1);  
		m1.setLabel(label);
	}
</script>

