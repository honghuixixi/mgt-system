<!DOCTYPE html>
<html>
	<head>
		<title>支付验证</title>
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
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form"
			action="${base}/payorder/eciticPayOrderSuccess.jhtml">
			<input type="hidden" value="${paybill.batchid}" id="batchid" name="batchid"/>
			<input type="hidden" value="${paybill.pkNo}" id="pkNo" name="pkNo"/>
			<input type="hidden" value="${subaccountId}" id="subaccountId" name="subaccountId"/>
			<div class="navbar-fixed-top" id="toolbar">
				<button  class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">确认支付
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>

			<div class="page-content">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="name" class="col-sm-6 control-label">
								验证码：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="code" id="code" maxlength=6>
							</div>
						</div>
					</div>
						<div class="col-xs-5">
						<div class="form-group">
								<input type="button" class="btn btn-info edit"   id="smsCodeBtn"  onClick=sendSmsCode() value="发送验证码" />
						</div>
					</div>
		       
				</div>

			 
		</form>
	</body>
</html>
<script>

var  wait=60;  

function sendSmsCode(){
$.ajax({
      url:'${base}/payorder/obtainValidCode.jhtml?subaccountId=${subaccountId}',
      type : 'post',
      dataType : "json",
      data :{batchid:$("#batchid").val()},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
        if(data.success==true){
       time($("#smsCodeBtn"));
		}else{
		  alert("发送验证码失败");
		  return false;
		}
      }
    }); 
}
function  time(o)  {  
      if  (wait  ==  0)  {  
			o.removeAttr("disabled");	
			o.val("获取验证码");  
			wait  =  60;  
			}  else  {  
			o.attr("disabled",  true);  
			o.val("重新发送("  +  wait  +  ")");  
			wait--;  
			setTimeout(function()  {  
			time(o)  
			},  
			1000)  
			} 

}  

function checkForm(){
  if (mgt_util.validate(form)){
	  $.ajax({
	    url:'${base}/payorder/validSMSCode.jhtml',
	    type : 'post',
	    dataType : "json",
	    data :{pkNo:$("#pkNo").val(),code:$("#code").val()},
	    error : function(data) {
		  alert("网络异常");
		  return false;
	    },
	    success : function(data) {
		  if(data.success==true){
			$('.btn.btn-danger').addClass('disabled').attr('disabled', true);
$('#form').ajaxSubmit({
			success: function (html, status) {
					if(html.code != 'AAAAAAA'){
	   		        	 $.jBox.tip(html.msg);
	   		        	 return;
	   		        }
	   		        else{
	   					top.$.jBox.tip('支付成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   					
	   			    }
	   			    $('.btn.btn-danger').removeClass('disabled').attr('disabled', false);
			},error : function(data){
				window.opener=null;window.open('','_self');window.close();
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				//return;
			}
		});


		  }else{
			alert("验证码错误");
		    return false;
		  }
	    }
      });
    }
}

</script>