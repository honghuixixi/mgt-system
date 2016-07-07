<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>经营指标分析</title>
           [#include "/common/commonHead.ftl" /]
        	<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
        	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
        	<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>	
        	<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
            <script src="http://cdn.hcharts.cn/highcharts/highcharts.js" type="text/javascript"></script>
        	<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
	   
	   <script  type="text/javascript">
	    $(document).ready(function(){
	    	//设置默认时间
			var date = new Date();
			$("#endDate").val(date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate());
    		date.setDate(date.getDate() - 30);
    		$("#startDate").val(date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate());
    		//默认按日统计
			$("#dayDiv").css({"background-color":"#C2DFF7","border-radius":"5px"});
			//统计数据
	    	statisticsOperateIndicators();
	    	//下拉框事件
	    	$('#statisticType').change(function(){
	    		statisticsOperateIndicators();
	    	});
			//点击统计方式 按日/周/月
			$("#time_type .form-group ").click(function() {
				var $str = $(this).find("label").attr("name");
				$("#staTimeType").val($str);
				if ($str == "day" || $str == "month" || $str == "week") {
					//$(this).siblings("div").css("background-color","white");
					$(this).siblings("div").css("background-color","");
					$(this).css({"background-color":"#C2DFF7","border-radius":"5px"});
				} 
				statisticsOperateIndicators();
		    });
		})

		//生成统计图表
        function makeHighcharts(categories,text,valueSuffix,name,data){
        	    $('#container').highcharts({
	        	        title: {
	        	            text: '营运指标统计',
	        	            x: -20 
	        	        },
	        	        subtitle: {
	        	            text: '来源：http://www.11wlw.cn/',
	        	            x: -20
	        	        },
	        	        xAxis: {
	        	            categories: categories
	        	        },
	        	        yAxis: {
	        	            title: {
	        	                text: text
	        	            },
	        	            plotLines: [{
	        	                value: 0,
	        	                width: 1,
	        	                color: '#808080'
	        	            }]
	        	        },
	        	        tooltip: {
	        	            valueSuffix: valueSuffix//'°C'
	        	        },
	        	        legend: {
	        	            layout: 'vertical',
	        	            align: 'right',
	        	            verticalAlign: 'middle',
	        	            borderWidth: 0
	        	        },
	        	        credits: {
			            	text: '11wlw.cn',
			            	href: 'http://www.11wlw.cn/'
			        	},
	        	        series: [{
	        	            name: name,
	        	            data: data
	        	        }]
        	    });
        }
        //ajax获取统计数据
        function statisticsOperateIndicators(){
        	$.ajax({
					url:'${base}/operateIndicators/statistics.jhtml',
					sync:false,
					type : 'post',
					data :{
						'startDate':$('#startDate').val(),
						'endDate':$('#endDate').val(),
						'staTimeType':$('#staTimeType').val(),
						'statisticType':$('#statisticType').val()
					},
					dataType : "json",
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						data = eval(data);
						var categories = new Array();
						var datas = new Array();
						for(var i=0; i<data.length; i++){
							var item = eval(data[i]);
							if(item.hasOwnProperty('DAY')){
								categories[i] = item.DAY + "日";
							}
							if(item.hasOwnProperty('MONTH')){
								categories[i] = item.MONTH + "月";
							}
							if(item.hasOwnProperty('WEEK')){
								categories[i] = item.WEEK + "周";
							}
							if(item.hasOwnProperty('ORDER_AMOUNT')){
								datas[i] = item.ORDER_AMOUNT;
							}
							if(item.hasOwnProperty('ORDER_NUM')){
								datas[i] = item.ORDER_NUM;
							}
							if(item.hasOwnProperty('ORDER_MASCAT_NUM')){
								datas[i] = item.ORDER_MASCAT_NUM;
							}
						}
						var name = $("#statisticType").find("option:selected").text();
						var value = $("#statisticType").find("option:selected").val();
						var yName = "数量";
						if(value == "1"){yName = "金额";}
						if(value == "2"){yName = "数量";}
						if(value == "3"){yName = "品种数";}
						makeHighcharts(categories,yName,'',name,datas);
					}
				  });
				  $("#endDate").blur();
				  $("#startDate").blur();
        }
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
       		<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="attendanceStatistics" class="sub_status_but active"><a href="#"> 经营指标分析</a></li>					
						</ul>
					</div>
					<div id="onFinishSt_new" style="display:block;">
						<div class="form-group">
							<li class="time_li" style="height:30px;">
								<input type="text" id="startDate" name="startDate" value="${startDate}"  style="width:90px;" class="form-control">&nbsp;<span style="margin-top:10px;">至</span>&nbsp;
								<input type="text" id="endDate" name="endDate" value="${endDate}"  style="width:90px;" class="form-control">
								<script type="text/javascript"> 
								$(function(){
							         $("#startDate").bind("click",function(){
							            WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',onpicked:function(){endDate.click();}});
							         });
							         $("#endDate").bind("click",function(){
							            WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: statisticsOperateIndicators});
							         });
								});
								</script>
								<div id="time_type" style="display:inline;">
									 <div class="form-group" id="dayDiv" style="margin-left:30px;width:20px;text-align:center;vertical-align: middle;">
					           			 <label name="day" class="control-label" style="width:20px;height:20px;">日</label>
					               	 </div>
					           		 <div class="form-group" style="width:20px;text-align:center;">
					           			 <label  name="week" class="control-label" style="width:20px;height:20px;">周</label>
					               	 </div>
					           		 <div class="form-group" style="width:20px;text-align:center;">
					           			 <label  name="month" class="control-label" style="width:20px;height:20px;">月</label>
					               	 </div>
					               	 <input type="hidden" name="staTimeType" id="staTimeType" value="day"/>
				               	 </div>
				               	 <div class="form-group">
					               	 <select id="statisticType" name="statisticType" style="width:120px;height:26px;">
							            <option value="1" selected>销售金额</option>
							            <option value="2" >销售数量</option>
							            <option value="3" >销售品种数</option>
							 		</select>
						 		</div>
							</li>
							
						 </div>
					</div>
					<div id="container" style="min-width:600px;width:100%;height:350px;float:left;margin-top:20px;" style="display:block"></div>
	            </form>
	        </div>
	      </div>
   		</div>
    </body>
</html>
 



