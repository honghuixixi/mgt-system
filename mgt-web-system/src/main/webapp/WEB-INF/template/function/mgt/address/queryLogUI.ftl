<!DOCTYPE html>
<html>
    <head>
        <title>地标审核日志详情</title>
		[#include "/common/commonHead.ftl" /]
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
    </head>
    <body>
       <div class="body-container">
           <table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">
  				<thead>
 					<tr bgcolor="#F8F8FF" border="1" height="18" >
     				<th align="center" width="4%" style="border:1px solid #000; border-right:none 0;">序号</th>
    				<th align="center" width="16%" style="border:1px solid #000; border-right:none 0;">被审核店铺编码</th>
			    	<th align="center" width="16%" style="border:1px solid #000; border-right:none 0;">审核人</th>
			     	<th align="center" width="15%" style="border:1px solid #000; border-right:none 0;">审核日期</th>
			     	<th align="center" width="16%" style="border:1px solid #000; border-right:none 0;">审核结果</th>
			    	<th align="center" width="15%" style="border:1px solid #000;">创建日期</th>
				  	</tr>
				</thead>
				<tbody>
            		[#list LmReqLogs as LmReqLogs]
            			<tr height="15" bgColor="#ffffff">
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${LmReqLogs_index+1}</td>
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${LmReqLogs.ACTION_USER_NAME}</td>
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${LmReqLogs.ACTION_USER}</td>
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${LmReqLogs.ACTION_DATE}</td>
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${LmReqLogs.ACTION_NAME}</td>
							<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">${LmReqLogs.CREATE_DATE}</td>
						</tr>
					[/#list]	
                </tbody>
           </table>
   	   </div>
    </body>
</html>