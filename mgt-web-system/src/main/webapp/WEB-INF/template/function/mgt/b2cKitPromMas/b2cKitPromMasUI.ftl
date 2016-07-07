<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>B2C套餐促销管理</title>
	    [#include "/common/commonHead.ftl" /]
	    <script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
	   <script  type="text/javascript">
				$(document).ready(function(){
					mgt_util.jqGrid('#grid-table',{
						url:'${base}/b2cKitPromMas/list.jhtml',
							colNames:['','创建日期','单据号码','起始时间','结束时间','备注','状态','操作'],
						   	colModel:[	 
								{name:'PK_NO',index:'ID',width:0,hidden:true,key:true},
						   		{name:'PROM_DATE',width:120,formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
									}},
								{name:'PROM_CODE', width:100},
								{name:'DATE_FROM',width:120,formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
									}},
								{name:'DATE_TO',width:120,formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
									}},
								{name:'NOTE', width:100},
								{name:'STATUS_FLG', width:60,formatter:function(data){
									if(data=='A'){
										return '活动';
									}
									if(data=='C'){
										return '取消';
									}
									if(data=='P'){
									return '启用';
									}
									else{
											return data;
									}
								}},
								{name:'', width:100,formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","P","启用")>启用</button>&nbsp;'+'<button type=button class="btn btn-info edit"  onclick=editStatusFlg("'+index.PK_NO+'","C","取消")>取消</button>';
									}
									if(index.STATUS_FLG=='P'){
										return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>';
									}
									if(index.STATUS_FLG=='C'){
										return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A","恢复") >恢复</button>';
									}
									else{
										//return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","P","启用")>启用</button>';
										return '';
									}
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
				
				function editStatusFlg(pkNo,statusFlg,message){
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
					
							 $.ajax({
								 url:'${base}/b2cKitPromMas/editStatus.jhtml',
								 sync:false,
								type : 'post',
								dataType : "json",
								data :{
									'pkNo':pkNo,
									'statusFlg':statusFlg
								},
								error : function(data) {
									alert("网络异常");
									return false;
								},
								success : function(data) {
									if(data.code==200){
									top.$.jBox.tip('保存成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
									}
									else if(data.code==300){
									top.$.jBox.tip('修改失败！编辑商品后操作.', 'error');
									}
									
									else if(data.code==400){
										top.$.jBox.tip('修改失败！促销套餐已过期，重新编辑后操作.', 'error');
										}
									else if(data.code==500){
										top.$.jBox.tip('修改失败！编辑地标后操作.', 'error');
										}
									else{
										top.$.jBox.tip('保存失败！', 'error');
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
	                 	<button type="button" class="btn_divBtn add"  id='prom_add' data-toggle="jBox-win"  href="${base}/b2cKitPromMas/addB2CKitPromMasUI.jhtml">添加</button>
	                 	<button type="button" class="btn_divBtn edit" id='prom_edit' data-toggle="jBox-edit"  href="${base}/b2cKitPromMas/editB2cKitPromMasUI.jhtml">编辑</button>
		                <button type="button" class="btn_divBtn del"  id='prom_del' data-toggle="jBox-remove-prom" href="${base}/b2cKitPromMas/deleteEditB2cKitPromMas.jhtml">删除</button>
	                 	<button type="button" class="btn_divBtn edit" id='prom_item_edit' data-toggle="jBox-edit-kitProm-item" jBox-width="1060" jBox-height="560" href="${base}/b2cKitPromMas/b2cKitPromItemUI.jhtml">编辑商品</button>
	                 	<button type="button" class="btn_divBtn edit" id='prom_item_edit' data-toggle="jBox-edit-kitPromLm-item" jBox-width="1060" jBox-height="560" href="${base}/b2cKitPromMas/B2cKitPromLmUI.jhtml">编辑地标</button>
	                </div>
	            </div>
	            <div class="form_divBox" style="display:block;">
            	    <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">单据号码</label>
		                    <input type="text" class="form-control" name="promCode" id="promCode" style="width:120px;" >
		                	<!-- <label><input name="statusFlg" type="radio" value="AP" checked="checked"/>启用 </label> 
							     <label><input name="statusFlg" type="radio" value="C" />取消 </label> -->
							<select name="statusFlg" class="form-control">
								<option value="">全部</option>
								<option value="A">活动</option>
								<option value="C">取消</option>
								<option value="P">启用</option>
							</select>
		                </div>
                    </form>
	            </div>
	            <div class="search_cBox">
	            	<button type="button" class="search_cBox_btn" id='prom_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
 



