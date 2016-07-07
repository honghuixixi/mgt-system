<!DOCTYPE html>
<html>
	<head>
		<title>菜单新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
				<style>
			table.big{border:1px solid #DDDDDD;width:810px;background-color:#F6F6F6}
			td{border:1px solid #DDDDDD;height:120px;}
			table.collapse{border-collapse:collapse;}
			thead td{text-align:left;font-weight:bold;height:40px;}
			table.small{width:560px;background-color:white;}
			tbody td{text-align:right;}
			table.small td{height:40px;border:1px solid white;text-align:left;}
			span.star{color:red;}
		</style>
		<script type="text/javascript">
		</script>
	</head>

	<body class="toolbar-fixed-top">
		<form class="addressForm" id="form" action="${base}/attendance/addAttendanceStatisticSetting.jhtml" enctype="multipart/form-data"method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				 <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForms" >保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div class="page-content">
				<table class="big collapse" style="display:block">
			<thead>
				<tr>
					<td colspan=2>考勤组</td>
			
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width:250px;" valign="top">考勤时间：<span class="star">*</span></td>
					<td>
						<table class="small">
							<tr>
								<td style="text-align:right;width:142px;">工作时间：</td>
								<td>
									<input type="text" id="startDate" name="workTimeBegin" onfocus="var endDate=$dp.$('endDate');WdatePicker({skin:'whyGreen',dateFmt:'H:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}'})" class="Wdate required" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.workTimeBegin?string('HH:mm:ss')}" [#else]value="9:00:00"[/#if]/>
									~
									<input type="text" id="endDate" name="workTimeEnd" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'H:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}'})" class="Wdate required" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.workTimeEnd?string('HH:mm:ss')}" [#else]value="18:00:00"[/#if]/>
								</td>
							</tr>
							<tr><td style="text-align:right;width:142px;">最早签到时间：</td><td><input type="text" id="earliestSignTime"  name="earliestSignTime" onfocus="var endDate=$dp.$('latestSignTime');WdatePicker({skin:'whyGreen',dateFmt:'H:mm:ss',onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'latestSignTime\')}'})" class="Wdate required" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.earliestSignTime?string('HH:mm:ss')}" [#else]value="8:00:00"[/#if]/></td></tr>
							<tr><td style="text-align:right;width:142px;">最晚签到时间：</td><td><input type="text" id="latestSignTime" name="latestSignTime" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'H:mm:ss',minDate:'#F{$dp.$D(\'earliestSignTime\')}'})" class="Wdate required" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.latestSignTime?string('HH:mm:ss')}" [#else]value="10:00:00"[/#if]/></td></tr>
						</table>
					</td>
				<tr>
				<tr>
					<td style="width:250px;height:80px;" valign="top">异常定义：</td>
					<td style="height:80px;">
						<table class="small">
							<tr><td><span class="star">*</span>迟到<input name="halfDayAbsenteeism" type="text" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.halfDayAbsenteeism}" [#else]value="90"[/#if] class="required number"/>分钟以上视为旷工半天</td></tr>
							<tr><td><span class="star">*</span>迟到<input name="allDayAbsenteeism" type="text" [#if mgtAttendantSetting?exists]value="${mgtAttendantSetting.allDayAbsenteeism}" [#else]value="180"[/#if]  class="required digits"/>分钟以上视为旷工一天</td></tr>
						</table>
					</td>
				<tr>
			
			</tbody>
			[#if mgtAttendantSetting?exists]
			<input type="hidden" name="pkNo" value="${mgtAttendantSetting.pkNo}"/>
			[/#if]
		<table>
			</div>
		</form>
	</body>
</html>
   <script>
   function checkForms() {
	   if (mgt_util.validate(form)){
   		$('#form').ajaxSubmit({
   			 dataType : "json",
   	            type : "post",
   	            url : "${base}/attendance/addAttendanceStatisticSetting.jhtml",
   			success: function (data) {
		    				if(data.success == true) {
		    					top.$.jBox.tip('保存成功！', 'success');
	    						top.$.jBox.refresh = true;
	    						mgt_util.closejBox('jbox-win');
			    			} else {
			    				top.$.jBox.tip(data.msg, 'error');
				    		}
   					},error : function(data){
   						top.$.jBox.tip('系统异常！', 'error');
   						top.$.jBox.refresh = true;
   						mgt_util.closejBox('jbox-win');
   						return;
   					}
   		});
   	}
   }
    </script>