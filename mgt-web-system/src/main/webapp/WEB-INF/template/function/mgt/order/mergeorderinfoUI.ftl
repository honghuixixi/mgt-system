<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"R"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/gatherList.jhtml',
 					colNames:['','汇总单号','目标仓库','地址','状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'WH_NAME',align:"center",width:80},
				   		{name:'LOC_NO',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='R'){
								return '已确认';
							}else if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已收货';
							}else if(data=='C'){
								return '已取消';
							}else{
								return data;
							}
	   					}},
				   		{name:'', width:140,align:"center",formatter:function(value,row,index){
									if(index.STATUS_FLG =='R'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/getDetail.jhtml">明细 </button>&nbsp;'+'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/deliver.jhtml">发货</button>&nbsp;'+'<button type=button class="btn btn-info edit" onclick=directPrint("'+index.PK_NO+'")>打印</button>';
									}
									if(index.STATUS_FLG=='D'){
										return '<button type=button class="btn btn-info del" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/getdelivereddetail.jhtml">明细</button>&nbsp;'+'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-change-order" href="${base}/order/cancelmerge.jhtml">撤销</button>';
									}
									if(index.STATUS_FLG=='P'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/getfinisheddetail.jhtml">明细</button>';
									}
									else{
									return '';
								}
							}
						} 
				   	],
				});
			});
		</script>
    </head>
    <body>
    <div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
       <div class="body-container">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
					<div class="form-group sr-only" >
	                    <label class="control-label">订单状态</label>
	                    <select class="form-control" name="statusFlg">
	                        <option value="">全部</option>
	                        <option value="R">待发货汇总单</option>
	                        <option value="D">已发货汇总单</option>
	                        <option value='P'>已完成汇总单</option>
	                    </select>
	                </div>
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="R" class="sub_status_but active"><a href="#">待发货汇总单</a></li>
							<li role="presentation" id="D" class="sub_status_but"><a href="#">已发货汇总单</a></li>
							<li role="presentation" id="P" class="sub_status_but"><a href="#">已完成汇总单</a></li>
						</ul>
					</div>
					<div class="form-group">
	                 	<button type="button" class="btn btn-info sr-only" id="gather_list" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
    
<script type="text/javascript">
	$(document).ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#gather_list").click();
	    });
	});
</script>
<script type="text/javascript">	
	    var argument=1000;//打印参数全局变量,纸高
    	var LODOP; //打印函数全局变量 

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
        LODOP.ADD_PRINT_TABLE(60, "0%", "100%", "100%", document.getElementById("printdiv_b").innerHTML);
        LODOP.SET_PRINT_STYLEA(0,"Vorient",3);	
    	};
    	
     //以下为页面加载打印数据			
     function directPrint(pkNo){
		$.ajax({
			url:'${base}/order/getAjaxDetail.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{
				'pkNo':pkNo,
			},
			error : function(data) {
				alert("网络异常");
				return false;
			},
			success : function(data) {
				var html = '';
				if(data.message.type == "success"){
					html += '<div id="printdiv_b" style="display:none">';
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
					html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
					html += '<th align="center"style="border:1px solid #000; border-right:none 0;">编号</th>';
     				html += '<th align="center"style="border:1px solid #000; border-right:none 0;">商品编码</th>';
    				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">条码</th>';
     				html += '<th align="center" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">单位</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">数量</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">净价</th>';
    				html += '<th align="center" style="border:1px solid #000;">小计</th></tr></thead><tbody>';
    				
    				$.each(data.order.orderItem,function(n, order) {
    					html += '<tr height="15" bgColor="#ffffff">';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += n+1;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += order.STK_C;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					if(""==order.PLU_C) {
							html += Item.STK_C;
						} else {
							html += order.PLU_C;
						}
    					html += '</td>';
    					html += '<td align="left" colspan="2"style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += order.STK_NAME;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += order.UOM;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += order.STK_QTY;
    					html += '</td>';
						html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">'+currency_0(order.NET_PRICE,true)+'</td>';
						html += '<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    					html += currency_0(order.NET_PRICE * order.STK_QTY,true);
    					html += '</td></tr>';
					}); 
    					html += '</tbody></table></div> ';
					$("#currentDataDiv").append(html);
					$().ready(function() {	
						prn1_preview();
					});
				}else{
					top.$.jBox.tip('系统错误', 'error');
	 				return false;
				}
			}
		});	
  }
</script>
</html>