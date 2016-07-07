<!DOCTYPE html>
<html>
	<head>
		<title>分配订单</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/logistics/userUpdate.jhtml">
		<input type="hidden"  id="ids"  name="ids" value="${ids}" >
           <div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<ul class="logisticUl" style="width:100%;overflow:hidden;">
			[#list list as var]
			<li style="float:left;width:50%;padding-top:5px;">
				<input type="radio" id="userNo" name="userNo" value="${var.userNo}"/><span style="padding-left:6px;">${var.userName}</span>
   			</li>
   			[/#list]
   			</ul>		

			
		</form>
	</body>
</html>
<script type="text/javascript">
function checkForm(){
	  var userNo=$("input[name='userNo']:checked").val();
	   if(typeof(userNo)=="undefined"){
	   	   top.$.jBox.close();
	   }else{
	   	   mgt_util.submitForm('#form');	
	   }
			
}
</script>
