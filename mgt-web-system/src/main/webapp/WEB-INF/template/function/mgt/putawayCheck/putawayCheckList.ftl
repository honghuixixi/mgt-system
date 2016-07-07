<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品上架审核</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/PutawayCheck/pclist.jhtml',
 					colNames:['','名称','商品主键','系统商品类别','自定义商品类别','原图地址','大图地址','操作'],
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'NAME',align:"center",width:90},
				   		{name:'STK_C',align:"center",width:90},
				   		{name:'CAT_NAME',align:"center",width:90},
				   		{name:'CAT_C',align:"center",width:90},
				   		{name:'SOURCE_PATH',align:"center",width:90},
				   		{name:'LARGE_PATH',align:"center",width:90},
				   		{name:'detail',index:'UUID',width:160,align:'center',sortable:false} 
				   		],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/PutawayCheck/putawayCheckUI.jhtml'>详情 </button><button type='button' class='btn btn-info edit' onClick=editStatus('"+id+"','Y') >审核通过</button></button><button type='button' class='btn btn-info edit' onClick=editStatus('"+id+"','N') >审核失败 </button>";
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
	<SCRIPT type="text/javascript">
	    function editStatus(id,status){
	   			$.jBox.confirm("确认修改吗?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : '${base}/PutawayCheck/updateCheckStatus.jhtml',
						type :'post',
						dataType : 'json',
						data : 'id=' + id+'&status='+status,
						success : function(data) {
					if(data.code==001){		
						top.$.jBox.tip('保存成功！', 'success');
						top.$.jBox.refresh = true;
						$('#grid-table').trigger("reloadGrid");
						}
						else{
						top.$.jBox.tip('保存失败！平台商品库维护未审核通过', 'error');
								return false;
						}
					}
					});
				}
			});
	   
	   }
	</SCRIPT>
    </head>
    <body>
		<div class="body-container">
			<div class="main_heightBox1"></div>
			<table id="grid-table" ></table>
			<div id="grid-pager"></div>
		</div>
    </body>
</html>