<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/padAdStk/list.jhtml',
 					colNames:['','商品编号','原价','折扣','净价','二维码url','上架时间','排序依据','操作'],
 					width:999,
				   	colModel:[
				   		{name:'STK_C',index:'STK_C',width:0,hidden:true,key:true},
				   		{name:'STK_C',align:"center",width:100},
				   		{name:'LIST_PRICE',align:"center",width:80},
				   		{name:'DISC_NUM',width:80,align:"center",editable:true},
				   		{name:'NET_PRICE',width:80,align:"center", editable:true, formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   		{name:'QR_CODE_URL',align:"center",width:270},
				   		{name:'PM_CREATE_DATE',width:180,align:"center", editable:true},
				   		{name:'SORT_NO',align:"center",width:70},
				   		{name:'detail',index:'STK_C',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							console.log(ids[i]);
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/padAdStk/padAdStkDetailUI.jhtml'>查看 </button>";
							//detail ="<a href='#' style='color:#f60' data-toggle='jBox-show' onclick='showDetail("+ id +")' >详情</a>"; 
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
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

			function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" action="${base}/padAdStk/list.jhtml" style="width:1000px" id="query-form"> 
	                <div class="form-group">
	                    <label class="control-label">商品编号</label>
	                    <input type="text" class="form-control" name="stkC" style="width:120px;">
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="padAdStk_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                 	<button type="button" class="btn btn-info add" id="padAdStk_add"  data-toggle="jBox-win" href="${base}/padAdStk/addPadAdStkUI.jhtml">添加 </button>
		                <button type="button" class="btn btn-info edit" id="padAdStk_edit" data-toggle="jBox-edit" href="${base}/padAdStk/editPadAdStkUI.jhtml">编辑 </button>
		                <button type="button" class="btn btn-info del" id="padAdStk_del" data-toggle="jBox-remove" href="${base}/padAdStk/delete.jhtml">删除 </button>
	                </div>
	            </form>
	        </div> 
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>