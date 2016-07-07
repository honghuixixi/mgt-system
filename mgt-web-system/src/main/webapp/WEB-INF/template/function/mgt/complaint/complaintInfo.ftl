<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户投诉服务平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/complaint/list.jhtml',
 					colNames:['','商品编号','商品竞价','投诉建议','提交时间','状态', '操作'],
 					width:999,
				   	colModel:[
				   	{name:'PK_NO', index:'PK_NO', hidden:true, key:true},
				   	{name:'STK_C'},
				   	{name:'PUR_PRICE', formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   	{name:'CONTENT'},
				   	{name:'PC_CREATE_DATE'},
				   	{name:'CLOSE_FLG', formatter:function(data){
				   		if('N' == data) {
				   			return '待处理';
				   		} else if('Y' == data) {
				   			return '已处理';
				   		}
				   	}},
				   	{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	prmNames: {stkC: 'STK_C'},
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='800' jBox-height='400' href='${base}/complaint/complaintDetailUI.jhtml'>查看</button>";
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
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	                <div class="form-group">
	                    <label class="control-label">商品编号</label>
	                    <input type="text" class="form-control" name="stkC" style="width:120px;">
	                </div>
	                <div class="form-group">
	                    <label class="control-label">投诉状态</label>
	                    <select class="form-control" name="closeFlg">
	                        <option value="">全部</option>
	                        <option value="N">待处理</option>
	                        <option value='Y'>已处理</option>
	                    </select>
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="order_search" data-toggle="jBox-query" href="${base}/complaint/list.jhtml"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>