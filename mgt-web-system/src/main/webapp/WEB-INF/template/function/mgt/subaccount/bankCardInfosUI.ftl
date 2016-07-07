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
				var deleteFlag='${deleteFlag}';
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/subaccount/bankCardInfos.jhtml?custId=${custId}&subaccountType=${subaccountType}',
					rownumbers : false,
 					colNames:['','账号','户名','行别','开户行','证件类型','证件号码','手机号码','绑定时间','操作'],
 					multiselectWidth:'1',
 					rownumWidth:'12',
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'BANKCARDNO',width:120},
				   		{name:'BANKCARDNAME',width:140},
				   		{name:'BANK_TYPE', width:65},
				   		{name:'BANK_NAME', width:100},
				   		{name:'USER_CERT_TYPE',width:80,align:"center",editable:true},
				   		{name:'USER_CARDNO',width:110,align:"center",editable:true},
				   		{name:'USER_BANKMOB', width:90},
						{name:'CARDBINDTIME', width:90, formatter:function(data){
							if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
							}},
						{name:'', width:60,formatter:function(value,row,index){
							
							if(deleteFlag=='1'){
								
								return '<button type="button" class="btn btn-info edit"     onClick=deleteBankCard("'+index.ID+'")   >删除银行卡 </button>';
							}
							return '';
							
						}}
				   	]
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
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" method="post" action="${base}/subaccountseq/list.jhtml"> 
	            
				<div class="search_cBox">
					<button type="button" class="search_cBox_btn" id="subaccountlist_search" data-toggle="jBox-query">搜 索 </button>
				</div></form>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>
 <script>
 function deleteBankCard(obj){
   	 
 	   $.jBox.confirm("确认删除银行卡?", "提示", function(v){
			if(v == 'ok'){
	var objVal=(obj+'');
     $.ajax({
url:'${base}/subaccount/deleteBankCard.jhtml',
sync:false,
type : 'post',
dataType : "json",
data :{'id': objVal},
error : function(data) {
  alert("网络异常");
  return false;
},
success : function(data) {
  		  	top.$.jBox.tip('删除成功');
  $("#grid-table").trigger("reloadGrid");

}
}); 
 
 }});
 }
 </script>