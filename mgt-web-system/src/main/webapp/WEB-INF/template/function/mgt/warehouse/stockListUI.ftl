<!DOCTYPE html>
<html lang="zh-cn">
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
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"A/R"};
				mgt_util.jqGrid('#grid-table',{
				postData: postData,
					url:'${base}/warehouse/stockList.jhtml',
 					colNames:['ID','备货单号','类型','发货方','收货方','状态','制单时间','操作'],
 					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:30,hidden:true,key:true},
				   		{name:'MAS_NO_CHAR',align:"center",width:110},
				   		{name:'MAS_CODE',width:80,align:"center",formatter:function(data){
							if(data=='WHVNDIN'){
								return '供应商补货';
							}else if(data=='WHVNDOUT'){
								return '供应商退货';
							}else if(data=='WHTRNOUT'){
								return '调拨发出';
							}else if(data=='WHTRNIN'){
								return '调拨接收';
							}else{
								return data;
	   					}}},
				   		{name:'FROM_ACC_NAME',align:"center",width:80},
				   		{name:'TO_ACC_NAME',align:"center",width:80},
				   		{name:'STATUS_FLG',width:50,align:"center",formatter:function(data){
							if(data=='A'){
								return '活动的';
							}else if(data=='R'){
								return '已确认';
							}else if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已收货';
							}else{
								return data;
	   					}}},
				   		{name:'MAS_DATE_CHAR',align:"center",width:90},
				   		{name:'', width:140,align:"center",formatter:function(value,row,index){
								if(index.STATUS_FLG =='A'){
									var others = '<button type=button class="btn btn-info edit" onclick=statusFlg("'+index.PK_NO+'","R","确认")>确认</button>&nbsp;'
										  		+'<button type=button class="btn btn-info edit" onclick=deleWhIoMas("'+index.PK_NO+'","'+index.STATUS_FLG+'","删除")>删除</button>';
									if(index.MAS_CODE =='WHVNDIN'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/editStkMas.jhtml?vCode='+index.FROM_ACC_CODE+'&masCode='+index.MAS_CODE+'&">编辑明细 </button>&nbsp;'+others;
									}else if(index.MAS_CODE =='WHVNDOUT'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/editStkMas.jhtml?vCode='+index.TO_ACC_CODE+'&masCode='+index.MAS_CODE+'&">编辑明细 </button>&nbsp;'+others;
									}else if(index.MAS_CODE =='WHTRNOUT'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/editStkMas.jhtml?wCode='+index.TO_ACC_CODE+'&masCode='+index.MAS_CODE+'&">编辑明细 </button>&nbsp;'+others;
									}else{
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/editStkMas.jhtml?wCode='+index.FROM_ACC_CODE+'&masCode='+index.MAS_CODE+'&">编辑明细 </button>&nbsp;'+others;
									}
								}
								if(index.STATUS_FLG =='R'){
									if(index.FLG =='A/R'){
										return '<button type=button class="btn btn-info edit" onclick=statusFlg("'+index.PK_NO+'","A","撤销")>撤销</button>&nbsp;'
											 + '<button type=button class="btn btn-info edit" onclick=directPrint("'+index.PK_NO+'")>打印 </button>';
									}else{
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/detailStkMas.jhtml?vCode='+index.FROM_ACC_CODE+'&statusFlg='+"R"+'&masCode='+index.MAS_CODE+'&">明细 </button>&nbsp;'
										  	  +'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/whReceOrDeliver.jhtml?statusFlg='+"D"+'&vCode='+index.FROM_ACC_CODE+'&masCode='+index.MAS_CODE+'&whC='+index.TO_ACC_CODE+'&">发货</button>&nbsp;';
									}
								}
								if(index.STATUS_FLG =='D'){
									return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/detailStkMas.jhtml?vCode='+index.FROM_ACC_CODE+'&statusFlg='+"D"+'&masCode='+index.MAS_CODE+'&">明细 </button>&nbsp;'
										  +'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/whReceOrDeliver.jhtml?statusFlg='+"P"+'&vCode='+index.FROM_ACC_CODE+'&masCode='+index.MAS_CODE+'&whC='+index.TO_ACC_CODE+'&">收货</button>&nbsp;';
								}
								if(index.STATUS_FLG =='P'){
									return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/warehouse/detailStkMas.jhtml?vCode='+index.FROM_ACC_CODE+'&statusFlg='+"P"+'&masCode='+index.MAS_CODE+'&">明细 </button>'
											+ '<button type=button class="btn btn-info edit" onclick=directPrintFinish("'+index.PK_NO+'")>打印 </button>';;
								}
								else{
									return '';
								}
							}
						}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 				   	
				});
				
			});
			
			//确认补货单，取消补货单(单据没有商品时不能确认)
			function statusFlg(pkNo,statusFlg,message){
			 $.jBox.confirm("确认操作吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				url:'${base}/warehouse/statusFlg.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'pkNo':pkNo,
				'statusFlg':statusFlg,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						top.$.jBox.tip('操作成功！', 'success');
						top.$.jBox.refresh = true;
						$('#grid-table').trigger("reloadGrid");
					}else if(data.code==002){
						top.$.jBox.tip('请先添加商品！', 'error');
			 			return false;
					}else{
						top.$.jBox.tip('操作失败！', 'error');
			 			return false;
					}
				  }
				});	
			   }
			  });
			}
						
			//删除备货单记录
			function deleWhIoMas(pkNo,statusFlg,message){
			 $.jBox.confirm("确认删除吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				url:'${base}/warehouse/deleWhIo.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'pkNo':pkNo,
				'statusFlg':statusFlg,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
					top.$.jBox.tip('删除成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table').trigger("reloadGrid");
					}else{
					top.$.jBox.tip('删除失败！', 'error');
			 			return false;
					}
					}
				});	
			   }
			  });
			}	
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form"> 
					<div class="control-group sub_status">
						<div class="form-group sr-only" >
		                    <select class="form-control" name="statusFlg">
		                        <option value="A/R">待确认备货单</option>
		                        <option value="D/R">待处理备货单</option>
		                        <option value='P'>完成的备货单</option>
		                    </select>
	                	</div>
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="A/R" class="sub_status_but active"><a>待确认备货单</a></li>
							<li role="presentation" id="D/R" class="sub_status_but"><a>待处理备货单</a></li>
							<li role="presentation" id="P" class="sub_status_but"><a>完成的备货单</a></li>
						</ul>
					 </div>
					 <div class="currentDataDiv_tit">
						<button type="button" class="btn_divBtn add" id="whstk_build" data-toggle="jBox-win" href="${base}/warehouse/buildWhIoMas.jhtml">新建 </button>
					 </div>	
	            <div class="form_divBox" style="display:block;">
	            	<div class="form-group" style="float:left;margin-right:0;">
						<label class="control-label">
							仓库：
						</label>
		                <select data-placeholder="请选择仓库" class="form-control" name="whC" id="whC">
		                	<option value=''>请选择仓库...</option>
		                </select>
		            </div>
					<div class="form-group" style="float:left;margin-right:0;" >
						<label class="control-label">备货单号</label>
						<input type="text" class="form-control" name="masNo" style="width:120px;">
					</div>
					<div class="form-group" style="float:left;margin-right:0;">
						<label class="control-label">开始时间</label>
						<input type="text" class="form-control" name="startDate" id="startDate" style="width:80px;" onfocus="WdatePicker();" >
					</div>
					<div class="form-group" style="float:left;margin-right:0;">
						<label class="control-label">结束时间</label>
						<input type="text" class="form-control" name="endDate" style="width:80px;"    onClick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}'})" >
					</div>
					<div class="search_cBox">
						<button type="button" class="search_cBox_btn" id="stock_search" data-toggle="jBox-query">搜 索 </button>
					</div>
				</div>
	            </form>
	        </div>
	      <div id="currentPrint">
	      </div>	        
	      </div>
	      <div style="clear:both;"></div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	// 控制“新建”按钮
	    	if("A/R" == $(this).attr("id")){
	    		$("button#whstk_build").removeClass("sr-only");
	    	}else{
	    		$("button#whstk_build").addClass("sr-only");
	    	}
	    	// 切换table时， 清空搜索框  masNo
	    		$("input[name=masNo]").val('');
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#stock_search").click(); 
	    });
	    
	   	//加载登录用户相关的仓库列表  
			$.ajax({
				url: "${base}/warehouse/selectOptions.jhtml",
				type: "GET",
				dataType: "json",
				cache: false,
				async: false,
				success: function(data) {
					//循环添加发货地址options
					$.each(data.whoptions, function(value, name) {
						$('#whC').append("<option value='"+value+"'>"+name+"</option>"); 
					});
		 		}
			});
	});
