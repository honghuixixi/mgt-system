<!DOCTYPE html>
<html>
	<!-- 头部 -->
	<head>
		<title>角色修改</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script text="text/javascript">
		function editPro(){
			$.jBox.confirm("确认修改吗?", "提示", function(v){
					 if(v == 'ok'){
						    var masPkNo = $('#masPkNo').text();
							$.ajax({
									url:"${base}/vendor/vendorDone.jhtml",
									method:'post',
									dataType:'json',
									data:{"masPkNo":masPkNo},
									sync:false,
									success : function(data) {
										
										alert("999");
										if(data.code== '001'){		
											top.$.jBox.tip('执行成功', 'success');
											top.$.jBox.refresh = true;
												
										}else{
											top.$.jBox.tip('执行失败', 'error');
											return false;
										}
									}
								
							});
					}
			})  
		}
		</script>
		
		
	</head>
	
	<!-- 身体 -->
<body class="toolbar-fixed-top">
       <div class="page-content">
           <div class="safe_right"> 
               <div>
               <form id="queryForm" type="post" >
                   <table class="price_bill" cellpadding="0" cellspacing="0" >
                        <thead>
					      <tr height="25">
					        <td><strong>序号</strong></td>
					        <td hidden="true;">外键</td>
					        <td><strong>商品编码</strong></td>
					        <td><strong>条码</strong></td>
					        <td><strong>名称</strong></td>
					        <td><strong>单位</strong></td>
					        <td><strong>请求数量</strong></td>
					        <td><strong>发货数量</strong></td>
					        <td><strong>收货数量</strong></td>
					      </tr>
    					</thead>
    					<tbody>
    						[#list vendor as item]
    						<tr>
    							<td width="100"><span>${item.PK_NO}</span></td>
    							<!-- 备货单号 -->
    							<td hidden="true" id="masPkNo">${item.MAS_PK_NO}</td>
    							<td width="100"><span>${item.STK_C}</span></td>
    							<td width="100"><span>${item.PLU_C}</span></td>
    							<td width="140"><span>${item.STK_NAME}</span></td>
    							<td width="100"><span>${item.UOM}</span></td>
    							<td width="100"><span>${item.STK_QTY}</span></td>
    							<td width="100"><span>${item.QTY1}</span></td>
    							<td width="100"><span>${item.QTY2}</span></td>
    						</tr>
    						[/#list]
    					</tbody>
                  </table>
             </form>     
		     </div>
		   </div>
	</div>
	<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
</body>
</html>