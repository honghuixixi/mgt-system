<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-供应商订单管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"WAITDELIVER,WAITPAYMENT"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/supplierlist.jhtml',
 					colNames:['','订单编号','状态','订单金额','目标仓库','下单日期','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '未接受';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='RETURNSING'){
								return '退单中';
							}else if(data=='SUCCESS'){
								return '交易成功';
							}else if(data=='CLOSE'){
								return '交易关闭';
							}else if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='WAITPAYMENT'){
								return '待支付';
							}else{
								return data;
							}
	   					}},
				   		{name:'AMOUNT',width:100,align:"left", editable:true, formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   		{name:'WMNAME',align:"center",width:320},
				   		{name:'OM_CREATE_DATE',width:150,align:"center", editable:true},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/orderDetailUI.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});

				$("#order_search").click(function(){
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
	            <form class="form form-inline queryForm" style=" overflow:hidden" id="query-form"> 
	                <div class="form-group sr-only" >
	                    <label class="control-label">订单编号</label>
	                    <input type="text" class="form-control" name="masNo" style="width:120px;">
	                </div>
	                <div class="form-group sr-only" >
	                    <label class="control-label">订单状态</label>
	                    <select class="form-control" name="statusFlg">
	                        <option value="">全部</option>
	                        <option value="WAITDELIVER">待发货</option>
	                        <option value="INPROCESS">处理中</option>
	                        <option value='DELIVERED'>已发货</option>
	                        <option value='RETURNSING'>退单中</option>
	                        <option value='SUCCESS'>交易成功</option>
	                        <option value='CLOSE'>交易关闭</option>
	                    </select>
	                </div>
	                
	                <div class="form-group sr-only" >
	                    <label class="control-label">订单状态</label>
	                    <select class="form-control" name="subStatus">
	                        <option value="">全部</option>
	                        <option value="WAITPRINT">待打印</option>
	                        <option value="WAITDELIVER">待发货</option>
	                        <option value='DELIVERED'>已发货</option>
	                    </select>
	                </div>

					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="WAITDELIVER" class="sub_status_but active"><a href="#"> 待接受订单</a></li>					
							<li role="presentation" id="INPROCESS" class="sub_status_but"><a href="#"> 待处理订单</a></li>		
							<li role="presentation" id="R" class="sub_status_but"><a href="#">待发货汇总单</a></li>
							<li role="presentation" id="D" class="sub_status_but"><a href="#">已发货汇总单</a></li>
							<li role="presentation" id="P" class="sub_status_but"><a href="#">已完成汇总单</a></li>				
						</ul>
						<!--<div style="position:absolute; right:0; top:8px; float:right;">
							<button type="button" class="btn btn-info edit"  id="order_inprocess" data-toggle="jBox-change-order" href="${base}/order/editStatus.jhtml?type=VENDORCONFIRM" style="float:right; margin-left:5px; display:inline;">接收订单 </button>
							<button type="button" class="btn btn-info sr-only edit"  id="order_combine" data-toggle="jBox-change-order" href="${base}/order/mergeorder.jhtml?type=A" style="float:right; margin-left:5px; display:inline;">合并订单 </button>
							<div class="form-group">
								button type="button" class="btn btn-info sr-only edit"  id="order_cancel" data-toggle="jBox-change-order" href="${base}/order/cancelorder.jhtml" style="float:right; margin-left:5px; display:inline;">取消订单 </button>
							</div>
						</div>
						<div class="controls sr-only" style="margin-top:10px;">
							<label class="radio"><input type="radio" name="sub_status_radio" value="WAITPRINT" > 待打印</label>
							<label class="radio"><input type="radio" name="sub_status_radio" value="WAITDELIVER" > 待发货</label>
						</div>-->
					</div>
					
					<div class="currentDataDiv_tit">
						<button type="button" class="btn_divBtn edit"  id="order_inprocess" data-toggle="jBox-change-order" href="${base}/order/editStatus.jhtml?type=VENDORCONFIRM">接收订单 </button>
						<button type="button" class="btn_divBtn sr-only edit"  id="order_combine" data-toggle="jBox-change-order" href="${base}/order/mergeorder.jhtml?type=A">合并订单 </button>
						<div class="form-group" style="margin:0;padding:0;">
							<button type="button" class="btn_divBtn sr-only edit"  id="order_cancel" data-toggle="jBox-change-order" href="${base}/order/cancelorder.jhtml">取消订单 </button>
						</div>
					</div>
					
					<!--<div class="form-group">
	                 	<button type="button" class="btn btn-info sr-only" id="suporder_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>-->
	            </form>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("INPROCESS" == $(this).attr("id")){
	    		$("button#order_combine").removeClass("sr-only");
	    		$("button#order_cancel").removeClass("sr-only");
	    	}else{
	    		$("button#order_combine").addClass("sr-only");
	    		$("button#order_cancel").addClass("sr-only");
	    	}
	    	// 控制“接收订单”按钮
	    	if("WAITDELIVER" == $(this).attr("id")){
	    		$("button#order_inprocess").removeClass("sr-only");
	    	}else{
	    		$("button#order_inprocess").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("button#order_print").addClass("sr-only");
	    	$("button#order_deliver").addClass("sr-only");
	    	$("select[name=subStatus]").val("");
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);

			 
	          var idVal=$(this).attr('id');
  			$('#grid-table').GridUnload();//重绘
	    	if(idVal=='WAITDELIVER'||idVal=='INPROCESS'){
	    		$('#grid-table').GridUnload();//重绘
	    	var postData={orderby:'CREATE_DATE',statusFlg:idVal};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/supplierlist.jhtml',
 					colNames:['','订单编号','状态','订单金额','目标仓库','下单日期','操作'],
 					width:999,
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='WAITDELIVER'){
								return '未接受';
							}else if(data=='DELIVERED'){
								return '已发货';
							}else if(data=='RETURNSING'){
								return '退单中';
							}else if(data=='SUCCESS'){
								return '交易成功';
							}else if(data=='CLOSE'){
								return '交易关闭';
							}else if(data=='INPROCESS'){
								return '处理中';
							}else if(data=='WAITPAYMENT'){
								return '待支付';
							}else{
								return data;
							}
	   					}},
				   		{name:'AMOUNT',width:100,align:"left", editable:true, formatter:'currency', formatoptions:{decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: ""}},
				   		{name:'WMNAME',align:"center",width:320},
				   		{name:'OM_CREATE_DATE',width:150,align:"center", editable:true},
				   		{name:'detail',index:'PK_NO',width:120,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/orderDetailUI.jhtml'>明细 </button>";
							//detail = detail + "<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/order/cancelorder.jhtml'>取消 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
				   	
				});
	    	
	    	
	    	}else{

				var postData={orderby:"CREATE_DATE",statusFlg:idVal};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/order/gatherList.jhtml',
 					colNames:['','汇总单号','目标仓库','地址','状态','操作'],
 					width:999,
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
								return '已接受';
							}else if(data=='C'){
								return '已取消';
							}else{
								return data;
							}
	   					}},
				   		{name:'', width:140,align:"center",formatter:function(value,row,index){
									if(index.STATUS_FLG =='R'){
										return '<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/getDetail.jhtml">明细 </button>&nbsp;'+'<button type=button class="btn btn-info edit" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/deliver.jhtml">发货</button> <button type="button" class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","A")>撤销</button>';
									}
									if(index.STATUS_FLG=='D'){
										return '<button type=button class="btn btn-info del" id="'+index.PK_NO+'" data-toggle="jBox-show" href="${base}/order/getdelivereddetail.jhtml">明细</button>&nbsp;'+'<button type="button" class="btn btn-info edit" onclick=editStatusFlg("'+index.PK_NO+'","B")>撤销</button>';
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

	    	}

	    });

	    // 子状态单选框事件，改变隐藏域select值并提交表单
	    $('input[name=sub_status_radio]').on("click",function(){
	    	// 控制“打印”按钮
	    	if("WAITPRINT" == $(this).val()){
	    		$("button#order_print").removeClass("sr-only");
	    	}else{
	    		$("button#order_print").addClass("sr-only");
	    	}
	    	// 控制“发货”按钮
	    	if("WAITDELIVER" == $(this).val()){
	    		$("button#order_deliver").removeClass("sr-only");
	    	}else{
	    		$("button#order_deliver").addClass("sr-only");
	    	}
	    	
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        
	    });
	});
	
	function editStatusFlg(pkNo,type){
			 $.jBox.confirm("确认撤销吗?", "提示", function(v){
			 if(v == 'ok'){
				
			 $.ajax({
				 url:'${base}/order/cancelmerge.jhtml',
				 sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'id':pkNo,
				'type':type
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					top.$.jBox.tip('撤销成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table').trigger("reloadGrid");
				}
			});	
			}});
	}
</script>
</html>