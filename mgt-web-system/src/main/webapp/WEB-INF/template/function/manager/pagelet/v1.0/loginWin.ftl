<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>用户登陆</title>

[#include "/common/commonHead.ftl" /]
            <link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
			<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
	</head>
	<body style="background-color: #f5f5f5">
				<form class="form-signin form-signin-win" role="form" method="post"
					id="loginForm" action="${base}/login/logindo.jhtml">
					<label class="control-label" for="accountName">
						登录名
					</label>
					<input type="text" id="accountName" name="accountName"
						class="input-block-level required form-control">
					<label class="control-label" for="password">
						密码
					</label>
					<input type="password" id="password" name="password"
						class="input-block-level required form-control">
					<button class="btn btn-lg btn-primary btn-block" type="submit">
						登陆
					</button>
				</form>
     		<script type="text/javascript">
     		$(document).ready(function() {
    			var u = $('#loginForm input[name=accountName]');
    			var p = $('#loginForm input[name=password]');
    			
    			$('#loginForm').bind('submit',function(){
    				if(u.val() === ""){
    					u.focus();
    				}else if(p.val() === ""){
    					p.focus();
    				}else{
    					$('button[type="submit"]').addClass('disabled').attr('disabled', true);
    					$('button[type="submit"]').text('登录中...');
    					$.ajax({
    						url: $('#loginForm').attr('action'),
    						method:'post',
    						dataType:'json',
    						data:{
    							accountName: u.val(),
    							password: p.val()
    						},
    						success:function(d){
    							if(d.success == true) {
    								top.$.jBox.close('loginBox');
    							}else{
    								top.bootbox.alert('用户名或密码错误, 请重试.');
    								p.focus();
    								$('button[type="submit"]').removeClass('disabled').attr('disabled', false).text('登录');
    								
    							}
    						}
    					})
    				}
    				
    				return false;
    			})	
    			$(document).keydown(function(event) {
    				var t = event.target;
    				if (event.keyCode == 13) {
    					if(t  ==  u[0] && u.val() !== ""){
    						p.focus();
    					}else if(t  ==  p[0] && p.val() !== ""){
    						$('#loginForm').submit();
    					}else{
    						u.focus();
    					}
    				}
    			});	
    			u.focus();
    		});
			</script>

	</body>
</html>
