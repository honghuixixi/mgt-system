<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>物流管理-客户收货结果确认</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
	<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    	<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
	</object> 
	<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
	<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/logistics/list.jhtml',
 					colNames:['','','','','','订单号','状态','客户','配送员','订单金额','单据时间','操作','备注'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CN',width:0,hidden:true,key:true},
				   		{name:'CN2',width:0,hidden:true,key:true},
				   		{name:'CN3',width:0,hidden:true,key:true},
				   		{name:'CN4',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:80},
				   		{name:'STATUS_FLG',align:"center",width:30,
				   			editable:true,formatter:function(data){
								if(data=='DELIVERED'){
									return '发货中';
								}else if(data=='SUCCESS'){
									return '已确认';
								}
				   			}
				   		},
				   		{name:'CUST_NAME',align:"center",width:70},
				   		{name:'NAME',align:"center",width:50},
				   		{name:'AMOUNT',align:"center",width:40},
				   		{name:'CREATE_DATE',align:"center",width:80,formatter : function(data){
                            if(!isNaN(data) && data){
                            	data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                         },
				   		{name:'detail',width:70,align:'center',sortable:false},
				   		{name:'remark',width:50,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
				   		if($("#type").val()=='D'){
				   			var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
							for(var i=0; i<ids.length; i++){
								var id=ids[i]; 
								var rowData = $('#grid-table').jqGrid('getRowData',id);
								if(rowData.CN2<0){
									detail ="错误数据";
									remark ="订单金额错误";
								}else if(rowData.CN3>0){
									detail ="错误数据";
									remark ="出库数量为0"
								}else if(rowData.CN4>0){
									detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show'  href='${base}/logistics/detailsInfo.jhtml'>确认客户收货结果</button>";
								    remark ="用户提交订单数量和出库数量不同"
							    }else{
									remark =""
									detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show'  href='${base}/logistics/detailsInfo.jhtml'>确认客户收货结果</button>";
								}
								jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail });
								jQuery("#grid-table").jqGrid('setRowData', ids[i], { remark: remark });
								if(rowData.CN>0){//判断是否是有差异订单 大于0是有差异，反之则没有，有差异的复选框禁用
									$('#jqg_grid-table_'+id).attr("disabled","disabled");
								}
							};
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
				   		}
					},
					onSelectAll:function (aRowids,status){
						if($("#type").val()=='D'){
							for(var i=0; i<aRowids.length; i++){
								var id=aRowids[i]; 
								var rowData = $('#grid-table').jqGrid('getRowData',id);
								if(rowData.CN>0){//判断是否是有差异订单 大于0是有差异，反之则没有，有差异的复选框禁用
									$('#jqg_grid-table_'+id).attr("checked",false);
								}
							}
						}
					},
					beforeSelectRow:function(rowid, e){
						if($("#type").val()=='D'){
							var rowData = $('#grid-table').jqGrid('getRowData',rowid);
							if(rowData.CN>0){
								return false;
							}else{
								return true;
							}
						}else{
							return true;
						}
					}
				   	
				});

			});
			function orderUpdate(){
				var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				var idss="";
				for(var i=0; i<ids.length; i++){ 
					var id=ids[i]; 
					var rowData = $('#grid-table').jqGrid('getRowData',id);
					if(rowData.CN>0){//判断是否是有差异订单 大于0是有差异，反之则没有，有差异的复选框禁用
						$('#jqg_grid-table_'+id).attr("checked",false);
					}
					if(rowData.CN==0){//判断如果等于0是没有差异的，进行拼装id
						if(idss==""){
							idss+=id
						}else{
							idss+=','+id
						}
					}
				}
				if(idss==""){
					top.$.jBox.tip('未选择数据，不可提交！','error');
					return false;
				}
				$.jBox.confirm("确认要确认收货结果?", "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在确认数据，请稍等...');
						$.ajax({
							url : "${base}/logistics/orderUpdate.jhtml",
							type :'post',
							dataType : 'json',
							data : 'pkno=' + idss,
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
									data, function(s) {
										if (s) {
											top.$.jBox.tip('确认收货成功！','success');
											mgt_util.refreshGrid("#grid-table");
										}
									});
							}
						});
					}
				})
			}
			function confirmList(){
				$("#grid-table").jqGrid('setGridParam', {
					start : 1,
					datatype:'json',
					type:'post',
					mtype:'post',
					page:1 ,
					postData : {type:'S'}
				}).trigger("reloadGrid");
				$("#confirm").hide();
				$("#orderupdate").hide();
				$("#unconfirmed").show();
				$("#print_all").show();
				$("#type").val("S");
				
			}
			
			function unconfirmedList(){
				$("#grid-table").jqGrid('setGridParam', {
					start : 1,
					datatype:'json',
					type:'post',
					mtype:'post',
					page:1 ,
					postData : {type:'D'}
				}).trigger("reloadGrid");
				$("#unconfirmed").hide();
				$("#print_all").hide();
				$("#confirm").show();
				$("#orderupdate").show();
				$("#type").val("D");
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
				var sum = 0.00;
				for(var i=0;i<seleIds.length;i++){
					var rowData = $("#grid-table").jqGrid("getRowData", seleIds[i]);
					pkNos[i] = rowData.PK_NO;
					sum = Number(sum) + Number(rowData.AMOUNT_CN); 
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
								html += '<tr><td colspan="2" align="center" style="font-size:18px;"></td><td colspan="3" align="left" style="font-size:18px;">订单总数：';
								html += seleIds.length;
								html += '</td>';
								html += '<td colspan="3" align="left" style="font-size:18px;">应付总金额：';
								html += currency_0(sum,true);
								html += '</td>';
								html += '</tbody></table></div>';
								
								//table数据部分
								html += '<div id="printdiv_b" style="display:none">';
								html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
								html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
								html += '<th align="center" width="6%" style="border:1px solid #000; border-right:none 0;">序号</th>';
     							html += '<th align="center" width="18%" style="border:1px solid #000; border-right:none 0;">订单号</th>';
    							html += '<th align="center" width="8%" colspan="2" style="border:1px solid #000; border-right:none 0;">状态</th>';
     							html += '<th align="center" width="25%" style="border:1px solid #000; border-right:none 0;">客户</th>';
     							html += '<th align="center" width="7%" style="border:1px solid #000; border-right:none 0;">配送员</th>';
     							html += '<th align="center" width="12%" style="border:1px solid #000; border-right:none 0;">应收金额</th>';
    							html += '<th align="center" width="12%" style="border:1px solid #000;">单据时间</th></tr></thead><tbody>';
    				
    						$.each(data.order,function(n, Item) {
    							html += '<tr height="15" bgColor="#ffffff">';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += n+1;
    							html += '</td>';
    							html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.MAS_NO;
    							html += '</td>';
    							html += '<td align="center" colspan="2" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							if(Item.STATUS_FLG=='DELIVERED'){
    								html += '发货中';
								}else if(Item.STATUS_FLG=='SUCCESS'){
    								html += '已确认';
								}
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    							html += Item.CUST_NAME;
    							html += '</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
								if(null!=Item.NAME) {
									html += Item.NAME;
								} else {
									html += '--';
								}
								html += '</td>';
								html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">'+currency_0(Item.AMOUNT_CN,true)+'</td>';
								html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    							var date = (new Date(parseFloat(Item.MAS_DATE))).format("yyyy-MM-dd")
    							html += date;
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
        	LODOP.ADD_PRINT_TEXT(30, 320, 300, 30, "客户收货确认单");
        	LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        	LODOP.ADD_PRINT_TEXT(42, 630, 200, 22, "第#页/共&页");
        	LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        	LODOP.ADD_PRINT_TABLE(80, "0%", "100%","100%", document.getElementById("printdiv_b").innerHTML);
       	 	LODOP.ADD_PRINT_HTM(53, "0%", "100%", "100%", document.getElementById("printdiv_h").innerHTML);
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    	};		   
	});
