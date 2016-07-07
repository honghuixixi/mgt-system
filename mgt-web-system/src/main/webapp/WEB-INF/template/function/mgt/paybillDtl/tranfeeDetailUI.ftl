<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
		</script>
    </head>
    <body>
       <div class="body-container">
      			 <form id="queryForm" type="post" >
                   <table cellpadding="0" cellspacing="0" border="2" style="width:400px;">
                        <thead>
					      <tr height="40" style="background:#999;" align="center">
					        <td width="200"><strong>费用类型</strong></td>
					        <td><strong>金额</strong></td>
					      </tr>
    					</thead>
    					<tbody>
    						[#list tranfee as tranfee]
    						<tr height="40"  align="center">
    							<td><span>${tranfee.TRAN_SUBTYPE}</span></td>
    							<td><span>${tranfee.TRANAMOUNT}</span></td>
    						</tr>
    						[/#list]
    					</tbody>
                  </table>
             </form>
   		</div>
    </body>
</html>