<!DOCTYPE html>
<html>
	<head>
		<title>分配角色</title>
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
		<form class="form-horizontal" id="form" action="${base}/employee/addUserWhMas.jhtml">
			<input type="hidden" value="${employeeId}" name="employeeId">
			<input type="hidden" value="${username}" name="username">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>	

			<div class="page-content">
				<div class="row">
					<div >
						<table >
							<tr height="50">
										
[#if whMasList?exists]
	[#list whMasList as whMas]
								<td >
									<input type="checkbox" value="${whMas.WH_C}" name="whMasIds" >${whMas.NAME}&nbsp;&nbsp;&nbsp;
								</td>
						[#if (whMas_index+1)%3==0 && whMasList.size()>3]
							</tr>
							<tr  height="50">
						[/#if]
	[/#list] 
[/#if]
							</tr>
						</table>
					</div>
				</div>
			</div>
		</form>
	</body>
	
	<script>
	[#if userWhList?exists]
	[#list userWhList as userWhList]
		$("input[name='whMasIds'][value='${userWhList.WH_C}']").attr("checked",true);
	[/#list]
[/#if]
	</script>
</html>