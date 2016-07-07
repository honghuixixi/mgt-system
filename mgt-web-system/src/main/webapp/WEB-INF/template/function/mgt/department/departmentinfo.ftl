<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-员工信息配置</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<style type="text/css">
			div#rMenu {position:absolute; visibility:hidden; top:5px;left:0;text-align: left;width:150px;height:70px;padding: 2px;}
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
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/employee/employeeList.jhtml',
 					colNames:['','用户编号','用户登录账号','用户真实姓名','手机','创建日期','状态','操作'],
 					sortable:true,
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'USER_CODE',width:80},
				   		{name:'ACCOUNT_NAME', width:100,editable:true},
				   		{name:'USER_NAME',width:120,align:"center",editable:true},
				   		{name:'MOBILE',width:120,align:"center",editable:true},
				   		{name:'CREATE_DATE',width:160,align:"center",editable:true,formatter:function(data){
									if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd hh:mm:ss');
								}},
				   		{name:'STATUS',width:60,align:"center",editable:true,formatter:function(data){
							if(data==1){
								return '启用';
							}
							if(data==0){
								return '停用';
							}else{
								return data;
							}
					   	}},
				   		{name:'',width:220,align:"center",editable:true,formatter:function(value,row,index){
					 
					 	var str =  '<button type="button" class="btn btn-info edit"     onClick=editEmployeeUI("'+index.ID+'")    href="${base}/employee/editEmployeeUI.jhtml">编辑 </button>&nbsp;<button type="button" class="btn btn-info edit"    onClick=addEmployeeRoleUI("'+index.ID+'")  href="${base}/employee/addEmployeeRoleUI.jhtml">分配角色</button>';
					   	
					   	if(index.STATUS==1){
					   	str+='&nbsp;<button type="button" class="btn btn-info del"    onClick=editStatus("'+index.ID+'","0")   href="${base}/employee/editStatus.jhtml">停用 </button>';
					   	}
						else{
					   	str+='&nbsp;<button type="button" class="btn btn-info del"    onClick=editStatus("'+index.ID+'","1")   href="${base}/employee/editStatus.jhtml">启用</button>';
						}				   	
					   	
					   	return str;
					   	}}
					   	//,
				   		//{name:'status',width:80,align:"center",editable:true,formatter:function(data){
						//	if(data==1){
						//		return '启用';
						//	}
						//	if(data==0){
						//		return '禁用';
						//	}else{
						//		return data;
						//	}
						//}},
				   		//{name:'PASSWORD',width:80,align:"center",editable:true}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
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
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="student">
	             <div class="currentDataDiv_tit">
	              	<div class="form-group">   
	                 	<button type="button" class="btn_divBtn add"  id="user_add"  data-toggle="jBox-win" href="${base}/employee/addEmployeeUI.jhtml">添加 </button>
		                <button type="button" class="btn_divBtn del"   id="user_del"  data-toggle="jBox-remove" href="${base}/employee/delete.jhtml">删除 </button>
		                <button type="button" class="btn_divBtn edit"   id="user_wh_mas_edit"  data-toggle="jBox-edit" href="${base}/employee/addUserWhMasUI.jhtml">分配仓库</button>
		                <button type="button" class="btn_divBtn del"   id="user_edit_dept"  data-toggle="jBox-edit-dept" href="${base}/employee/editEmployeeDeptUI.jhtml">批量修改</button>
	                </div>
	             </div> 
	             <div class="form_divBox" style="display:block;padding-left:160px;">   
		            <form class="form form-inline queryForm"  id="query-form"> 
		               <!-- <div class="form-group">
		                    <label class="control-label">人员编号</label>
		                    <input type="text" class="form-control" name="employeeCode" maxlength="32" style="width:120px;">
		                </div>
		                -->
		                <div class="form-group">
		                    <label class="control-label">人员姓名</label>
		                    <input type="text" class="form-control" name="userName" maxlength="60" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">性别</label>
		                    <select class="form-control" name="sex">
		                        <option value="">全部</option>
		                        <option value="1">男</option>
		                        <option value='2'>女</option>
		                    </select>
		                </div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="status">
		                        <option value="">全部</option>
		                        <option value="1">启用</option>
		                        <option value='0'>停用</option>
		                    </select>
		                </div>
		            </form>
	            </div>
	            <div class="search_cBox">
	               <div class="form-group">   
		                <button type="button" class="search_cBox_btn" id="user_search"  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </div>
	        </div>
	      </div>    

        <div class="content_wrap">
        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
				    <td valign="top" width="192" >
				    	<div class="aaab" style="position:absolute;top:40px;left:0;width:176px;height:48px;border-right:solid 1px #e1e1e1;"></div>
	    				<div class="zTreeDemoBackground left"  style="float:left;width:150px;position:relative;top:-38px;left:0;">
							<ul id="treeDemo" class="ztree" style=" margin-top:0px;"></ul>
						</div>
				    </td>
				    <td valign="top" width="auto">
	    				<div id="pos_fixR">
							<ul class="info" >
								<table id="grid-table" ></table>
								<div id="grid-pager" class="grid-pager" align="right"></div>
	<!--  `
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
   		<!--
   		<div id="rMenu" style="margin:5px 0 0 30px;">
			<ul class="ul-right-group">
				<li id="m_add" onclick="Yhxutil.org.addTreeNode(this);" src="${base}/department/addDepartmentUI.jhtml">增加部门</li>
				<li id="m_modify" onclick="Yhxutil.org.modifyTreeNode(this);" src="${base}/department/editDepartmentUI.jhtml">修改部门</li>
				<li id="m_del" onclick="Yhxutil.org.removeTreeNode(this);" src="${base}/department/delete.jhtml">删除部门</li>
			</ul>
		</div>-->
    </body>
	<SCRIPT type="text/javascript">
		var datas = {
			id:'ids',	name:'names'
		}
	    var param = {
	    	url:'${base}/department/deptList.jhtml',
	    	data:datas
	    }
	   Yhxutil.org.doInit(param);
	   
	   function editEmployeeUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '编辑',
							url : '${base}/employee/editEmployeeUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   }
	   function addEmployeeRoleUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '分配角色',
							url : '${base}/employee/addEmployeeRoleUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   }
	   function editStatus(obj,status){
	   			$.jBox.confirm("确认修改员工状态?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在设置数据，请稍等...');
					$.ajax({
						url : '${base}/employee/editStatus.jhtml',
						type :'post',
						dataType : 'json',
						data : 'id=' + obj+'&status='+status,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								if (s) {
									top.$.jBox.tip('设置成功！','success');
									mgt_util.refreshGrid($("#grid-table"));
								}
							});
						}
					});
				}
			});
	   
	   }
	</SCRIPT>
</html>