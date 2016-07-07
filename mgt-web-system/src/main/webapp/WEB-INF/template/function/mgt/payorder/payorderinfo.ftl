<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>缴纳代收货款</title>
		[#include "/common/commonHead.ftl" /]		
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />		
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/payorder/list.jhtml',
 					colNames:['','订单号','客户编码','客户名称','状态','支付状态','配送员','订单金额','实付金额','操作'],
 					width:'100%',
 					rowNum:2147483647,
				   	colModel:[
				   		{name:'PK_NO',index:'ID',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',width:'15%'},
				   		{name:'CUST_CODE',width:'6%'},
				   		{name:'CUST_NAME', width:'10%'},	
				   		{name:'STATUS_FLG',width:'8%',align:"center",editable:true,formatter:function(value,row,index){
						return '已收货';
	   		            }},
				   		{name:'PAY_STATUS',width:'10%',align:"center",editable:true,formatter:function(value,row,index){
						return '未支付';
	   		            }},
	   		            {name:'LOGISTICUSERNAME', width:'10%'},
	   		            {name:'AMOUNT', width:'10%'},
	   		            {name:'ACTUALAMOUNT', width:'10%',formatter:function(value,row,index){
	   		            var actualAmount=index.AMOUNT;
						if(null!=index.MISC_PAY_AMT){
						actualAmount=actualAmount-index.MISC_PAY_AMT;
						}
						if(null!=index.DIFF_MISC_AMT){
							actualAmount=actualAmount-index.DIFF_MISC_AMT;
						}
						if(null!=index.FREIGHT){
						actualAmount=actualAmount+index.FREIGHT;
						}
						return  actualAmount.toFixed(2);
	   		            }},
	   		            {name:'', width:'10%',formatter:function(value,row,index){
	   		            var str =  '<button type="button" class="btn btn-info edit"     onClick=findPayOrderUI("'+index.PK_NO+'")   >订单详情 </button><button type="button" class="btn btn-info edit"     onClick=payOrderUI("'+index.PK_NO+'")   >付款</button>';
	   		            
						return  str;
	   		            }}
	   		            
				   	],
				   	onSelectAll:function(aRowids,status){
					setTimeout(function(){
				   	var orderAmountSpan = 0.00;
				   	var orderActualAmountSpan = 0.00;
				   	var selectedIds = $("#grid-table").jqGrid("getGridParam", "selarrrow");
				   	for(var i=0;i<selectedIds.length;i++){
				   	var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
				   	orderAmountSpan=orderAmountSpan+parseFloat(rowData.AMOUNT);
				   	orderActualAmountSpan=orderActualAmountSpan+parseFloat(rowData.ACTUALAMOUNT);
				   	}
				   	$("#orderAmountSpan").html(formatCurrency(orderAmountSpan));
				   	$("#orderActualAmountSpan").html(formatCurrency(orderActualAmountSpan));
				   	$("#orderCountSpan").html(selectedIds.length);
				   	},600);
				   	},
				   	onCellSelect:function(rowid,iCol,cellcontent,e){
					setTimeout(function(){
				   	var orderAmountSpan = 0.00;
				   	var orderActualAmountSpan = 0.00;
				   	var selectedIds = $("#grid-table").jqGrid("getGridParam", "selarrrow");
				   	for(var i=0;i<selectedIds.length;i++){
				   	var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
				   	orderAmountSpan=orderAmountSpan+parseFloat(rowData.AMOUNT);
				   	orderActualAmountSpan=orderActualAmountSpan+parseFloat(rowData.ACTUALAMOUNT);
				   	}
				   	$("#orderAmountSpan").html(formatCurrency(orderAmountSpan));
				   	$("#orderActualAmountSpan").html(formatCurrency(orderActualAmountSpan));
				   	$("#orderCountSpan").html(selectedIds.length);
				   	},600);
				   	},
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				});
				

				$("#payorder_search").live('click',function(){
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
		    <!--浮动文字-->
		    <div class="pos_orderCount_box">
		   		<div class="orderCount-IconBtn"></div>
				<div class="pos_orderCount">
		   			<div class="form-group"><font>总计配送订单数：</font><span id="orderCountSpan">0</span>张<font class="padding_fontl">总计配送总金额：</font><span id="orderAmountSpan">0.00</span> 元<font class="padding_fontl">应交货款：</font><span id="orderActualAmountSpan">0.00</span> 元</div>
				</div>
		    </div>
			<div id="currentDataDiv" action="resource">
				 <div class="currentDataDiv_tit">
					 <div class="form-group">
		                <button type="button" class="btn_divBtn edit" id='payorder_defray'     onClick='payOrderUI()'   >在线支付</button>
	               		<button type="button" class="btn_divBtn edit" id='waitpayment_payorder_search'     onClick='findWaitPaymentPayorder()'   >查看未支付交易</button>
	               		<button type="button" class="btn_divBtn edit" id='line_payment'     onClick='linePayment()'   >线下支付</button>
	               		<a class="btn_divBtn" class="btn_divBtn" id="print_all">批量打印 </a>	
	                 </div>
	             </div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">订单编号</label>
		                    <input type="text" class="form-control" name="masNo" id="masNo" style="width:90px;" >
		                </div>
		                <div class="form-group">
		                    <label class="control-label">配送员</label>
		                    <input type="text" class="form-control" name="logisticusername" id="logisticusername" style="width:90px;" >
		                </div>  
		                <!--  增加客户、业务员查询条件 yinghua.zheng 2016/5/23-->
		                
		                <div class="form-group">
		                    <label class="control-label">业务员</label>
		                    <input type="text" class="form-control" name="spName" id="spName" style="width:90px;" >
		                </div>
		                
		                 <div class="form-group">
		                    <label class="control-label">客户 </label>
		                    <input type="text" class="form-control" name="custName" id="custName" style="width:90px;" >
		                </div>
		                
		                 <div class="form-group">
		                    <label class="control-label">下单时间</label>
		                    <input type="text" class="form-control" name="startDate" id="startDate" style="width:90px;"  onClick="WdatePicker({readOnly:true})">
		               		至
		               		<input type="text" class="form-control" name="endDate" id="endDate" style="width:90px;"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}',readOnly:true})">
		               		
		                </div>
		                <div class="search_cBox">
							<div class="form-group">
				                <button type="button" class="search_cBox_btn btn btn-info" id="payorder_search"  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
			                </div>
		                </div>
		            </form>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		    <!--
		  	<div id="grid-pager"></div>
		    -->
   		</div>
    </body>
    <div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
</html>
 
<script> 
		function findWaitPaymentPayorder(){
		window.location.href='${base}/payorder/waitPaymentPayOrderInfo.jhtml';
		
		}
	   function findPayOrderUI(obj){
		mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '订单详情',
							url : '${base}/payorder/findById.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   }
	   function payOrderUI(obj){
	   if(null==obj){
	   obj= $("#grid-table").jqGrid("getGridParam", "selarrrow");
	   	if (obj.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
	   }
	   	   $.jBox.confirm("确认要支付?", "提示", function(v){
				if(v == 'ok'){
		var objVal=(obj+'');
	       $.ajax({
      url:'${base}/payorder/payFlag.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{'ids': objVal},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
        if(data.data==0){
        	       $.ajax({
      url:'${base}/payorder/payOrderUI.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{'ids': objVal},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
        if(data.success==true){
		//window.open('${base}/payorder/payBillUI.jhtml?pkNo='+data.data, "_blank", "toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no");
			mgt_util.showjBox({
							width : 1200,
							height : 460,
							title : '支付',
							url :'${base}/payorder/payBankList.jhtml?pkNo='+data.data,
							grid : $('#grid-table')
						});
		}else{ 
		  	top.$.jBox.tip('勾选的订单存在已支付状态,请刷新后选择');
		 	return false;
		}
      }
    }); 
 		}else{ 
		  	top.$.jBox.tip('勾选的订单存在已支付状态,请刷新后选择');
		 	return false;
		}
      }
    }); 
  }});
}
	   function linePayment(obj){
		   
		   if(null==obj){
			   obj= $("#grid-table").jqGrid("getGridParam", "selarrrow");
			   	if (obj.length <= 0) {
						top.$.jBox.tip('请选择一条记录！');
						return;
					}
			   }
			   	   $.jBox.confirm("请确保订单已收到款项，该操作会将订单修改为‘支付完成’！", "提示", function(v){
						if(v == 'ok'){
				var objVal=(obj+'');
			       $.ajax({
		      url:'${base}/payorder/linePayment.jhtml',
		      sync:false,
		      type : 'post',
		      dataType : "json",
		      data :{'ids': objVal},
		      error : function(data) {
			    alert("网络异常");
		        return false;
		      },
		      success : function(data) {
		    	     if(data.success==true){
		       top.$.jBox.tip('订单处理成功');
		      }else{
		      top.$.jBox.tip('处理失败，未找到银行交易流水');
		      }
		        $("#grid-table").trigger("reloadGrid");
		      }
		    }); 
		  }});
		   
	   }
</script>
<script  type="text/javascript">
	$(document).ready(function(){
		var argument;//打印参数全局变量
    	var LODOP; //打印函数全局变量 

			$("#print_all").click(function(){
				argument = '297mm';
				var seleIds = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				var pkNos =	[];
				for(var i=0;i<seleIds.length;i++){
					var rowData = $("#grid-table").jqGrid("getRowData", seleIds[i]);
					pkNos[i] = rowData.PK_NO;  
				}
				//动态拼接订单详情页面
					$.ajax({
						url:'${base}/payorder/getAjaxPayOrder.jhtml',
						sync:false,
						type : 'post',
						dataType : "json",
						data :{
							'pkNos':pkNos,
						},
						traditional: true, 
						error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
						var html = '';
						if(data.message.type == "success"){
								html += '<div id="printdiv_h"  style="padding:15px 110px;background:#fff; display:none">';
								html += '<table width="90%" align="center" style=" font-size:15px;margin:0 30px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">';
								html += '<tbody>';
								html += '<tr><td colspan="2" align="center" style="font-size:18px;"></td><td colspan="6" align="left" style="font-size:18px;">总单数：';
								html += $("#orderCountSpan").html();
								html += '</td></tr>';
								html += '<tr><td colspan="2" align="center" style="font-size:18px;"></td><td colspan="3" align="left" style="font-size:18px;">订单总金额：';
								html += $("#orderAmountSpan").html();
								html += '</td>';
								html += '<td colspan="3" align="left" style="font-size:18px;">实付总金额：';
								html += $("#orderActualAmountSpan").html();
								html += '</td>';
								html += '</tbody></table></div>';
								
								//table数据部分
								html += '<div id="printdiv_b" style="display:none">';
								html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
								html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
								html += '<th align="center" width="6%" style="border:1px solid #000; border-right:none 0;">序号</th>';
     							html += '<th align="center" width="18%" style="border:1px solid #000; border-right:none 0;">订单号</th>';
    							html += '<th align="center" width="8%" colspan="2" style="border:1px solid #000; border-right:none 0;">客户编码</th>';
     							html += '<th align="center" width="25%" style="border:1px solid #000; border-right:none 0;">客户名称</th>';
     							html += '<th align="center" width="12%" style="border:1px solid #000; border-right:none 0;">支付状态</th>';
     							html += '<th align="center" width="7%" style="border:1px solid #000; border-right:none 0;">配送员</th>';
     							html += '<th align="center" width="12%" style="border:1px solid #000; border-right:none 0;">订单金额</th>';
    							html += '<th align="center" width="12%" style="border:1px solid #000;">支付金额</th></tr></thead><tbody>';
    				
    						$.each(data.order,function(n, Item) {
    							html += '<tr height="15" bgColor="#ffffff">';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += n+1;
    							html += '</td>';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.MAS_NO;
    							html += '</td>';
    							html += '<td align="center" colspan="2" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.CUST_CODE;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.CUST_NAME;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							if("WAITPAYMENT"==Item.PAY_STATUS) {
    								html += '未支付';
    							}else if("PAID"==Item.PAY_STATUS){
    								html += '已支付';
    							}else{
    								html += '已发货';
    							}
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
								if(null!=Item.NAME) {
									html += Item.NAME;
								} else {
									html += '--';
								}
								html += '</td><td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">'+currency_0(Item.AMOUNT,true)+'</td>';
								html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    							html += Item.AMOUNT_CN.toFixed(2);
    							html += '</td></tr>';

							});
    							html += '</tbody><tfoot><tr><td colspan="8" height="10"></td></tr>';
    							html += '<tr><td colspan="4" align="center" style="font-size:18px;">配送员签字：</td><td colspan="4" align="center" style="font-size:18px;">收款人签字： </td></tr>';
								html += '<tr><td colspan="8" height="10"></td></tr></tfoot></table></div>';
								
								$("#currentDataDiv").append(html);
								//直接打印
								//prn1_print(data.order.PK_NO); 
								prn1_preview(data.order.PK_NO); 
					}else{
						top.$.jBox.tip('系统错误', 'error');
	 					return false;
					}
				}
			  });
			});
		//预览功能
    	function prn1_preview(pkNo) {
       		PrintMytable(pkNo);
        	LODOP.PREVIEW();
    	};
    	//直接打印功能
    	function prn1_print(pkNo) {
       		PrintMytable(pkNo);
       		//LODOP.PRINTA();
       		LODOP.PRINT();
    	};
    	//打印表格功能的实现函数
    	function PrintMytable(pkNo) {
        	LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        	LODOP.PRINT_INIT("打印工作名称");
        	LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
        	LODOP.SET_PRINT_PAGESIZE(1,"210mm",argument,"");
        	LODOP.ADD_PRINT_TEXT(30, 320, 300, 30, "货款交接表");
        	LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        	LODOP.ADD_PRINT_TEXT(42, 630, 200, 22, "第#页/共&页");
        	LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        	LODOP.ADD_PRINT_TABLE(103, "0%", "100%","100%", document.getElementById("printdiv_b").innerHTML);
       	 	LODOP.ADD_PRINT_HTM(53, "0%", "100%", "100%", document.getElementById("printdiv_h").innerHTML);
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    	};	   
	});
</script>