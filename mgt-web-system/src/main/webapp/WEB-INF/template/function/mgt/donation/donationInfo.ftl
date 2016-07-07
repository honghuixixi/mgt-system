<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>营销管理-赠品发放</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					rowNum:2147483647,
					url:'',
 					colNames:['','客户编码','客户名称','筛选规则','条件','统计值','备注','操作'],
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:0,hidden:true,key:true},
				   		{name:'CUST_CODE',align:"center",sortable:false,width:50},
				   		{name:'CUST_NAME',align:"center",sortable:false,width:50},
				   		{name:'RULE',align:"center",sortable:false,width:50,
				   			editable:true,formatter:function(data){
								if(data=='A'){
									return '按订单金额';
								}else if(data=='B'){
									return '按订货频率';
								}else if(data=='M'){
									return '手工添加';
								}
				   			}},
				   		{name:'CONDITION',align:"center",sortable:false,width:90},
				   		{name:'SUMALL',align:"center",sortable:false,width:70},
				   		{name:'REMARKS',align:"center",width:70,sortable:false,
				   			editable:true,formatter:function(data){
								return '最近7天有'+data+'赠送记录'; 
				   			}},
                        {name:'detail',width:80,align:'left',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
								detail ="<button type='button' class='btn btn-info edit' id='"+rowData.CUST_CODE+"' jBox-width='1000' jBox-height='600' data-toggle='jBox-show'  href='${base}/donation/donationTaskUserLog.jhtml'>日志</button>";
								detail+="<button type='button' class='btn btn-info edit'  onClick='delStk("+id+")' >删除</button>"
							//var condition =$("#condition").val()
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail });
							//jQuery("#grid-table").jqGrid('setRowData', ids[i], { CONDITION: condition });
						} 
					}
				});
				
				//table数据高度计算
				//tabHeight();
				
				$("#donationGrant").click(function(){
					var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					
					var userDate = "["
	   				for(var i=0; i<ids.length; i++){
	   					var id=ids[i]; 
						var rowData = $('#grid-table').jqGrid('getRowData',id);
						var rules="";
						var beginDate =$("#beginDate").val(); 			
						var endDate =$("#endDate").val();			
						var datesum =$("#datesum").val();
						var beginAmount =$("#beginAmount").val();
   						var endAmount =$("#endAmount").val();
						var strRule=rowData.RULE;
						if(strRule=="按订单金额"){
							rules='A';
						}
						else if(strRule=="按订货频率"){
							rules='B';
						}else if(strRule=="手工添加"){
							rules='M';
						}
						var le = ids.length-1;
						if(le==i){
							userDate+="{sumall:'"+rowData.SUMALL+"',beginDate:'"+beginDate+"',endDate:'"+endDate+"',datesum:'"+datesum+"',beginAmount:'"+beginAmount+"',endAmount:'"+endAmount+"',rules:'"+rules+"',userno:"+rowData.USER_NO+"}]"
						}else{
							userDate+="{sumall:'"+rowData.SUMALL+"',beginDate:'"+beginDate+"',endDate:'"+endDate+"',datesum:'"+datesum+"',beginAmount:'"+beginAmount+"',endAmount:'"+endAmount+"',rules:'"+rules+"',userno:"+rowData.USER_NO+"},"
						}
	   				}
					if(ids.length>0){
						window.location.href = "${base}/donation/donationTaskInfo.jhtml?userDate="+encodeURI(userDate);
					}else{
						top.$.jBox.tip('请选择数据！', 'error');
						return false;
					}
				})
				$("#donationLog").click(function(){
					window.location.href = "${base}/donation/donationTaskLog.jhtml";
				})
			});
			
			function queryMoneyUI(){
				$.jBox.open("iframe:${base}/donation/queryMoneyUI.jhtml", "按订单金额", 800, 350, { buttons: { } });
			}
			function queryFrequencyUI(){
				$.jBox.open("iframe:${base}/donation/queryFrequencyUI.jhtml", "按订货频率", 800, 350, { buttons: { },showScrolling: false });
			}
			
			function queryManualUI(){
				$.jBox.open("iframe:${base}/donation/queryManualUI.jhtml", "手工添加", 900, 350, { buttons: { },showScrolling: false });
			}
			
			function sss(){
				$("#jbox-content").css("overflow-y","hidden");
			}
			
			function getids(){
				var ids = jQuery("#grid-table").jqGrid('getDataIDs');
				return ids
			}
			
			function queryAll(page){
				//刷新grid表单数据
				$("#grid-table").jqGrid('setGridParam', {
						start : 1,
						datatype:'json',
						type:'post',
						mtype:'post',
						page:1 ,
						url : '${base}/donation/donationList.jhtml?'+page
				}).trigger("reloadGrid");
			}
			function delStk(rowid){
				var url = "${base}/donation/deleteCache.jhtml";
				$.jBox.confirm("确认要删除吗?", "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在删除，请稍等...');
						$.ajax({
            				url:url,
            				type : 'post',
							dataType : 'json',
							data:{rowid:rowid},
							error : function(data) {
								alert("网络异常");
								mgt_util.hideMask();
								return false;
							},
							success : function(data) { 
								top.$.jBox.tip('操作成功！', 'success');
								mgt_util.hideMask();
								$('#grid-table').jqGrid('delRowData',rowid);
							}
            			});
					}
				})
			}
			
			
		</script>
    </head>
    <body>
    <input type="hidden" id="condition" name="condition" value=""/>
    <input type="hidden" id="beginDate" name="beginDate" value=""/>
    <input type="hidden" id="endDate" name="endDate" value=""/>
    <input type="hidden" id="datesum" name="datesum" value=""/>
    <input type="hidden" id="beginAmount" name="beginAmount" value=""/>
    <input type="hidden" id="endAmount" name="endAmount" value=""/>
   		<div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="currentDataDiv_tit">
             		<div class="btn-group">
						   <button type="button" class="btn btn-default dropdown-toggle btn_divBtn" 
						      data-toggle="dropdown">
						     选择客户 <span class="caret"></span>
						   </button>
						   <ul class="dropdown-menu" role="menu">
						      <li><a href="#" onclick="queryMoneyUI()" >按订单金额</a></li>
						      <li class="divider"></li>
						      <li><a href="#" onclick="queryFrequencyUI()" >按订货频率</a></li>
						      <li class="divider"></li>
						      <li><a href="#" onclick="queryManualUI()">手工添加</a></li>
						      
						   </ul>
						</div>
             		<button type="button" class="btn_divBtn" id="donationGrant" >赠品发放</button>
             		<button type="button" class="btn_divBtn" id="donationLog" >发放日志</button>
	            </div>
	        </div>
	      </div>   
		  <table id="grid-table" ></table>
   		</div>
    </body>
    
</html>