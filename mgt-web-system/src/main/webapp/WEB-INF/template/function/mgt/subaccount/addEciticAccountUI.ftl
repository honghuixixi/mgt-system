<!DOCTYPE html>
<html>
	<head>
		<title>资源新增</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/auto.css" />
		
		<script type="text/javascript" src="${base}/scripts/lib/jquery/js/jquery-1.8.3.min.js"></script>
		<script type="text/javascript" src="${base}/scripts/function/mgt/authVerify.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/layer/layer.js"></script> 
		<script type="text/javascript" src="${base}/scripts/lib/layer/tools.js"></script> 
		<script type="text/javascript" src="${base}/scripts/lib/autoPrompt/autopromot.js"></script> 
		
		<style type="text/css">
			.tb_yhxx tr{
				cellpadding:3px;
			}
			.tb_yhxx tr td div{
				padding-top:5px;
			}
			.tb_yhxx tr td input{
				margin-left:4px;
				width:195px;
			}
			.tb_qtxx tr{
				cellpadding:3px;
			}
			.tb_qtxx tr td div{
				padding-top:5px;
				margin-left:3px;
			}
			.tb_qtxx tr td input{
				width:180px;
			}
			#select_zh{
				background: transparent;
				margin-left:3px;
			    width: 196px;
			    height: 27px;
			}
			#select_zj{
				background: transparent;
			    width: 181px;
			    height: 27px;
			}
			#markRed{
				color:red;
			}
		</style>
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"
			action="${base}/subaccount/addEciticAccount.jhtml" method="post">
				<input type="hidden" value="${custId}" name="custId"/>
				<input type="hidden" id="custNameID" value="${scuser.name}" name="custName"/>
				<input type="hidden" value="${scuser.crmPic}" name="crmPic"/>
				<input type="hidden" value="${scuser.crmMobile}" name="crmMobile"/>
				<input type="hidden" value="${scuser.crmAddress1}" name="crmAddress1"/>
				<input type="hidden" value="${scuser.refUserName}" name="refUserName"/>
				<input type="hidden" id="accountNameParam"  name="accountName" value=""/>
				<input type="hidden" id="corporactionNameParam"  name="corporactionName" value=""/>
				<input type="hidden" id="hiddenBankType" value=""/>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger"  data-toggle="jBox-call" data-fn="checkForm">创建附属账户
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div>
				<table>
					<tr>
						<td>客户名称:${scuser.name}</td>
						<td>联系人:${scuser.crmPic}</td>
					</tr>
					<tr>
						<td>联系电话:${scuser.crmMobile}</td>
						<td>详细地址:${scuser.crmAddress1}</td>
					</tr>
				</table>
			</div>
			<div class="navbar-fixed-left toolbar-tit" id="toolbar">请完善下列资料</div>
			<div>
				<table class="tb_yhxx" style="max-width:50%;display:inline;">
					<tr>
						<td align=center>银行信息</td>
					</tr>
					<tr>
						<td>
							<div>
								<span>银行类型：</span>
								<select name="bankType" id="select_zh">
								[#if banktypelist ??]
							        [#list banktypelist as banktype]
				                          <option value="${banktype.BANK_TYPE}">${banktype.BANK_NAME}</option>
									[/#list]
								[/#if]
								</select>
								<span id="markRed">*</span>
							</div>
						</td>
					<tr>
						<td>
							<div>
								<span>账户名称：</span>
								<input type="text" id="accountName" value="${scuser.name}" disabled>
								<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>	
							<span>银行账号：</span>
							<input type="text" id="bankNum" name="bankNum" onkeyup="formatBankNo(this)" onkeydown="formatBankNo(this)"  value="">
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
						<div>
							<span>开户银行：</span>
							<input type="text" id="bankName" name="bankName" placeholder="开户行名错误会导致提现失败" value="">
							<span id="markRed">*</span>
						</div>
						<div id="auto"></div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<span>账户性质：</span>
								<select name="bankAccountType" value="2" class="select_zh" id="select_zh" >
							      <option value="2">对公账户</option>
							      <option value="1">个人账户</option>
								</select>
								<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
								<span>附属账户：</span>
								<input type="text" name="adjunctAccount" id="autoNum" placeholder="311081001367  7位数字" value="" style="width:145px">
								<a href="javascript:void(0)" onclick="autoCreate()" id="autoCreate" style="font-size:12px;color:blue;">
									自动生成
								</a>
								<span id="markRed">
								*
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</span>
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size:12px;color:red;">
							<span>
								注：该银行账户在附属账户提现时使用，如果为中信<br/>银行，提现免费；如果为其它行，按中信银行的收费<br/>费率收取费用
							</span>
						</td>
					</tr>
				</table>
				<table class="tb_qtxx"; style="max-width:50%;display:inline;">
					<tr>
						<td align=center>其他信息</td>
					</tr>
					<tr>
						<td>
						<div>
							<span>客户证件类型：</span>
							<select class="certificateType" name="certificateType" id="select_zj" value="5" onfocus="this.defaultIndex=this.selectedIndex;" onchange="this.selectedIndex=this.defaultIndex;">
						      <option value="5">组织机构代码</option>
						      <option value="0">身份证</option>
							</select>
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>证&nbsp;&nbsp;件&nbsp;&nbsp;号&nbsp;&nbsp;码&nbsp;：</span>
							<input type="text" id="certificateNum" name="certificateNum" value="" />
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>法&nbsp;&nbsp;人&nbsp;&nbsp;名&nbsp;&nbsp;称&nbsp;：</span>
							<input type="text" id="corporactionName" value="">
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>联&nbsp;&nbsp;&nbsp;&nbsp;系&nbsp;&nbsp;&nbsp;&nbsp;人&nbsp;&nbsp;：</span>
							<input type="text" id="contactName" name="contactName" value="" style="margin-left:1px;">
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>预&nbsp;&nbsp;留&nbsp;&nbsp;电&nbsp;&nbsp;话&nbsp;：</span>
							<input type="text" id="reservedPhone" name="reservedPhone" value="">
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>预&nbsp;&nbsp;留&nbsp;&nbsp;邮&nbsp;&nbsp;箱&nbsp;：</span>
							<input type="text" id="reservedEmail" name="reservedEmail" value="">
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div>
							<span>预留联系地址：</span>
							<input type="text" id="reservedAddress" name="reservedAddress" value=""  style="margin-left:0.5px;"/>
							<span id="markRed">*</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>

<script type="text/javascript">
$(document).ready(function(){
	//获取默认select框的值
	var value = $("#select_zh option:selected").val();
	$("#hiddenBankType").val(value);
		
	$(".select_zh").change(function(){
		var selectVal = $(".select_zh").val();
		if(selectVal=="2"){//对公
			$(".certificateType").val("5");
			$("#accountName").attr("disabled",true);
			$("#accountName").val($("#custNameID").val());
			$("#corporactionName").val("");
			$("#corporactionName").attr("disabled",false);
		}else if(selectVal=="1"){//个人
			$(".certificateType").val("0");
			$("#accountName").val("");
			$("#accountName").attr("disabled",false);
		}
	});
	
	//获取当前选中参数
	$("#select_zh").change(function(){
		var value = $("#select_zh option:selected").val();
		$("#hiddenBankType").val(value);
	});
	
	$("#autoNum").keyup(function(){
		var adjunctAccount = $("#autoNum").val();
		var re = /^[0-9]+.?[0-9]*$/; 
		if (!re.test(adjunctAccount)) { 
			alert("只能为数字！");
			$("#autoNum").val("311081001367");
		}
		if(adjunctAccount.length<=12||adjunctAccount.substr(0,12)!="311081001367"){
			$("#autoNum").val("311081001367");
		}
		
	});
	$("#autoNum").focus(function(){
		var adjunctAccount = $("#autoNum").val();
		if(adjunctAccount==""){
			$("#autoNum").val("311081001367");
		}
	});
	$("#autoNum").blur(function(){
		var adjunctAccount = $("#autoNum");
		if(adjunctAccount.val()!="311081001367"&&adjunctAccount.val().length!=19){
			alert("只能在后面添加7位数字，请重新输入！");
			adjunctAccount.val("311081001367");
		}
	});
	
	$("#accountName").blur(function(){
		$("#corporactionName").val($("#accountName").val());
		$("#corporactionName").attr("disabled",true);
	});
	
});
function checkForm(){
	var paramIds=new Array("#accountName","#bankNum","#bankName",".select_zh","#autoNum","#certificateNum","#corporactionName","#contactName","#reservedPhone","#reservedEmail","#reservedAddress");
	var paramNames=new Array("账户名称","银行账号","开户银行","账户性质","附属账户","证件号码","法人名称","联系人","预留电话","预留邮箱","预留联系地址");
	
    for (i=0;i<paramIds.length;i++){
		if($.trim($(paramIds[i]).val())==""){
			alert(paramNames[i]+"不能为空");
			return;
		}
		if(paramIds[i]=="#autoNum"&&$(paramIds[i]).val().length!=19){
			alert(paramNames[i]+"只能为19位数字");
			return;
		}
		if(paramIds[i]=="#reservedEmail"&&!$(paramIds[i]).val().match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/)){
			alert(paramNames[i]+"格式不正确！请重新输入");
			return;
		}
		if(paramIds[i]=="#reservedPhone"&&!checkTel($(paramIds[i]).val())){
			alert(paramNames[i]+"不符合规则");  
		    return;
		}
		
		if(paramIds[i]=="#certificateNum"){
			if($(".select_zh").val()=="1"&&!IdCardValidate($(paramIds[i]).val())){
				alert("身份证输入不合法");  
			    return;
			}else if($(".select_zh").val()=="2"&&orgcodevalidate($(paramIds[i]).val())){
				alert("组织机构代码输入不合法");  
			    return;
			}
		}
	} 
	$("#accountNameParam").val($("#accountName").val());
	$("#corporactionNameParam").val($("#corporactionName").val());
	
	//loading层
	//loading层
	layer_show();
	//提交表单
	$('#form').ajaxSubmit({
			success: function (html, status) {
				if(html.success){
					alert(html.msg);
					mgt_util.closejBox(this);
				}else{
					alert(html.msg);
					layer_close();
				    //layer.close(index);
				}
			},error : function(data){
				alert('请求失败了，请稍后重试！');
				layer.close(index);
			}
		});
}

//自动生成附属账户
function autoCreate(){
	var autoNum = $("#autoNum").val();
	if(autoNum!="311081001367"){
		autoNum="311081001367";
	}
	$.ajax({
		url : "${base}/subaccount/autoAttachedLucknum.jhtml",
		type :'post',
		data:{'account':$("#autoNum").val()},
		dataType : 'text',
		success : function(data) {
			var number = data;
			$("#autoNum").val(autoNum+number);
		}
	}); 
}

</script>