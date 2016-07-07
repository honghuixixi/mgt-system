<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
            <title></title>
        	[#include "/common/commonHead.ftl" /]
            <link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
            <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
   			<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index_wel.css" />
   			<link rel="stylesheet" media="screen" href="${base}/styles/css/operationsMap.css" />
			<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=DDb12a84344b679c799680268e263ad7"></script>
			<script type="text/javascript" src="${base}/scripts/lib/echarts/echarts.js"></script>
	</head>
	<body>
	<center>
	  <div class="khfb_Box">
	<div class="khfb_posLeft">
    	<div class="khfb_pos1" id="quyu" style="overflow-y:auto;height:370px;border:1px solid #ddd;">
        </div>
        <div class="khfb_pos1" id="quyuDetail" style="display:none;overflow-y:auto;height:370px;border:1px solid #ddd;">
        </div>
        <div class="khfb_pos1">
        	<div class="khfb_pos1T"><p><input type="checkbox" id="selectAll" checked/>全选</p><i></i>商户类型</div>
            <div class="khfb_pos1Cont">
            	<ul>
                	<li><a href="#">店铺</a><input id="chdp" type="checkbox" name="type" checked/></li>
                    <li><a href="#">供应商</a><input id="chgy" type="checkbox" name="type" checked/></li>
                    <li><a href="#">物流商</a><input id="chwl" type="checkbox" name="type" checked/></li>
                    <li><a href="#">O2O店铺</a><input id="choo" type="checkbox" name="type" checked/></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="khfb_contR">
    	<div class="khfb_dtTit" id="breadcrumb"><a href="#">全国</a><span>></span><a class="cur" href="#">北京</a></div>
    	<div class="khfb_dtBox">
            <div id="province" style="height:500px;width:100%;"></div>
            <div id="city" style="height:500px;width:100%;display:none;"></div>
            <div id="allmap" style="height:500px;width:100%;display:none;"></div>   
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    [#if area??]
        var arr = ${area};
        var levelOne = [];
        var levelTwo = [];
        var levelThree = [];
        function isNotExist(id,level){
        	var j = 0;
        	for(;j<level.length;j++){
        		if(level[j].id==id){
        			break;
        		}
        	}
        	if(j<level.length&&level.length!=0){return false;}
        	else{return true;}
        }
        for(var i=0;i<arr.length;i++){
        	if(isNotExist(arr[i].ID1,levelOne)){
        		var data = {};
        		data.id=arr[i].ID1;
        		data.name=arr[i].A1;
        		data.PUR_QTY=arr[i].PUR_QTY;
        		data.CUS_QTY=arr[i].CUS_QTY;
        		data.LGS_QTY=arr[i].LGS_QTY;
        		data.O2O_QTY=arr[i].O2O_QTY;
        		levelOne.push(data);
        	}else{
        		for(var x=0;x<levelOne.length;x++){
        			if(levelOne[x].id==arr[i].ID1){
        				levelOne[x].PUR_QTY=levelOne[x].PUR_QTY+arr[i].PUR_QTY;
		        		levelOne[x].CUS_QTY=levelOne[x].CUS_QTY+arr[i].CUS_QTY;
		        		levelOne[x].LGS_QTY=levelOne[x].LGS_QTY+arr[i].LGS_QTY;
		        		levelOne[x].O2O_QTY=levelOne[x].O2O_QTY+arr[i].O2O_QTY;
		        		break;
        			}
        		}
        	}
        	if(isNotExist(arr[i].ID2,levelTwo)){
        		var data = {};
        		data.id=arr[i].ID2;
        		data.parentid=arr[i].ID1;
        		data.parentname=arr[i].A1;
        		data.name=arr[i].A2;
        		data.count=0;
        		data.PUR_QTY=arr[i].PUR_QTY;
        		data.CUS_QTY=arr[i].CUS_QTY;
        		data.LGS_QTY=arr[i].LGS_QTY;
        		data.O2O_QTY=arr[i].O2O_QTY;
        		levelTwo.push(data);
        	}else{
        		for(var x=0;x<levelTwo.length;x++){
        			if(levelTwo[x].id==arr[i].ID2){
        				levelTwo[x].PUR_QTY=levelTwo[x].PUR_QTY+arr[i].PUR_QTY;
		        		levelTwo[x].CUS_QTY=levelTwo[x].CUS_QTY+arr[i].CUS_QTY;
		        		levelTwo[x].LGS_QTY=levelTwo[x].LGS_QTY+arr[i].LGS_QTY;
		        		levelTwo[x].O2O_QTY=levelTwo[x].O2O_QTY+arr[i].O2O_QTY;
		        		break;
        			}
        		}
        	}
        	if(isNotExist(arr[i].ID3,levelThree)){
        		var data = {};
        		data.id=arr[i].ID3;
        		data.parentid=arr[i].ID2;
        		data.parentname=arr[i].A2;
        		data.ppid=arr[i].A1;
        		data.ppname=arr[i].A1;
        		data.name=arr[i].A3;
        		data.count=0;
        		data.PUR_QTY=arr[i].PUR_QTY;
        		data.CUS_QTY=arr[i].CUS_QTY;
        		data.LGS_QTY=arr[i].LGS_QTY;
        		data.O2O_QTY=arr[i].O2O_QTY;
        		levelThree.push(data);
        	}
        }
        for(var i=0;i<levelOne.length;i++){
        	var count = calCount(levelOne[i]);
        	$('#quyu').append('<div class="khfb_pos1T" id="q'+levelOne[i].id+'" data-name="'+levelOne[i].name+'" data-id="'+levelOne[i].id+'"><span>'+count+'</span><i></i>'+levelOne[i].name+'</div>');
        }
        var childContent=[];
        for(var i=0;i<levelTwo.length;i++){
        	var count = calCount(levelTwo[i]);
        	var htm = '<dd><div class="hkfb_ddBox"><i></i><span>'+count+'</span><a data-id="'+levelTwo[i].id+'" data-name="'+levelTwo[i].name+'" data-pname="'+levelTwo[i].parentname+'" id="q'+levelTwo[i].id+'" href="#">'+levelTwo[i].name+'</a></div></dd>';
        	var k=0;
        	for(;k<childContent.length;k++){
        		if(childContent[k].pid==levelTwo[i].parentid){
        			childContent[k].html = childContent[k].html+htm;
        			break;
        		}
        	}
        	if(childContent.length==0 || k==childContent.length){
        		childContent.push({pid:levelTwo[i].parentid,html:htm});
        	}
        }
        for(var i=0;i<childContent.length;i++){
        	$('#q'+childContent[i].pid).after('<div class="khfb_pos1Cont"><dl><dt></dt>'+childContent[i].html+'</dl></div>');
        }
        
        childContent=[];
        for(var i=0;i<levelThree.length;i++){
        	var count = calCount(levelThree[i]);
        	var htm = '<div class="khfb_ddList"><i></i><span>'+count+'</span><a href="#" data-id="'+levelThree[i].id+'" data-name="'+levelThree[i].name+'" data-pname="'+levelThree[i].parentname+'" data-ppname="'+levelThree[i].ppname+'" id="q'+levelThree[i].id+'">'+levelThree[i].name+'</a></div>';
        	var k=0;
        	for(;k<childContent.length;k++){
        		if(childContent[k].pid==levelThree[i].parentid){
        			childContent[k].html = childContent[k].html+htm;
        			break;
        		}
        	}
        	if(childContent.length==0 || k==childContent.length){
        		childContent.push({pid:levelThree[i].parentid,html:htm});
        	}
        }
        for(var i=0;i<childContent.length;i++){
        	$('#q'+childContent[i].pid).parent().after('<div class="khfb_ddlistBox">'+childContent[i].html+'</div>');
        }
        function menuToggle(object){
        	var next = object.next();
        	if(next.is(":visible")){
        		next.slideUp();
        	}else{
        		next.slideDown();
        		next.css('overflow','');
        	}
        }
        $('#quyu').children('.khfb_pos1T').click(function(){
        	menuToggle($(this));
            var name = $(this).data('name');
            var areaid = $(this).data('id');
            $("#breadcrumb").html('<a href="#" id="china">全国</a><span>></span><a class="cur" href="javascript:breadcrumbClick(\''+name+'\');">'+name+'</a>');
            $('#province').show();
            $('#city').hide();
            $('#allmap').hide();
            $('#quyu').show();
            $('#quyuDetail').hide();
            $('#china').click(function(){
            	loadmapProvince('china',0,levelOne);
            });
            
            for(var i=0;i<mapType.length;i++){
                if(name.indexOf(mapType[i])>=0){
		            currentSel.key = mapType[i];
		            currentSel.aid = areaid;
		            currentSel.level = levelTwo;
		            currentSel.grade = 1;
                    loadmapProvince(mapType[i],areaid,levelTwo);
                    break;
                }
            }
        });
        $('.hkfb_ddBox a').click(function(){
        	$('#quyu .hkfb_ddBox').each(function(){
        		if($(this).hasClass('cur')){
        			$(this).removeClass('cur');
        		}
        	});
        	$(this).parent().addClass('cur');
        	menuToggle($(this).parent());
    		var key = $(this).data("name");
        	if(undefined !=cityMap[key]){
	        	$("#breadcrumb").html('<a href="#" id="china">全国</a><span>></span><a href="javascript:breadcrumbClick(\''+$(this).data("pname")+'\');">'+$(this).data("pname")+'</a><span>></span><a class="cur" href="#">'+$(this).data("name")+'</a>');
	            $('#province').hide();
	            $('#city').show();
	            $('#allmap').hide();
	            $('#quyuDetail').hide();
	            $('#quyu').show();
	            $('#china').click(function(){
	            	loadmapProvince('china',0,levelOne);
	            });
	            currentSel.key = $(this).data("name");
	            currentSel.aid = $(this).data("id");
	            currentSel.level = levelThree;
	            currentSel.grade = 2;
	            loadmapCity($(this).data("name"),$(this).data("id"),levelThree);
        	}else{
        		//loadStreet(key,$(this).data("id"));
	            $('#quyu').show();
        		$('#province').show();
	            $('#city').hide();
	            $('#allmap').hide();
	            $('#quyuDetail').hide();
        	}
        });
        $('.khfb_ddList a').click(function(){
        	$('#quyu .khfb_ddList a').each(function(){
        		if($(this).hasClass('active')){
        			$(this).removeClass('active');
        		}
        	});
        	$(this).addClass('active');
        	$("#breadcrumb").html('<a href="#" id="china">全国</a><span>></span><a href="javascript:breadcrumbClick(\''+$(this).data("ppname")+'\');">'+$(this).data("ppname")+'</a><span>></span><a href="javascript:breadcrumbClick(\''+$(this).data("pname")+'\');">'+$(this).data("pname")+'</a><span>></span><a class="cur" href="#">'+$(this).data("name")+'</a>');
        	currentSel.key = $(this).data("name");
            currentSel.aid = $(this).data("id");
            currentSel.grade = 3;
            $('#china').click(function(){
	            $('#quyu').show();
            	$('#province').show();
	            $('#city').hide();
	            $('#allmap').hide();
	            $('#quyuDetail').hide();
            	loadmapProvince('china',0,levelOne);
            });
        	loadStreet($(this).data("name"),$(this).data("id"));
        });
        $('#quyu .khfb_ddlistBox').hide();
        $('#quyu .khfb_pos1Cont').hide();
        
        $($("#quyu").children("div").get(0)).trigger('click');
    [/#if]
    $("#selectAll").change(function(){
	    if ($(this).attr("checked")) {  
	        $("input[name='type']").attr("checked", true);  
	    } else {  
	        $("input[name='type']").attr("checked", false);  
	    } 
	    checkboxChange();
	});
	function checkboxChange(){
		for(var i=0;i<levelOne.length;i++){
        	$('#q'+levelOne[i].id).children(":first").text(calCount(levelOne[i]));
        }
        for(var i=0;i<levelTwo.length;i++){
        	$('#q'+levelTwo[i].id).prev().text(calCount(levelTwo[i]));
        }
        for(var i=0;i<levelThree.length;i++){
        	$('#q'+levelThree[i].id).prev().text(calCount(levelThree[i]));
        }
        if(currentSel.grade ==1){
        	loadmapProvince(currentSel.key,currentSel.aid,currentSel.level);
        }else if(currentSel.grade ==2){
        	loadmapCity(currentSel.key,currentSel.aid,currentSel.level);
        }else if(currentSel.grade == 3){
        	loadStreet(currentSel.key,currentSel.aid);
        }
	}
	$("input[name='type']").change(function(){
		checkboxChange();
	});
});
var currentSel = {};
// 百度地图API功能
var map = new BMap.Map("allmap");
var point = new BMap.Point(116.404, 39.915);
map.centerAndZoom(point, 15);
map.enableScrollWheelZoom(false);    
//启用地图惯性拖拽，默认禁用    
map.enableContinuousZoom();    
// 添加默认比例尺控件    
map.addControl(new BMap.ScaleControl());    
//添加默认缩放平移控件    
map.addControl(new BMap.NavigationControl());


require.config({
    paths: {
        echarts: '${base}/scripts/lib/echarts'
    }
});
function breadcrumbClick(cname){
	$("*[data-name]").each(function(){
		if(cname == $(this).data("name")){
			if(undefined ==cityMap[$(this).data("name")] && undefined != $(this).attr("data-pname")){
				breadcrumbClick($(this).attr("data-pname"));
			}else{
				$(this).trigger('click');
			}
		}
	});
}
function calCount(row){
	var c = 0;
	if($('#chdp').attr("checked")){
		c+=row.CUS_QTY;
	}
	if($('#chgy').attr("checked")){
		c+=row.PUR_QTY;
	}
	if($('#chwl').attr("checked")){
		c+=row.LGS_QTY;
	}
	if($('#choo').attr("checked")){
		c+=row.O2O_QTY;
	}
	return c;
}
var marked = [];
function loadStreet(key,aid){
	$('#province').hide();
    $('#city').hide();
    $('#allmap').show();
    map.clearOverlays();
    marked = [];
	var contentHtml = '';
	var dp = false;
	var gy = false;
	var wl = false;
	var oo = false;
	if($('#chdp').attr("checked")){
		dp = true;
	}
	if($('#chgy').attr("checked")){
		gy = true;
	}
	if($('#chwl').attr("checked")){
		wl = true;
	}
	if($('#choo').attr("checked")){
		oo = true;
	}
	var count = 0;
	if(undefined ==tudes[key]){
		$.ajax({
			url : '${base}/operationsCenter/mapTudebyArea.jhtml',
			type : 'get',
			dataType : 'json',
			data : {aid:aid},
			success : function(data, status, jqXHR) {
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						if(null==data[i].CRM_PIC){data[i].CRM_PIC='';}
						if(null==data[i].CRM_TEL){data[i].CRM_TEL='';}
						if(null==data[i].CRM_ADDRESS1){data[i].CRM_ADDRESS1='';}
						if(null==data[i].BNAME){data[i].BNAME='';}
						if(null==data[i].BTEL){data[i].BTEL='';}
						if((dp && data[i].SALESMEN_FLG=='Y') || (gy && data[i].PURCHASER_FLG=='Y') || (wl && data[i].LOGISTICS_PROVIDER_FLG=='Y') || (oo && data[i].O2O_FLG=='Y')){
							addMarker(new BMap.Point(data[i].LONGITUDE, data[i].LATITUDE),data[i],"red");
							contentHtml += addStreetInfor(data[i]);
							count++;
						}
					}
					map.panTo(new BMap.Point(data[0].LONGITUDE, data[0].LATITUDE));
				}
				tudes[key]=data;
				
				contentHtml = '<div class="khfb_pos1T"><span>'+count+'</span><i></i>'+key+'</div><div class="khfb_pos1Cont">'+contentHtml+'</div>';
				$('#quyu').hide();
				$('#quyuDetail').html(contentHtml);
			    $('#quyuDetail').show();
			}
		});
	}else{
		var data = tudes[key];
		if(data.length>0){
			for(var i=0;i<data.length;i++){
				if((dp && data[i].SALESMEN_FLG=='Y') || (gy && data[i].PURCHASER_FLG=='Y') || (wl && data[i].LOGISTICS_PROVIDER_FLG=='Y') || (oo && data[i].O2O_FLG=='Y')){
					addMarker(new BMap.Point(data[i].LONGITUDE, data[i].LATITUDE),data[i],"red");
					contentHtml += addStreetInfor(data[i]);
					count++;
				}
			}
		}else{
			//console.log("had marked");
		}
		moveTo(data[0].LONGITUDE, data[0].LATITUDE);
		$('#province').hide();
        $('#city').hide();
        $('#allmap').show();
        
        contentHtml = '<div class="khfb_pos1T"><span>'+count+'</span><i></i>'+key+'</div><div class="khfb_pos1Cont">'+contentHtml+'</div>';
		$('#quyu').hide();
		$('#quyuDetail').html(contentHtml);
	    $('#quyuDetail').show();
	}
	
}
function moveTo(longitude,latitude){
	map.panTo(new BMap.Point(longitude, latitude));
}
function addStreetInfor(row){
	var h = '';
	h+='<div class="fb_threeList">';
	h+='<div class="fb_threeT"><a href="javascript:moveTo('+row.LONGITUDE+','+row.LATITUDE+')">'+row.NAME+'</a></div>';
	h+='<div class="fb_threeC">联系人：'+row.CRM_PIC+'</div>';
	h+='<div class="fb_threeC">电话：'+row.CRM_TEL+'</div>';
	h+='<div class="fb_threeC">地址：'+row.CRM_ADDRESS1+'</div>';
	h+='</div>';
	return h;
}
function mentype(r){
	var t = '';
	if(r.SALESMEN_FLG=='Y'){t+='店铺,';}
	if(r.PURCHASER_FLG=='Y'){t+='供货商,';}
	if(r.LOGISTICS_PROVIDER_FLG=='Y'){t+='物流商,';}
	if(r.O2O_FLG=='Y'){t+='O2O店铺,';}
	if(''!=t){t = t.substring(0,t.length-1);}
	return t;
}
function addMarker(point,rowData,color){
	//设置marker图标为水滴
	var marker = new BMap.Marker(point, {
	  // 指定Marker的icon属性为Symbol
	  icon: new BMap.Symbol(BMap_Symbol_SHAPE_POINT, {
	    scale: 1,//图标缩放大小
	    fillColor: color,//填充颜色
	    fillOpacity: 0.6,//填充透明度
	    enableMassClear:true
	  })
	});
	marker.addEventListener("click", function(e){
		map.openInfoWindow(new BMap.InfoWindow('<div class="map_posCont"><p>联系人：'+rowData.CRM_PIC+'</p><p>电话：'+rowData.CRM_TEL+'</p><p>地址：'+rowData.CRM_ADDRESS1+
		'</p><p>客户类型：'+mentype(rowData)+'</p><p>客户经理：'+rowData.BNAME+'</p><p>联系电话：'+rowData.BTEL+'</p>',{width:230,height:180,title:'<div class="map_posTit"><span></span>'+rowData.NAME+'</div></div>'}),point);
    });
	var x = Math.round(Math.random()*25);
	var y = Math.round(Math.random()*20)-20;
	//console.log(x+"---"+y);
	//marker.setLabel(new BMap.Label(rowData.NAME,{offset:new BMap.Size(x,y)}));
	map.addOverlay(marker);
}
function calMapData(level,aid){
	var data = [];
	var max = 0;
	if(aid!=0){
		for(var i=0;i<level.length;i++){
			if(level[i].parentid==aid){
				var count = calCount(level[i]);
				if(count>max) max=count;
				data.push({name:level[i].name,value:count});
			}
		}
	}else{
		for(var i=0;i<level.length;i++){
			var count = calCount(level[i]);
			if(count>max) max=count;
			var proName = level[i].name;
			for(var x=0;x<mapType.length;x++){
				if(level[i].name.indexOf(mapType[x])>=0){
					proName = mapType[x];
					break;
				}
			}
			data.push({name:proName,value:count});
		}
	}
	return {data:data,max:max};
}
function mapTitle(){
	var title = "";
	if($('#chdp').attr("checked")){
		title += '店铺+';
	}
	if($('#chgy').attr("checked")){
		title += '供应商+';
	}
	if($('#chwl').attr("checked")){
		title += '物流商+';
	}
	if($('#choo').attr("checked")){
		title += 'O2O店铺+';
	}
	if(''!=title){
		title = title.substring(0,title.length-1);
	}
	return title;
}