</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="btn_diva_box"></div>
				<div class="currentDataDiv_tit">
					<button type="button" id="orderupdate" class="btn btn-info btn_divBtn" onclick="orderUpdate()" >批量确认</button>
					<button type="button" id="confirm" class="btn btn-info btn_divBtn" onclick="confirmList()" >已确认</button>
					<button type="button" id="unconfirmed" style="display:none;" class="btn btn-info btn_divBtn" onclick="unconfirmedList()" >未确认 </button>
					<button type="button" id="print_all" style="display:none;" class="btn btn-info btn_divBtn" onclick="unconfirmedList()" >批量打印</button>
					<!--<span class="open_btn"></span>显示隐藏按钮-->
				</div>
				<input type="hidden"  id="type" value="D" />
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
		                <div id="finishSt" class="" style="padding-top:0px;">
							<div class="form-group" id="custCodesDiv">
							<label class="control-label">订单号</label>
							<input type="text" class="form-control digits" id="masNo"  name="masNo"  maxlength=32 />
							<label class="control-label">配送员</label>
							<input type="text" class="form-control digits" id="logisticsName"  name="logisticsName" style="width:120px;" maxlength=32 />
							</div>
						</div>
		            </form>
		            <div class="search_cBox">
						<button type="button" class="search_cBox_btn" data-toggle="jBox-query" >搜 索</button>
					</div>
	            </div> 
	        </div>
	      </div>    
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>