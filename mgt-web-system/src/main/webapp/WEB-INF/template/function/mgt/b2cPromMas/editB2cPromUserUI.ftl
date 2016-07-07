<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promUserLists={};
		[#list promUserList as promuser] 
		promUserLists['${promuser.USER_NO}']='${promuser.USER_NO}';
		 [/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/b2cPromMas/userList.jhtml?pkNo=${pkNo}&selectType='+$("#selectTypeVal").val(),
					multiselect:false,
 					colNames:['','','用户编号','登录名','名称','地址','手机号码'],
				   	colModel:[	 
				   	{name:'',width:10,formatter:function(value,row,rowObject){
					   		if(null!=promUserLists[rowObject.USER_NO]){
								return '<input type="checkbox"  id="promCheckBox'+rowObject.USER_NO+'" value="'+rowObject.USER_NAME+'" onclick="addPromItem(this)" checked=checked>';
						   	}else{
								return '<input type="checkbox"  id="promCheckBox'+rowObject.USER_NO+'" value="'+rowObject.USER_NAME+'" onclick="addPromItem(this)" >';
							}
				     }},
					{name:'USER_NO',index:'ID',width:0,hidden:true,key:true},
					{name:'USER_NO',index:'ID',width:60},
			   		{name:'USER_NAME',width:60},
					{name:'NAME',width:60},
			   		{name:'CRM_ADDRESS1', width:100},
			   		{name:'CRM_MOBILE', width:40}
				   	]
				});

				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});


			});
			
			
			function addPromCheckBox(obj){
						setTimeout(function(){
				$("#promCheckBox"+obj).attr('checked',true);
				var promCheckBox = document.getElementById("promCheckBox"+obj);
				addPromItem(promCheckBox);
						},1000);
			
			}
				function addPromItem(obj){
					$.ajax({
						url:'${base}/b2cPromMas/addUserList.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							addFlag: obj.checked,
							userName: obj.value,
							pkNo : '${pkNo}'
							},
						success : function(data) { 
								top.$.jBox.tip('编辑商户成功！','success');
								var promUserArrays=data.data;
								var promUserLists = {};
								for(var i=0;i<promUserArrays.length;i++){
									promUserLists[promUserArrays[i].USER_NO]=promUserArrays[i].USER_NO;
								}
						}
					});
					
					}
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="resource" style="position:relative;padding:10px 0;">
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block;">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form">
	            	<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1" >
	                <div class="form-group">
	                    <label class="control-label">登录名</label>
	                    <input type="text" class="form-control" name="userName" id="userName" style="width:120px;" >
	                </div>
	                <div class="form-group">
	                    <label class="control-label">真实姓名</label>
	                    <input type="text" class="form-control" name="name" id="name" style="width:120px;" >
	                </div>
	                
	            </form>
	            </div>
	           <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id='search_b2cUser' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索</button>
	                 	<button type="button" class="search_cBox_btn" id='search_addB2cUser' data-toggle="jBox-query-prom-user"  ><i class="icon-search"></i> <span id="sreachFlagSpan">添加商户</span> </button>
	                 	
	                </div>
	           </div>
	        </div>
	         <div style="clear:both;"></div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
  	
   		</div>
    </body>
</html>
 



