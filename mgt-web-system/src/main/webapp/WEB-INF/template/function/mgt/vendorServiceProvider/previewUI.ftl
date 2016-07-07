<!DOCTYPE html>
<html>
	<head>
		<title>客服预览</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		
		 <link href="${base}/styles/css/style-b2b.css" rel="stylesheet" type="text/css" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	</head>

	<body style="width:95%;height:100%;" >
	<div >
    	<table class="order-table-listNew" width="100%" cellpadding="0" cellspacing="0" border="0">
        	<tr>
                  <td  align="center">
                    	<!-- 在线客服 -->
                    	<div class="ordService-p" >
	                    	<div class="service-absBox" >
								<div class="service-absTit"><a href="#">${vendor.name}</a></div>
								<div class="service-listBox">
									<h3>在线客服</h3>
									<ul>
									[#if serviceList?exists && serviceList?size>0]
										[#list serviceList as service]
											<li><a href="#"><img src="${base}/styles/images/online-service.gif" width="72" height="16" /></a>
												[#if service.type=="1"]
												  <label>售前：</label>
												[#elseif service.type=="2"] 
												  <label>售中：</label>
												[#elseif service.type=="3"] 
												  <label>售后：</label>
												[/#if]
												<label>${service.serviceName}</label>
											</li>
			                     		[/#list]
			                     	[#elseif vendor!=null]
			                     		<li><a href="#"><img src="${base}/styles/images/online-service.gif" width="72" height="16" /></a>
			                     		<label>销售：客服</label>
			                     	[/#if]
									</ul>
								</div>
								<div class="service-listBox" style="border:none 0;">
									<h3>工作时间</h3>
									<p>周一至周日：8:30 - 0:30</p>
									<p>周六至周日：8:30 - 0:30</p>
								</div>
							</div>
                    	</div>
                  </td>
        	</tr>
        </table>
    </div>
	</body>
</html>
