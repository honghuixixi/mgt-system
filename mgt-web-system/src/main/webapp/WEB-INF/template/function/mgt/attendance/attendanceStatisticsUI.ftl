<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
           [#include "/common/commonHead.ftl" /]
        	<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
        	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
        	<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>	
        	<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
        	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.jqGrid.src.js"></script>	
            <script src="http://cdn.hcharts.cn/highcharts/highcharts.js" type="text/javascript"></script>
        	<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
	   
	   <script  type="text/javascript">
	    $(document).ready(function(){
		    $("#onFinishSt_new").show();
		    $("#container").show();
		    $("#onFinishSt").hide();
	    	getKeyIndex();
	    	getFlg();
	    	
	    	
			$("li.sub_status_but").on("click",function() {
				$('#grid-table').GridUnload();
				if("attendanceStatistics" == $(this).attr("id")) { 
					$("li.sub_status_but").removeClass("active");
		    		$(this).addClass("active");
		    		$("#onFinishSt").hide();
		    		$("#onFinishSt_new").show();
		    		$("#container").show();
				} 
				if("attendanceStatisticsByPerson" == $(this).attr("id")) { 
					$("li.sub_status_but").removeClass("active");
		    		$(this).addClass("active");
		    		$("#onFinishSt").show();
		    		$("#onFinishSt_new").hide();
		    		$("#container").hide();
		    		mgt_util.jqGrid('#grid-table',{
						url:'${base}/attendance/getMoaAttendantList.jhtml',
						colNames:['工号','姓名','工作日天数','工作日考勤正常天','迟到天数','早退天数','工作日考勤异常天'],
						colModel:[	 
								{name:'USER_CODE', width:100, align:"center"},
								{name:'USER_NAME', width:100, align:"center"},
								{name:'WORK_DAY_TOTAL', width:100, align:"center"},
								{name:'WORK', width:100, align:"center",formatter:function(data, options, rowObject){
									if (data == null) {
										return "--"
									} else {
										return data;
									}
								}},
								{name:'LATE', width:100, align:"center",formatter:function(data, options, rowObject){
									if (data == null) {
										return "--"
									} else {
										return data;
									}
								}},
								{name:'LEAVE', width:100, align:"center",formatter:function(data, options, rowObject){
									if (data == null) {
										return "--"
									} else {
										return data;
									}
								}},
								{name:'NON_WORK', width:100, align:"center", formatter:function(data, options, rowObject){
									if (data == null) {
										return "--"
									} else {
										return data;
									}
								}}
						  ],
						  gridComplete:function(){ 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						  }
					});
		    		getFlg();
		    		
				}
			});

			$("#onFinishSt .form-group ").click(function() {
				var $str = $(this).find("div").attr("name");
				if ($str == "Today" 
						|| $str == "Yesterday"
						|| $str == "ThisWeek"
						|| $str == "ThisMonth"
						|| $str == "LastSevenDays"
						|| $str == "LastThirty" ) {
					//$(this).siblings("div").css("background-color","white");
					$("#onFinishSt .form-group").find("label").removeClass("cur");
					$(this).find("label").addClass("cur");
					//$(this).css({"background-color":"#C2DFF7","border-radius":"5px"});
					$("#startDate").val("");
					$("#endDate").val("");
					var str = $(this).find("div").attr("date");
					$("#dateKind").val(str);
					switch($str){
						case "Today":
						  $("#startDate").val(GetDateStr(0));
						  $("#endDate").val(GetDateStr(0));
						  break;
						case "Yesterday":
							$("#startDate").val(GetDateStr(-1));
							$("#endDate").val(GetDateStr(-1));
						  break;
						case "ThisWeek":
							$("#startDate").val(getWeekStartDate());
							$("#endDate").val(GetDateStr(0));
						  break;
						case "ThisMonth":
							$("#startDate").val(getMonthStartDate());
							$("#endDate").val(GetDateStr(0));
						  break;
						case "LastSevenDays":
							$("#startDate").val(GetDateStr(-7));
							$("#endDate").val(GetDateStr(0));
						  break;
						case "LastThirty":
							$("#startDate").val(GetDateStr(-30));
							$("#endDate").val(GetDateStr(0));
						  break;
						default:
							null;
					};
					doSearch();
					
				} 
			
		    });

		    $(".time_li input").click(function() {
			    $(".form-group").each(function(){
					$(this).css("background-color","white");
					$("#dateKind").val("");
				});
			 });
			
		})
		function getKeyIndex() {
	    	 $.ajax({
					url:'${base}/attendance/key.jhtml',
					sync:false,
					type : 'post',
					data :{
						'startDate':$('#keyStartDate').val(),
						'endDate':$('#keyEndDate').val(),
					},
					dataType : "json",
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
							if (data.flg == false) {
								$("#settingAttSta").trigger('click');
							} else {
								makeHighcharts(data.heng,'正常率','%','正常率',data.shu);
							}
							
					}
				  });
		}


        function makeHighcharts(categories,text,valueSuffix,name,data){
        	    $('#container').highcharts({
	        	        title: {
	        	            text: '考勤正常率统计',
	        	            x: -20 
	        	        },
	        	        subtitle: {
	        	            text: '来源：外勤360',
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
        function expAttStatStart() {
            var cols = getColProperties("grid-table");
            var _colNames=$("#grid-table").jqGrid('getGridParam','colNames');
            var colNames = (_colNames.slice(2,_colNames.length+1)).toString();
            $.ajax({
				url:'${base}/attendance/attendanceStaticsExport.jhtml',
				sync:false,
				type : 'post',
				data :{
					'startDate':$('#startDate').val(),
					'endDate':$('#endDate').val(),
					'cols':cols,
					'colNames':colNames
				},
				dataType : "json",
				error : function(data) {
					top.$.jBox.tip("网络异常，稍后执行本次操作.");
					return false;
				},
				success : function(data) {
					if (data.code == '002') {
 					 top.$.jBox.tip(data.msg);
					} 
					if (data.code == '001') {
						top.$.jBox.tip(data.msg);
				    }
				}
			  });
        }
        function getColProperties(id) {
            var b = jQuery("#"+id)[0];
	    	var params = b.p.colModel;
	    	
	    	var cols = "";
	    	for ( var i = 2; i < params.length; i++) {
	        	cols +=  params[i].name+",";
	        }
	        return cols
        } 
        
        function getFlg(){
        	 $.ajax({
					url:'${base}/attendance/findFlg.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
							if (data.code == "001") {
								$("#settingAttSta").trigger('click');
							} 
					}
				  });
        }
        function doSearch() {
        	$("#order_search_down").trigger('click');
        }
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
       		<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
					<div class="pos_orderCount_box">
				   		<div class="orderCount-IconBtn"></div>
						<div class="pos_orderCount">
				   			<div class="form-group">
				   				<div id="settingAttSta"data-toggle="jBox-win" href="${base}/attendance/attendanceStatisticsSettingUI.jhtml">
				   					<font style="text-align:center;">考勤设置</font>
				   				</div>
				   			</div>
						</div>
	   				</div>
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="attendanceStatistics" class="sub_status_but active"><a href="#"> 考勤统计</a></li>					
							<li role="presentation" id="attendanceStatisticsByPerson" class="sub_status_but"><a href="#"> 按人员统计</a></li>						
						</ul>
					</div>
					<div id="onFinishSt_new" style="display:block">
						<div class="form-group">
							<li class="time_li">
								<input type="text" id="keyStartDate" name="keyStartDate" value="${startDate}"  style="width:90px;" class="form-control">~
								<input type="text" id="keyEndDate" name="keyEndDate" value="${endDate}"  style="width:90px;" class="form-control">
								<script type="text/javascript"> 
								$(function(){
							         $("#keyStartDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'keyEndDate\')||\'%y-%M-%d\'}',onpicked:function(){keyEndDate.click();}});
							         });
							         $("#keyEndDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'keyStartDate\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: getKeyIndex});
							         });
								});
								</script>
							</li>
						 </div>
					</div>
					<div id="container" style="min-width:600px;height:350px" style="display:block"></div>
					
					<div id="onFinishSt" style="display:none">	
		                 	
			                 <div class="form-group" style="margin-right:10px;padding-left:10px;padding-top:8px;">
			           		   <button type="button" class="search_cBox_btn btn btn-info" id="order_search"  onclick="expAttStatStart()"> 导出 </button>
			               	 </div>
			               	 <div class="form-group" style="margin-right:0px;padding-top:8px;">
			           			 <div id=""data-toggle="jBox-win" href="${base}/attendance/downloadListUI.jhtml">
					   					<font class="search_cBox_btn" style="text-align:center;cursor:pointer;">下载</font>
					   			 </div>
			               	 </div>
		                 	 <div class="form-group">
								<button type="button" style="display:none;"class="search_cBox_btn btn btn-info" id="order_search_down" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
							 </div>
		           		 <div class="form-group" style="padding-left:10px;margin-right:5px;">
		           			 <label class="control-label">今日</label>
		                     <div name="Today" date="Today"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">昨日</label>
		                    <div name="Yesterday" date="Yesterday"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">本周</label>
		                    <div name="ThisWeek" date="ThisWeek" ></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">本月</label>
		                    <div name="ThisMonth" date="ThisMonth"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">最近7日</label>
		                    <div name="LastSevenDays" date="LastSevenDays"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">最近30日</label>
		                    <div name="LastThirty" date="LastThirty"></div>
		                   
		               	 </div>
		               	  <input type="hidden"  id="dateKind" name="dateKind" value="">
		                 <div class="form-group">
		                 	<div name="start_end" style="display:none;"></div>
		                 	<li class="time_li">
				                	<input type="text" class="form-control" name="startDate" id="startDate" style="width:90px;" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd',onpicked:function(){endDate.click()}});"  value="${startDate}">
				                	<span class="control-label">~</span>
				                	<input type="text" class="form-control" name="endDate" id="endDate" style="width:90px;" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd', maxDate:'%y-%M-%d' ,onpicked: doSearch});" value="${endDate}" >
							</li>
		                 </div>
		                  <div class="search_cBox">
		                 <div class="form-group">
								<button type="button" style="display:block;"class="search_cBox_btn btn btn-info" id="order_search_down" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
							 </div>
							 </div>
           			 </div>
	            </form>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
  	
   		</div>
    </body>
</html>
 



