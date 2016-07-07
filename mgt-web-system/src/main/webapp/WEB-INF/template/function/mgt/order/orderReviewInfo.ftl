<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品评价审核</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/orderReviewlist.jhtml',
 					colNames:['','','评论时间','评论用户','商品名称','商品价格','商品供应商','评论内容','评分','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'STATUS_FLG',index:'STATUS_FLG',width:0,hidden:true},
				   		{name:'CREATE_DATE',align:"center",width:180,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                        },
				   		{name:'NAME',align:"center",width:160},
				   		{name:'NAMES',align:"center",width:220},
				   		{name:'NET_PRICE',align:"center",width:90},
				   		{name:'VENDOR_NAME',align:"center",width:180},
				   		{name:'CONTENT',align:"center",width:330},
				   		{name:'SCORE',align:"center",width:50},
				   		{name:'detail',index:'PK_NO',width:130,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.STATUS_FLG!='Y'){
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"'  onClick=editStatus('"+id+"','Y')>通过</button>";
							}else{
							detail ="审核已通过";
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
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
		<div class="body-container">
			<div class="main_heightBox1"></div>
			<table id="grid-table" ></table>
			<div id="grid-pager"></div>
		</div>
    </body>
    
<script type="text/javascript">
function editStatus(id,status){
	var msgtip="";
	if(status=='Z'){
		msgtip="确定删除吗";
	}
	else if(status=='Y'){
		msgtip="确定通过审核吗？";
	}
	$.jBox.confirm(msgtip, "提示", function(v){
	if(v == 'ok'){
		$.ajax({
			url : '${base}/order/updateStatus.jhtml',
			type :'post',
			dataType : 'json',
			data : 'id=' + id+'&status='+status,
			success : function(data) {
		if(data.code==001){		
			top.$.jBox.tip('操作成功！', 'success');
			top.$.jBox.refresh = true;
			$('#grid-table').trigger("reloadGrid");
			}
			else{
			top.$.jBox.tip(data.msg, 'error');
					return false;
			}
		}
		});
	}
});
}
</script>
</html>