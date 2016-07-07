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
					rownumWidth:10,
					multiselect:false,
					url:'${base}/inOutBalanceOfAcc/citicVirtualAccountDetails.jhtml?custId=${cust}',
 					colNames:['','交易日期','类型','交易号','方向','交易金额','总金额','可提现金额','不可提现金额','可提现冻结金额','不可提现冻结金额'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'WORKDATE',width:30},
				   		{name:'CHANGE_TYPE',width:30,formatter:function(data){
							if(data == null){
								return '';
							}
							if(data=='01'){
								return '充值';
							}
					   		if(data=='02'){
								return '支付';
							}
					   		if(data=='03'){
								return '提现';
							}
					   		if(data=='04'){
								return '内部转账';
							}
					   		if(data=='05'){
								return '结息';
							}
					   		if(data=='06'){
								return '利息税';
							}
					   		if(data=='07'){
								return '原交易退款';
							}
					   		if(data=='08'){
								return '原交易撤销';
							}
					   		if(data=='09'){
								return '内部结算';
							}
							 else{
								return data;
							}
	   		            }},
				   		{name:'REFSN', width:40},
				   		{name:'SEQFLAG', width:16,formatter:function(data){
				   			
				   			if(data=='0'){
								return '收入';
							}
					   		if(data=='1'){
								return '支出';
							}
							 else{
								return data;
							}
						 
							}},
						{name:'TRANS_AMT', width:50},
				   		{name:'AMOUNT', width:50},
				   		{name:'CASH_AMOUNT', width:50},
				   		{name:'UNCASH_AMOUNT', width:30},
				   		{name:'FREEZE_CASH_AMOUNT',width:30},
				   		{name:'FREEZE_UNCASH_AMOUNT',width:30}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
				

				$("#virtualaccountdetails_search").click(function(){
					var changeTypes = '';
	                $("input[name='changeTypes']:checked").each(function(){
	                	changeTypes+=$(this).val()+",";
	                })
					var json = $("#query-form").serializeObjectForm();
					json['changeTypes'] = changeTypes;
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:json, //发送数据  
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
				 <div   style="border-bottom:1px solid #f39801;padding-top:10px;padding-left:10px;padding-bottom:10px;position:relative;">
					 <form class="form form-inline queryForm" id="query-form" method="post" action="${base}/inOutBalanceOfAcc/citicAccountDetailList.jhtml"> 
		                <div class="form-group">
							<label class="control-label" style="vertical-align: middle;">资金流向:</label>
							<select class="form-control required" id="seqflag" name="seqFlag">
								<option value="">请选择</option>
							    <option value="0">收入</option>
							    <option value="1">支出   </option>
						    </select>
						</div>
					    <div class="form-group">
							<label class="control-label" style="vertical-align: middle;">交易类型:</label>
	<!-- 						changeType;       //类型 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销 -->
							<input class="form-control required"  type="checkbox" id="changeType01" name="changeTypes" value="01">
							<label class="control-label" for="changeType01" style="width: 30px;vertical-align: middle;">充值</label>
							
							<input class="form-control required"  type="checkbox" id="changeType02" name="changeTypes" value="02">
							<label class="control-label" for="changeType02" style="width: 30px;vertical-align: middle;">支付</label>
							
							<input class="form-control required"  type="checkbox" id="changeType03" name="changeTypes" value="03">
							<label class="control-label" for="changeType03" style="width: 30px;vertical-align: middle;">提现</label>
							
							<input class="form-control required"  type="checkbox" id="changeType04" name="changeTypes" value="04">
							<label class="control-label" for="changeType04" style="width: 60px;vertical-align: middle;">内部调账</label>
							
							<input class="form-control required"  type="checkbox" id="changeType05" name="changeTypes" value="05">
							<label class="control-label" for="changeType05" style="width: 30px;vertical-align: middle;">结息</label>
							
							<input class="form-control required"  type="checkbox" id="changeType06" name="changeTypes" value="06">
							<label class="control-label" for="changeType06" style="width: 50px;vertical-align: middle;">利息税</label>
							
							<input class="form-control required"  type="checkbox" id="changeType07" name="changeTypes" value="07">
							<label class="control-label" for="changeType07" style="width: 70px;vertical-align: middle;">原交易退款</label>
							
							<input class="form-control required"  type="checkbox" id="changeType08" name="changeTypes" value="08">
							<label class="control-label" for="changeType08" style="width: 70px;vertical-align: middle;">原交易撤销</label>
							<input class="form-control required"  type="checkbox" id="changeType09" name="changeTypes" value="09">
							<label class="control-label" for="changeType09" style="width: 70px;vertical-align: middle;">内部结算</label>
						</div>
		                <div class="search_cBox">
							<button type="button" class="search_cBox_btn" id="virtualaccountdetails_search"  >搜 索 </button>
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