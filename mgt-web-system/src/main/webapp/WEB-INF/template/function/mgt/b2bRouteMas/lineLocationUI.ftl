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
	<title>线路安排</title>
</head>
<body>
<div class="body-container">
  <div class="main_heightBox1">
	<div id="currentDataDiv" action="menu" >
		<div class="btn_diva_box"></div>
		<div class="currentDataDiv_tit">
			<button type="button" class="btn btn-info btn_divBtn" onclick="history.back();">返回线路安排列表页</button>
		</div>
    </div>
  </div> 
  <div class="map_box">
   			<div class="map_left">
   			<input  type='hidden' id='types' value='1'/>
   			<input type='hidden' id='routeCodes' value='${routeCodes}'/>   			
   			[#list listName as locationNmae]
   				<div class="address_list addressDiv${locationNmae_index}">
	   				<h4 class="address_h4"><i>+</i>${locationNmae.ROUTE_NAME}</h4>
	   				[#list list as location]
	   					[#if location.ROUTE_CODE==locationNmae.ROUTE_CODE]
						<ul id="addressUl" class="addressUl">
	 						<li class="addressLi"> 
								<span>${location.CNO+1}</span> 
								<div class="map_contPbox" id="div"> 
	 								<p title="${location.NAME}">${location.NAME}</p> 
									<p title="${location.CRM_ADDRESS1}">${location.CRM_ADDRESS1}</p> 
									<p name='p1' id="p1${location.USER_NO}${location.ROUTE_CODE}" userno="${location.USER_NO}" routecode="${location.ROUTE_CODE}"><button type="button" class="btn_divBtn" >调 整  </button>  排序： ${location.SORT_NO}</p> 
								</div> 
	 						</li> 
						</ul>
					[/#if]
					[/#list]
				</div>
			[/#list]
				
				
			</div>
   			<div class="map_right"><div id="allmap"></div></div>
   		</div>
</div>
</body>
</html>
<script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("allmap");
	//中心点坐标
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);
	map.enableScrollWheelZoom(true);
	var colors = [];
		colors[0]="red";
		colors[1]="blue";
		colors[2]="black";
		colors[3]="DarkGreen";
		colors[4]="Olive";
	var all =[];
	var allLa =[];
	[#list listName as locationName]
		var gPoints = [];
		var gLabel = [];
		[#list list as location]
	   			[#if location.ROUTE_CODE==locationName.ROUTE_CODE]
	   				gPoints[${location.CNO}] = new BMap.Point('${location.LONGITUDE}','${location.LATITUDE}' );
	   				gLabel[${location.CNO}]='${location.NAME}';
	   			[/#if]
	   	[/#list]
	   	all[${locationName_index}]=gPoints;
	   	allLa[${locationName_index}]=gLabel;
	[/#list]
	var p1 = new BMap.Point(${whMas.longitude},${whMas.latitude});
	//var drv = [];
	//drv[0]= new BMap.DrivingRoute(map);
	var marker = new BMap.Marker(new BMap.Point(${whMas.longitude},${whMas.latitude})); 
    map.addOverlay(marker);
    var label = new BMap.Label("仓库",{offset:new BMap.Size(20,-10)});
	marker.setLabel(label);
    
    
   for(var h =0;h<all.length;h++){
		for (var q = 0; q < all[h].length; q ++) {
			if(all[h][q]!=null){
				var point = all[h][q]
				var label = new BMap.Label((q+1)+"--"+allLa[h][q],{offset:new BMap.Size(20,-10)});
				addMarker(point,label);
			}
		}
	}
	
	
	for(var h =0;h<all.length;h++){
   		if(h==0){
   		var driving_0=new BMap.DrivingRoute(map);
   		//eval( "var driving_"+ h +" =new BMap.DrivingRoute(map)");
   			for(var i =0;i<all[h].length;i++){
	   			var j=i;
				if(all[h].length!=1){
					j=i+1;
				}
				if(i==all[h].length-1){
					driving_0.search(all[h][i], p1);
				}else if(all[h][i]!=null){
					driving_0.search(all[h][i], all[h][j]);
				}
	    	}
   		}
   		if(h==1){
   		eval( "var driving_"+ h +" =new BMap.DrivingRoute(map)");
   			for(var i =0;i<all[h].length;i++){
	   			var j=i;
				if(all[h].length!=1){
					j=i+1;
				}
				if(i==all[h].length-1){
					driving_1.search(all[h][i], p1);
				}else if(all[h][i]!=null){
					driving_1.search(all[h][i], all[h][j]);
				}
	    	}
   		}
   		if(h==2){
   		eval( "var driving_"+ h +" =new BMap.DrivingRoute(map)");
   			for(var i =0;i<all[h].length;i++){
	   			var j=i;
				if(all[h].length!=1){
					j=i+1;
				}
				if(i==all[h].length-1){
					driving_2.search(all[h][i], p1);
				}else if(all[h][i]!=null){
					driving_2.search(all[h][i], all[h][j]);
				}
	    	}
   		}
   		if(h==3){
   		eval( "var driving_"+ h +" =new BMap.DrivingRoute(map)");
   			for(var i =0;i<all[h].length;i++){
	   			var j=i;
				if(gPoints.length!=1){
					j=i+1;
				}
				if(i==gPoints.length-1){
					driving_3.search(gPoints[i], p1);
				}else{
					driving_3.search(gPoints[i], gPoints[j]);
				}
	    	}
   		}
   		if(h==4){
   		eval( "var driving_"+ h +" =new BMap.DrivingRoute(map)");
   			for(var i =0;i<all[h].length;i++){
	   			var j=i;
				if(gPoints.length!=1){
					j=i+1;
				}
				if(i==gPoints.length-1){
					driving_4.search(gPoints[i], p1);
				}else{
					driving_4.search(gPoints[i], gPoints[j]);
				}
	    	}
   		}
	}
	
	for(var k=0;k<all.length;k++){
		if(k==0){
			driving_0.setSearchCompleteCallback(function(){
				var pts = driving_0.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  
				var polyline = new BMap.Polyline(pts,{strokeColor:colors[0], strokeWeight:6, strokeOpacity:0.5});       
				map.addOverlay(polyline);
			})
		}
		if(k==1){
			driving_1.setSearchCompleteCallback(function(){
				var pts = driving_1.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  
				var polyline = new BMap.Polyline(pts,{strokeColor:colors[1], strokeWeight:6, strokeOpacity:0.5});       
				map.addOverlay(polyline);
			})
		}
		if(k==2){
			driving_2.setSearchCompleteCallback(function(){
				var pts = driving_2.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  
				var polyline = new BMap.Polyline(pts,{strokeColor:colors[2], strokeWeight:6, strokeOpacity:0.5});       
				map.addOverlay(polyline);
			})
		}
		if(k==3){
			driving_3.setSearchCompleteCallback(function(){
				var pts = driving_3.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  
				var polyline = new BMap.Polyline(pts,{strokeColor:colors[3], strokeWeight:6, strokeOpacity:0.5});       
				map.addOverlay(polyline);
			})
		}
		if(k==4){
			driving_4.setSearchCompleteCallback(function(){
				var pts = driving_4.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  
				var polyline = new BMap.Polyline(pts,{strokeColor:colors[4], strokeWeight:6, strokeOpacity:0.5});       
				map.addOverlay(polyline);
			})
		}
		
		
	
		
	}

		   	function addMarker(point,label){
	  			var marker = new BMap.Marker(point);
	  			map.addOverlay(marker);
	  			marker.setLabel(label);
			}

	
   

	function mapht(){
		var dmentHeight = $(document.body).height();
	    var div1Height = $(".main_heightBox1").height()+10;
	    var mapHeight = dmentHeight-div1Height;
	    $(".map_right").css("height",mapHeight);
	    $(".map_left").css("height",mapHeight);
	    $(".map_box").css("height",mapHeight);
	    $("#allmap").css("height",mapHeight);
    
    };
    mapht();
    $(window).resize(function() {
	    mapht();
	});
	
	$(window).scroll(function() {
	    mapht();
	})
	$(window).click(function() {
	    mapht();
	})
	$(function(){
		$(".address_list h4").click(function(){
			if($(this).parent().hasClass("address_click")){
				$(this).parent().removeClass("address_click");
				$(this).find("i").html("+");
			}else{
				$(this).parent().addClass("address_click");
				$(this).find("i").html("-");		
			}
		})
		//var datas= [{"ROUTE_CODE":"LINE444","ROUTE_NAME":"线路四"},{"ROUTE_CODE":"Line1","ROUTE_NAME":"北京线路1"},{"ROUTE_CODE":"rjy0021","ROUTE_NAME":"默认线路1"},{"ROUTE_CODE":"test11","ROUTE_NAME":"测试11"}];;
		$.getJSON("${base}/b2bRouteMas/listMap.jhtml", function (data) { 
				datas=data;
		})
		$("[name=p1]").each(function(){ 
			$(this).click(function(){ 
				if($("#types").val()==1){
					var userno =$(this).attr('userno');
					var routecode =$(this).attr('routecode');
					$(this).after("<p id='ap1"+userno+routecode+"'>"+
					"线路 <select class='form-control ' id='x"+userno+routecode+"' name='routeCode' style='width:120px;'><option value=''>请选择</option></p>"+
					[#if listWhc?exists] 
  						[#list listWhc as route]
    						"<option value='${route.ROUTE_CODE}'>${route.ROUTE_NAME}</option>"+
  						[/#list]
					[/#if]
					"</select><p id='ap2"+userno+routecode+"'>排序 <input class='form-control' id='p"+userno+routecode+"' type='text' style='width:60px;' /><button type='button' userno='"+userno+"' routecode='"+routecode+"' class='btn_divBtn' onClick='sss(this)'>保存  </button> <button type='button' userno='"+userno+"' routecode='"+routecode+"' class='btn_divBtn' onClick='qqq(this)'>取消  </button> </p>")
					
					$("#types").val(2)
					$(this).hide();
				}else{
					alert("只能修改一条数据!")
				}
			})
		})
		
		
		
	});
	function sss(obj){
		var userno=$(obj).attr("userno");
		var routecode=$(obj).attr("routecode");
		var routeCodes = $("#routeCodes").val();
		var x =$("#x"+userno+routecode+"").val();
		var p =$("#p"+userno+routecode+"").val();
		if(x==null ||  x==""){
			top.$.jBox.tip('请选择线路!');
			return false;
		}
		var regu = "^[0-9]+$";
		var re = new RegExp(regu);
		if (p.search(re) != -1) {
					
		} else {
			top.$.jBox.tip('请输入数字');
			return false;
		}
		var url = '${base}/b2bRouteMas/updateLine.jhtml?routeCode='+routecode+'&userno='+userno+'&routeCodes='+routeCodes+'&x='+x+'&p='+p;
		window.location.href = url;
	}
	
	function qqq(obj){
		var userno=$(obj).attr("userno");
		var routecode=$(obj).attr("routecode");
		$("#types").val(1)
		
		$("#ap1"+userno+routecode+"").remove();
		$("#ap2"+userno+routecode+"").remove();
		$("#p1"+userno+routecode+"").show();
	}
	
	
	

</script>

