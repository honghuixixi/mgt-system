<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>运维管理-促销商品</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/list.jhtml',
 					colNames:['','单据号码','活动名称','促销方式','开始时间','结束时间','状态','备注','操作'],
				   	colModel:[	 
						{name:'PK_NO',index:'ID',hidden:true,key:true},
				   		{name:'MAS_NO',width:100},
				   		{name:'REF_NO',width:120},
				   		{name:'MAS_CODE',width:80,formatter:function(data){
							if(data=='WEBPROMA'){return '单款打折';}
							else if(data=='WEBPROMB'){return '买赠';}
							else{return data;}
			 
							}},
				   		{name:'BEGIN_DATE',formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
				   		{name:'END_DATE', formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
				   		{name:'STATUS_FLG',width:60, formatter:function(data){
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
				   		{name:'SP_NOTE'},
				   		{name:'',formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","P","启用")>启用</button>&nbsp;'+'<button type=button class="btn btn-info edit"  onclick=editStatusFlg("'+index.PK_NO+'","C","取消")>取消</button> <button type="button"  class="btn btn-info edit"    onclick=editPromItem("'+index.PK_NO+'","'+index.STATUS_FLG+'")>编辑商品</button>';
									}
									if(index.STATUS_FLG=='P'){
										return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>';
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
			//onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>
			function editStatusFlg(pkNo,statusFlg,message){
				//alert(pkNo);
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
					
							 $.ajax({
								 url:'${base}/prom/editStatus.jhtml',
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
									top.$.jBox.tip('修改失败！请先添加商品...', 'error');
									}
									else if(data.code==004){
										top.$.jBox.tip('修改失败！未添加赠品', 'error');
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
			<div class="currentDataDiv_tit">
             	<button type="button" class="btn_divBtn add"  id='prom_add' data-toggle="jBox-win"  href="${base}/prom/addPromUI.jhtml">添加</button>
             	<button type="button" class="btn_divBtn edit" id='prom_edit' data-toggle="jBox-edit"  href="${base}/prom/editPromUI.jhtml">编辑</button>
                <button type="button" class="btn_divBtn del"  id='prom_del' data-toggle="jBox-remove-prom" href="${base}/prom/delete.jhtml">删除</button>
				<button type="button" class="btn_divBtn add"  id='prom_item_list' onclick="itemListUI()" >正在促销商品</button>
			
			</div>
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">单据号码</label>
		                    <input type="text" class="form-control" name="masNo" id="masNo" style="width:120px;" >
		                	<input style="vertical-align: middle;margin-right:5px;" class="radi_input" name="statusFlg" type="radio" value="AP" checked="checked"/><span class="radi_span">启用</span> 
							<input style="vertical-align: middle;margin-right:5px;" name="statusFlg" type="radio" value="C" /><span class="radi_span">取消</span> 
		                </div>
		          		<div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id='prom_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
			                </div>
		                </div>
		            </form>
	        	</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/editPromItemUI.jhtml" method="post" id="editPromForm">
   		<input type="hidden" name="id" id="promId" value="">
   		
   		</form>
   			<form action="${base}/prom/itemListUI.jhtml" method="post" id="itemListForm">
   		</form>
    </body>
</html>
<script  >
function editPromItem(pkNo,statusFlg){
		if(statusFlg=='取消'){
			top.$.jBox.tip('该活动已取消！');
			return;
		}else{
		$.ajax({
			url : "${base}/prom/findPromStatFlag.jhtml",
			type :'post',
			dataType : 'json',
			data : 'pkNo=' + pkNo,
			success : function(data, status, jqXHR) { 
				if(data.code==001){
					$("#promId").val(pkNo);
					$("#editPromForm").submit();
					}else if(data.code==002){
					top.$.jBox.tip('该活动正在进行中或已经结束...', 'error');
					}
			}
		});
		}
		

	}

function  itemListUI(){
	$("#itemListForm").submit();
	
}
</script> 



