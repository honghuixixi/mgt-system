<!DOCTYPE html>
<html>
	<head>
		<title>详细消息</title>
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
           <div class="navbar-fixed-top" id="toolbar">
			    
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>			

			<div class="page-content">
				<div class="page-content">
					<table id="packTab" class="tjqy_table" width="90%" border="0" cellspacing="0" cellpadding="0">
						<tbody>
						<tr><td>标题：</td><td>${message.title}</td></tr>
						<tr><td>内容：</td><td>${message.content}</td></tr>
						<tr><td>来源：</td><td>${message.source}</td></tr>
						</tbody>
					</table>
				</div>
			</div>
		</form>
	</body>
</html>
