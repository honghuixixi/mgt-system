
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加点标注工具--高级示例</title>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.2"></script>
<script src="${base}/scripts/function/mgt/MarkerTool_min.js" type="text/javascript"></script>
<script src="${base}/scripts/lib/jquery/js/jquery-1.8.3.min.js" ></script>
<style type="text/css">
    /* 样式选择面板相关css */
    *{padding:0;margin:0;}
    #divStyle {
        width: 280px;
        height: 160px;
        border: solid 1px gray;
        display:block;
        margin: 2px; 0px;
        display:none;
    }
    #divStyle ul{
        list-style-type: none;
        padding: 2px 2px;
        margin: 2px 2px
    }
    #divStyle ul li a{
        cursor: pointer;
        margin: 2px 2px;
        width: 30px;
        height: 30px;
        display: inline-block;
        border: solid 1px #ffffff;
        text-align: center;
    }

    #divStyle ul li a:hover{
        background:none;
        border: solid 1px gray;     
    }
    
    #divStyle ul li img{
        border: none;
        background:url('http://api.map.baidu.com/library/MarkerTool/1.2/examples/images/icon.gif');
    }

    /* infowindow相关css */
    .common {
        font-size: 12px;
    }
    .star {
        color: #ff0000;
    }
    .result_box{width:100%;overflow:hidden;}
    .result_left{float:left;width:522px;height:46px;}
    .result_leftT{width:100%;overflow:hidden;padding:10px 0;}
    .result_leftT select{float:left;display:inline;margin-right:15px;}
    .result_left_cont{width:100%;overflow:hidden;}
    .bz_box{float:left;position:relative;}
    .bz_box input{padding:0;margin:0;border:solid 1px #565960;background:#eef5f6;color:#4f4e53;padding-left:10px;height:24px;line-height:20px;padding:0 5px 0 12px;}
    .bz_box img{position:absolute;left:5px;top:5px;}
    .result_left_R{float:right;position:relative;}
    .result_left_R input{height:24px;line-height:20px;border:solid 1px #565960;padding:0 18px 0 5px;color:#9a9a9a;}
    .result_left_R img{position:absolute;right:5px;top:5px;}
    .result_right{float:right;width:310px;display:inline;margin-right:10px;}
    .result_rightT{width:100%;line-height:46px;color:#4f4e53;font-size:14px;}
    .result_right_cont{border:solid 1px gray;padding:10px;height:320px;overflow-x:hidden;overflow-y:auto;font-size:12px;}
    .pos_subBtn{position:fixed;right:10px;bottom:0px;display:inline-block;width:70px;height:24px;text-decoration:none;line-height:24px;background:#f6821f;color:#fff;text-align:center;border-radius:5px;}
</style>
	<style type="text/css">
		body, html{width: 100%;height: 100%; margin:0;font-family:"微软雅黑";}
		#l-map{height:300px;width:100%;}
		#r-result{width:100%;}
		
	</style>
</head>
<body>
<div class="result_box">
	<div class="result_left">
		<div class="result_leftT">
			<!--<select>
				<option>北京市</option>
				<option>上海市</option>
				<option>南京市</option>
			</select>-->
			<div id="cityList"></div>
			<div class="bz_box"><input type="button" value="标注位置" onclick="openStylePnl()" /><img width="7" height="13" src="${base}/styles/images/biaozhu_icon.jpg" /></div>
			<div class="result_left_R"><a href="#"  onclick="seach();"><img src="${base}/styles/images/spanSearch_btnIcon.jpg" hwight="14" width="14"></a><input type="text" id="seachStr" value="" /><a href="#"></a></div>
		</div>
		<div class="result_left_cont">
			<div style="width:520px;height:340px;border:1px solid gray" id="container"></div>
			<div id="r-result"></div>
		</div>
	</div>
	<div class="result_right">
		<div class="result_rightT">客户位置</div>
		<div class="result_right_cont" id="result_right_cont"></div>
	</div>
</div>
<!--<a id="curcity" title="修改城市" href="javascript:;">北京市</a>
<a class="pos_subBtn" href="#">确定</a>-->
<input type="hidden" id="lng" name="lng">
<input type="hidden" id="lat" name="lat">
<input type="hidden" id="address" name="address">
</div>
</body>
</html>
<script type="text/javascript">
	
	$(document).ready(function() {
	if(window.parent.document.getElementById("address").value){
		var address = window.parent.document.getElementById("address").value;
		var opts = {
		  width : 200,     // 信息窗口宽度
		  height: 100,     // 信息窗口高度
		  title : "客户位置" , // 信息窗口标题
		  enableMessage:true,//设置允许信息窗发送短息
		  message:address
		}
		var infoWindow = new BMap.InfoWindow(address, opts);  // 创建信息窗口对象 
		document.getElementById("result_right_cont").innerHTML=address;
		var point = new BMap.Point(window.parent.document.getElementById("lng").value,window.parent.document.getElementById("lat").value);
		var marker = new BMap.Marker(point);// 创建标注
		var label = new BMap.Label(address,{offset:new BMap.Size(20,-10)});
		marker.setLabel(label);
		
		marker.addEventListener("click", function(){          
			map.openInfoWindow(infoWindow,point); //开启信息窗口
		});
		map.addOverlay(marker);             // 将标注添加到地图中
		marker.disableDragging(); 
		
		map.centerAndZoom(point, 12)
	}
		
	});

	var map = new BMap.Map("container");
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 12);
	map.enableScrollWheelZoom();
	
	var local = new BMap.LocalSearch(map, {
		renderOptions: {map: map, panel: "result_right_cont"}
	});
	function seach(){
		var str =  document.getElementById("seachStr").value;
		local.search(str);
	}
	
	var curMkr = null; // 记录当前添加的Mkr
	var infoWin = null;
	var point = null;
	
	var mkrTool = new BMapLib.MarkerTool(map, {autoClose: true});
	mkrTool.addEventListener("markend", function(evt){ 
		deletePoint();
	    var mkr = evt.marker;
	    point = mkr.point;
	    document.getElementById("lng").value=mkr.point.lng;
		document.getElementById("lat").value=mkr.point.lat;
		var address = '';
		var geoc = new BMap.Geocoder();
		geoc.getLocation(mkr.point, function(rs){
			var addComp = rs.addressComponents;
			address = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
			document.getElementById("address").value=address;
		    var html = [];
			html.push('<span style="font-size:12px">属性信息: </span><br/>');
			html.push('<table border="0" cellpadding="1" cellspacing="1" >');
			html.push('  <tr>'); 
			html.push('      <td align="left" class="common">名 称：</td>');
			html.push('      <td colspan="2"><input type="text" maxlength="50" size="18"  id="txtName" value="客户位置"></td>');
			html.push('	     <td valign="top"><span class="star">*</span></td>');
			html.push('  </tr>');
			html.push('  <tr>');
			html.push('      <td  align="left" class="common">位置：</td>');
			html.push('      <td colspan="2"><input type="text" maxlength="30" size="18"  id="txtTel" value="'+address+'" ></td>');
			html.push('	     <td valign="top"><span class="star">*</span></td>');
			html.push('  </tr>');
			html.push('  <tr>');
			html.push('	     <td  align="center" colspan="3">');
			html.push('          <input type="button" name="btnOK"  onclick="fnOK()" value="确定">&nbsp;&nbsp;');
			html.push('	     </td>');
			html.push('  </tr>');
			html.push('</table>');	
			infoWin = new BMap.InfoWindow(html.join(""), {offset: new BMap.Size(0, -10)});
		    mkr.openInfoWindow(infoWin);
		    curMkr = mkr;
		}); 
	});
	
	//打开样式面板
	function openStylePnl(){
	    mkrTool.open(); //打开工具 
	    var icon = BMapLib.MarkerTool.SYS_ICONS[2]; //设置工具样式，使用系统提供的样式BMapLib.MarkerTool.SYS_ICONS[0] -- BMapLib.MarkerTool.SYS_ICONS[23]
	    mkrTool.setIcon(icon); 
	}
	//提交数据
	function fnOK(){
		var address = "位置："+document.getElementById("address").value;
		var opts = {
		  width : 200,     // 信息窗口宽度
		  height: 100,     // 信息窗口高度
		  title : "客户位置" , // 信息窗口标题
		  enableMessage:true,//设置允许信息窗发送短息
		  message:address
		}
		var infoWindow = new BMap.InfoWindow(address, opts);  // 创建信息窗口对象 
		document.getElementById("result_right_cont").innerHTML=address;
		var marker = new BMap.Marker(point);// 创建标注
		var label = new BMap.Label(address,{offset:new BMap.Size(20,-10)});
		marker.setLabel(label);
		
		marker.addEventListener("click", function(){          
			map.openInfoWindow(infoWindow,point); //开启信息窗口
		});
		map.addOverlay(marker);             // 将标注添加到地图中
		marker.disableDragging();  
		if(infoWin){
			 if(infoWin.isOpen()){
		        map.closeInfoWindow();
		    }
		}
	}
	
	function deletePoint(){
		var address = document.getElementById("address").value;
		var lng = document.getElementById("lng").value;
		var lat = document.getElementById("lat").value;
		var allOverlay = map.getOverlays();
		for (var i = 0; i < allOverlay.length -1; i++){
			if(allOverlay[i] !=null && allOverlay[i].getLabel() != null && allOverlay[i].getLabel().content == address){
				map.removeOverlay(allOverlay[i]);
			}
			if(allOverlay[i].point.lng ==lng && allOverlay[i].point.lat ==lat){
				map.removeOverlay(allOverlay[i]);
			}
		}
	}
	
	function submit(){
		alert(window.parent.document.getElementById("custCode").value );
	}
</script>

