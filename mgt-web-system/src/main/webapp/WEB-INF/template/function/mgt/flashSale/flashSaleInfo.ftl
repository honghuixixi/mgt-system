<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>营销管理-限时抢购(供应商)</title>
		[#include "/common/commonHead.ftl" /]
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/findFlashSaleList.jhtml',
 					colNames:['','开始时间','结束时间','每日时间段','活动主题','活动规则','平台补贴规则','操作'],
				   	colModel:[	 
						{name:'PK_NO',index:'PK_NO',hidden:true,key:true},
				   		{name:'BEGIN_DATE',width:80,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'END_DATE', width:80,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
						{name:'TIME_FROM',width:60},
						{name:'REF_NO',width:100},
						{name:'', width:110,align:"center",formatter:function(value,row,rowObject){
							if(rowObject.PAY_ONLINE_FLG=='Y'){
								return '订单金额不小于'+rowObject.MIN_AMT_NEED+',且必须在线支付';
							}else{
								return '订单金额不小于'+rowObject.MIN_AMT_NEED;
							}
						  }
						},
						{name:'ALLOWANCE_TYPE', width:80,align:"center",formatter:function(data){
							if(data=='V'){
								return '差额补贴';
							}else if(data=='R'){
								return '百分比补贴';
							}else{
							    return '无补贴';
							}}
						},					   					   		
				   		{name:'detail',index:'PK_NO',width:60,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail = '<button type="button"  class="btn btn-info edit"    onclick=join("'+rowData.PK_NO+'")>参与</button>';
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				   	
				});
				
			});
		</script>
    </head>
    <body>
       <div class="body-container">
		  <div class="main_heightBox1">
            <!-- 面包屑导航 -->
			<div id="currentDataDiv" action="resource">
			<div class="currentDataDiv_tit">
             	<!--<button type="button" class="btn_divBtn add"  id='promCombo_add' data-toggle="jBox-win"  href="${base}/prom/addPromComboUI.jhtml">新增</button>
             	<button type="button" class="btn_divBtn edit" id='promCombo_edit' data-toggle="jBox-edit-promCombo"  href="${base}/prom/editPromComboUI.jhtml">修改</button>
                <button type="button" class="btn_divBtn del"  id='promCombo_del' data-toggle="jBox-remove-prom" href="${base}/prom/delete.jhtml">删除</button>-->
			
			</div>
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <!--<label class="control-label">关键词：</label>
		                    <input type="text" class="form-control" name="keyWord" id="keyWord" placeholder="请输入商品的条码、编码、名称" style="width:190px;" >
		                	<input style="vertical-align: middle;margin-right:5px;" class="radi_input" name="statusFlg" type="radio" value="AP" checked="checked"/><span class="radi_span">有效的</span> 
							<input style="vertical-align: middle;margin-right:5px;" name="statusFlg" type="radio" value="C" /><span class="radi_span">无效的</span>-->
		                </div>
		          		<div class="search_cBox">
			                <div class="form-group">
			                 	<!--<button type="button" class="search_cBox_btn" id='promCombo_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>-->
			                </div>
		                </div>
		            </form>
	        	</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/joinFlashSaleItemUI.jhtml" method="post" id="joinPromForm">
   			<input type="hidden" name="id" id="promId" value="">
   		</form>
    </body>
</html>
<script  >
//判断该活动是否可以参加
function join(pkNo){
	$("#promId").val(pkNo);
	$("#joinPromForm").submit();
	}
</script> 