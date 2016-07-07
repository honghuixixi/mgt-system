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
					redraw();
					$('#range').change(function(){
						$('#startDate').toggle();
						redraw();
					});
					$('#orderList').change(function(){
						redraw();
					});
				});
				var colNames1 = ['一级区域','二级区域','三级区域','订单数量','销售金额'];
				var colModel1 = [	
							{name:'A1',width:200,align:"center",sortable:false},
							{name:'A2',width:200,align:"center",sortable:false},
							{name:'A3',width:200,align:"center",sortable:false},
							{name:'COUNT',width:200,align:"center"},
							{name:'AMT',width:200,align:"center"}
						];
				var colNames2 = ['一级区域','二级区域','三级区域','供应商','订单数量','销售金额'];
				var colModel2 = [	
							{name:'A1',width:200,align:"center",sortable:false},
							{name:'A2',width:200,align:"center",sortable:false},
							{name:'A3',width:200,align:"center",sortable:false},
							{name:'NAME',width:200,align:"center"},
							{name:'COUNT',width:200,align:"center"},
							{name:'AMOUNT',width:200,align:"center"}
						];
				var colNames3 = ['一级区域','二级区域','三级区域','客户','订单数量','销售金额'];
				var colModel3 = [	
							{name:'A1',width:200,align:"center",sortable:false},
							{name:'A2',width:200,align:"center",sortable:false},
							{name:'A3',width:200,align:"center",sortable:false},
							{name:'NAME',width:200,align:"center"},
							{name:'COUNT',width:200,align:"center"},
							{name:'AMOUNT',width:200,align:"center"}
						];
				var colNames4 = ['一级区域','二级区域','三级区域','商品','销售数量','销售金额'];
				var colModel4 = [	
							{name:'A1',width:200,align:"center",sortable:false},
							{name:'A2',width:200,align:"center",sortable:false},
							{name:'A3',width:200,align:"center",sortable:false},
							{name:'NAME',width:200,align:"center"},
							{name:'COUNT',width:200,align:"center"},
							{name:'AMOUNT',width:200,align:"center"}
						];
				//重绘明细数据统计列表
				function redraw(){
					var val = $('#orderList').val();
					var colNames;
					var colModel;
					if("2"==val){colNames=colNames2;colModel=colModel2;}
					else if("3"==val){colNames=colNames3;colModel=colModel3;}
					else if("4"==val){colNames=colNames4;colModel=colModel4;}
					else {colNames=colNames1;colModel=colModel1;}
					var postData={startDate:$('#startDate').val(),endDate:$('#endDate').val(),range:$('#range').val(),val:val};
					$('#grid-table').GridUnload();//重绘
					mgt_util.jqGrid('#grid-table',{
						mtype: "GET",
						sortorder:'desc',
						sortname:'COUNT',
						postData: postData,
						url:'${base}/operationsCenter/byOperator.jhtml',
						multiselect:false,
						colNames:colNames,
						colModel:colModel,
						onSortCol: function (index, iCol, sortorder) {changeExportExcelUrl();}
					});
					changeExportExcelUrl();
				}
				function changeExportExcelUrl(){
					$("#flg").attr("href","${base}/operationsCenter/exportExcelOper.jhtml?val="+$('#orderList').val()+"&range="+$('#range').val()+"&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val()+"&orderby="+$('#grid-table').getGridParam('sortname')+"&sord="+$('#grid-table').getGridParam('sortorder')+"&rows=10000"); 
				}
   			</script>
	</head>
	<body>
	<center>
	  <div class="ifaNav-box">
	    <h2>
	      运营中心控制台
	    </h2>
	    <div class="db-box">
	      <div class="db-box">
	        <h3>
	          <i class="fk-icon2">
	          </i>
	          <div class="db-box_right">
	            <input type="text" id="startDate" name="startDate" value="${startDate}"
	            style="width:80px;">
	            <input type="text" id="endDate" name="endDate" value="${endDate}" style="width:80px;">
	            <script type="text/javascript">
	              $(function() {
	                $("#startDate").bind("click",
	                function() {
	                  WdatePicker({
	                    doubleCalendar: true,
	                    dateFmt: 'yyyy-MM-dd',
	                    autoPickDate: true,
	                    maxDate: '#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',
	                    onpicked: function() {
	                      endDate.click();
	                    }
	                  });
	                });
	                $("#endDate").bind("click",
	                function() {
	                  WdatePicker({
	                    doubleCalendar: true,
	                    minDate: '#F{$dp.$D(\'startDate\')}',
	                    maxDate: '%y-%M-%d',
	                    dateFmt: 'yyyy-MM-dd',
	                    autoPickDate: true,
	                    onpicked: redraw
	                  });
	                });
	              });
	            </script>
	            <select id="range" name="range">
	              <option value="1">
	                新增数
	              </option>
	              <option value="2">
	                累积数
	              </option>
	            </select>
	            <select id="orderList" name="orderList">
	              <option value="1">
	                区域
	              </option>
	              <option value="2">
	                区域+供应商
	              </option>
	              <option value="3">
	                区域+客户
	              </option>
	              <option value="4">
	                区域+商品
	              </option>
	            </select>
	          </div>
	          明细数据统计
	          <a id="flg" style="float:right;background:none;border:none;color:#fff;font-weight:bold;font-size:14px;"
	          href="${base}/operationsCenter/exportExcel.jhtml?val=1">
	            导出Excel
	          </a>
	        </h3>
	        <div id="mingxi">
	          <table id="grid-table">
	          </table>
	          <div id="grid-pager">
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	</center>
	</body>
</html>