<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
	<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    	<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
	</object> 
	<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
	<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
   <script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/productlist.jhtml?mergeNo='+${masNo},
					multiselect:false,
 					colNames:['商品编码','条码','商品名称','单位','数量','发货数量','净价','小计'],
 					rowNum: 1000,
				   	colModel:[	 
						{name:'STK_C',width:50},
						{name:'PLU_C',width:70},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'QTY1', width:40},
					   	{name:'NET_PRICE', width:40},
					   	{name:'SUB1', width:40}
				   	],
				});
			});
		</script>
<script  type="text/javascript">
	$(document).ready(function(){
	    var argument;//打印参数全局变量
    	var LODOP; //打印函数全局变量 
		//打印+预览按钮js
		$("#print").click(function() {
			printInfo.Show();
		});
		//打印参数设置对话框关闭
			$(".comPoP_head a").click(function() {
				printInfo.Close();
			}); 
			  	
		//打印参数设置对话框确定
		$(".comPoP_body a").click(function() {
			argument = $(".comPoP_body select").val();
			printInfo.Close();
			//订单masNo
			var mergeNo = ${masNo};
			//动态拼接订单详情页面
			$.ajax({
				url:'${base}/order/AjaxProductlist.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'mergeNo':mergeNo,
				},
				traditional: true, 
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
				var html = '';
				if(data.message.type == "success"){
					html += '<div id="printdiv_h"';
					html +='" style="display:none">';
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">';
					html += '<tbody><tr><td colspan="3" align="center">(www.qpwa.cn)</td></tr><tr><td style="text-align:left;float: left;" width="50%">单据编号：';
					html += data.order.MAS_NO;
					html += '</td><td style="text-align:left;float: left;" width="50%">单据日期：';
					html += data.order.MAS_DATE;
					html += '</td></tr><tr><td style="text-align:left;float: left;" width="37%">发&nbsp;&nbsp;货&nbsp;&nbsp;方：';
					html += data.order.ACC_NAME;
					html += '</td>';
					html += '<td colspan="3" align="left">收货方：';
					html += data.order.WH_NAME;
					html += '</td></tr></tbody></table></div>';				
				
					//table数据部分
					html += '<div id="printdiv_b" style="display:none">';
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
					html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
					html += '<th align="center"style="border:1px solid #000; border-right:none 0;">编号</th>';
     				html += '<th align="center"style="border:1px solid #000; border-right:none 0;">商品编码</th>';
    				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">条码</th>';
     				html += '<th align="center" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">单位</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">数量</th>';
    				html += '<th align="center" style="border:1px solid #000; ">发货数量</th></tr></thead><tbody>';
    				
    				$.each(data.item,function(n, Item) {
    					html += '<tr height="15" bgColor="#ffffff">';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += n+1;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += Item.STK_C;
    					html += '</td>';
    					html += '<td align="center" colspan="2" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += Item.PLU_C;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += Item.STK_NAME;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += Item.UOM;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += Item.STK_QTY;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    					html += Item.QTY1;
						html += '</td></tr>';
					});
    					html += '</tbody><tfoot><tr><td colspan="8" height="10"></td></tr>';
    					html += '<tr><td colspan="4" align="center" style="font-size:18px;">发货人签字：</td><td colspan="4" align="center" style="font-size:18px;">收款人签字： </td></tr>';
						html += '<tr><td colspan="8" height="10"></td></tr></tfoot></table></div>';
								
						$("#currentDataDiv").append(html);
						//直接打印
						prn1_print();
						//prn1_preview(); 
			}else{
				top.$.jBox.tip('系统错误', 'error');
	 			return false;
			}
		   }
		 });
		});

    	//直接打印功能
    	function prn1_print() {
       		PrintMytable();
       		LODOP.PRINT();
    	};
    	//预览功能
    	function prn1_preview() {
       		PrintMytable();
        	LODOP.PREVIEW();
    	};
    	//打印表格功能的实现函数
    	function PrintMytable() {
        	LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        	LODOP.PRINT_INIT("打印工作名称");
        	LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
        	LODOP.SET_PRINT_PAGESIZE(1,"210mm",argument,"");
        	LODOP.ADD_PRINT_TEXT(30, 320, 300, 30, "已发货汇总单");
        	LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        	LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        	LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        	LODOP.ADD_PRINT_TEXT(42, 630, 200, 22, "第#页/共&页");
        	LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        	LODOP.ADD_PRINT_TABLE(115, "0%", "100%","100%", document.getElementById("printdiv_b").innerHTML);
       		LODOP.ADD_PRINT_HTM(58, "0%", "100%", "100%", document.getElementById("printdiv_h").innerHTML);
        	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    	};		   
	});
</script>		
    </head>
    <body>
    <div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
       <div class="body-container">
       		<div id="currentDataDiv" action="resource" style="padding:10px 10px 0;">
       			<div class="btn-group pull-right">
            		<button  id="print" class="btn btn-danger">打印</button>
            	</div>
                <div class="form-group">
                    <label class="control-label">商品信息（当前汇总单所包含的商品）</label>
                </div>
	        </div>
	        <div style="clear:both;height:10px;font-size:10px;"></div>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>