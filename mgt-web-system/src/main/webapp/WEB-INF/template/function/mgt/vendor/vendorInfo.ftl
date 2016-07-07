<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-备货管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"A"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendor/list.jhtml',
 					colNames:['','备货单号','类型','发货方','收货方','状态','日期','操作'],
 					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:150},
				   		{name:'MAS_CODE',align:"center",width:100,editable:true,formatter:function(data){
							if(data=='WHVNDIN'){
								return '供应商补货';
							}else if(data=='WHVNDOUT'){
								return '供应商退货';
							}else if(data=='WHTRNOUT'){
								return '调拨发出';
							}else if(data=='WHTRNIN'){
								return '调拨接收';
							}
	   					}},
				   		{name:'FROM_ACC_NAME',align:"center",width:180},
				   		{name:'TO_ACC_NAME',align:"center",width:180},
				   		{name:'STATUS_FLG',align:"center",width:80,editable:true,formatter:function(data){
							if(data=='A'){
								return '活动的';
							}else if(data=='D'){
								return '已发货';
							}else if(data=='R'){
								return '已确认';
							}else if(data=='P'){
								return '已收货';
							}
	   					}},
				   		{name:'CREATE_DATE',align:"center",width:180,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }},
				   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.STATUS_FLG=='已收货'){
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/vendor/getVendorDetailUI.jhtml'>明细 </button>";
							}else if(rowData.MAS_CODE=='供应商补货'&&rowData.STATUS_FLG=='已发货'){
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/vendor/getVendorDetailUI.jhtml'>明细 </button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='editStatus("+id+");'>撤销</button>";
							}else{
							
							if(rowData.MAS_CODE=='供应商补货'&&rowData.STATUS_FLG=='已确认'){	//发货
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' onclick='directPrint("+id+");'>打印 </button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/vendor/vendorDetailUI.jhtml'>发货</button>";
							}else if(rowData.MAS_CODE=='供应商退货'&&rowData.STATUS_FLG=='已发货'){//退货
							detail ="<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show' href='${base}/vendor/getVendorDetailUI.jhtml'>明细 </button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show' href='${base}/vendor/vendorDetailUI.jhtml'>收货</button>";
							}else{
							detail;
							}
							
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
				
					$("#searchbtn").click(function(){
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
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form">      
				    <div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="A" class="sub_status_but active"><a href="#"> 待送货订单</a></li>					
							<li role="presentation" id="D" class="sub_status_but"><a href="#"> 已送货订单</a></li>						
							<li role="presentation" id="P" class="sub_status_but"><a href="#"> 已接收订单</a></li>
						</ul>
				    </div>			
				    <div class="form-group sr-only" >
	                    <label class="control-label">订单状态</label>
	                    <select class="form-control" name="statusFlg">
	                        <option value="">全部</option>
	                        <option value="A">活动的</option>
	                        <option value="R">已确认</option>
	                        <option value='D'>已发货</option>
	                        <option value='P'>已收货</option>
	                    </select>
	                </div>
	                <div id="finishSt" class="sr-only">
	                	<div class="form_divBox" style="display:block;">
							<div class="form-group">
								<label class="control-label">订单编号</label>
								<input type="text" class="form-control" name="masNo" style="width:120px;">
							</div>
							<div class="form-group">
								<label class="control-label">开始时间</label>
								<input type="text" class="form-control" id="startDate" name="startDate" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
							</div>
							<div class="form-group">
								<label class="control-label">结束时间</label>
								<input type="text" class="form-control" id="endDate" name="endDate" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
							</div>
						</div>
						<div class="search_cBox">
							<button style="margin-top:8px;" type="button" class="btn_divBtn" id="order_search" data-toggle="jBox-query">搜 索 </button>
						</div>
					</div>
	            </form>
	        </div>
	      </div>    
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("P" == $(this).attr("id")){
	    		$(".click_form").removeClass("sr-only");
	    		$("#finishSt").removeClass("sr-only");
	    	}else{
	    		$(".click_form").addClass("sr-only");
	    		$("#finishSt").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#order_search").click(); 
	    });
	});
		//供应商备货管理--撤销
		function editStatus(id){
			 $.jBox.confirm("确认撤销吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				 url:'${base}/vendor/revocation.jhtml',
				 sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'pkNo':id
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
					top.$.jBox.tip('撤销成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table').trigger("reloadGrid");
					}
					else{
					top.$.jBox.tip('撤销失败！', 'error');
			 			return false;
					}
				}
			});	
		}
	  });
	}
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
    	function PrintMytable() {
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
    	
     //以下为页面加载打印数据			
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
					html += '<tbody><tr><td colspan="3" align="center">(www.qpwa.cn)</td></tr><tr><td style="text-align:left;float: left;" width="50%">单据编号：';
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
    				html += '<th align="center" style="border:1px solid #000;">实发数量</th></tr></thead><tbody>';
    				
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
						html += '<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">';
    					html += '</td></tr>';
					}); 
    					html += '</tbody><tfoot><tr><td colspan="8" height="10"></td></tr>';
    					html += '<tr><td colspan="4" align="center" style="font-size:18px;">发货方签字：</td><td colspan="4" align="center" style="font-size:18px;">收货方签字： </td></tr>';
						html += '<tr><td colspan="8" height="10"></td></tr></tfoot></table></div>';
					$("#currentDataDiv").append(html);
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