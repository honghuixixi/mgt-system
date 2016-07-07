<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>B2C常规促销</title>
	[#include "/common/commonHead.ftl" /]
   <script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/b2cPromMas/list.jhtml',
 					colNames:['','促销编码','开始时间','结束时间','状态','备注','操作'],
				   	colModel:[	 
						{name:'PK_NO',index:'ID',width:0,hidden:true,key:true},
				   		{name:'PROM_CODE',width:80},
				   		{name:'DATE_FROM',width:120,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
				   		{name:'DATE_TO', width:120,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
				   		{name:'STATUS_FLG', width:60,formatter:function(data){
									if(data=='A'){
									return '活动';
									}
									if(data=='P'){
									return '启用';
									}
									else{
									return data;
									}
								}},
				   		{name:'NOTE', width:100},
				   		{name:'', width:100,formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","P","启用")>启用</button>&nbsp;';
									}
									if(index.STATUS_FLG=='P'){
										return '&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>';
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
			function editStatusFlg(pkNo,statusFlg,message){
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
					
							 $.ajax({
								 url:'${base}/b2cPromMas/editStatus.jhtml',
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
									if(data.code==001){
									top.$.jBox.tip('保存成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
									}
									else if(data.code==002){
									top.$.jBox.tip('修改失败！该活动正在进行中或已解释...', 'error');
									}
									else if(data.code==003){
									top.$.jBox.tip(data.msg, 'error');
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
				<div class="currentDataDiv_tit" style="display:block;">
					<div class="form-group">
	                 	<button type="button" class="btn_divBtn add"  id='b2cPromMas_add' data-toggle="jBox-win"  href="${base}/b2cPromMas/addB2cPromMasUI.jhtml">添加</button>
	                 	<button type="button" class="btn_divBtn edit" id='b2cPromMas_edit' data-toggle="jBox-edit"  href="${base}/b2cPromMas/editB2cPromMasUI.jhtml">编辑</button>
		                <button type="button" class="btn_divBtn del"  id='b2cPromMas_del' data-toggle="jBox-remove-prom" href="${base}/b2cPromMas/delete.jhtml">删除</button>
	                 	<button type="button" class="btn_divBtn edit" id='b2cPromMas_item_edit' data-toggle="jBox-edit-b2cprom-item" jBox-width="1060" jBox-height="560" href="${base}/b2cPromMas/editB2cPromItemUI.jhtml">编辑商品</button>
	                    <button type="button" class="btn_divBtn edit" id='b2cPromMas_lm_edit' data-toggle="jBox-edit-b2cprom-item" jBox-width="1060" jBox-height="560" href="${base}/b2cPromMas/editB2cPromLmUI.jhtml">编辑地标</button>
	                    <button type="button" class="btn_divBtn edit" id='b2cPromMas_user_edit' data-toggle="jBox-edit-b2cprom-item" jBox-width="1060" jBox-height="560" href="${base}/b2cPromMas/editB2cPromUserUI.jhtml">编辑供应商</button>
		             </div>
				</div>
	            <!-- 搜索条 -->
            	<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label style="float:left;line-height:24px;" class="control-label">促销编码</label>
		                    <input type="text" class="form-control" name="promCode" id="promCode" style="width:120px;float:left;margin-right:10px;" >
		                	<label style="width:auto;float:left;margin-top:5px;"><input name="statusFlg" type="radio" value="P" checked="checked"/>启用 </label> 
							<label style="width:auto;float:left;padding-left:10px;margin-top:5px;"><input name="statusFlg" type="radio" value="A" />活动 </label>
		                </div>
		            </form>
            	</div>
            	<div class="search_cBox">
		            <div class="form-group">
			        	<button type="button" class="search_cBox_btn" id='b2cPromMas_query' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
			        </div>
            	</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
 



