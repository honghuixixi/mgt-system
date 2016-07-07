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
					multiselect:false,
					url:'${base}/inOutBalanceOfAcc/inOutList.jhtml',
 					colNames:['','客户编号','客户名称','总金额','可提现金额','不可提现金额','可提现冻结金额','不可提现冻结金额','操作'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'CUST_ID',width:42},
				   		{name:'CUST_NAME',width:100},
				   		{name:'AMOUNT', width:50},
				   		{name:'CASH_AMOUNT', width:50},
				   		{name:'UNCASH_AMOUNT', width:50},
				   		{name:'FREEZE_CASH_AMOUNT',width:50},
				   		{name:'FREEZE_UNCASH_AMOUNT',width:50},
						{name:'',width:50,align:"center",editable:true,formatter:function(value,row,index){
					 		var str ='<button type="button" class="btn btn-info edit"   onClick=findBankCardDetails("'+index.CUST_ID+'") >交易明细</button>';
					   		return str;
					   	}}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
				

				$("#query-form #virtualaccountlist_search").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#query-form").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       	 <div class="main_heightBox1">
       	 	<div id="currentDataDiv" action="menu" >
				<div class="control-group sub_status">
					<ul class="nav nav-pills" role="tablist">
						<li role="presentation" id="inOutBalanceOfAccount" class="sub_status_but active"><a>虚拟账户</a></li>
						<li role="presentation" id="citicAccountGeneral" class="sub_status_but"><a>中信账户概况</a></li>
						<li role="presentation" id="citicAccountDetails" class="sub_status_but"><a>中信账户明细</a></li>
					</ul>
				 </div>
	        </div>
			<div id="currentDataDiv" action="resource" style="margin-top:20px;padding-bottom:10px;">
				 <div style="border-bottom:1px solid #f39801;position:relative;">
				   <span class="open_btn"  style="top:-10px;"></span>
				 </div>	
	            
	            <div class="form_divBox" >
		            <form class="form form-inline queryForm" id="query-form" method="post" action="${base}/inOutBalanceOfAcc/inOutList.jhtml"> 
		            	<div class="form-group">
		                    <label class="control-label">客户编号</label>
		                    <input type="text" class="form-control" placeholder="请输入客户编号" name="custId" id="custId" style="width:120px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">客户名称</label>
		                    <input type="text" class="form-control" name="custName" placeholder="请输入客户名称(支持模糊查询)" id="custName" style="width:160px;" >
		                </div>
					    <div class="form-group">
	<!-- 						changeType;       //类型 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销 -->
							<input class="form-control required"  type="checkbox" id="changeType01" name="changeTypes" value="01">
							<label class="control-label" for="changeType01" style="width: 130px;">仅显示总金额>0的账户</label>
							
							<input class="form-control required"  type="checkbox" disabled="true" id="changeType02" name="changeTypes" value="02">
							<label class="control-label" for="changeType02" style="width: 120px;">仅显示未还款的账户</label>
							
							<input class="form-control required"  type="checkbox" disabled="true" id="changeType03" name="changeTypes" value="03">
							<label class="control-label" for="changeType03" style="width: 150px;">仅显示信用额度>0的账户</label>
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" id="virtualaccountlist_search"  >搜 索 </button>
						</div>
					</form>
				</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
  		<form action="" method="post" id="tabFrom"></form>
    </body>
</html>
<script>
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	console.log($(this).attr("id"));
	    	$("#tabFrom").attr('action','${base}/inOutBalanceOfAcc/'+$(this).attr("id")+'.jhtml');
	    	$("#tabFrom").submit();
	    });
	});
	
	function findBankCardDetails(custId){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '交易明细',
							url : '${base}/inOutBalanceOfAcc/citicVirtualAccountDetail.jhtml?custId='+custId,
							grid : $('#grid-table')
						});
	}
</script>