var mapType=['广东','青海','四川','海南','陕西','甘肃','云南','湖南','湖北','黑龙江','贵州','山东','江西','河南','河北','山西','安徽','福建','浙江','江苏','吉林','辽宁','台湾','新疆','广西','宁夏','内蒙古','西藏','北京','天津','上海','重庆','香港','澳门'];
var cityMap={"北京市":"110100","天津市":"120100","上海市":"310100","重庆市":"500100","崇明县":"310200","湖北省直辖县市":"429000","铜仁市":"522200","毕节市":"522400","石家庄市":"130100","唐山市":"130200","秦皇岛市":"130300","邯郸市":"130400","邢台市":"130500","保定市":"130600","张家口市":"130700","承德市":"130800","沧州市":"130900","廊坊市":"131000","衡水市":"131100","太原市":"140100","大同市":"140200","阳泉市":"140300","长治市":"140400","晋城市":"140500","朔州市":"140600","晋中市":"140700","运城市":"140800","忻州市":"140900","临汾市":"141000","吕梁市":"141100","呼和浩特市":"150100","包头市":"150200","乌海市":"150300","赤峰市":"150400","通辽市":"150500","鄂尔多斯市":"150600","呼伦贝尔市":"150700","巴彦淖尔市":"150800","乌兰察布市":"150900","兴安盟":"152200","锡林郭勒盟":"152500","阿拉善盟":"152900","沈阳市":"210100","大连市":"210200","鞍山市":"210300","抚顺市":"210400","本溪市":"210500","丹东市":"210600","锦州市":"210700","营口市":"210800","阜新市":"210900","辽阳市":"211000","盘锦市":"211100","铁岭市":"211200","朝阳市":"211300","葫芦岛市":"211400","长春市":"220100","吉林市":"220200","四平市":"220300","辽源市":"220400","通化市":"220500","白山市":"220600","松原市":"220700","白城市":"220800","延边朝鲜族自治州":"222400","哈尔滨市":"230100","齐齐哈尔市":"230200","鸡西市":"230300","鹤岗市":"230400","双鸭山市":"230500","大庆市":"230600","伊春市":"230700","佳木斯市":"230800","七台河市":"230900","牡丹江市":"231000","黑河市":"231100","绥化市":"231200","大兴安岭地区":"232700","南京市":"320100","无锡市":"320200","徐州市":"320300","常州市":"320400","苏州市":"320500","南通市":"320600","连云港市":"320700","淮安市":"320800","盐城市":"320900","扬州市":"321000","镇江市":"321100","泰州市":"321200","宿迁市":"321300","杭州市":"330100","宁波市":"330200","温州市":"330300","嘉兴市":"330400","湖州市":"330500","绍兴市":"330600","金华市":"330700","衢州市":"330800","舟山市":"330900","台州市":"331000","丽水市":"331100","合肥市":"340100","芜湖市":"340200","蚌埠市":"340300","淮南市":"340400","马鞍山市":"340500","淮北市":"340600","铜陵市":"340700","安庆市":"340800","黄山市":"341000","滁州市":"341100","阜阳市":"341200","宿州市":"341300","六安市":"341500","亳州市":"341600","池州市":"341700","宣城市":"341800","福州市":"350100","厦门市":"350200","莆田市":"350300","三明市":"350400","泉州市":"350500","漳州市":"350600","南平市":"350700","龙岩市":"350800","宁德市":"350900","南昌市":"360100","景德镇市":"360200","萍乡市":"360300","九江市":"360400","新余市":"360500","鹰潭市":"360600","赣州市":"360700","吉安市":"360800","宜春市":"360900","抚州市":"361000","上饶市":"361100","济南市":"370100","青岛市":"370200","淄博市":"370300","枣庄市":"370400","东营市":"370500","烟台市":"370600","潍坊市":"370700","济宁市":"370800","泰安市":"370900","威海市":"371000","日照市":"371100","莱芜市":"371200","临沂市":"371300","德州市":"371400","聊城市":"371500","滨州市":"371600","菏泽市":"371700","郑州市":"410100","开封市":"410200","洛阳市":"410300","平顶山市":"410400","安阳市":"410500","鹤壁市":"410600","新乡市":"410700","焦作市":"410800","濮阳市":"410900","许昌市":"411000","漯河市":"411100","三门峡市":"411200","南阳市":"411300","商丘市":"411400","信阳市":"411500","周口市":"411600","驻马店市":"411700","省直辖县级行政区划":"469000","武汉市":"420100","黄石市":"420200","十堰市":"420300","宜昌市":"420500","襄阳市":"420600","鄂州市":"420700","荆门市":"420800","孝感市":"420900","荆州市":"421000","黄冈市":"421100","咸宁市":"421200","随州市":"421300","恩施土家族苗族自治州":"422800","长沙市":"430100","株洲市":"430200","湘潭市":"430300","衡阳市":"430400","邵阳市":"430500","岳阳市":"430600","常德市":"430700","张家界市":"430800","益阳市":"430900","郴州市":"431000","永州市":"431100","怀化市":"431200","娄底市":"431300","湘西土家族苗族自治州":"433100","广州市":"440100","韶关市":"440200","深圳市":"440300","珠海市":"440400","汕头市":"440500","佛山市":"440600","江门市":"440700","湛江市":"440800","茂名市":"440900","肇庆市":"441200","惠州市":"441300","梅州市":"441400","汕尾市":"441500","河源市":"441600","阳江市":"441700","清远市":"441800","东莞市":"441900","中山市":"442000","潮州市":"445100","揭阳市":"445200","云浮市":"445300","南宁市":"450100","柳州市":"450200","桂林市":"450300","梧州市":"450400","北海市":"450500","防城港市":"450600","钦州市":"450700","贵港市":"450800","玉林市":"450900","百色市":"451000","贺州市":"451100","河池市":"451200","来宾市":"451300","崇左市":"451400","海口市":"460100","三亚市":"460200","三沙市":"460300","成都市":"510100","自贡市":"510300","攀枝花市":"510400","泸州市":"510500","德阳市":"510600","绵阳市":"510700","广元市":"510800","遂宁市":"510900","内江市":"511000","乐山市":"511100","南充市":"511300","眉山市":"511400","宜宾市":"511500","广安市":"511600","达州市":"511700","雅安市":"511800","巴中市":"511900","资阳市":"512000","阿坝藏族羌族自治州":"513200","甘孜藏族自治州":"513300","凉山彝族自治州":"513400","贵阳市":"520100","六盘水市":"520200","遵义市":"520300","安顺市":"520400","黔西南布依族苗族自治州":"522300","黔东南苗族侗族自治州":"522600","黔南布依族苗族自治州":"522700","昆明市":"530100","曲靖市":"530300","玉溪市":"530400","保山市":"530500","昭通市":"530600","丽江市":"530700","普洱市":"530800","临沧市":"530900","楚雄彝族自治州":"532300","红河哈尼族彝族自治州":"532500","文山壮族苗族自治州":"532600","西双版纳傣族自治州":"532800","大理白族自治州":"532900","德宏傣族景颇族自治州":"533100","怒江傈僳族自治州":"533300","迪庆藏族自治州":"533400","拉萨市":"540100","昌都地区":"542100","山南地区":"542200","日喀则地区":"542300","那曲地区":"542400","阿里地区":"542500","林芝地区":"542600","西安市":"610100","铜川市":"610200","宝鸡市":"610300","咸阳市":"610400","渭南市":"610500","延安市":"610600","汉中市":"610700","榆林市":"610800","安康市":"610900","商洛市":"611000","兰州市":"620100","嘉峪关市":"620200","金昌市":"620300","白银市":"620400","天水市":"620500","武威市":"620600","张掖市":"620700","平凉市":"620800","酒泉市":"620900","庆阳市":"621000","定西市":"621100","陇南市":"621200","临夏回族自治州":"622900","甘南藏族自治州":"623000","西宁市":"630100","海东地区":"632100","海北藏族自治州":"632200","黄南藏族自治州":"632300","海南藏族自治州":"632500","果洛藏族自治州":"632600","玉树藏族自治州":"632700","海西蒙古族藏族自治州":"632800","银川市":"640100","石嘴山市":"640200","吴忠市":"640300","固原市":"640400","中卫市":"640500","乌鲁木齐市":"650100","克拉玛依市":"650200","吐鲁番地区":"652100","哈密地区":"652200","昌吉回族自治州":"652300","博尔塔拉蒙古自治州":"652700","巴音郭楞蒙古自治州":"652800","阿克苏地区":"652900","克孜勒苏柯尔克孜自治州":"653000","喀什地区":"653100","和田地区":"653200","伊犁哈萨克自治州":"654000","塔城地区":"654200","阿勒泰地区":"654300","自治区直辖县级行政区划":"659000","台湾省":"710000","香港特别行政区":"810100","澳门特别行政区":"820000"};
var tudes={};

