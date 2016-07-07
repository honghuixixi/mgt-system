<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
   		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/order/productlist.jhtml?mergeNo='+${masNo},
					multiselect:false,
 					colNames:['商品编码','条码','商品名称','单位','数量','净价','小计'],
 					rowNum: 1000,
				   	colModel:[	 
						{name:'STK_C',width:30},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
					   	{name:'NET_PRICE', width:40,formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
					   	{name:'SUB', width:40,formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}}
				   	],
				});
			});
		</script>
	<script type="text/javascript">
	$().ready(function() {
	    var argument;//打印参数全局变量
    	var LODOP; //打印函数全局变量 
		//打印+预览按钮js
		$("#preview").click(function() {
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
				prn1_preview();	//打印预览+打印
			});
		//打印预览功能
    	function prn1_preview() {
       		PrintMytable();
        	LODOP.PREVIEW();
    	};
    	//打印功能
    	function prn1_print() {
       		PrintMytable();
        	LODOP.PRINT();
    	};
    	//打印表格功能的实现函数
    	function PrintMytable() {
        LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        LODOP.PRINT_INIT("打印工作名称");
        LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
        LODOP.SET_PRINT_PAGESIZE(1,2100,argument,"");
        LODOP.ADD_PRINT_TEXT(30, 330, 300, 30, "商品汇总单");
        LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        LODOP.ADD_PRINT_TEXT(42, 630, 200, 22, "第#页/共&页");
        LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        LODOP.ADD_PRINT_TABLE(60, "0%", "100%", argument, document.getElementById("printdiv_b").innerHTML);
        LODOP.SET_PRINT_STYLEA(0,"Vorient",3);	
    	};
 	}); 
</script>
    </head>
    <body>
       <div class="body-container">
       		<div id="currentDataDiv" action="resource" style="padding:10px 10px 0;">
       			<div class="btn-group pull-right">
					<button  id="preview" class="btn btn-red">
						打印
					</button>
				</div>
	            <div class="form-group">
	                <label class="control-label">商品信息（当前汇总单所包含的商品）</label>
	            </div>
	        </div>
	        <div style="clear:both;height:10px;font-size:10px;"></div>
		    <table id="grid-table" >
		    </table>
   		</div>
   	<!--打印订单预览div-->
	<div style="display:none"> 
		[#import "/function/mgt/order/supOrderMacro.ftl" as supOrder]
		[@supOrder.SupOrderPrint supPrint=order /]    
	</div>
	<!--打印+预览按钮div-->
	<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>