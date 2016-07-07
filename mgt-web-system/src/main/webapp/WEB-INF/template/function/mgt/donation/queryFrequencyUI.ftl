<!DOCTYPE html>
<html>
	<head>
		<title>查询订货频率页面</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<style>
		.page-content-tab tr td{height:30px;}
		.page-contentList{width:100%;padding-top:20px;line-height:30px;}
		.page-contentList input{height:30px;}
		.page-contentList label{float:left;width:150px;text-align:right;padding-right:10px;}
		.page-contentList span{padding:0 5px;}
		.sortNo2,.sortNo3{margin-right:5px;float:left;height:auto;margin-top:10px;}
		.page-contentList font{float:left;display:inline-block;line-height:30px;padding:0 20px 0 5px;}
		.help-block{position:absolute;top:25px;left:0;}
		.page-contentList1{float:left;}
		.page-contentList2{float:left;position:relative;}
		.sortNo{width:100px;}
		</style>
	</head>

	<body class="toolbar-fixed-top">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" onclick="sub()" >
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" onclick="closes()">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<form class="form-horizontal" id="form"  method="POST">
 	        <div class="page-content">
	 	        <div class="page-contentList clearfix">
	 	        	<div class="page-contentList1"><label>选择统计时间范围:</label><span>从 </span></div>
	 	        	<div class="page-contentList2"><input type="text" id="beginDate" name="beginDate" class="form-control required" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width:181px;" /></div>
	 	        	<div class="page-contentList1"><span>到</span></div>
	 	        	<div class="page-contentList2"><input type="text" id="endDate" name="endDate" class="form-control required"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}',dateFmt:'yyyy-MM-dd'})"style="width:181px;" /></div>
	 	        </div>
	 	       	<div class="page-contentList clearfix">
	 	       		<div class="page-contentList1"><label>订货天数 >=:</label></div>
	 	        	<div class="page-contentList2 " style="width:300px;"><input type="text"  id="datesum" name="datesum" class="form-control required digits" style="width:100px;"  maxlength="4"/></div>
	 	       	</div>
	 	       	<div class="page-contentList clearfix"><input style="margin-left:15px;" type="radio" class="sortNo2" id="type" name="type" value="S" checked="checked" /><font>仅统计状态为已完成的订单</font><input type="radio" class="sortNo3" id="type" name="type" value="P"/><font>仅统计已完成线上付款的订单 </font></div>
			</div>
			</form>		
	</body>
</html>
   <script type="text/javascript">
   $(document).ready(function(){
   		window.parent.sss(); 
   })
   function sub(){
   	 if (mgt_util.validate(form)){
   		var beginDate =$("#beginDate").val();
   		var endDate =$("#endDate").val();
   		var datesum =$("#datesum").val();
   		var type =$("input[name='type']:checked ").val();
   		var page ="beginDate="+beginDate+"&endDate="+endDate+"&datesum="+datesum+"&flg=C&type="+type+"&userids="+window.parent.getids()
   		var condition = "日期从"+beginDate+",到"+endDate+" 订货天数>="+datesum;
   		window.parent.document.getElementById("condition").value=condition;
   		window.parent.document.getElementById("beginDate").value=beginDate;
   		window.parent.document.getElementById("endDate").value=endDate;
   		window.parent.document.getElementById("datesum").value=datesum;
   		window.parent.queryAll(page); 
   		window.parent.window.jBox.close();
   	}
   }
   function closes(){
   		window.parent.window.jBox.close();
   }
    </script>