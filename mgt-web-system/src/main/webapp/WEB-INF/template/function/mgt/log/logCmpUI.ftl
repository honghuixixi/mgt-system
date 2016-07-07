<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>日志管理-日志对比</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
    </head>
    
    <body>
    <body class="toolbar-fixed-top" width="100%">
			<div class="navbar-fixed-top" id="toolbar">
			[#if lastPkNo?if_exists]
				<button class="btn btn-danger" onclick="compareBefore('${lastPkNo}')">对比上一条数据
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
			    <button class="btn btn-danger" onclick="compareNext('${lastPkNo}')">对比下一条数据
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
			[#else]
				[#if nextFlg?if_exists && nextFlg=="true"]
					<button class="btn btn-danger" onclick="compareBefore('${pkNo}')">对比上一条数据
				    	<i class="fa-save align-top bigger-125 fa-on-right"></i>
			    	</button>
				[#else]
					<button class="btn btn-danger" onclick="compareNext('${pkNo}')">对比下一条数据
				    	<i class="fa-save align-top bigger-125 fa-on-right"></i>
			    	</button>
				[/#if]
			[/#if]
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>		
			<div class="page-content" style="margin-bottom:50px;">
						<p id="messageContent" style="background-color:#cff"></p>
						<table border = "2" hight="80%" width="100%">
							<tr><td>类型</td><td>源数据</td><td>[#if nextFlg?if_exists && nextFlg=="false"]上一条数据[#else]下一条数据[/#if]</td></tr>
							<tr><td>业务ID</td><td colspan="2">${actionId}</td></tr>
							<tr><td>业务模块</td><td>${bizModule}</td><td>${lastBizModule}</td></tr>
							<tr><td>业务名称</td><td>${bizName}</td><td>${lastBizName}</td></tr>
							<tr><td>客户端IP</td><td>${ipAddress}</td><td>${lastIpAddress}</td></tr>
							<tr><td>操作日期</td><td>${actionDate?string("yyyy-MM-dd HH:mm:ss")}</td><td>[#if lastActionDate?if_exists]${lastActionDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]</td></tr>
						</table>
						<HR style="FILTER: progid:DXImageTransform.Microsoft.Shadow(color:#987cb9,direction:145,strength:15)" width="100%" color=#987cb9 SIZE=1>
						<table id="bizContent" border = "2" width="100%">
							<tr><td>字段名称</td><td>源数据</td><td>[#if nextFlg?if_exists && nextFlg=="false"]上一条数据[#else]下一条数据[/#if]</td></tr>
						</table>
							<script type="text/javascript">  
								$(document).ready(
									function() {	
										var idx = 0;
										var array = new Array();
										[#if message?if_exists]
											$("#messageContent").append("<h3>${message}</h3>");
										[/#if]
										[#if bizContent?if_exists]
									 	 	$.each(${bizContent},function(name,value) {
									 	 	    array[idx] = "<tr id = 'tr"+idx+"'><td>"+name+"</td><td id='td"+idx+"'>"+value+"</td></tr>";
												idx ++;
											});
											var arrStr = array.join();
											$("#bizContent").append(arrStr);
										[/#if]
										[#if lastBizContent?if_exists]
										 	idx = 0;
											$.each(${lastBizContent},function(bname,bvalue) {
									 	 	    $("#tr"+idx).append("<td>"+bvalue+"</td>");
									 	 	    var v ="'"+$("#td"+idx).text()+"'";
									 	 	    bvalue = "'"+bvalue+"'";
									 	 	    if(v != bvalue){
									 	 	    	$("#tr"+idx).css({color:"red"});
									 	 	    }
												idx ++;
											});
										[#else]
											for(var i=0;i<array.length;i++){
												$("#tr"+i).append("<td></td>");
											}
										[/#if]
								});
								function compareBefore(pkNo){
									window.location.href = "${base}/log/logCmpUI.jhtml?id="+pkNo+"&nextFlg=false";
								}
								function compareNext(pkNo){
									window.location.href = "${base}/log/logCmpUI.jhtml?id="+pkNo+"&nextFlg=true";
								}				
							</script> 
			</div>
    </body>
</html>