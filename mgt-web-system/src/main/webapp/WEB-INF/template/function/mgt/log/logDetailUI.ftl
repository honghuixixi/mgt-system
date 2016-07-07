<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>日志管理-系统日志详情</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
    </head>
    
    <body>
    <body class="toolbar-fixed-top">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div class="page-content" style="margin-bottom:50px;">	
			<table border = "2" hight="80%" width="100%">
				<tr><td>类型</td><td>数据</td></tr>
				<tr><td>行动日期</td><td>${sysBizActionLog.actionDate}</td></tr>
				<tr><td>业务模块</td><td>${sysBizActionLog.bizName}</td></tr>
				<tr><td>业务名称</td><td>${sysBizActionLog.bizModule}</td></tr>
				<tr><td>客户端IP</td><td>${sysBizActionLog.ipAddress}</td></tr>
			</table>
			<HR style="FILTER: progid:DXImageTransform.Microsoft.Shadow(color:#987cb9,direction:145,strength:15)" width="100%" color=#987cb9 SIZE=1>	
			<table id="bizContent"  border = "2">
				<tr><td>字段名称</td><td>字段值</td></tr>
			</table>
				<script type="text/javascript">  
					$(document).ready(
						function() {
							var idx = 0;
							var array = new Array();
					 		var anObject=${sysBizActionLog.bizContent};
					 	 	 $.each(anObject,function(name,value) {
					 	 	    array[idx] = "<tr><td>"+name+"</td><td>"+value+"</td></tr>";
								idx ++;
							});
							var arrStr = array.join();
							$("#bizContent").append(arrStr);
					});
				</script> 
			</div>
	</body>
</html>