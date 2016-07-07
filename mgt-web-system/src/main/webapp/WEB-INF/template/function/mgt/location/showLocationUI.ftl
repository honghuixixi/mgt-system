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
	<div class="header-wrap">
		<div id="currentDataDiv" action="menu">
		    <form class="form form-inline queryForm" style="width:1275px" id="query-form"> 
		         <div class="form-group">
		            <label class="control-label">请选择时间</label>
		            <input type="text" class="form-control" id="startDate" name="startDate" value="${date}" style="width:120px;" onfocus="WdatePicker();" >
		            <input type="hidden" id="userId" name="userId" value="${id}">
		        </div>
		        <div class="form-group">
		         	<button type="button" class="btn btn-info" id='search_location' data-toggle="jBox-query" ><i class="icon-search"></i> 查看 </button>
		        </div>
		    </form>
		</div>
	</div>
	<div style="float: left;width:250px;">
		<ul id="route" class="nav nav-pills nav-stacked">
		</ul>
   	</div>
   	<div style="float:right;width:1025px;">
		<div id="allmap"></div>
	</div>
</body>
</html>
<script type="text/javascript">
	
	$(document).ready(function(){
		 addFugaiwu();
		 $('#search_location').click(function(){
		 	addFugaiwu();
	});
		var commpolyline = null;
	  $('.routeli').live('click',function(){
	  	//去除之前的红线
	  	map.removeOverlay(commpolyline);
	 	$this = $(this);
	 	var points = new Array();
	 	points.push(new BMap.Point($this.attr('lon1'),$this.attr('lat1')));
	 	points.push(new BMap.Point($this.attr('lon2'),$this.attr('lat2'))); 
	 	var polyline = new BMap.Polyline(points, {strokeColor:"red", strokeWeight:2, strokeOpacity:0.5});   //创建折线
		map.addOverlay(polyline);   //增加折线
		commpolyline = polyline;
		map.centerAndZoom(new BMap.Point($this.attr('lon1'),$this.attr('lat1')), 15);
	 });
	});	
	
	//添加覆盖物
	function addFugaiwu(){
		//清除覆盖物
		map.clearOverlays(); 
		var route = new Array(); 
		
		$.ajax({
			url: '${base}/location/locdetail.jhtml',
			type: "GET",
			dataType: "json",
			data: {
					userId: $('#userId').val(),
					date: $('#startDate').val(),
					},
			cache: false,
			error: function(message) {
			},
			success: function(message) {
				var list = message.list;
				var points = new Array(); 
				var mid ;
				for(var i in list){
					var location = list[i];
					if(location.TYPE == 'N'){
						addMarker(new BMap.Point(location.LONGITUDE, location.LATITUDE),new BMap.Label(location.NAME,{offset:new BMap.Size(20,-10)}),"red");
					}else if(location.TYPE == 'S'){
						addMarker(new BMap.Point(location.LONGITUDE, location.LATITUDE),new BMap.Label(location.NAME,{offset:new BMap.Size(20,-10)}),"orange");
					}else if(location.TYPE == 'L' || location.TYPE == 'C'){
						if(mid == null){
							mid = new BMap.Point(location.LONGITUDE, location.LATITUDE);
						}
						if(location.TYPE == 'C'){
							route.push(location);
						}
						points.push(new BMap.Point(location.LONGITUDE,location.LATITUDE));
					}
					var polyline = new BMap.Polyline(points, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.5});   //创建折线
					map.addOverlay(polyline);   //增加折线
					addArrow(polyline,10,Math.PI/7);  
				}
				
				var str = "";
				for(var i=0;i<route.length;i++){
					if(i < route.length-1){
						str = str + "<li><a class='routeli' lat1='"+route[i].LATITUDE+"' lon1='"+route[i].LONGITUDE+"' lat2='"+route[i+1].LATITUDE+"' lon2='"+route[i+1].LONGITUDE+"'>"+route[i].NAME+"--->"+route[i+1].NAME+"</a></li>";
					}
				}
				$('#route').html("");
				$('#route').html(str);
				map.centerAndZoom(mid, 16);
			}
		});
	}
	
	// 百度地图API功能
	var map = new BMap.Map("allmap");
	var point = new BMap.Point(116.404, 39.915);
	map.centerAndZoom(point, 16);
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
	
	function addArrow(polyline,length,angleValue){ //绘制箭头的函数  
		var linePoint=polyline.getPath();//线的坐标串  
		var arrowCount=linePoint.length;  
		for(var i =1;i<arrowCount;i++){ //在拐点处绘制箭头  
		var pixelStart=map.pointToPixel(linePoint[i-1]);  
		var pixelEnd=map.pointToPixel(linePoint[i]);  
		var angle=angleValue;//箭头和主线的夹角  
		var r=length; // r/Math.sin(angle)代表箭头长度  
		var delta=0; //主线斜率，垂直时无斜率  
		var param=0; //代码简洁考虑  
		var pixelTemX,pixelTemY;//临时点坐标  
		var pixelX,pixelY,pixelX1,pixelY1;//箭头两个点  
		if(pixelEnd.x-pixelStart.x==0){ //斜率不存在是时  
		    pixelTemX=pixelEnd.x;  
		    if(pixelEnd.y>pixelStart.y)  
		    {  
		    pixelTemY=pixelEnd.y-r;  
		    }  
		    else  
		    {  
		    pixelTemY=pixelEnd.y+r;  
		    }     
		    //已知直角三角形两个点坐标及其中一个角，求另外一个点坐标算法  
		    pixelX=pixelTemX-r*Math.tan(angle);   
		    pixelX1=pixelTemX+r*Math.tan(angle);  
		    pixelY=pixelY1=pixelTemY;  
		}  
		else  //斜率存在时  
		{  
		    delta=(pixelEnd.y-pixelStart.y)/(pixelEnd.x-pixelStart.x);  
		    param=Math.sqrt(delta*delta+1);  
		  
		    if((pixelEnd.x-pixelStart.x)<0) //第二、三象限  
		    {  
		    pixelTemX=pixelEnd.x+ r/param;  
		    pixelTemY=pixelEnd.y+delta*r/param;  
		    }  
		    else//第一、四象限  
		    {  
		    pixelTemX=pixelEnd.x- r/param;  
		    pixelTemY=pixelEnd.y-delta*r/param;  
		    }  
		    //已知直角三角形两个点坐标及其中一个角，求另外一个点坐标算法  
		    pixelX=pixelTemX+ Math.tan(angle)*r*delta/param;  
		    pixelY=pixelTemY-Math.tan(angle)*r/param;  
		  
		    pixelX1=pixelTemX- Math.tan(angle)*r*delta/param;  
		    pixelY1=pixelTemY+Math.tan(angle)*r/param;  
		}  
		  
		var pointArrow=map.pixelToPoint(new BMap.Pixel(pixelX,pixelY));  
		var pointArrow1=map.pixelToPoint(new BMap.Pixel(pixelX1,pixelY1));  
		var Arrow = new BMap.Polyline([  
		    pointArrow,  
		 linePoint[i],  
		    pointArrow1  
		], {strokeColor:"blue", strokeWeight:3, strokeOpacity:0.5});  
		map.addOverlay(Arrow);  
		}  
	}  
</script>

