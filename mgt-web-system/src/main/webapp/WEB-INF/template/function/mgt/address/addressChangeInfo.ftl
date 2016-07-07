<!DOCTYPE html>
<html>
    <head>
        <title>即时信息维护</title>
		[#include "/common/commonHead.ftl" /]
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
        <script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/account/accountinfoList.jhtml',
 					colNames:['ID','用户名','店铺名称','用户类型','状态','店铺地址','联系人','联系电话'],
 					width:999,
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:30,hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",width:60},
				   		{name:'NAME',align:"center",width:180},
				   		{name:'BIND_FLG',width:60,align:"center"},
				   		{name:'JOIN_FLG',align:"center",width:60},
				   		{name:'CRM_ADDRESS1',align:"center",width:170},
				   		{name:'CRM_PIC',align:"center",width:40},
				   		{name:'CRM_MOBILE',align:"center",width:90},
				   	],				   	
				});

				$("#searchbtn").click(function(){
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
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" style="width:1000px" name="query" id="query-form"> 
        			<div class="form-group">
	                    <label class="control-label">用户名</label>
           				<input type="text" class="form-control" name="userName" style="width:120px;">
        			</div>
	                <div class="form-group">
	                    <label class="control-label">用户类型</label>
	                    <select class="form-control" name="typeFlg" onChange="changeselect1(this.value)" onfocus="changeselect1(this.value)">
	                        <option value="">全部</option>
	                        <option value="0">店铺</option>
	                        <option value='1'>供应商</option>
	                        <option value='2'>物流商</option>
	                    </select>&nbsp;&nbsp;
	                    <label class="control-label">用户状态</label>
  						<select class="form-control" name="status" onfocus="changeselect1(document.query.typeFlg.value)">    
  						</select> 
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="account_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	                <div style="float:right;">
						<button type="button" class="btn btn-info" id="account_join" data-toggle="jBox-audit-userfunction" href="${base}/account/synchAccount.jhtml">供应商入驻</button>
					</div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
   		
   	<!--级联下拉菜单js-->	
   	<script type="text/javascript">  
  		var subcat=new Array();   
  			subcat[0]=new Array('','--','') 
  			subcat[1]=new Array('0','--','')    
  			subcat[2]=new Array('1','全部','') 
  			subcat[3]=new Array('1','已入驻','1') 
  			subcat[4]=new Array('1','未入驻','0') 
  			subcat[5]=new Array('2','全部','') 
  			subcat[6]=new Array('2','已入驻','1') 
  			subcat[7]=new Array('2','未入驻','0') 
  
  		function changeselect1(selectValue){ 
   			document.query.status.length =0;
   			for(i=0;i<subcat.length; i++){ 
    			if(subcat[i][0]==selectValue){ 
      				document.query.status.options[document.query.status.length]=new Option(subcat[i][1],subcat[i][2]);
     			} 
  			 } 
  		} 
  	</script> 
    </body>
</html>