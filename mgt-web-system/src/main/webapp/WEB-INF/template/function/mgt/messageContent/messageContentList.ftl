<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>消息列表</title>
		[#include "/common/commonHead.ftl" /]		
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
        <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index_wel.css" />
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					mtype:'GET',
					postData: {},
					url:'${base}/messageContent/messageContentList.jhtml',
					multiselect:false,
					colNames:['','标题','内容','来源','状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'TITLE',width:'10%',align:"left",sortable:false},
						{name:'CONTENT',width:'50%',align:"left",sortable:false},
						{name:'SOURCE',width:'6%',align:"center",sortable:false},
						{name:'READ_TIME',width:'6%',align:"center",sortable:false,formatter:function(data){
							if(data<=0){
								return "未读";
							}else{
								return "已读";
							}
		   				}},
						{name:'detail',width:'6%',align:'center',sortable:false}
				   	],
				   	gridComplete:function(){
						var ids=jQuery("#grid-table").jqGrid('getDataIDs');
						var detail;
						var rowData;
						for(var i=0; i<ids.length; i++){
							rowData = $('#grid-table').jqGrid('getRowData',ids[i]);
							detail ="&nbsp;<button type='button' onClick='showMessageDetail(\""+ids[i]+"\")' class='btn btn-info edit'>查看</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						}
					}
				});
				

				$("#search").live('click',function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:{startDate:$('#startDate').val(),endDate:$('#endDate').val()}, //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
				$("#startDate").bind("click",
	                function() {
	                  WdatePicker({
	                    doubleCalendar: true,
	                    dateFmt: 'yyyy-MM-dd',
	                    autoPickDate: true,
	                    maxDate: '#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}'
	                  });
	                });
	                $("#endDate").bind("click",
	                function() {
	                  WdatePicker({
	                    doubleCalendar: true,
	                    minDate: '#F{$dp.$D(\'startDate\')}',
	                    maxDate: '%y-%M-%d',
	                    dateFmt: 'yyyy-MM-dd',
	                    autoPickDate: true
	                  });
	                });
			});
			function showMessageDetail(id){
			
				rowData = $('#grid-table').jqGrid('getRowData',id);
				if(rowData.READ_TIME=="未读"){
					console.log("set read");
					jQuery("#grid-table").jqGrid('setRowData', id, { READ_TIME: "已读" }); 
				}
			
				mgt_util.showjBox({
	 			width : 550,
	 			height : 400,
	 			title : '详细消息',
	 			url : '${base}/messageContent/messageContent.jhtml?id='+id
	 		});
			}
		</script>
    </head>
    <body>
       <div class="body-container">
       	 <div class="main_heightBox1">
		    <!--浮动文字
		    <div class="pos_orderCount_box">
		   		<div class="orderCount-IconBtn"></div>
				<div class="pos_orderCount">
		   			<div class="form-group"><font>总计配送订单数：</font><span id="orderCountSpan">0</span>张<font class="padding_fontl">总计配送总金额：</font><span id="orderAmountSpan">0.00</span> 元<font class="padding_fontl">应交货款：</font><span id="orderActualAmountSpan">0.00</span> 元</div>
				</div>
		    </div>-->
			<div id="currentDataDiv" action="resource">
				 <div class="currentDataDiv_tit">
					 <div class="form-group db-box_right">
					 	时间范围：<input type="text" id="startDate" name="startDate" value="${startDate}" style="width:80px;">
	            		---&nbsp;<input type="text" id="endDate" name="endDate" value="${endDate}" style="width:80px;">
		                <button type="button" id="search" >&nbsp;搜 索&nbsp;</button>
		                &nbsp;&nbsp;&nbsp;&nbsp;
	                 </div>
	             </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
<script  type="text/javascript">
	$(document).ready(function(){
		  
	});
</script>
</html>
 