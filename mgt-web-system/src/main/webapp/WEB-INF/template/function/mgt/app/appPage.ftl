
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>app列表管理</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" media="screen" href="/qpwa-management/styles/css/base/css/base.css" />
	<link rel="stylesheet" media="screen" href="/qpwa-management/styles/css/base/css/main.css" />
	<link href="/qpwa-management/scripts/lib/plugins/jqgrid/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="/qpwa-management/scripts/lib/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<link rel="stylesheet" href="/qpwa-management/styles/function/mgt/mgt_core.css" type="text/css">
   	<style>
	body {
		*margin: 0;
		*padding: 0;
	}
	</style>
	<script src="/qpwa-management/scripts/lib/jquery/js/jquery-1.8.3.min.js" ></script>
   	<!-- 包空间 -->
	<script src="/qpwa-management/scripts/lib/plugins/js/main.js" ></script>
	<script src="/qpwa-management/scripts/lib/plugins/bootstrap/js/bootstrap.js" ></script>
	<script src="/qpwa-management/scripts/lib/plugins/bootstrap/js/bootbox.js" ></script>
	<script src="/qpwa-management/scripts/lib/plugins/jbox/jquery.jBox-2.3.min.js" ></script>
	<script src="/qpwa-management/scripts/lib/jquery/js/jquery.form.min.js" ></script>
	<script src="/qpwa-management/scripts/lib/jquery/jquery-form.js" ></script>
    <!-- jquery.jqGrid.src.js -->   
	<script src="/qpwa-management/scripts/lib/plugins/jqgrid/js/i18n/grid.locale-cn.js" type="text/javascript"></script>
	<script src="/qpwa-management/scripts/lib/plugins/jqgrid/js/jquery.jqGrid.src.js" type="text/javascript"></script>
	<!-- 公用util -->
	<script src="/qpwa-management/scripts/function/mgt/mgt_core.js" type="text/javascript"></script>
	<script src="/qpwa-management/scripts/function/mgt/mgt_constant.js" type="text/javascript"></script>
	<script src="/qpwa-management/scripts/function/mgt/mgt_util.js" type="text/javascript"></script>
	<!-- jquery-validate-->
	<script src="/qpwa-management/scripts/lib/plugins/jquery-validation/jquery.validate.js" type="text/javascript"></script>
	<script src="/qpwa-management/scripts/lib/plugins/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="/qpwa-management/scripts/lib/plugins/jquery-validation/jquery.validate.method.js" type="text/javascript"></script>
  
   <script type="text/javascript" language="javascript" src="/qpwa-management/scripts/lib/tabData.js"></script>
	   <script  type="text/javascript">
				$(document).ready(function(){
					mgt_util.jqGrid('#grid-table',{
						url:'/qpwa-management/app/list.jhtml',
							colNames:['','app名字','包号','版本号','版本日志','版本的url','强制更新','操作'],
						   	colModel:[	 
								{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
						   		{name:'APP_NAME',width:120},
								{name:'APP_CODE', width:100},
								
								{name:'VER_NUM',width:120},
								{name:'VER_LOG', width:100},
								{name:'URL', width:100},
								{name:'FORCE_FLG', width:60,formatter:function(data){
									if(data=='Y'){
										return '是';
									}
									if(data=='N'){
										return '否';
									}
								}},
								{name:'', width:100,formatter:function(value,row,index){
									
									return '<button type=button class="btn btn-info edit"  onclick=editStatusFlg("'+index.UUID+'","删除")>删除</button>';
								  
								  }
								}
						   	],
						   	gridComplete:function(){ //循环为每一行添加业务事件 
								//table数据高度计算
								cache=$(".ui-jqgrid-bdivFind").height();
								tabHeight($(".ui-jqgrid-bdiv").height());
							}
					});
				})
				
				function editStatusFlg(pkNo,message){
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
					
							 $.ajax({
								 url:'/qpwa-management/app/editStatus.jhtml',
								 sync:false,
								type : 'post',
								dataType : "json",
								data :{
									'uuid':pkNo,
								},
								error : function(data) {
									alert("网络异常");
									return false;
								},
								success : function(data) {
									if(data.code==200){
									top.$.jBox.tip('删除成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
									}
									else{
										top.$.jBox.tip('删除失败！', 'error');
								 			return false;
									}
								}
				           });	
			   }});
			}
		
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
            <!-- 面包屑导航 -->
			<div id="currentDataDiv" action="resource">
	            <!-- 搜索条 -->
	            <div class="currentDataDiv_tit">
	            	 <div class="form-group">
	                 	<button type="button" class="btn_divBtn add"  id='prom_add' data-toggle="jBox-win"  href="/qpwa-management/app/addAppUI.jhtml">添加</button>
	                 	<!--<button type="button" class="btn_divBtn edit" id='prom_edit' data-toggle="jBox-edit"  href="/qpwa-management/b2cKitPromMas/editB2cKitPromMasUI.jhtml">编辑</button>
		                <button type="button" class="btn_divBtn del"  id='prom_del' data-toggle="jBox-remove-prom" href="/qpwa-management/b2cKitPromMas/deleteEditB2cKitPromMas.jhtml">删除</button>
	                 	<button type="button" class="btn_divBtn edit" id='prom_item_edit' data-toggle="jBox-edit-kitProm-item" jBox-width="1060" jBox-height="560" href="/qpwa-management/b2cKitPromMas/b2cKitPromItemUI.jhtml">编辑商品</button>
	                 	<button type="button" class="btn_divBtn edit" id='prom_item_edit' data-toggle="jBox-edit-kitPromLm-item" jBox-width="1060" jBox-height="560" href="/qpwa-management/b2cKitPromMas/B2cKitPromLmUI.jhtml">编辑地标</button>
	                -->
	                </div>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
 



