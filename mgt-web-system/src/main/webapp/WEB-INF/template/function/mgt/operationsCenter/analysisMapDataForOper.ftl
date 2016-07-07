<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
            <title></title>
        	[#include "/common/commonHead.ftl" /]
            <link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
            <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
   			<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index_wel.css" />
			<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=DDb12a84344b679c799680268e263ad7"></script>
	</head>
	<body>
	<center>
	  <div class="ifaNav-box" style="padding:0px 10px;">
	    <div class="db-box" style="margin-top:0px;">
	      <div class="db-box" style="margin-top:0px;">
	        <h3>
	          <div class="db-box_right">
	            <input type="text" id="startDate" name="startDate" value="${startDate}" style="width:80px;">
	            <input type="text" id="endDate" name="endDate" value="${endDate}" style="width:80px;">
	            <select id="range" name="range">
	              <option value="1">
	                新增数
	              </option>
	              <option value="2">
	                累积数
	              </option>
	            </select>
	          </div>
	          <a id="flg" style="float:right;background:none;border:none;color:#fff;font-weight:bold;font-size:14px;"
	          href="${base}/operationsCenter/exportExcel.jhtml?val=1">
	            导出Excel
	          </a>
	        </h3>
	        <div id="sumInfo" style="background-color:#ddd;margin:5px 0px;padding:10px;">
	        </div>
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
	<script type="text/javascript">
		$(document).ready(function() {
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
                maxDate: '%y-%M-%d',
                dateFmt: 'yyyy-MM-dd',
                autoPickDate: true,
                onpicked: gridReload
              });
            });
            $('#range').change(function(){
				$('#startDate').toggle();
				gridReload();
			});
            loadSumCount();
            changeExportExcelUrl();
            
			mgt_util.jqGrid('#grid-table',{
				mtype:'GET',
				postData: {startDate:$('#startDate').val(),endDate:$('#endDate').val(),range:$('#range').val()},
				url:'${base}/operationsCenter/countDatabyOperator.jhtml',
				multiselect:false,
				colNames:['一级区域','二级区域','三级区域','店铺','供应商','物流商','O2O店铺','消费者'],
			   	colModel:[
			   		{name:'A1',width:200,align:"center",sortable:false},
					{name:'A2',width:200,align:"center",sortable:false},
					{name:'A3',width:200,align:"center",sortable:false},
					{name:'CUS_QTY',width:80,align:"center"},
					{name:'PUR_QTY',width:80,align:"center"},
			   		{name:'LGS_QTY',width:80,align:"center"},
			   		{name:'O2O_QTY',align:"center",width:80},
			   		{name:'C_QTY',align:"center",width:80}
			   	],
			   	gridComplete:function(){
					
				}
			});
		});
		function gridReload(){
			var postData = {startDate:$('#startDate').val(),endDate:$('#endDate').val(),range:$('#range').val()};
			$("#grid-table").jqGrid('setGridParam',{
				page:1,
		        postData:postData
		    }).trigger("reloadGrid"); //重新载入  
		    loadSumCount();
		    changeExportExcelUrl();
		}
		function changeExportExcelUrl(){
			$("#flg").attr("href","${base}/operationsCenter/exportExcelSumCount.jhtml?range="+$('#range').val()+"&startDate="+$('#startDate').val()+"&endDate="+$('#endDate').val()); 
		}
		function loadSumCount(){
			$.ajax({
				url : '${base}/operationsCenter/countSumDatabyOperator.jhtml',
				type : 'get',
				dataType : 'json',
				data : {startDate:$('#startDate').val(),endDate:$('#endDate').val(),range:$('#range').val()},
				success : function(data, status, jqXHR) {
					if(null == data.PUR_QTY){data.PUR_QTY=0;}
					if(null == data.CUS_QTY){data.CUS_QTY=0;}
					if(null == data.LGS_QTY){data.LGS_QTY=0;}
					if(null == data.O2O_QTY){data.O2O_QTY=0;}
					if(null == data.C_QTY){data.C_QTY=0;}
					$('#sumInfo').html('汇总：店铺 '+data.CUS_QTY+'&emsp;   供应商  '+data.PUR_QTY+'&emsp;    物流商 '+data.LGS_QTY+'&emsp;  O2O店铺  '+data.O2O_QTY+'&emsp;   消费者  '+data.C_QTY);
				}
			});
		}
	</script>
	</body>
</html>