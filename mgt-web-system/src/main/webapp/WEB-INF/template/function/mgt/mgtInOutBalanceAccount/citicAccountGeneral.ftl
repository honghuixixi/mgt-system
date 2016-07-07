<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title> 
[#include "/common/commonHead.ftl" /]
<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<script src="${base}/scripts/lib/plugins/js/index.js"></script>
<script src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>
<script src="${base}/scripts/lib/jquery/highcharts.js" type="text/javascript"></script>
<style type="text/css">
	li:hover { cursor: pointer; }
	.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
	.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
</style>
</head>
 <body>
   <div class="body-container">
   	 <div class="main_heightBox1">
   	 	<div id="currentDataDiv" action="menu" >
			<div class="control-group sub_status">
				<ul class="nav nav-pills" role="tablist">
					<li role="presentation" id="inOutBalanceOfAccount" class="sub_status_but"><a>虚拟账户</a></li>
					<li role="presentation" id="citicAccountGeneral" class="sub_status_but active"><a>中信账户概况</a></li>
					<li role="presentation" id="citicAccountDetails" class="sub_status_but"><a>中信账户明细</a></li>
				</ul>
			 </div>
        </div>
        
        <form class="form form-inline queryForm" style="overflow:hidden;" id="query-form"> 
				<div class="form-group">
           			<ul class="change-ul" style="list-style:none;padding-top:10px;float:left;">
						<li style="margin-left:10px;" onClick="getCurWeek();">本周</li>
						<li class="cur" onClick="getCurMonth();">本月</li>
						<li style="margin-right:10px;" onClick="getCurYear();">本年</li>
					</ul>
               	 </div>
                 <div class="form-group">
					<label class="control-label" style=" vertical-align: middle;">订单时间:</label>
					<input type="text" class="form-control" id="startDate" style="width:90px;" name="startDate" value="${startDate}" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});">
				</div>
				<div class="form-group">
					<label class="control-label" style=" vertical-align: middle;padding-right:10px;">至</label>
					<input type="text" class="form-control" id="endDate" style="width:90px;" name="endDate" value="${endDate}" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});">
				</div>
				<div class="form-group">
					<select id="generalType" name="generalType" style="height:26px;">
			            <option value="01" selected="">中信账户收支统计</option>
			            <option value="02">中信账户资金分布</option>
			 		</select>
				</div>
				<div class="search_cBox">
					 <div class="form-group">
					 	<!-- <button class="search_cBox_btn btn btn-info"  id="order_search" data-toggle="jBox-call"  data-fn="checkForm">
					 	搜索<i class="fa-save align-top bigger-125 fa-on-right"></i>
				        </button>
				         <button type="button" class="btn_divBtn" id="exportExcel">导出Excel</button>-->
				        <button type="button" class="btn_divBtn" id="stock_query" data-toggle="jBox-query"><i class="icon-search"></i>开始统计</button>
       			    </div>
   			    </div>
        </form>
    </div>
	<div id="container" style="min-width:50%;float:left;"></div>
  </div>
  <form action="" method="post" id="tabFrom"></form>
