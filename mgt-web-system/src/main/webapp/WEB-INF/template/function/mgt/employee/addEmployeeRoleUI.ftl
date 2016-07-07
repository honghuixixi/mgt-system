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
		<form class="form-horizontal" id="form" action="${base}/employee/addEmployeeRole.jhtml">
			<input type="hidden" value="${employeeId}" name="employeeId">
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
										
                                [#if roleList?exists]
	                                [#list roleList as roleList]
                                        <td >
                                            <input type="checkbox" value="${roleList.ID}" name="roleIds" title=" ${roleList.NAME}" onclick="change(this)">${roleList.NAME}&nbsp;&nbsp;&nbsp;
                                        </td>
							            [#if (roleList_index+1)%4==0 && roleList.size()>4]
								            </tr><tr  height="50">
							            [/#if]
	                            	[/#list] 
								[/#if]
							</tr>
						</table>
					</div>
				</div>
                <div class="row">
                    <table id="menuTable" align="left" width="100%" border="1" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td align="center" width="20%" height="30" >角色</td>
                            <td align="center" width="20%" height="30">功能</td>
                            <td align="center" width="60%" height="30">权限</td>
                        </tr>
                    [#if menuList?exists]
                        [#list menuList as menuItem]
                            <tr class="${menuItem.ROLE_ID}">
                                <td align="center" height="30">${menuItem.ROLE_NAME}</td>
                                <td align="center" height="30">${menuItem.NAME}</td>
                                <td align="left" height="30">
                                    <!--循环查询出该用户角色和菜单必须一样的资源-->
                                    [#if resourceList?exists]
                                        [#list resourceList as resourceItem]
                                            [#if resourceItem.MENU_ID == menuItem.ID && resourceItem.ROLE_ID == menuItem.ROLE_ID]
                                                <span style="padding:0 10px;white-space:nowrap">${resourceItem.NAME}</span>
                                            [/#if]
                                        [/#list]
                                    [/#if]
                                </td>
                            </tr>
                        [/#list]
                    [/#if]
                    </table>
                </div>
			</div>
		</form>
	</body>
	
	<script>
[#if employeeRoleList?exists]
	[#list employeeRoleList as employeeRoleList]
		var id='${employeeRoleList.ROLE_ID}';
		$("input[name='roleIds'][value='${employeeRoleList.ROLE_ID}']").attr("checked",true);
	[/#list]
[/#if]



/*选中调用分配角色并加载角色对应的权限*/
  function change(obj){
      var roleId = $(obj).val();
      if($(obj).attr("checked")){

         $.ajax({
             url:'${base}/employee/assignRole.jhtml',
             sync:false,
             type : 'post',
             dataType : 'json',
             data :{
                 'roleId':roleId
             },
             error : function(data) {
                 alert("网络异常");
                 return false;
             },
             success : function(data) {
             
                 if(data.code==001){
                      //在表格后面加载数据
                    var resourceList = data.data.resourceList;
                    var menuList = data.data.menuList;
                    var html = "";
                    if(menuList==null || menuList.length ==0){
                         html+="<tr class='"+roleId+"'><td align='center' height='30'>"+$(obj).attr("title")+"</td><td></td><td></td></tr>";
                    }else{
                         $.each(menuList, function (index, menu) {
                             html+="<tr class='"+roleId+"'><td align='center' height='30'>"+menu.ROLE_NAME+"</td>";
                             html+="<td align='center' height='30'>"+menu.NAME+"</td>";
                             html+="<td align='left' height='30'>";
                             $.each(resourceList,function(index,resource){
                                 if(resource.MENU_ID == menu.ID && resource.ROLE_ID == menu.ROLE_ID){
                                     html+="<span style='padding:0 10px;white-space:nowrap'>"+resource.NAME+"</span>";
                                 }
                             });
                             html+="</td></tr>";
                         });
                     }
                     $("#menuTable").append(html);
                 }else{
                     top.$.jBox.tip('分配角色失败！', 'error');
                     return false;
                 }
             }
         });
     }else{
         $("."+roleId).remove();
     }
     
  }
	</script>
</html>