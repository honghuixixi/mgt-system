<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-客户分类维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
			
				$('#defFlgEdit').click(function(){
					var ids = $('#grid-table').jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请选择一条记录！');
						return;
					} else if (ids.length > 1) {
						top.$.jBox.tip('选择记录不能超过一条！');
						return;
					}
					$.jBox.confirm("确认要处理该数据?", "提示", function(v){
						if(v == 'ok'){
							var rowData = $('#grid-table').jqGrid('getRowData',ids[0]);
							$.ajax({
								url : '${base}/vendorCust/updateDefFlg.jhtml',
								type :'post',
								dataType : 'json',
								data : 'catC=' + rowData.CAT_C,
								success : function(data) {
									top.$.jBox.tip('处理成功！','success');
									mgt_util.refreshGrid($('#grid-table'));
								}
							});
						}
					});
				});
			
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendorCust/listCat.jhtml',
 					colNames:['','代码','名称','折扣','是否默认','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CAT_C',align:"center",width:100},
				   		{name:'CAT_NAME',align:"center",width:180},
				   		{name:'DISC_NUM',align:"center",width:180,
				   		formatter : function(rowObject){
				   			return 100-rowObject
				   		}
				   		},
				   		{name:'DEF_FLG',align:"center",width:180,
				   		formatter : function(rowObject){
				   			if(rowObject == 'Y'){
				   				return '是';
				   			}else{
				   				return '否';
				   			}
				   		}
				   		},
				   		{name:'detail',index:'PK_NO',width:180,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							
							detail ="<button type='button' class='btn btn-info edit' id='"+rowData.CAT_C+"' data-toggle='jBox-show'  href='${base}/vendorCust/addVendorCatUI.jhtml'>修改</button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CAT_C+"' data-toggle='jBox-remove' href='${base}/vendorCust/vendorCatdelete.jhtml?catC="+rowData.CAT_C+"'>删除</button>";
							if(rowData.DEF_FLG != '是'){
								detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CAT_C+"' data-toggle='jBox-show'  href='${base}/vendorCust/editCategoryDisUI.jhtml'>类别折扣</button>";
							}
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
			<div id="currentDataDiv" action="menu" >
				<div class="btn_diva_box"></div>
				<div class="currentDataDiv_tit">
					<button type="button" class="btn btn-info btn_divBtn"  data-toggle="jBox-win"  href="${base}/vendorCust/addVendorCatUI.jhtml?id=">新 增 </button>
					<button type="button" class="btn btn-info btn_divBtn" id="defFlgEdit"  href="${base}/vendorCust/addVendorCatUI.jhtml?id=">设为默认 </button>
				</div>
	        </div>
	      </div> 
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
</html>