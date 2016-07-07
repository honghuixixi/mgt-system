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
      			 <form id="queryForm" type="post"  action="${base}/order/editStatusFlg.jhtml">
      			 <input type="hidden"  id="pkNo"  name="pkNo" value="${pkNo}" >
	      			 <div class="navbar-fixed-top" id="toolbar" style="top:300px;">
	      			 [#list orderMas as orderMas]
	      			 [#if orderMas.statusFlg=='DELIVERED']
				    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm"> 执行
					    <i class="fa-save align-top bigger-125 fa-on-right"></i>
				    </button>
				    [/#if]
				    [/#list]
					<button class="btn btn-warning" data-toggle="jBox-close">
						关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
					</div>
                   <table cellpadding="0" cellspacing="0" border="2">
                        <thead>
					      <tr height="40" style="background:#999;" align="center">
					        <td width="200"><strong>商品编码</strong></td>
					        <td><strong>条码</strong></td>
					        <td><strong>商品名称</strong></td>
					        <td><strong>单位</strong></td>
					        <td><strong>退货数量</strong></td>
					      </tr>
    					</thead>
    					<tbody>
    						[#list orderItem as orderItem]
    						<tr height="40"  align="center">
    							<td><span>${orderItem.STK_C}</span></td>
    							<td><span>${orderItem.PLU_C}</span></td>
    							<td><span>${orderItem.STK_NAME}</span></td>
    							<td><span>${orderItem.UOM}</span></td>
    							<td><span>${orderItem.STK_QTY}</span></td>
    						</tr>
    						[/#list]
    					</tbody>
                  </table>
             </form>
   		</div>
    </body>
    <script type="text/javascript">
    function checkForm(){
		mgt_util.submitForm('#queryForm');
		}
	</script>
</html>