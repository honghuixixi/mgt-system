<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-菜单信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/menu/list.jhtml',
 					colNames:['','名称','菜单地址','状态','排序'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'NAME',width:100},
				   		{name:'URL',width:150},
				   		{name:'VISIBLE',width:80,align:"center",editable:true,formatter:function(data){
							if(data==1){
								return '启用';
							}
							if(data==0){
								return '禁用';
							}else{
								return data;
							}
	   		            }},
				   		{name:'SORTBY',width:100}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
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
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
					<div class="form-group">
		                 	<button type="button" class="btn_divBtn add" id="menu_add"  data-toggle="jBox-win" href="${base}/menu/addMenuUI.jhtml">添加 </button>
			                <button type="button" class="btn_divBtn edit" id="menu_edit" data-toggle="jBox-edit" href="${base}/menu/editMenuUI.jhtml">编辑 </button>
			                <button type="button" class="btn_divBtn del" id="menu_del" data-toggle="jBox-remove" href="${base}/menu/delete.jhtml">删除 </button>
							<button type="button" class="btn_divBtn btn btn-info del" id='' data-toggle="jBox-win" href="${base}/payorder/agentPaymentByDlsubtrn.jhtml">强制转账 </button>
	    		        	<button type="button" class="btn_divBtn btn btn-info del" id='' data-toggle="jBox-win" href="${base}/payorder/importEciticSubAccDeal.jhtml">交易数据导入 </button>
							<button type="button" class="btn_divBtn btn btn-info add" id='' data-toggle="jBox-win" href="${base}/payorder/paymentByDltrsfin.jhtml">调账入款 </button>
							<button type="button" class="btn_divBtn btn btn-info del" id='' data-toggle="jBox-win" href="${base}/payorder/agentPayment.jhtml">代理支付 </button>
							<button type="button" class="btn_divBtn btn btn-info add" id='' data-toggle="jBox-win" href="${base}/payorder/paymentResults.jhtml">交易结果返回 </button>
		             </div>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">名称</label>
		                    <input type="text" class="form-control" name="name" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">状态</label>
		                    <select class="form-control" name="visible">
		                        <option value="">全部</option>
		                        <option value="1">启用</option>
		                        <option value='0'>禁用</option>
		                    </select>
		                </div>
		            </form>
		         </div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="menu_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	             	</div>
	         	</div>
	        </div>
	     </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>