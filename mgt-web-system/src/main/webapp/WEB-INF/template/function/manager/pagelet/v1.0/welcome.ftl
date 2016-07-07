<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
            <title></title>
        	[#include "/common/commonHead.ftl" /]
            <link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
            <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
   			<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index_wel.css" />
   			<script src="${base}/scripts/lib/plugins/js/exportExcel.js"></script>
			<script src="http://cdn.hcharts.cn/highcharts/highcharts.js" type="text/javascript"></script>
   			<script type="text/javascript">
				$(document).ready(function() {
				$("#flg").attr("href","${base}/welcome/exportExcel.jhtml?val=1&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val());
					//初始化页面
					init();
					var postData={startDate:$('#startDate').val(),endDate:$('#endDate').val()};
					mgt_util.jqGrid('#grid-table',{
						postData:postData,
						url:'${base}/welcome/day.jhtml',
						multiselect:false,
						colNames:['时间','数量','金额'],
						rowNum:100, 
						width:1000,
						colModel:[	
							{name:'MAS_DATE',width:300,align:"center"},
							{name:'COUNT',width:300,align:"center"},
							{name:'AMT',width:299,align:"center"},
						]
					});
					
					//切换关键指标纬度
					$('#keyList').change(function(){
						getKeyIndex();
					});
					
					//$('#flg').click(function(){
					
					//});
					//切换明细数据列表视图
					$('#orderList').change(function(){
						redraw();
					});
				});
				
				//重绘明细数据统计列表
				function redraw (){
					var val = $('#orderList').val();
					var postData={startDate:$('#startDate').val(),endDate:$('#endDate').val()};
					$('#grid-table').GridUnload();//重绘
						if(val == '1'){
						$("#flg").attr("href","${base}/welcome/exportExcel.jhtml?val=1&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val()); 
							mgt_util.jqGrid('#grid-table',{
								postData: postData,
								url:'${base}/welcome/day.jhtml',
								multiselect:false,
								colNames:['时间','数量','金额'],
								width:1000,
								rowNum: 100, 
								colModel:[	
									{name:'MAS_DATE',width:300,align:"center"},
									{name:'COUNT',width:300,align:"center"},
									{name:'AMT',width:299,align:"center"},
								]
							});
						}else if(val == '2'){
						$("#flg").attr("href","${base}/welcome/exportExcel.jhtml?val=2&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val()); 
							mgt_util.jqGrid('#grid-table',{
								postData: postData,
								url:'${base}/welcome/area.jhtml',
								multiselect:false,
								colNames:['一级区域','二级区域','三级区域','数量','金额'],
								width:1000,
								colModel:[	
									{name:'A1',width:200,align:"center"},
									{name:'A2',width:200,align:"center"},
									{name:'A3',width:200,align:"center"},
									{name:'COUNT',width:200,align:"center"},
									{name:'AMT',width:199,align:"center"},
								]
							});
						}else if(val == '3'){
						$("#flg").attr("href","${base}/welcome/exportExcel.jhtml?val=3&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val()); 
							mgt_util.jqGrid('#grid-table',{
								postData: postData,
								url:'${base}/welcome/stk.jhtml',
								multiselect:false,
								colNames:['一级区域','二级区域','商品编号','商品名称','单位','订单数量','订单金额','发货数量','实收金额'],
								width:1000,
								colModel:[	
									{name:'A1',width:150,align:"center"},
									{name:'A2',width:150,align:"center"},
									{name:'STK_C',width:100,align:"center"},
									{name:'STK_NAME',width:400,align:"center"},
									{name:'UOM',width:100,align:"center"},
									{name:'STK_QTY',width:100,align:"center"},
									{name:'AMT',width:100,align:"center"},
									{name:'QTY2',width:100,align:"center"},
									{name:'AMT2',width:99,align:"center"},
								]
							});
						}
				}
				
				//初始化页面数据
   				function init(){
   					var purchaserFlg = '${user.purchaserFlg}';
					if(purchaserFlg =='Y'){
						$('div.ifaNav-box').show();
					}else{
						$('div.ifaNav-box').hide();
					}
					toDoList();
					getKeyIndex();
					getStatistics();
   				}

				//获取待办数据
				function toDoList(){
				 $.ajax({
					url:'${base}/welcome/todo.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						$('#toReceive').html(data.toReceive);
						$('#toSend').html(data.toSend);
						$('#toCheck').html(data.toCheck);
					}
				  });
				}
				//获取关键指标数据
				function getKeyIndex(){
					 $.ajax({
						url:'${base}/welcome/key.jhtml',
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
							if($("#keyList").val() == '1'){
								makeHighcharts(data.heng,'订单数量','个','订单数量',data.shu)
							}else{
								makeHighcharts(data.heng,'订单金额','元','订单金额',data.jine)
							}
						}
					  });
				}
				//获取概况统计数据
				function getStatistics(){
		         	 $.ajax({
						url:'${base}/welcome/ordercountamount.jhtml',
						sync:false,
						type : 'post',
						data :{
							'startDate':$('#startTime').val(),
							'endDate':$('#endTime').val(),
						},
						dataType : "json",
						error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
							$('#count').html(data.COUNT);
							$('#amt').html(data.AMT);
						}
					  });
		         }
		         
		         //图表展示容器，与div的id保持一致
		         function makeHighcharts(categories,text,valueSuffix,name,data){
		         	$('#container').highcharts({
						title: {
			            text: '关键指标分析',
			            x: -20 //center
				        },
				        subtitle: {
				            text: '来源: 物恋网',
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
				            valueSuffix: valueSuffix
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
    
    				function getDtb(){
    				var val = $('#orderList').val();
		         	 $.ajax({
						url:'${base}/welcome/exportExcel.jhtml',
						sync:false,
						type : 'post',
						data :{
							'startDate':$('#startDate').val(),
							'endDate':$('#endDate').val(),
							'val':val,
						},
						dataType : "json",
						error : function(data) {
							alert("网络繁忙，请稍后再试！.");
							return false;
						},
						success : function(data) {
							if (data.code == '001') {
			 					 	alert(data.msg);
								} 
							if (data.code == '002') {
								alert(data.msg);
						    }
						}
					  });
		         }
		         
		         function getDtbs(){
		         var flg = '1';
		         	 $.ajax({
						url:'${base}/welcome/exportExcel.jhtml',
						sync:true,
						type : 'post',
						data :{
							'flg':flg,
						},
						dataType : "json",
						error : function(data) {
							alert("网络繁忙，请稍后再试！.");
							return false;
						},
						success : function(data) {
							if (data.code == '001') {
		 					 	alert(data.msg);
							} 
							if (data.code == '002') {
								alert(data.msg);
						    }
						}
					  });
		         }
   			</script>
	</head>
	<body>
		<center>
	 	<div class="ifaNav-box" style="display: none">
	 		<h2>供应商控制台</h2>
	 		<div class="line-div"></div>
	 		
	 		<div class="db-box">
	 			<h3><i class="fk-icon1"></i>待办事宜</h3>
	 			<div style="clear:both;"></div>
	 			<div class="sj-box  tit-num1">
	 				<dl>
	 					<dd>
		 					<div class="dd-findBox">
		 						<div class="sj_tit">待接收订单</div>
		 						<div class="biao_box">
		 							<label id="toReceive" name="toReceive"></label><span>张</span>
		 						</div>
		 					</div>
	 					</dd>
	 					<dd>
		 					<div class="dd-findBox">
		 						<div class="sj_tit">待发货订单</div>
		 						<div class="biao_box">
		 							<label id="toSend" name="toSend"></label><span>张</span>
		 						</div>
		 					</div>
	 					</dd>
	 					<dd>
		 					<div class="dd-findBox">
		 						<div class="sj_tit">待对账订单</div>
		 						<div class="biao_box">
		 							<label id="toCheck" name="toCheck"></label><span>张</span>
		 						</div>
		 					</div>
	 					</dd>
	 				</dl>
	 			</div>
	 		</div>
	 		
	 		<div class="db-box">
	 			<h3><i class="fk-icon2"></i>
	 			<div class="db-box_right">
	 				<input type="text" id="startTime" name="startTime" value="${startDate}" style="width:80px;">
					<input type="text" id="endTime" name="endTime" value="${endDate}" style="width:80px;">
					<script type="text/javascript"> 
					$(function(){
				         $("#startTime").bind("click",function(){
				             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'endTime\')||\'%y-%M-%d\'}',onpicked:function(){endTime.click();}});
				         });
				         $("#endTime").bind("click",function(){
				             WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'startTime\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: getStatistics });
				         });
					});
					</script>
				</div>概况统计</h3>
	 			
	 			<div style="clear:both;"></div>
	 			<div class="sj-box tit-num2">
	 				<dl>
	 					<dd>
		 					<div class="dd-findBox">
		 						<div class="sj_tit">订单数</div>
		 						<div class="biao_box">
		 							<label id="count" name="count"></label><span>张</span>
		 						</div>
		 					</div>
	 					</dd>
	 					<dd>
		 					<div class="dd-findBox">
		 						<div class="sj_tit">成交额</div>
		 						<div class="biao_box">
		 							<label id="amt" name="amt"></label><span>元</span>
		 						</div>
		 					</div>
	 					</dd>
	 				</dl>
	 			</div>
	 		</div>
	 		<div class="db-box">
	 			<h3><i class="fk-icon3"></i>
	 			<div class="db-box_right">
	 				<input type="text" id="keyStartDate" name="keyStartDate" value="${startDate}" style="width:80px;">
					<input type="text" id="keyEndDate" name="keyEndDate" value="${endDate}" style="width:80px;">
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
				<select id="keyList" name="keyList">
	 			<option value="1">订单数量</option>
	 			<option value="2">订单金额</option>
	 			</select>
				</div>关键指标分析</h3>
	 			<div id="container" style="min-width:600px;height:350px"></div>
	 		</div>
	 		<div class="db-box">
	 			<h3><i class="fk-icon1"></i>
	 			<div class="db-box_right"></div>
	 			各仓库的商品数量和总金额<a style="float:right;background:none;border:none;color:#fff;font-weight:bold;margin-top:3px;font-size:14px;" href="${base}/welcome/exportExcel.jhtml?flg=1">导出Excel</a></h3> 
	 			<div id="cangku">
	 			<table cellpadding="0" cellspacing="0" border="2">
                        <thead>
					      <tr height="40" style="background:#FF9900;font-size:14px;">
					        <td style="text-align:center;font-weight:bold">&#x4ED3;&#x5E93;&#x540D;</td>
					        <td style="text-align:center;font-weight:bold">商品数量</td>
					        <td style="text-align:center;font-weight:bold">总金额</td>
					        <td style="text-align:center;font-weight:bold">预留数量</td>
					      </tr>
    					</thead>
    					<tbody>
    						[#list data as data]
    						<tr height="40"  align="center">
    							<td  style="text-align:center;"><span>${data.NAME}</span></td>
    							<td  style="text-align:center;"><span>${data.STK_QTY}</span></td>
    							<td  style="text-align:center;"><span>${data.AMT}</span></td>
    							<td  style="text-align:center;"><span>${data.RES_QTY}</span></td>
    						</tr>
    						[/#list]
    					</tbody>
                  </table>
                  </div>
	 		<div class="db-box">
	 			<h3><i class="fk-icon2"></i>
	 			<div class="db-box_right">
	 			<input type="text" id="startDate" name="startDate" value="${startDate}" style="width:80px;">
					<input type="text" id="endDate" name="endDate" value="${endDate}" style="width:80px;">
					<script type="text/javascript"> 
					$(function(){
				         $("#startDate").bind("click",function(){
				             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',onpicked:function(){endDate.click();}});
				         });
				         $("#endDate").bind("click",function(){
				             WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: redraw});
				         });
					});
					</script>
				<select id="orderList" name="orderList">
	 			<option value="1">日期</option>
	 			<option value="2">区域</option>
	 			<option value="3">区域、商品汇总</option>
	 			</select></div>明细数据统计<a id="flg" style="float:right;background:none;border:none;color:#fff;font-weight:bold;margin-top:3px;font-size:14px;" href="${base}/welcome/exportExcel.jhtml?val=1">导出Excel</a></h3>
	 			<div id="mingxi">
	 			<table id="grid-table" ></table>
		    	<div id="grid-pager"></div>
		    	</div>
	 		</div>
	 		</div>
	 	</div>
	 	</center>
	</body>
</html>