function loadmapCity(cityName,areaid,levelThree){
	require(
  [
    'echarts',
    'echarts/chart/map' // 使用地图就加载map模块
  ],
  function(ec) {
    var curIndx = 0;
    var mapType = [];
    var mapGeoData = require('echarts/util/mapData/params');
    //console.log(mapGeoData)
    for (var city in cityMap) {
      mapType.push(city);
      // 自定义扩展图表类型
      mapGeoData.params[city] = {
        getGeoJson: (function(c) {
          var geoJsonName = cityMap[c];
          return function(callback) {
            $.getJSON('${base}/scripts/lib/echarts/geoJson/china-main-city/' + geoJsonName + '.json', callback);
          }
        })(city)
      }
    }
   
    var mapData = calMapData(levelThree,areaid);
	
	option = {
	    title : {
	        text: cityName+':'+mapTitle(),
	        x:'center'
	    },
	    tooltip : {
	        trigger: 'item'
	    },
	    dataRange: {
	        min: 0,
	        max: mapData.max,
	        x: 'left',
	        y: 'bottom',
	        text:['高','低'],           // 文本，默认为数值文本
	        calculable : true
	    },
	    toolbox: {
	        show: true,
	        orient : 'vertical',
	        x: 'right',
	        y: 'center',
	        feature : {
	            mark : {show: true},
	            dataView : {show: true, readOnly: false},
	            restore : {show: true},
	            saveAsImage : {show: true}
	        }
	    },
	    series : [
	        {
	            name: cityName,
	            type: 'map',
	            mapType: cityName,
	            selectedMode : 'single',
	            itemStyle:{
	                normal:{label:{show:true}},
	                emphasis:{label:{show:true}}
	            },
	            data:mapData.data
	        }
	    ]
	};
	
	var myChart = ec.init(document.getElementById('city'));
	myChart.setOption(option);
	});
}

