<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>缴纳代收货款-查看未支付交易</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/payorder/paybillList.jhtml',
 					colNames:['','交易分类','名称','批次号','交易金额','交易状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'TRAN_TYPE',align:"center",width:'100',
				   		editable:true,formatter:function(data){
							if(data=='9001'||data=='9000'){
								return '第三方支付平台收款';
							}else if(data=='9002'){
								return '资金归集';
							}else if(data=='9003'){
								return '批量代付';
							}else{
								return '第三方支付平台收款';
							}
	   					}
				   		},
				   		{name:'TRAN_NOTE',align:"center",width:80},
				   		{name:'BATCHID',align:"center",width:120},
				   		{name:'TRANAMOUNT',align:"center",width:60},
				   		{name:'STATE',align:"center",width:'60',
				   		editable:true,formatter:function(data){
							if(data=='10'){
								return '未支付';
							}else if(data=='00'){
								return '待支付';
							}else if(data=='01'){
								return '支付中';
							}else if(data=='02'){
								return '支付成功';
							}else if(data=='03'){
								return '支付失败';
							}
	   					}
				   		},
				   		{name:'detail',index:'PK_NO',width:160,align:'center',sortable:false,formatter:function(value,row,index){
	   		            var str =  '<button type="button" class="btn btn-info edit"     onClick=payBillUI("'+index.PK_NO+'")>付款</button><button type="button" class="btn btn-info edit"     onClick=cancelPayBill("'+index.PK_NO+'")>取消</button><button type="button"  class="btn btn-info edit"  onClick=paybillDetailUI("'+index.BATCHID+'") id="'+index.BATCHID+'" href="${base}/paybill/paybillDetailUI.jhtml">详情</button>  <button type="button" class="btn btn-info edit"     onClick=affirmPaySuccess("'+index.PK_NO+'")>确认支付成功</button>';
						return  str;
	   		            }} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				   	
				});
					$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
			});
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	           <div class="currentDataDiv_tit">
	              <div class="form-group">
	                 <button type="button" class="btn_divBtn edit" id=''     onClick='payorderlist()'   >查看代收货款列表</button>
	                </div>
	            </div>
	            <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"   id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">金额范围:</label>
		                    <input type="text" class="form-control" name="minMoney" style="width:95px;">&nbsp;&nbsp;至&nbsp;&nbsp;
		                    <input type="text" class="form-control" name="maxMoney" style="width:95px;">
		                </div>
		                <div class="form-group">
			                 <label class="control-label">交易分类:</label>
		     				 <select class="form-control" name="tranType" style="width:95px;">
			                        <option value="">全部</option>
			                        <option value="9001">第三方支付平台收款</option>
			                        <option value="9002">资金归集</option>
			                        <option value="9003">批量代付</option>
			                  </select>	            
		                  </div>
		                  <div class="search_cBox">
			                  <div class="form-group">
				              	<button type="button" class="search_cBox_btn btn btn-info" id="order_search" data-toggle="jBox-query">搜 索 </button>
				              </div>  
						  </div> 
		            </form>
	            </div>
	        </div>
	      </div>    
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
		function payorderlist(){
		window.location.href='${base}/payorder/payorderinfo.jhtml';
		}
		 function payBillUI(obj){
		 		//window.open('${base}/payorder/payBillUI.jhtml?pkNo='+obj, "_blank", "toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no");
		 
			mgt_util.showjBox({
							width : 1200,
							height : 460,
							title : '支付',
							url :'${base}/payorder/payBankList.jhtml?pkNo='+obj,
							grid : $('#grid-table')
						});

	   }
	   
	   	   function paybillDetailUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '订单详情',
							url : '${base}/paybill/paybillDetailUI.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   }
	   
	    function affirmPaySuccess(obj){
	 
	   	   $.jBox.confirm("确认支付成功?", "提示", function(v){
				if(v == 'ok'){
		var objVal=(obj+'');
	       $.ajax({
      url:'${base}/payorder/affirmPaySuccess.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{'id': objVal},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
      
      if(data.success==true){
        		  	top.$.jBox.tip('处理成功');
      }else{
      top.$.jBox.tip('处理失败，未找到银行交易流水');
      }
        $("#grid-table").trigger("reloadGrid");
	 
      }
    }); 
	   
	   }});
	   }
	    
	    function cancelPayBill(obj){
	   	 
		   	   $.jBox.confirm("确认取消交易?", "提示", function(v){
					if(v == 'ok'){
			var objVal=(obj+'');
		       $.ajax({
	      url:'${base}/payorder/cancelPayBill.jhtml',
	      sync:false,
	      type : 'post',
	      dataType : "json",
	      data :{'id': objVal},
	      error : function(data) {
		    alert("网络异常");
	        return false;
	      },
	      success : function(data) {
	      
	      if(data.code=='001'){
	        		  	top.$.jBox.tip('取消成功');
	      }else{
	      top.$.jBox.tip('处理失败，该交易已支付成功,不能取消');
	      }
	        $("#grid-table").trigger("reloadGrid");
		 
	      }
	    }); 
		   
		   }});
		   }
</script>
</html>