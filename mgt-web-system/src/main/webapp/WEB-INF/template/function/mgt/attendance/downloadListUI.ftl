<!DOCTYPE html>
<html>
	<head>
		<title>DownloadPage</title>
		[#include "/common/commonHead.ftl" /]
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
			<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/attendance/downloadList.jhtml',
					colNames:['任务名称','大小','绝对路径','状态','操作时间','操作'],
					colModel:[	 
							{name:'NAME', width:270, editable:false},
							{name:'SIZE', width:50, editable:true},
							{name:'ABSO_PATH', width:100, hidden:true},
							{name:'STATUS', width:50, editable:true, formatter:function(cellvalue, options, rowObject){
									if(cellvalue == "T"){
										return "已导出";
									}else{
										return "未导出";
										
									}
								}},
							{name:'MODI_TIME', width:100, editable:false},
							{name:'detail',index:'PK_NO',width:40,sortable:false,  formatter:function(cellvalue, options, rowObject){
								return '<a href="' + rowObject.ABSO_PATH + '" style="color:gray;" >下载</a>';
								}} 
					  ],
					  gridComplete:function(){ 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
					  }
				});
			});
		</script>
	</head>

	<body>
		  <div class="body-container">
		   <div class="main_heightBox1">
				<form class="addressForm" id="form" action="${base}/attendance/addAttendanceStatisticSetting.jhtml" enctype="multipart/form-data"method="POST">
					<div class="navbar-fixed-top" id="toolbar">
						 <button class="btn btn-warning" data-toggle="jBox-close">保存
							<i class="fa-undo align-top bigger-125 fa-on-right"></i>
						 </button>
					</div>
				</form>
				</div>
				<table id="grid-table" ></table>
				<div id="grid-pager"></div>
		</div>
	</body>
</html>
