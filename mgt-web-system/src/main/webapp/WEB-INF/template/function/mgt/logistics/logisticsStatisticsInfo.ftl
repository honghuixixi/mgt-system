<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>配送员统计</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>	
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
			        getMonth();
			        var startDate = $("input[name='startDate']").val();
			        var endDate = $("input[name='endDate']").val();
					mgt_util.jqGrid('#grid-table',{
					    multiselect:false,
						postData: {startDate:startDate,endDate:endDate},
						url:'${base}/logistics/statisticsList.jhtml',
	 					colNames:['姓名','工号','订单量','订单总金额','完成订单量','未完成订单量'],
	 					width:1000,
					   	colModel:[
					   		{name:'NAME',align:"center",width:200},
					   		{name:'USER_NAME_S',align:"center",width:250},
					   		{name:'TOTAL',align:"center",width:150},
					   		{name:'AMOUNT',align:"center",width:150},
					   		{name:'SUCCESS',width:150,align:'center'},
					   		{name:'WEI',width:150,align:'center'} 
					   	],
					   	gridComplete:function(){ 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						}
					});
					
					$(".change-ul li").click(function(){
						$(".change-ul li").removeClass("cur");
						$(this).addClass("cur");
					});
					$("#stock_query").click(function(){
						$(".change-ul li").removeClass("cur");
					});
					$("#exportExcel").click(function(){
						var startDate = $("input[name='startDate']").val();
				        var endDate = $("input[name='endDate']").val();
				        var _cols = getColProperties("grid-table");
			            var _colNames=$("#grid-table").jqGrid('getGridParam','colNames');
			            var colNames = (_colNames.slice(1,_colNames.length)).toString();
			            var cols = ( _cols.split(",").slice(0, _cols.split(",").length-1)).toString();
			            window.location.href = "${base}/logistics/statisticsExportExcel.jhtml?cols="+cols+
			            		"&colNames="+encodeURI(colNames)+"&startDate="+startDate+"&endDate="+endDate;
					});
				});
				
				var format = function(time, format){
			    var t = new Date(time);
			    var tf = function(i){return (i < 10 ? '0' : '') + i};
			    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
			        switch(a){
			            case 'yyyy':
			                return tf(t.getFullYear());
			                break;
			            case 'MM':
			                return tf(t.getMonth() + 1);
			                break;
			            case 'mm':
			                return tf(t.getMinutes());
			                break;
			            case 'dd':
			                return tf(t.getDate());
			                break;
			            case 'HH':
			                return tf(t.getHours());
			                break;
			            case 'ss':
			                return tf(t.getSeconds());
			                break;
			        }
			    })
			}
				function getWeek(){
					var myDate = new Date();
					var date = new Date(myDate-(myDate.getDay()-1)*86400000);
					var dateOne = date.getTime()-7*24*60*60*1000;//上周一
					var dateSeven = date.getTime()-24*60*60*1000;//上周日
					form1.startDate.value=format(dateOne, 'yyyy-MM-dd');
					form1.endDate.value=format(dateSeven, 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				
				function getLastMonth(){
					var date=new Date();//上个月第一天
				    date.setFullYear(date.getFullYear());
				    date.setMonth(date.getMonth()-1);
					date.setDate(1);
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
					var date1=new Date();//上个月最后一天
			        date1.setFullYear(date1.getFullYear());
			        date1.setMonth(date1.getMonth());
					date1.setDate(0);
					form1.endDate.value = format(date1.getTime(), 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				
				function getMonth(){
					var date=new Date();//今天
					form1.endDate.value = format(date.getTime(), 'yyyy-MM-dd');
				 	date.setDate(1);//当前月的第一天
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				function doSearch() {
	        	$("#stock_query").trigger('click');
	       		}
				function getColProperties(id) {
		            var b = jQuery("#"+id)[0];
			    	var params = b.p.colModel;
			    	
			    	var cols = "";
			    	for ( var i = 1; i < params.length; i++) {
			        	cols +=  params[i].name+",";
			        }
			        return cols
		        }
		</script>
    </head>
    <body>
    
       <div class="body-container">
         <div class="main_heightBox1">
			<div style="border-bottom:1px solid #f39801;overflow:hidden;padding-bottom:10px;">
	            <form class="form form-inline queryForm"  id="query-form" name="form1">
	           		<div>
	           			<ul class="change-ul" style="list-style:none;padding-top:14px;float:left;">
    						<li  onClick="getWeek()">上周</li>
    						<li  onClick="getLastMonth()">上个月</li>
    						<li class="cur" style="margin-right:10px;"  onClick="getMonth()">本月</li>
  						</ul>
	               	 </div>
	                 <div class="form-group">
						<label class="control-label" style=" vertical-align: middle;">订单时间:</label>
						<input type="text" class="form-control" id="startDate" style="width:90px;" name="startDate" value="${startDate}">
						</div>
						<div class="form-group">
						<label class="control-label" style=" vertical-align: middle;padding-right:10px;">至</label>
						<input type="text" class="form-control" id="endDate" style="width:90px;" name="endDate" value="${endDate}">
						</div>
						<script type="text/javascript"> 
								$(function(){
							         $("#startDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',onpicked:function(){endDate.click();}});
							         });
							         $("#endDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: doSearch});
							         });
								});
								</script>
						<div class="search_cBox" style="bottom:20px;">
							 <div class="form-group">
							 	<!-- <button class="search_cBox_btn btn btn-info"  id="order_search" data-toggle="jBox-call"  data-fn="checkForm">
							 	搜索<i class="fa-save align-top bigger-125 fa-on-right"></i>
						        </button>-->
						         <button type="button" class="btn_divBtn" id="exportExcel">导出Excel</button>
						        <button type="button" class="btn_divBtn" id="stock_query" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	           			    </div>
           			    </div>
	            </form>
	        </div>
	      </div>
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>

<script type="text/javascript">
</script>
</html>