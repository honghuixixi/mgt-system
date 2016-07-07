<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
        <title>系统管理-商户系统参数配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
<script  type="text/javascript">
			var userSettingLists={};
			[#if userSettingList?exists]
				[#list userSettingList as user]
					userSettingLists['${user.ITEM_NO}']='${user.ITEM_NO}';
				[/#list]
			[/#if]
			 
			$(document).ready(function(){
						
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/mgtSettingDtl/list.jhtml',
 					colNames:['','','编号','菜单名称','是否设置项','是否允许用户设置','默认值','描述','排序','操作'],
 					multiselect:false,
				   	colModel:[
				   		{name:'ITEM_NO',index:'ITEM_NO',width:0,hidden:true,key:true},
				   		{name:'',width:20,formatter:function(value,row,rowObject){
				   			if(null!=userSettingLists[rowObject.ITEM_NO]){
								return '<input type="checkbox" name="itemNos" value="'+rowObject.ITEM_NO+'"  checked=checked>';
					   		}else{
								return '<input type="checkbox" name="itemNos" value="'+rowObject.ITEM_NO+'" >';
						   	}
				   	    }},
				   		{name:'ITEM_NO',align:"center",width:160},
				   	    {name:'MENU_NAME',align:"center",width:160},
				   		{name:'DEF_FLG',width:60,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){
								return '是';
							}else{
								return '否';
							}
	   					}},
				   		{name:'USER_FLG',width:50,align:"center", editable:true,formatter:function(data){
							if(data=='Y'){
								return '是';
							}else{
								return '否';
							}
	   					}},
	   					{name:'DEF_VALUE',align:"center",width:50},
	   					{name:'DESCRIPTION',align:"center",width:160},
	   					{name:'SORT_NO',align:"center",width:50},
	   					{name:'detail',index:'ITEM_NO',width:120,align:'center',sortable:false} 
			   			
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件
				   		var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i];
							if(null==userSettingLists[id]){
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/mgtSettingDtl/addUserSettingUI.jhtml'>设置参数 </button>";
							}else{
							    detail ="<button type='button' class='btn btn-info edit' id='"+id+"' onClick=removeUserSetting('"+id+"') >取消参数设置 </button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						}; 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});

				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
	function removeUserSetting(obj){
		 $.jBox.confirm("确认要取消参数设置?", "提示", function(v){
                    if(v == 'ok'){
                        mgt_util.showMask('正在操作，请稍等...');
                        $.ajax({
                            url : "${base}/mgtSettingDtl/removeUserSetting.jhtml",
                            type :'post',
                            dataType : 'json',
                            data : 'id=' + obj,
                            success : function(data, status, jqXHR) {
                                mgt_util.hideMask();
                                mgt_util.showMessage(jqXHR,
                                        data, function(s) {
                                            if (s) {
                                                if(data.code=='success'){
                                                    top.$.jBox.tip('操作成功！','success');
                                                    document.location.reload();
                                                    //mgt_util.refreshGrid("#grid-table");
                                                    //$('#grid-table').trigger("reloadGrid");
                                                }else{
                                                    top.$.jBox.tip('当前应用正在使用,不能取消！','error');
                                                }
                                            }
                                        });
                            }
                        });
                    }
                });
       }
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="role">
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">编号</label>
		                    <input type="text" class="form-control" name="itemNo" style="width:120px;"/>
		                </div>
		                 <div class="form-group">
		                    <label class="control-label">菜单名称</label>
		                    <input type="text" class="form-control" name="menuName" style="width:120px;"/>
		                </div>
		            </form>
	            </div>
	            <div class="search_cBox">
	            	<div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="queryMgtSettingDtl" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </div>
	        </div>
     	  </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>