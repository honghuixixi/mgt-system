<!DOCTYPE html>
<html>
    <head>
        <title>备货管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/subaccount/list.jhtml?custId=${custId}&custIds=${custIds}',
 					colNames:['','客户编号','账户类型','附属帐户属性','客户名称','账户性质','状态','创建时间','操作'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'CUST_ID',width:30},
				   		{name:'SUBACCOUNT_TYPE',width:30,formatter:function(data){
							if(data=='9001'){
								return '平台余额账户';
							}
							if(data=='8001'){
								return '中信附属账户';
							}else{
								return data;
							}
	   		            }},
				   		{name:'ATTACHED_ACCOUNTTYPE', width:30,formatter:function(data){
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
				   		{name:'CUST_NAME', width:30},
				   		{name:'PROPERTY', width:20,formatter:function(data){
							if(data==1){
								return '个人';
							}
							if(data==2){
								return '企业';
							}else{
								return data;
							}
	   		            }},
				   		{name:'STATE',width:20,align:"center",editable:true,formatter:function(data){
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
				   		{name:'CREATE_TIME',width:30,align:"center",editable:true,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
								}},
						{name:'',width:70,align:"center",editable:true,formatter:function(data,row,rowObject){
							var str ='<button type="button" class="btn btn-info edit" onClick=findBankCardDetails("'+rowObject.ID+'") >查看银行卡 </button>';
									if(rowObject.STATE == '00' && (rowObject.SUBACCOUNT_TYPE == '9001'|| rowObject.SUBACCOUNT_TYPE =='8001')){
										   str +=  '<button type="button" class="btn btn-info edit" onClick=bindBankCard("'+rowObject.ID+'")>绑定银行卡</button><button type="button"  class="btn btn-info edit"  onClick=takeCash("'+rowObject.ID+'")>提现</button>';
									}
									str +='<button type="button" class="btn btn-info edit"   onClick=findSubaccountDetails("'+rowObject.ID+'") >查看 </button>';
									return str;
									}
								
						}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
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
	            <form class="form form-inline queryForm" style=" overflow:hidden; id="query-form"> 
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="subaccountlist" class="sub_status_but active"><a>我的账户</a></li>
							<li role="presentation" id="paybilllist" class="sub_status_but"><a>交易记录</a></li>
							<li role="presentation" id="subaccountseqInfo" class="sub_status_but"><a>收支明细</a></li>
						</ul>
					 </div>
					 <div class="currentDataDiv_tit">
					  <div class="form-group">
					 </div>	</div>
	            </form>
	         
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
   		<form action="" method="post" id="tabFrom"></form>
    </body>
    
</html>
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	$("#tabFrom").attr('action','${base}/subaccountseq/'+$(this).attr("id")+'.jhtml');
	    	$("#tabFrom").submit();
	    });
	});
	
	function bindBankCard(obj){
		mgt_util.showjBox({
			width : 800,
			height : 460,
			title : '绑定银行卡',
			url :'${base}/subaccountseq/bindBankCardUI.jhtml?id='+obj,
			grid : $('#grid-table')
		});
		
	}
function takeCash(obj){
	mgt_util.showjBox({
		width : 800,
		height : 460,
		title : '提现',
		url :'${base}/subaccountseq/takeCashUI.jhtml?id='+obj,
		grid : $('#grid-table')
	});	
	}
	
function findBankCardDetails(obj){
	mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '银行卡信息',
							url : '${base}/subaccount/bankCardDetails.jhtml?deleteFlag=1&id='+obj,
							grid : $('#grid-table')
						});
}


function findSubaccountDetails(obj){
	mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '账号信息',
							url : '${base}/subaccountseq/subaccountDetails.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	}
</script> 