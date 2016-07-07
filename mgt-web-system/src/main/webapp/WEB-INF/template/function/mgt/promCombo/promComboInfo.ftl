<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>运维管理-套装定义</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/Combolist.jhtml',
 					colNames:['','','商品编码','商品名称','规格','单位','套装名称','排序','套装原价','套装价格','开始日期','结束日期','操作'],
				   	colModel:[	 
						{name:'PK_NO',index:'ID',hidden:true,key:true},
						{name:'STATUS_FLG',hidden:true},
				   		{name:'STK_C',width:60},
				   		{name:'NAME',width:180},
				   		{name:'MODLE',width:40},
				   		{name:'UOM',width:30},
				   		{name:'REF_NO',width:120},
				   		{name:'SORT_NO',width:30},
				   		{name:'KIT_LIST_PRICE',width:60,align:"center",editable:true,formatter:function(data,row,rowObject){
					   			return (parseFloat(rowObject.KIT_LIST_PRICE)).toFixed(2);
				   		}},	
				   		{name:'KIT_PRICE',width:60,align:"center",editable:true,formatter:function(data,row,rowObject){
								return (parseFloat(rowObject.KIT_PRICE)).toFixed(2);
				   		}},						   					   		
				   		{name:'BEGIN_DATE',width:125,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'END_DATE', width:125,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'',formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","P","启用")>启用</button>&nbsp;'+'<button type=button class="btn btn-info edit"  onclick=editStatusFlg("'+index.PK_NO+'","C","取消")>取消</button> <button type="button"  class="btn btn-info edit"    onclick=editPromItem("'+index.PK_NO+'","'+index.STK_C+'","'+index.STATUS_FLG+'")>套装定义</button>';
									}
									if(index.STATUS_FLG=='P'){
										return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>';
									}
									else{
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
			});
			
			//撤销
			function editStatusFlg(pkNo,statusFlg,message){
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
									}else if(data.code==002){
										top.$.jBox.tip('修改失败！该活动正在进行中或已解释...', 'error');
									}else if(data.code==003){
										top.$.jBox.tip('修改失败！请先添加商品...', 'error');
									}else if(data.code==004){
										top.$.jBox.tip('修改失败！未添加赠品', 'error');
									}else{
										top.$.jBox.tip('保存失败！', 'error');
							 			return false;
									}
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
            <!-- 面包屑导航 -->
			<div id="currentDataDiv" action="resource">
			<div class="currentDataDiv_tit">
             	<button type="button" class="btn_divBtn add"  id='promCombo_add' data-toggle="jBox-win"  href="${base}/prom/addPromComboUI.jhtml">新增</button>
             	<button type="button" class="btn_divBtn edit" id='promCombo_edit' data-toggle="jBox-edit-promCombo"  href="${base}/prom/editPromComboUI.jhtml">修改</button>
                <button type="button" class="btn_divBtn del"  id='promCombo_del' data-toggle="jBox-remove-prom" href="${base}/prom/delete.jhtml">删除</button>
			
			</div>
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">关键词：</label>
		                    <input type="text" class="form-control" name="keyWord" id="keyWord" placeholder="请输入商品的条码、编码、名称" style="width:190px;" >
		                	<input style="vertical-align: middle;margin-right:5px;" class="radi_input" name="statusFlg" type="radio" value="AP" checked="checked"/><span class="radi_span">有效的</span> 
							<input style="vertical-align: middle;margin-right:5px;" name="statusFlg" type="radio" value="C" /><span class="radi_span">无效的</span> 
		                </div>
		          		<div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id='promCombo_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
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
   			<input type="hidden" name="stkC" id="stkC" value="">
   		</form>
    </body>
</html>
<script  >
function editPromItem(pkNo,stkC,statusFlg){
		if(statusFlg=='C'){
			top.$.jBox.tip('该活动已取消！');
			return;
		}else{
		$.ajax({
			url : "${base}/prom/findPromStatFlag.jhtml",
			type :'post',
			dataType : 'json',
			data : {
					'pkNo' : pkNo,
					'stkC' : stkC,
			},
			success : function(data, status, jqXHR) { 
				if(data.code==001){
					$("#promId").val(pkNo);
					$("#stkC").val(stkC);
					$("#editPromForm").submit();
				}else if(data.code==002){
					top.$.jBox.tip('该活动正在进行中或已经结束...', 'error');
				}
			}
		});
		}
		

	}
</script> 



