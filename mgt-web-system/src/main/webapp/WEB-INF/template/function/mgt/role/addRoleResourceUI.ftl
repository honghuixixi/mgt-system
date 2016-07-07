<!DOCTYPE html>
<html>
	<head>
		<title>分配资源</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>

	<script type="text/javascript">
		var roleUserList={};
	</script>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/role/addRoleResource.jhtml">
			<input type="hidden" value="${roleId}" name="roleId">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<input class="btn btn-success"  type="button" value="全选" id="allSelect"/>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>

			<div class="page-content">
[#if menuList?exists]
    [#list menuList as menuLists]
    	[#list menuLists.menuItems as menuItem]
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
						<span class="contraction_span" id="span${menuItem.ID}" onClick="spShow('${menuItem.ID}')" style="cursor: pointer;">-</span><input type="checkbox" id="ckbox${menuItem.ID}" onClick="chTable('${menuItem.ID}')" class="contraction_input" /><label class="fpzy_la" style="color: red;">${menuItem.NAME}</label>
						</div>
					</div>
				</div>
				<div class="row">
						<table class="contraction_table"  id="table${menuItem.ID}">
							<tr >
			[#list menuItem.resourceItems as resourceItem]
								<td width="100">
									<input type="checkbox" name="resourceIds" value="${resourceItem.ID}">${resourceItem.NAME}&nbsp;&nbsp;
								</td>
				[#if (resourceItem_index+1)%4==0 && menuItem.resourceItems.size()>4] 
							</tr>
							<tr height="50">
				[/#if]
			[/#list]
							</tr>
						</table>
						<HR align=left width=550 color=#990099 SIZE=30 noShade>
				</div>
		[/#list]
    [/#list]
[/#if]
			</div>
		</form>
	</body>
<script>
[#if resourceList?exists]
	[#list resourceList as resource]
		$("input[name='resourceIds'][value='${resource.ID}']").attr("checked",true);
	[/#list] 
[/#if]

$(document).ready(function(){
	$("#allSelect").click(function(){
		if(this.value=='全选'){
			$("input[name='resourceIds']").attr("checked",true);
			this.value='取消全选';
		}else{
			$("input[name='resourceIds']").attr("checked",false);
			this.value='全选';
		}
	});
});

function chTable(obj){
var checkFlag=$("#ckbox"+obj).attr("checked");
if(null==checkFlag||undefined==checkFlag){
checkFlag=false;
}
		$("#table"+obj).find("input[name='resourceIds']").attr("checked",checkFlag);
}

function spShow(obj){
var spanText=$("#span"+obj).text();
if(spanText=='+'){
$("#span"+obj).text("-")
}else{
$("#span"+obj).text("+")
}
$("#table"+obj).fadeToggle();

}
</script>
</html>