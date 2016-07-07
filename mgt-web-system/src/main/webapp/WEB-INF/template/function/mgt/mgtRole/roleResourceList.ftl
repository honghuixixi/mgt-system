<!DOCTYPE html>
<html>
	<head>
		<title>人员权限分配</title>
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
			<input type="hidden" value="${employeeId}" id="employeeId">
			<div class="page-content">
			<!--登录人的姓名-->
				<span id="username_dis"><font size="8"><b>${accountName}</b></font></span>
			</div>
            <div class="page-content" style="padding-bottom:15px;overflow:hidden;">
                <!--输入用户名，根据用户名精确查询-->
                <label class="control-label fl_l" style="float:left;margin-right:10px;">用户名</label><input type="text" id="accountName" class="form-control fl_l"  style="width:120px;float:left;margin-right:10px;"  value="${accountName}"/>
                <button type="button" class="search_cBox_btn"  style="float:left;" onclick="search();"><i class="icon-search"></i> 搜 索 </button>
            </div>
            <div id="resource">
                <div id="roleCheck" class="page-content">
                    [#if roleList?exists]
                        [#list roleList as roleItem]
                                <div class="row" style="float:left;margin:0;">
                                    <div class="col-xs-5" style="width:100%">
                                        <div>
                                            <input type="checkbox" name="roleIds" value="${roleItem.id}" title=" ${roleItem.name}"  onclick="change(this)" [#if roleItem.visible == 'y']checked[/#if] >
                                             ${roleItem.name}
                                        </div>
                                    </div>
                                </div>
                        [/#list]
                    [/#if]
                </div>
                <p>
                <p>
                <!--循环菜单和资源-->
                <div>
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
 
	</body>
<script>
    function search(){

        var accountName = $('#accountName').val();
        if(accountName!=null){
            $.ajax({
                url:'${base}/mgtRole/search.jhtml',
                sync:false,
                type : 'post',
                dataType : 'json',
                data :{
                    'accountName':accountName
                },
                error : function(data) {
                    alert("网络异常");
                    return false;
                },
                success : function(data) {
                    if(data.code==001 && data.data!=null){
                        //删除角色和菜单
                       
                        if($("#roleCheck").text().trim()!=""){
                            $("#roleCheck").empty();
                        }
                        $("table tr").eq(0).nextAll().remove();
                        //在表格后面加载数据
                        var resourceList = data.data.resourceList;
                        var menuList = data.data.menuList;
                        var roleList = data.data.roleList;
                        var roleHtml="";
                        var html = "";
                        if(roleList!=null){
                            $.each(roleList, function (index, role) {
                                roleHtml+="<div class='row' style='float:left;margin:0;'><div class='col-xs-5' style='width:100%'><div>";
                                roleHtml+= "<input type='checkbox' name='roleIds' onclick='change(this)' title='"+role.name+"' value='"+role.id+"' ";
                                if( role.visible == 'y'){
                                    roleHtml+= " checked />" ;
                                }else{
                                    roleHtml+="/>";
                                }
                                roleHtml+=role.name;
                                roleHtml+="</div></div></div>";
                            });
                            $.each(menuList, function (index, menu) {
                                html+="<tr class='"+menu.ROLE_ID+"'><td align='center' height='30'>"+menu.ROLE_NAME+"</td>";
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
                        $("#roleCheck").append(roleHtml);
                        $("#menuTable").append(html);
                    }else{
                        /*$("#resource").hidden();*/
                        top.$.jBox.tip(data.msg, 'error');
                        return false;
                    }
                }

            });
        }
    }

  /*选中调用分配角色并加载角色对应的权限*/
  function change(obj){
      var roleId = $(obj).val();
      var employeeId = $('#employeeId').val();
      if($(obj).attr("checked")){

         $.ajax({
             url:'${base}/mgtRole/assignRole.jhtml',
             sync:false,
             type : 'post',
             dataType : 'json',
             data :{
                 'roleId':roleId,
                 'employeeId':employeeId
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
          $.ajax({
              url:'${base}/mgtRole/cancleAssignRole.jhtml',
              sync:false,
              type : 'post',
              dataType : 'json',
              data :{
                  'roleId':roleId,
                  'employeeId':employeeId
              },
              error : function(data) {
                  alert("网络异常");
                  return false;
              },
              success : function(data) {
                  if(data.code==001){
                       $("."+roleId).remove();
                  }else{
                      top.$.jBox.tip('取消角色失败！', 'error');
                      return false;
                  }
              }
          });
     }
     
  }
</script>
</html>