</script> 
<script type="text/javascript">	
	    var argument='297mm';//打印参数全局变量,纸高
    	var LODOP; //打印函数全局变量 
    	var type=''; //打印类型

    	//打印功能
    	function prn1_print(type) {
       		PrintMytable(type);
        	LODOP.PRINT();
    	};
    	//预览功能
    	function prn1_preview(type) {
       		PrintMytable(type);
        	LODOP.PREVIEW();
    	};
    	//打印表格功能的实现函数
    	function PrintMytable(type) {
        LODOP = getLodop(document.getElementById('LODOP'), document.getElementById('LODOP_EM'));
        LODOP.PRINT_INIT("打印工作名称");
        LODOP.SET_PRINT_PAGESIZE(3, 0, 0, "A4");
        LODOP.ADD_PRINT_TEXT(30, 330, 300, 30, type+"单");
        LODOP.SET_PRINT_STYLEA(1, "ItemType", 1);
        LODOP.SET_PRINT_STYLEA(1, "FontSize", 16);
        LODOP.SET_PRINT_STYLEA(1, "Bold", 1);
        LODOP.ADD_PRINT_TEXT(46, 630, 200, 22, "第#页/共&页");
        LODOP.SET_PRINT_STYLEA(2, "ItemType", 2);
        LODOP.ADD_PRINT_TABLE(115, "0%", "100%","100%", document.getElementById("printdiv_b").innerHTML);
       	LODOP.ADD_PRINT_HTM(58, "0%", "100%", "100%", document.getElementById("printdiv_h").innerHTML);
        LODOP.SET_PRINT_STYLEA(0,"Vorient",3);	
    	};
    	
     //以下为页面加载"待确认备货单"打印数据			
     function directPrint(id){
		$.ajax({
			url:'${base}/vendor/getAjaxDetail.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{
				'pkNo':id,
			},
			error : function(data) {
				alert("网络异常");
				return false;
			},
			success : function(data) {
				var html = '';
				$("#currentPrint").html('');
				if("WHVNDIN"==data.order.masCode){
						type = '供应商补货';
					}else if("WHVNDOUT"==data.order.masCode){
						type = '供应商退货';
					}else if("WHTRNOUT"==data.order.masCode){
						type = '调拨发出';
					}else{
						type = '调拨接收';
					}
				if(data.message.type == "success"){
					html += '<div id="printdiv_h"';
					html +='" style="display:none">';
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">';
					html += '<tbody><tr><td colspan="3" align="center">(www.11wlw.cn)</td></tr><tr><td style="text-align:left;float: left;" width="50%">单据编号：';
					html += data.order.masNo;
					html += '</td><td style="text-align:left;float: left;" width="50%">单据日期：';
					var date = (new Date(parseFloat(data.order.masDate))).format("yyyy-MM-dd hh:mm:ss")
					html += date;
					html += '</td></tr><tr><td style="text-align:left;float: left;" width="37%">发&nbsp;&nbsp;货&nbsp;&nbsp;方：';
					html += data.order.fromAccName;
					html += '</td>';
					html += '<td colspan="3" align="left">收货方：';
					html += data.order.toAccName;
					html += '</td></tr></tbody></table></div>';				
				
					html += '<div id="printdiv_b"';
					html +='" style="display:none">';					
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
					html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
					html += '<th align="center"style="border:1px solid #000; border-right:none 0;">编号</th>';
     				html += '<th align="center"style="border:1px solid #000; border-right:none 0;">商品编码</th>';
    				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">条码</th>';
     				html += '<th align="center" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">单位</th>';
    				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">请求数量</th>';
    				html += '<th align="center" style="border:1px solid #000;">发货数量</th></tr></thead><tbody>';
    				
    				$.each(data.item,function(n, item) {
    					html += '<tr height="15" bgColor="#ffffff">';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += n+1;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_C;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					if(""==item.PLU_C) {
							html += item.STK_C;
						} else {
							html += item.PLU_C;
						}
    					html += '</td>';
    					html += '<td align="left" colspan="2"style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_NAME;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.UOM;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_QTY;
    					html += '</td>';
  						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += '</td>';  					
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += '</td></tr>';
					}); 
    					html += '</tbody><tfoot><tr><td colspan="8" height="10"></td></tr>';
    					html += '<tr><td colspan="4" align="center" style="font-size:18px;">发货方签字：</td><td colspan="4" align="center" style="font-size:18px;">收货方签字： </td></tr>';
						html += '<tr><td colspan="8" height="10"></td></tr></tfoot></table></div>';
					$("#currentPrint").append(html);
					$().ready(function() {
						//prn1_preview(type);
						prn1_print(type);
					});
				}else{
					top.$.jBox.tip('系统错误', 'error');
	 				return false;
				}
			}
		});	
  }
     //以下为页面加载“完成的备货单”打印数据			
     function directPrintFinish(id){
		$.ajax({
			url:'${base}/vendor/getAjaxDetail.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{
				'pkNo':id,
			},
			error : function(data) {
				alert("网络异常");
				return false;
			},
			success : function(data) {
				var html = '';
				$("#currentPrint").html('');
				if("WHVNDIN"==data.order.masCode){
						type = '供应商补货';
					}else if("WHVNDOUT"==data.order.masCode){
						type = '供应商退货';
					}else if("WHTRNOUT"==data.order.masCode){
						type = '调拨发出';
					}else{
						type = '调拨接收';
					}				
				if(data.message.type == "success"){
					html += '<div id="printdiv_h"';
					html +='" style="display:none">';
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">';
					html += '<tbody><tr><td colspan="3" align="center">(www.11wlw.cn)</td></tr><tr><td style="text-align:left;float: left;" width="50%">单据编号：';
					html += data.order.masNo;
					html += '</td><td style="text-align:left;float: left;" width="50%">单据日期：';
					var date = (new Date(parseFloat(data.order.masDate))).format("yyyy-MM-dd hh:mm:ss")
					html += date;
					html += '</td></tr><tr><td style="text-align:left;float: left;" width="37%">发&nbsp;&nbsp;货&nbsp;&nbsp;方：';
					html += data.order.fromAccName;
					html += '</td>';
					html += '<td colspan="3" align="left">收货方：';
					html += data.order.toAccName;
					html += '</td></tr></tbody></table></div>';				
				
					html += '<div id="printdiv_b"';
					html +='" style="display:none">';					
					html += '<table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">';
					html += '<thead><tr bgcolor="#F8F8FF" border="1" height="18" >';
					html += '<th align="center"style="border:1px solid #000; border-right:none 0;">编号</th>';
     				html += '<th align="center"style="border:1px solid #000; border-right:none 0;">商品编码</th>';
    				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">条码</th>';
     				html += '<th align="center" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">单位</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">请求数量</th>';
     				html += '<th align="center" style="border:1px solid #000; border-right:none 0;">发货数量</th>';
    				html += '<th align="center" style="border:1px solid #000;">收货数量</th></tr></thead><tbody>';
    				
    				$.each(data.item,function(n, item) {
    					html += '<tr height="15" bgColor="#ffffff">';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += n+1;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_C;
    					html += '</td>';
    					html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					if(""==item.PLU_C) {
							html += item.STK_C;
						} else {
							html += item.PLU_C;
						}
    					html += '</td>';
    					html += '<td align="left" colspan="2"style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_NAME;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.UOM;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.STK_QTY;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.QTY1;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += item.QTY2;
    					html += '</td>';
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">';
    					html += '</td></tr>';
					}); 
    					html += '</tbody><tfoot><tr><td colspan="8" height="10"></td></tr>';
    					html += '<tr><td colspan="4" align="center" style="font-size:18px;">发货方签字：</td><td colspan="4" align="center" style="font-size:18px;">收货方签字： </td></tr>';
						html += '<tr><td colspan="8" height="10"></td></tr></tfoot></table></div>';
					$("#currentPrint").append(html);
					$().ready(function() {
						//prn1_preview(type);
						prn1_print(type);
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