function loadmapProvince(areaName,areaid,levelTwo){
    require(
        [
            'echarts',
            'echarts/chart/map' // 使用柱状图就加载bar模块，按需加载
        ],
        function (ec) {
            // 基于准备好的dom，初始化echarts图表
            var myChart = ec.init(document.getElementById('province'));
			var mapData = calMapData(levelTwo,areaid);
			var mm = areaName;
			if(areaName=='china'){mm='全国';}
            option = {
            	 title : {
			        text: mm+':'+mapTitle(),
			        x:'center'
			    },
			    tooltip : {
			        trigger: 'item'
			    },
			    dataRange: {
			        min: 0,
			        max: mapData.max,
			        x: 'left',
			        y: 'bottom',
			        text:['高','低'],           // 文本，默认为数值文本
			        calculable : true
			    },
			    toolbox: {
			        show: true,
			        orient : 'vertical',
			        x: 'right',
			        y: 'center',
			        feature : {
			            mark : {show: true},
			            dataView : {show: true, readOnly: false},
			            restore : {show: true},
			            saveAsImage : {show: true}
			        }
			    },
                series : [
                    {
                        name: '中国',
                        type: 'map',
                        mapType: areaName,
                        selectedMode : 'multiple',
                        itemStyle:{
                            normal:{label:{show:true}},
                            emphasis:{label:{show:true}}
                        },
                        data:mapData.data
                    }
                ]
            };
    
            // 为echarts对象加载数据 
            myChart.setOption(option);
        }
    )
}

</script>
	</center>
	</body>
</html>