</body>
</html>
<script>
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	$("#tabFrom").attr('action','${base}/inOutBalanceOfAcc/'+$(this).attr("id")+'.jhtml');
	    	$("#tabFrom").submit();
	    });
		$(".change-ul li").click(function(){
			$(".change-ul li").removeClass("cur");
			$(this).addClass("cur");
		});
		$('#generalType').change(function(){ 
			var gVal=$(this).children('option:selected').val();
			if(gVal == '02'){
				$("#query-form #startDate").attr("disabled",true);
				$("#query-form #endDate").attr("disabled",true);
			}else if(gVal == '01'){
				$("#query-form #startDate").attr("disabled",false);
				$("#query-form #endDate").attr("disabled",false);
			}
		});
		$("#stock_query").click(function(){
			mgt_util.showMask('正在统计绘图中....');
			mgt_util.buttonDisabled();
			var json = $("#query-form").serializeObjectForm();
			json['chart_titile'] = $("#query-form #generalType option:selected").text();
			var generalType = $("#query-form #generalType option:selected").val();
			$.ajax({
				url : '${base}/inOutBalanceOfAcc/generalData.jhtml',
				type : 'post',
				dataType : 'json',
				data : json,
				success : function(data, status, jqXHR) {
					mgt_util.hideMask();
					mgt_util.buttonEnable();
					mgt_util.showMessage(jqXHR, data,null);
					if('01' == generalType){
						$('#container').highcharts({
				            chart: {
				                plotBackgroundColor: null,
				                plotBorderWidth: null,
				                plotShadow: false
				            },
				            title: {
				                text: json['chart_titile']
				            },
				            tooltip: {
				                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
				            },
				            plotOptions: {
				                pie: {
				                    allowPointSelect: true,
				                    cursor: 'pointer',
				                    dataLabels: {
				                        enabled: false
				                    },
				                    showInLegend: true
				                }
				            },
				            series: [{
				                type: 'pie',
				                name: '比例',
				                data: [
				                    [data.INVAL == null?'收入[0元]':'收入['+data.INVAL+'元]',   data.INVAL],
				                    {
				                        name: data.OUTVAL==null?'支出[0元]':'支出['+data.OUTVAL+'元]',
				                        y: data.OUTVAL,
				                        sliced: true,
				                        selected: true
				                    },
				                ]
				            }]
		        		});
					}else if('02' == generalType) {
						$('#container').highcharts({
				            chart: {
				                plotBackgroundColor: null,
				                plotBorderWidth: null,
				                plotShadow: false
				            },
				            title: {
				                text: json['chart_titile']
				            },
				            tooltip: {
				                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
				            },
				            plotOptions: {
				                pie: {
				                    allowPointSelect: true,
				                    cursor: 'pointer',
				                    dataLabels: {
				                        enabled: false
				                    },
				                    showInLegend: true
				                }
				            },
				            series: [{
				                type: 'pie',
				                name: '比例',
				                data: [
				                    [data.QS_VAL==null?'清算户[0元]':'清算户['+data.QS_VAL+'元]',   data.QS_VAL],
				                    [data.JX_VAL==null?'公共计息户[0元]':'公共计息户['+data.JX_VAL+'元]',   data.JX_VAL],
				                    [data.TZ_VAL==null?'公共调账户[0元]':'公共调账户['+data.TZ_VAL+'元]',   data.TZ_VAL],
				                    [data.ZJ_VAL==null?'资金初始化[0元]':'资金初始化['+data.ZJ_VAL+'元]',   data.ZJ_VAL],
				                    {
				                        name: data.QT_VAL==null?'其它[0元]':'其它['+data.QT_VAL+'元]',
				                        y: data.QT_VAL,
				                        sliced: true,
				                        selected: true
				                    },
				                ]
				            }]
		        		});
					}
					
				}
			});
		});
		
		getCurMonth();	//选中当月
		$("#stock_query").click();	//绘制统计图
	});
	function getCurWeek(){
		var myDate = new Date();
		$("#query-form #endDate").val(myDate.format('yyyy-MM-dd'));
		myDate.setDate(myDate.getDate() - myDate.getDay() + 1);
		$("#query-form #startDate").val(myDate.format('yyyy-MM-dd'));
	}
	function getCurMonth(){
		var myDate=new Date();//今天
		$("#query-form #endDate").val(myDate.format('yyyy-MM-dd'));
	 	myDate.setDate(1);//当前月的第一天
		$("#query-form #startDate").val(myDate.format('yyyy-MM-dd'));
	}
	function getCurYear(){
		var myDate=new Date();//今天
		$("#query-form #endDate").val(myDate.format('yyyy-MM-dd'));
		myDate.setMonth(0);//当年的第一个月
		myDate.setDate(1);//当前月的第一天
		$("#query-form #startDate").val(myDate.format('yyyy-MM-dd'));
	}
</script>