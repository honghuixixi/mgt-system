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
		<form class="form-horizontal" id="form" action="${base}/returnmergeorder/deliver.jhtml" style="">
		<input id="id" name="pkNo" type="hidden" value="${pkNo}">
			<div class="navbar-fixed-top" id="toolbar">
				<div class="btn-group pull-right">
					<div class="btn-group">
						<button class="btn btn-red btn-danger" data-toggle="jBox-call" data-fn="checkForm">
							发货
						<i class="fa-save  align-top bigger-125 fa-on-right"></i>
					</button>
					<button class="btn btn-red" data-toggle="jBox-close">关闭
						<i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
					</div>
				</div>
			</div>			
[#if orderItemList?exists]		
<div class="page-content">
    <div class="safe_right" style=""> 
      <div>
        <table class="price_bill" cellpadding="0" cellspacing="0" >
    <thead>
      <tr height="25">
        <td><strong>商品编码</strong></td>
        <td><strong>条码</strong></td>
        <td><strong>商品名称</strong></td>
        <td><strong>单位</strong></td>
        <td><strong>单价</strong></td>
        <td><strong>应退数量</strong></td>
        <td><strong>实退数量</strong></td>
        <td><strong>赔偿金额</strong></td>
        <td><strong>小计</strong></td>
      </tr>
    </thead>
    <tbody>
	  [#list orderItemList as item]
	  <tr height="60">
	    <td width="100"><span>${item.stkC}</span></td>
	    <td width="101"><span></span></td>
	    <td width="201">${item.stkName}</td>
	    <td width="126"><span>${item.uom}</span></td>
	    <td width="126">${item.netPrice}</td>
	    <td width="126">${item.qty1}</td>
	    <td width="126"><input name="qty2" id="qty2" class="qty2" value="${item.qty2}" style="width:50px"/></td>
	    <td width="126"><input name="amt" id="amt" class="amt" value="${item.diffMiscAmt}" style="width:50px"/></td>
	    <td width="126"><span></span></td>
	  </tr>
	  [/#list]
      
    </tbody>
  </table>
      </div>
    </div>
</div>

[#else]暂无数据
[/#if]
<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
</form>
	</body>
	<script type="text/javascript">
			function checkForm(){
				 $(".qty2").each(function(){
				    if( $(this).val() == ''){
				    	$(this).val(0)
				    }
				  });
				  $(".amt").each(function(){
				    if( $(this).val() == ''){
				    	$(this).val(0)
				    }
				  });
				mgt_util.submitForm('#form');
			}
			
			function check(){
				$(".qty2").each();
			}
			$().ready(function() {
				$(".qty2").blur(function(){ 
				var qty = $(this).parent().prev().text();
					if(Number($(this).val())>Number(qty)){
						top.$.jBox.tip('实退数量不能大于应退数量！', 'error');
						$(this).val("");
					}
					if($(this).val()>0){
						var xiaoji = Number($(this).parent().prev().prev().text())*$(this).val()+Number($(this).parent().next().children().val());
						var zonge = Number($(this).parent().prev().prev().text())*Number($(this).parent().prev().text());
						if(xiaoji>zonge){
							top.$.jBox.tip('小计金额不能大于商品总额！', 'error');
							$(this).val("");
							$(this).parent().next().next().text($(this).parent().next().children().val());
						}else{
							$(this).parent().next().next().text(xiaoji);
						}
					}
				});
				$(".amt").blur(function(){ 
					var val = Number($(this).parent().prev().prev().prev().text())*(Number($(this).parent().prev().prev().text()) -Number($(this).parent().prev().children().val()));
					if(Number($(this).val())>Number(val)){
						top.$.jBox.tip('赔偿金额不能大于商品总额！', 'error');
						$(this).val("");
					}
					var xiaoji1 = Number($(this).parent().prev().prev().prev().text())*Number($(this).parent().prev().children(".qty2").val())+Number($(this).val());
					$(this).parent().next().text(xiaoji1);
				});
			});
	</script>
</html>