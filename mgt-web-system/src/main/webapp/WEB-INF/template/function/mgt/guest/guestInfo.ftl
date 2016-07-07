<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>客户管理-商户入驻审核</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/guest/guestList.jhtml',
 					colNames:['','','','登录名','企业名称','联系人','手机号码','联系电话','注册区域','创建时间','买家','卖家','物流商','审核状态','操作'],
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:0,hidden:true,key:true},
				   		{name:'AREA_ID_L1',width:0,hidden:true,key:true},
				   		{name:'NOT_ENABLE',width:0,hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",width:50},
				   		{name:'NAME',align:"center",width:50},
				   		{name:'PIC',align:"center",width:50},
				   		{name:'CRM_MOBILE',align:"center",width:70},
				   		{name:'CRM_TEL',align:"center",width:70},
				   		{name:'AREA_DESC',align:"center",width:70},
				   		{name:'CREATE_DATE',align:"center",width:70,
				   			formatter : function(data){
	                        	if(!isNaN(data) && data){
	                        		data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
	                        	}else{
	                        		data="";
	                        	}
	                        	return data;
                        	}
				   		},
				   		{name:'SALESMEN_FLG',align:"center",width:40,
				   			editable:true,formatter:function(data){
								if(data=='Y'){
									return '是';
								}else if(data=='N'){
									return '否';
								}else{
									return '';
								}
				   			}
				   		},
				   		{name:'PURCHASER_FLG',align:"center",width:40,
				   			editable:true,formatter:function(data){
								if(data=='Y'){
									return '是';
								}else if(data=='N'){
									return '否';
								}else{
									return '';
								}
				   			}
				   		},
				   		{name:'LOGISTICS_PROVIDER_FLG',align:"center",width:40,
				   			editable:true,formatter:function(data){
								if(data=='Y'){
									return '是';
								}else if(data=='N'){
									return '否';
								}else{
									return '';
								}
				   			}
				   		},
				   		{name:'APPROVE_STATUS',align:"center",width:40,
				   			editable:true,formatter:function(data){
								if(data=='R'){
									return '已拒绝';
								}else if(data=='P'){
									return '已批准';
								}else if(data=='F'){
									return '已入驻';
								}else if(data=='I'){
									return '审核中';
								}else{
									return '';
								}
				   			}
				   		},
                        {name:'detail',width:80,align:'left',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.APPROVE_STATUS=="审核中"){
								detail ="<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' jBox-width='1000' jBox-height='600' data-toggle='jBox-show'  href='${base}/guest/detailGuestUI.jhtml'>详情</button>";
								if(rowData.NOT_ENABLE==0){
									detail+="<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' jBox-width='1000' jBox-height='600' data-toggle='jBox-show'  href='${base}/guest/examineGuestUI.jhtml'>审核</button>"
								}else{
									detail+="没有权限操作";
								}
								//detail+="<button type='button' class='btn btn-info edit' id='"+rowData.USER_NO+"' jBox-width='1000' jBox-height='600' data-toggle='jBox-show'  href='${base}/guest/examineGuestUI.jhtml'>审核</button>"
							}else {
								detail=""
							}
							
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail });
						} 
					}
				});
				
				//table数据高度计算
				tabHeight();
			});
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
	                <div id="finishSt" class="" style="padding-top:0px;">
						<div class="form-group" id="custCodesDiv">
						<label class="control-label">登录名</label>
						<input type="text" class="form-control digits" id="userName"  name="userName" style="width:120px;" maxlength=32 />
						<label class="control-label">企业名</label>
						<input type="text" class="form-control digits" id="name"  name="name" style="width:120px;" maxlength=32 />
						<label class="control-label" style="padding-right:5px;">审核状态</label>
						<select class="form-control" id="approveStatus" name="approveStatus" style="width:120px;">
							<option value="">请选择</option>
							<option value="I">审核中</option>
	    					<option value="P">已批准</option>
	    					<option value="R">已拒绝</option>
	    					
						</select>
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" data-form="#query-form" data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
						</div>
					</div>
	            </form>
	        </div>
	      </div>   
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
</html>