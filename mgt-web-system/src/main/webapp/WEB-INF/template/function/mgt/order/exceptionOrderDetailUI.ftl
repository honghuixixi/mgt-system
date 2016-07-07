<!DOCTYPE html>
<html>
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
	</head>
	<body class="toolbar-fixed-top">
	<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
		<form class="form-horizontal" id="form" action="" >
			<input type="hidden"id="orderId" name="orderId"  value="${order.PK_NO}" >
		</form>
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
					<div class="btn-group">
				        <button  id="preview" class="btn btn-red" onclick="createReturnOrder();">
							生成退货单
						</button>
					</div>
				</div>
			</div>			
    [#if order?exists]
    <div class="page-content">
    <div class="safe_right"> 
      <div>
        <table class="price_bill" cellpadding="0" cellspacing="0" >
            <thead>
                  <tr height="25">
                        <td><strong>商品编码</strong></td>
                        <td><strong>条码</strong></td>
                        <td><strong>商品名称</strong></td>
                        <td><strong>单位</strong></td>
                        <td><strong>订单数量</strong></td>
                        <td><strong>发货数量</strong></td>
                        <td><strong>收货数量</strong></td>
                        <td><strong>差异数量</strong></td>
                        <td><strong>拆零金额差异</strong></td>
                        <td><strong>备注</strong></td>
                  </tr>
            </thead>
            <tbody>
                [#list order.get("orderItem") as item]
                    <tr height="60">
                        <td width="80"><span>${item.STK_C}</span></td>
                        <td width="101">${item.PLU_C}</td>
                        <td width="101">${item.STK_NAME}</td>
                        <td width="101">${item.UOM}</td>
                        <td width="101">${item.UOM_QTY}</td>
                        <td width="101">${item.QTY1}</td>
                        <td width="101">${item.QTY2}</td>
                        <td width="101">${item.QTY1-item.QTY2}</td>
                        <td width="126">${item.DIFF_MISC_AMT}</td>
                        <td width="150">${item.DIFF_REMARK}</td>
                    </tr>
                [/#list]
             </tbody>
           </table>
      </div>
    </div>
</div>
[#else]暂无订单数据
[/#if]
<script type="text/javascript">
    function createReturnOrder(){
        var orderId = $("#orderId").val();
			$.ajax({
					type: "POST",
					url:  '${base}/order/createReturnOrder.jhtml',
					async:false,
					data: {'orderId':orderId},
					scope:this,
					error : function(data) {
						$.jBox.tip("网络异常");
						return false;
					},
					success: function(data){
						top.$.jBox.tip('操作成功！');
						top.$.jBox.refresh = true;
                        top.$.jBox.close();
					}
				});
		}	
</script>
</html>