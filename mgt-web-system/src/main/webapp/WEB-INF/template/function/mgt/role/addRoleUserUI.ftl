<!DOCTYPE html>
<html>
	<head>
		<title>分配人员</title>
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

	<style type="text/css">
		div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #49AFCD;text-align: left;width:150px;height:70px;padding: 2px;}
		div#rMenu ul li{
			margin: 1px 0;
			padding: 0 5px;
			margin-left:-40px;
			cursor: pointer;
			list-style: none outside none;
			background-color: #DFDFDF;
		}
	</style>

	<script  type="text/javascript">
		var roleUserLists={};
		[#if roleUserList?exists]
			[#list roleUserList as roleUser]
				roleUserLists['${roleUser.EMPLOYEE_ID}']='${roleUser.ROLE_ID}';
			[/#list]
		[/#if]	 

		$(document).ready(function(){
			mgt_util.jqGrid('#grid-table',{
				url:'${base}/employee/employeeList.jhtml',
				colNames:['','','用户编号','用户登录账号','用户真实姓名','性别','邮件','状态'],
				multiselect:false,
			   	colModel:[
			   		{name:'ID',index:'ID',width:30,hidden:true,key:true},
			   		{name:'',width:30,formatter:function(value,row,rowObject){
			   			if(null!=roleUserLists[rowObject.ID]){
							return '<input type="checkbox" name="userIds" value="'+rowObject.ID+'" onclick="addroleuser(this)" checked=checked>';
				   		}else{
							return '<input type="checkbox" name="userIds" value="'+rowObject.ID+'" onclick="addroleuser(this)" >';
					   	}
				   	}},
			   		{name:'USER_CODE',width:120},
			   		{name:'ACCOUNT_NAME', width:100,editable:true},
			   		{name:'USER_NAME',width:120,align:"center",editable:true},
			   		{name:'SEX',width:120,align:"center",editable:true,formatter:function(data){
						if(data==1){
							return '男';
						}
						if(data==2){
							return '女';
						}else{
							return data;
						}
				   	}},
			   		{name:'EMAIL',width:120,align:"center",editable:true},
			   		{name:'STATUS',width:120,align:"center",editable:true,formatter:function(data){
						if(data==1){
							return '启用';
						}
						if(data==2){
							return '已删除';
						}
						if(data==0){
							return '禁用';
						}else{
							return data;
						}
   					}}
			   	]
			});

			$("#searchbtn").click(function(){
				//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
				//mgt_util.showMask('正在查询，请稍等...');
				//top.$.jBox.tip('删除成功！','success');
				$("#grid-table").jqGrid('setGridParam',{  
			        datatype:'json',  
			        postData:$("#queryForm").serializeObjectForm(), //发送数据  
			        page:1  
			    }).trigger("reloadGrid"); //重新载入  
			});
		});

		function addroleuser(obj){
			$.ajax({
				url : '${base}/role/addRoleUser.jhtml',
				type : 'post',
				dataType : 'json',
				data : {
					employeeId : obj.value,
					addFlag: obj.checked,
					roleId : '${roleId}'
				},
				success : function(data) { 
					var roleUserArrays=data.data;
					roleUserLists={};
					for(var i=0;i<roleUserArrays.length;i++){
						roleUserLists[roleUserArrays[i].user_id]=roleUserArrays[i].role_id;
					}
				}
			});
		}
	</script>

	<body class="toolbar-fixed-top">
		<input type="hidden" value="${roleId}" name="roleId">
		<div class="navbar-fixed-top" id="toolbar">
			<div class="btn-group pull-right">
				<div class="btn-group"></div>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
		</div>	

		<div id="currentDataDiv" action="student" style="position:relative;padding:10px 0;">
			 <div class="form_divBox" style="display:block;">   
		       	 <form class="form form-inline queryForm"  id="query-form">     
		            <div class="form-group">
		                <label class="control-label">人员编号</label>
		                <input type="text" class="form-control" name="userCode" style="width:120px;">
		            </div>
		            <div class="form-group">
		                <label class="control-label">人员姓名</label>
		                <input type="text" class="form-control" name="userName" style="width:120px;">
		            </div>
		            <div class="form-group">
		                <label class="control-label">性别</label>
		                <select class="form-control" name="sex">
		                    <option value="">全部</option>
		                    <option value="1">男</option>
		                    <option value='2'>女</option>
		                </select>
		            </div>
		        	</form>
		       </div>
		        <div class="search_cBox">
					<div class="form-group">   
						<button type="button" class="search_cBox_btn"  id='' data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		            </div>
	            </div>
	    </div>

		<div class="page-content">
			<div class="row">
			 	<div class="content_wrap">
					<table width="100%" cellspacing="0" cellpadding="0" border="0" >
						<tr>
							<td valign="top" width="150" >
			    				<div class="zTreeDemoBackground left"  style="float:left;width:150px;">
									<ul id="treeDemo" class="ztree" style=" margin-top:0px;"></ul>
								</div>
							</td>
							<td>
			    				<div class="right" style="float:right;width:100%">
									<ul class="info" >
										<table id="grid-table" ></table>
										<div id="grid-pager"></div>
<!--  
												<li class="title"><h2>实现方法说明</h2>
													<ul class="list">
													<li>利用 beforeRightClick / onRightClick 事件回调函数简单实现的右键菜单</li>
													<li class="highlight_red">Demo 中的菜单比较简陋，你完全可以配合其他自定义样式的菜单图层混合使用</li>
													</ul>
												</li>
-->	
									</ul>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</body>
<SCRIPT type="text/javascript">
	var datas = {
		id:'ids',	
		name:'names'
	}

    var param = {
	    url:'${base}/department/deptList.jhtml',
	    data:datas
    }

   Yhxutil.org.doInit(param);
</SCRIPT>
</html>
 