<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>MGT-平台账户管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/subaccount/AAMList.jhtml',
 					colNames:['','用户编码','账户类型','账户号','账户名称','账户性质','状态','操作'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'CUST_ID',width:42},
				   		{name:'SUBACCOUNT_TYPE',width:32,formatter:function(data){
							if(data=='9001'){
								return '平台余额账户';
							}
							if(data=='8001'){
								return '中信附属账户';
							}else{
								return data;
							}
	   		            }},
				   		{name:'ATTACHED_ACCOUNT', width:65},
				   		{name:'CUST_NAME', width:75},
				   		{name:'PROPERTY', width:30,formatter:function(data){
							if(data==1){
								return '个人';
							}
							if(data==2){
								return '企业';
							}else{
								return data;
							}
	   		            }},
				   		{name:'STATE',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='00'){
								return '生效';
							}
						 	if(data=='01'){
								return '冻结';
							}
								if(data=='02'){
								return '注销';
							}
							else{
								return data;
							}
	   		            }},
						{name:'',width:90,align:"center",editable:true,formatter:function(value,row,index){
							 	var str ='<button type="button" class="btn btn-info edit"   onClick=findBankCardDetails("'+index.CUST_ID+'","'+index.SUBACCOUNT_TYPE+'") >银行卡信息 </button>'; 
							 		str +='<button type="button" class="btn btn-info edit"   style="color:#C2C2C2">申请变更</button>';
							 		str +='<button type="button" class="btn btn-info edit"   onClick=queryAmout("'+index.CUST_ID+'") >余额查询</button>';
					   			return str;
					   	}}
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
			<div id="currentDataDiv" action="resource">
				<!-- <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">客户编号</label>
		                    <input type="text" class="form-control" name="custId" id="custId" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">客户名称</label>
		                    <input type="text" class="form-control" name="custName" id="custName" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">账户类型</label>
		                    <select class="form-control" name="subaccountType">
		                        <option value="">全部</option>
		                        <option value="9001">平台余额账户</option>
		                        <option value='8001'>中信附属账户</option>
		                    </select>
		                </div>
		            </form>
		        </div> -->
		        <div class="search_cBox">
			        <div class="form-group">
	                 	<button type="button" class="search_cBox_btn btn btn-info" id='subaccount_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	                </div>
                </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
<script>
function addEciticAccount(obj,custId){
	mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '添加附属账号',
							url : '${base}/subaccount/addEciticAccountUI.jhtml?id='+obj+'&custId='+custId,
							grid : $('#grid-table')
						});
}
function queryAmout(custId){
	mgt_util.showjBox({
			width : 960,
			height : 500,
			title : '附属账户余额查询',
			url : '${base}/subaccount/queryAmout.jhtml?custId='+custId,
			grid : $('#grid-table')
		});
}
function findBankCardDetails(custId,subaccountType){
	mgt_util.showjBox({
		width : 960,
		height : 500,
		title : '银行卡信息',
		url : '${base}/subaccount/queryBankCardDetail.jhtml?custId='+custId+'&subaccountType='+subaccountType,
		grid : $('#grid-table')
	});
}
function changeStatus(obj,status){
$.jBox.confirm("确认更改账户状态?", "提示", function(v){
if(v == 'ok'){
	$.ajax({
	   type: "POST",		   
	   url:  '${base}/subaccount/changeStatus.jhtml',
	   data: {id:obj,state:status},
	   success: function(response){
	     var obj = jQuery.parseJSON(response)
	     top.$.jBox.tip('设置成功！','success');
		 mgt_util.refreshGrid("#grid-table");
		}
	});
	}});
}
</script>