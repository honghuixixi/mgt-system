<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-平台账户管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/subaccount/list.jhtml',
 					colNames:['','客户编号','账户类型','附属帐户属性','客户名称','账户性质','状态','创建时间','操作'],
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
				   		{name:'ATTACHED_ACCOUNTTYPE', width:40,formatter:function(data){
							if(data=='A'){
								return '清算户';
							}
							if(data=='B'){
								return '利息结算户';
							}
							if(data=='C'){
								return '调帐帐户';
							}
							if(data=='D'){
								return '初始化帐户';
							}
							if(data=='N'){
								return '一般帐户';
							}
							 else{
								return data;
							}
	   		            }},
				   		{name:'CUST_NAME', width:46},
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
				   		{name:'CREATE_TIME',width:40,align:"center",editable:true,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
								{name:'',width:100,align:"center",editable:true,formatter:function(value,row,index){
					 	var str ='<button type="button" class="btn btn-info edit"   onClick=findBankCardDetails("'+index.ID+'") >查看银行卡 </button>'; 
					 	if(index.ECITICACCOUNTNUM==0){
					 	str +='<button type="button" class="btn btn-info edit"   onClick=addEciticAccount("'+index.ID+'","'+index.CUST_ID+'") >添加附属账户 </button>';
					 	}
					 	if(index.STATE=='00'){
					 	str +='<button type="button" class="btn btn-info edit"   onClick=changeStatus("'+index.ID+'","01") >冻结</button><button type="button" class="btn btn-info edit"   onClick=changeStatus("'+index.ID+'","02") >注销</button>';
					 	}
					 	else if(index.STATE=='01'){
					 	str +='<button type="button" class="btn btn-info edit"   onClick=changeStatus("'+index.ID+'","00") >解冻</button><button type="button" class="btn btn-info edit"   onClick=changeStatus("'+index.ID+'","02") >注销</button>';
					 	}
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
				<div class="form_divBox" style="display:block;">
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
		        </div>
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
	$.ajax({
		url : "${base}/subaccount/addEciticIsExist.jhtml",
		type :'post',
		data:{'custId':custId},
		dataType : 'text',
		success : function(data) {
			var number = data;
			if(number=='1'){
				mgt_util.showjBox({
					width : 960,
					height : 500,
					title : '添加附属账号',
					url : '${base}/subaccount/addEciticAccountUI.jhtml?custId='+custId,
					grid : $('#grid-table')
				});
			}else{
				alert("用户所在的企业尚未开通附属账户!");
			}
		}
	}); 
}
function findBankCardDetails(obj){
	mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '银行卡信息',
							url : '${base}/subaccount/bankCardDetails.jhtml?deleteFlag=0&id='+obj,
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