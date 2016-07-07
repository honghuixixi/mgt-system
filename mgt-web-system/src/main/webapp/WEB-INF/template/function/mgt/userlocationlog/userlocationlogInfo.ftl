<!DOCTYPE html>
<html lang="zh-cn" class="html_ofh">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-角色信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
			<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";padding:0;}
	</style>
			<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=DDb12a84344b679c799680268e263ad7"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mapht();
				    //map左侧点击
				    $(".map_left li").click(function(){
				    	$(".map_left li").removeClass("cur");
				    	$(this).addClass("cur");
				    })
						
			});
			
			function mapht(){
				var dmentHeight = $(document.body).height();
			    var div1Height = $(".main_heightBox1").height()+10;
			    var mapHeight = dmentHeight-div1Height
			    $(".map_right").css("height",mapHeight)
			    $(".map_left").css("height",mapHeight)
		    
		    }
		    $(window).resize(function() {
			    mapht();
			});
			
			$(window).scroll(function() {
			    mapht();
			})
			$(window).click(function() {
			    mapht();
			})
		</script>
    </head>
    <body>
    <div id="mapDIV" >
       <div class="body-container">
       		<div class="main_heightBox1 userlocationLog">
       			<div id="currentDataDiv" action="role">
					<div class="form_divBox" style="display:block;padding:0 10px;">
			            <form class="form form-inline" id="query-form-location" method="post" action="${base}/userlocationlog/list.jhtml"> 
		                <input type="hidden" id="pageIndex" name="pageIndex" value="1">
						<input type="hidden" id="types" name="types" >
						<div class="ygcxBtn_borBox clearfix">
							<div class="ygcxBtn-box"><label style="width:70px;" class="control-label">选择员工</label><input type="text" class="form-control input-sm required" name="userName" id="userName" readonly="readonly"  ><a href="#"   onclick="choiceUserName('mapDIV','empListDIV')"></a></div>
			            	<div class="ygcxBtn-box"><span></span><label style="width:70px;" class="control-label">查询日期</label><input type="text" class="form-control input-sm required" id="createDate" style="width:160px;" name="createDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'});" value="${sDate }" ></div>
			                    		<div id="pageDIV" align="right" style="display: none;">
				<input type="button" value="上一页"  class="btn_divBtn" id="backPage"  onclick="pageTurning(0)">
				<input type="button" value="下一页"  class="btn_divBtn" id="nextPage" onclick="pageTurning(1)">
				</div>
			            </div>
			            <div style="clear:both;"></div>
					     	<div class="form-group" style="float:left;padding:0 0 5px 0px;border-bottom:solid 1px #e8e8e8;width:100%;">
								<!-- <label class="control-label">交易类型:</label>
								changeType;       //类型 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销 -->
								<span style="display:inline-block;line-height:26px;padding:6px 0 0 10px;float:left;">详细条件搜索：</span>
								<input class="form-control required"  type="checkbox" id="type01" name="type" value="C">
								<label class="control-label" for="type01" style="width: 30px;">考勤</label>
								
								<input class="form-control required"  type="checkbox" id="type02" name="type" value="S">
								<label class="control-label" for="type02" style="width: 60px;">提交订单</label>
								
								<input class="form-control required"  type="checkbox" id="type03" name="type" value="L">
								<label class="control-label" for="type03" style="width: 60px;">配送完成</label>
								
								<input class="form-control required"  type="checkbox" id="type04" name="type" value="V">
								<label class="control-label" for="type04" style="width: 60px;">店铺拜访</label>
								
								<input class="form-control required"  type="checkbox" id="type05" name="type" value="N">
								<label class="control-label" for="type05" style="width: 60px;">新店登记</label>
								
								<input class="form-control required"  type="checkbox" id="type06" name="type" value="U">
								<label class="control-label" for="type06" style="width: 60px;">店铺升级</label>
								
								<input class="form-control required"  type="checkbox" id="type07" name="type" value="R">
								<label class="control-label" for="type07" style="width: 60px;">领取订单</label>
								
								<input class="form-control required"  type="checkbox" id="type08" name="type" value="P">
								<label class="control-label" for="type08" style="width: 60px;">拣货完成</label>
								<input class="form-control required"  type="checkbox" id="type09" name="type" value="G">
								<label class="control-label" for="type09" style="width: 60px;">价格采集</label>
							</div>
			            </form>
			
			        </div>
			         <div class="search_cBox" style="bottom:17px;">
			        	<div class="form-group">
		                 	<button type="button" class="search_cBox_btn" id="userlocationlog_search" onclick="$('#pageIndex').val(1);userlocationlogSearch()"><i class="icon-search"></i> 搜 索 </button>
		                </div>
			        </div> 
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
					<div id="pageDIV" align="center" style="display: none;">
				<input type="button" value="上一页"  class="btn_divBtn" id="backPage"  onclick="pageTurning(0)">
				<input type="button" value="下一页"  class="btn_divBtn" id="nextPage" onclick="pageTurning(1)">
				</div>
			</div>
   			<div class="map_right"><div id="allmap"></div></div>
   		</div>
   		
   		</div>
   		<div  style="display: none;" id="empListDIV">
   			<div class="navbar-fixed-top" id="toolbar" style="z-index:1000000;top:10px;text-align:right;height:30px;background:none;">
	    <button class="btn btn-danger" onclick="selectEmp()">选择
		    <i class="fa-save align-top bigger-125 fa-on-right"></i>
	    </button>
		<button class="btn btn-warning"  onclick="choiceUserName('empListDIV','mapDIV')">
			关闭 <i class="fa-undo align-top bigger-125 fa-on-right" ></i>
		</button>
	</div >
   			[#include "/function/mgt/userlocationlog/choiceUserName.ftl" /]
   		</div>
   		
    </body>
    <input type="hidden" id="pageSize" value="10">
    <input type="hidden" id="count" value="10">
    <input type="hidden" id="pageCount" value="0">
</html>
 <script>
 	var pageSize = 10;
	var map = new BMap.Map("allmap");    // 创建Map实例
	map.centerAndZoom(new BMap.Point(115.990, 40.115), 11);  // 初始化地图,设置中心点坐标和地图级别
	map.addControl(new BMap.MapTypeControl());   //添加地图类型控件
	map.setCurrentCity("北京");          // 设置地图显示的城市 此项是必须设置的
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	
	
	
 function choiceUserName(obj,obj1){
// 	 mgt_util.showjBox({
// 			width : 800,
// 			height : 460,
// 			title : '选择员工',
// 			url : '${base}/userlocationlog/choiceUserName.jhtml',
// 			grid : $('#grid-table')
// 		});
	 
	 $("#"+obj).css('display','none');
	 $("#"+obj1).css('display','block');
 }
 
 function userlocationlogSearch(){
	 
	 var userName = $("#userName").val();
	 var createDate = $("#createDate").val();
	 if(null==userName||''==userName){
        	top.$.jBox.tip('请选择员工！', 'error');
		 return;
	 }
	 if(null==createDate||''==createDate){
     	top.$.jBox.tip('请选择时间！', 'error');
		 return;
	 }
		var types = '';
        $("input[name='type']:checked").each(function(){
        	types+=$(this).val()+",";
        });
        if(''!=types){
        	$("#types").val(types);
        }else{
        	$("#types").val(null);
        	
        }
	 
	 $('#query-form-location').ajaxSubmit({
			success: function (html, status) {
				$("#addressUl").find("li").remove();
				map.clearOverlays(); 
				 var data = html.data.itemList;
				 var total = html.data.total;
				 var pageIndex = $("#pageIndex").val();
				 if(data.length>0){
						  if(total>data.length){
							  if((total%pageSize)!=0){
							  $("#pageCount").val(parseInt(total/pageSize)+1);
							  }else{
								  $("#pageCount").val(total/pageSize);  
							  }
							  $("#pageDIV").css("display","block");
							  $("#backPage").attr("disabled","disabled");
							  $("#nextPage").removeAttr("disabled");
						  }else if(total==data.length&&pageIndex==1){
							  $("#pageDIV").css("display","none");
						  }
					 
					 var arr = [data.length];
						                       //清除地图上所有的覆盖物  
						 var walking = new BMap.WalkingRoute(map);    //创建步行实例  
						for(var i=0;i<data.length;i++){
							
							var messageText='';
							//C 考勤；S 提交订单；L 配送完成；V 店铺拜访；N 新店登记；U 店铺升级；R 领取订单；P 捡货完成；G 价格采集
							if(data[i].TYPE=='C'){
								messageText='打考勤';
							}
							else if(data[i].TYPE=='S'){
								messageText='提交订单';
							}
							else if(data[i].TYPE=='L'){
								messageText='配送完成';
							}
							else if(data[i].TYPE=='V'){
								messageText='店铺拜访';
							}
							else if(data[i].TYPE=='N'){
								messageText='登记新客户';
							}
							else if(data[i].TYPE=='U'){
								messageText='创建了正式客户';
							}
							else if(data[i].TYPE=='R'){
								messageText='领取待配送订单';
							}
							else if(data[i].TYPE=='P'){
								messageText='完成了拣货';
							}
							else if(data[i].TYPE=='G'){
								messageText='进行了价格采集';
							}
							
							//var date=new Date(data[i].CREATE_DATE);
							$("#addressUl").append('<li>'+
							'<span>'+(parseInt(i+1)+parseInt((pageIndex-1)*pageSize))+'</span>'+
							'<div class="map_contPbox">'+
							'	<p title="'+messageText+'"><font>'+messageText+'</font><em>'+data[i].CREATE_DATE+'</em></p>'+
							'	<p title="'+data[i].MEMO+'">'+data[i].MEMO+'</p>'+
							'</div>'+
							'</li>')
							if(i==(data.length-1)&&i!=0){
								
								arr[i]=new BMap.Point(data[i].LONGITUDE,data[i].LATITUDE);
							break;
							}
							 var myp = new BMap.Point(data[i].LONGITUDE,data[i].LATITUDE);    //起点-重庆  
							 var j=i;
							 if(data.length!=1){
								 j=i+1;
							 }
							 var myp1 = new BMap.Point(data[j].LONGITUDE,data[j].LATITUDE);    //起点-重庆  

							 walking.search(myp, myp1);                 //第一个驾车搜索  
						        arr[i]=myp;
					 	}
						
						walking.setSearchCompleteCallback(function(){
				        	 var pts = walking.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组  

				             var polyline = new BMap.Polyline(pts,{strokeColor:"blue", strokeWeight:6, strokeOpacity:0.5});       
				             map.addOverlay(polyline);  
				        		for(var i=0;i<data.length;i++){
				       			 var myIcon = new BMap.Icon("${base}/styles/images/makers.png", new BMap.Size(23, 30), {
									    offset: new BMap.Size(10, 30),
									    imageOffset: new BMap.Size(0, 0 - (i+(parseInt((pageIndex-1)*pageSize))) * 30)

									  });
			        			 var myp = new BMap.Point(data[i].LONGITUDE,data[i].LATITUDE);      
			            	 var m1 = new BMap.Marker(myp,{icon: myIcon,title:i+1+parseInt((pageIndex-1)*pageSize)})
				             map.addOverlay(m1);  
				               
				             var lab1 = new BMap.Label('',{position:myp});        //创建3个label  
				             map.addOverlay(lab1);  
				        		}
				               
				             setTimeout(function(){  
				                map.setViewport(arr);          //调整到最佳视野  
				             },1000);  
				        	
				        }); 
						
						  $(".map_left li").click(function(){
						    	$(".map_left li").removeClass("cur");
						    	$(this).addClass("cur");
						    })
					 
					 
				 }else{
					  $("#pageDIV").css("display","none");
				 }
			},error : function(data){
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
			}
		});
 }
 
 function selectEmp(){
	 var id = $("#grid-table").jqGrid('getGridParam', 'selrow');
		if (id.length <= 0) {
			top.$.jBox.tip('请选择一条记录！');
			return;
		} 
		
		var rowData = $('#grid-table').jqGrid('getRowData',id);
		$("#userName").val(rowData.ACCOUNT_NAME);
		choiceUserName('empListDIV','mapDIV');
 }
 

 function pageTurning(flg){
	 if(flg==0){
		 $("#pageIndex").val(parseInt($("#pageIndex").val())-1);
	 }else{
		 $("#pageIndex").val(parseInt($("#pageIndex").val())+1);
	 }
	 var pageIndex = $("#pageIndex").val();
	 var pageCount = $("#pageCount").val();
	 if(pageIndex==1){
		  $("#backPage").attr("disabled","disabled");
		  $("#nextPage").removeAttr("disabled");
	 }
	 else if(pageIndex==pageCount){
		  $("#nextPage").attr("disabled","disabled");
		  $("#backPage").removeAttr("disabled");
	 }else{
		 $("#nextPage").removeAttr("disabled");
		 $("#backPage").removeAttr("disabled");
	 }
	 
	 userlocationlogSearch();
	  
 }
 </script>