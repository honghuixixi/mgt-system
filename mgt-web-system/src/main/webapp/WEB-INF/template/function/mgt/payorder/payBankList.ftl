<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>在线支付</title>
[#include "/common/commonHead.ftl" /]
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>在线支付</title>
</head>

<body>
<div class="pay_box">
    <div class="select_bank">选择支付银行</div>
    <div class="select_bankBox">
    	<ul>
    	[#if subaccount!=null]
        	<li class="first_li">
            	<div class="quick_payBox">
                	<div class="quick_payBox_l">银行卡</div>
                    <div class="quick_payBox_c"><img src="${base}/styles/images/zx_bankImg.jpg" /><span>快捷</span>附属卡<em>|</em>银行卡尾号 **${subaccount.attachedAccount}</div>
                    <div class="quick_payBox_r">支付：<font>${paybill.tranamount}</font>元</div>
                </div>
                <div class="quick_payBtn"><a   onClick="eciticTelCode('${paybill.pkNo}','${subaccount.id}')" >立即支付</a></div>
            </li>
            [/#if]
            [#if subaccount1!=null]
        	<li class="first_li">
            	<div class="quick_payBox">
                	<div class="quick_payBox_l">银行卡</div>
                    <div class="quick_payBox_c"><img src="${base}/styles/images/zx_bankImg.jpg" /><span>快捷</span>附属卡<em>|</em>银行卡尾号 **${subaccount1.attachedAccount}</div>
                    <div class="quick_payBox_r">支付：<font>${paybill.tranamount}</font>元</div>
                </div>
                <div class="quick_payBtn"><a   onClick="eciticTelCode('${paybill.pkNo}','${subaccount1.id}')" >立即支付</a></div>
            </li>
            [/#if]
            <!-- 
        	<li><a class="pay_bankIcon1" onClick="payEciticUI('${paybill.pkNo}')"></a></li>
            <li><a class="pay_bankIcon2"  onClick="payBillUI('${paybill.pkNo}')" ></a></li>
             -->
        </ul>
        <!-- 
        <div class="bank_textBox">
        	<p>•请您选择支付方式。建议使用中信银行的银行卡，支付请直接点击相应银行的按钮；如果您使用其他银行的银行卡，请点击“中国银联”按钮。</p>
            <p>•请遵守相关银行的规定进行操作。您在银行页面上进行的任何操作及其产生的任何法律后果，将按照您与银行签订的合同处理。本网站不承担任何责任。</p>
        </div>
         -->
    </div>
</div>
</body>
	<form class="form-horizontal" id="form"
			action="${base}/payorder/eciticPayBillUI.jhtml" method="post">
			<input type="hidden" name="pkNo" id="pkNo" value="${paybill.pkNo}"/>
			<input type="hidden" name="subaccountId" id="subaccountId"  />
			</form>
</html>


<script>
		 function payBillUI(obj){
		 		window.open('${base}/payorder/payBillUI.jhtml?pkNo='+obj, "_blank", "toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no");
		 	top.$.jBox.close();
	   }

function eciticTelCode(obj,subaccountId){
	$("#subaccountId").val(subaccountId);
	$("#form").submit();
}
	 function payEciticUI(obj){
		 		window.open('${base}/payorder/payEciticUI.jhtml?pkNo='+obj, "_blank");
	 top.$.jBox.close();
	   }
</script>