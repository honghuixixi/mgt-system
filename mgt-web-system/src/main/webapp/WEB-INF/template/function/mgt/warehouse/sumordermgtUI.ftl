<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>汇总单仓库管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"D",masCode:'VNMERGE,WHMERGE'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/sumorderlist.jhtml',
 					colNames:['','汇总单号','供应商','状态','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'ACC_NAME',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else{
								return data;
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/getdelivereddetail.jhtml'>明细 </button>";
							detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/receive.jhtml'>收货</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="control-group sub_status" style="position:relative;">
					<ul class="nav nav-pills" role="tablist">
						<li role="presentation" id="X" class="sub_status_but active"><a> 待接收汇总单</a></li>					
						<li role="presentation" id="ORDER" class="sub_status_but"><a> 待合并订单</a></li>						
						<li role="presentation" id="R" class="sub_status_but"><a> 待发货汇总单</a></li>
						<li role="presentation" id="D" class="sub_status_but"><a> 已发货汇总单</a></li>
						<li role="presentation" id="P" class="sub_status_but"><a>已完成汇总单</a></li>
					</ul>
				</div>
                <div class="currentDataDiv_tit" style="border:none;margin-bottom:0;">
					<button type="button" class="btn_divBtn sr-only edit"  id="order_combine" data-toggle="jBox-change-order"  href="${base}/order/mergeorder.jhtml?type=B" >合并订单 </button>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" style=" overflow:hidden" id="query-form"> 
		            	 <div id="finishSt" class="" style="padding-top:0px;">
							<div class="form-group" id="custCodesDiv">
								<label class="control-label">供应商：</label>
								<input type="text" class="form-control digits" id="accName"  name="accName" maxlength=32 />
							</div>
						</div>
						<div class="search_cBox">
							<button type="button" class="search_cBox_btn" data-toggle="jBox-query" >搜 索</button>
						</div>
		            </form>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
   		</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {
		
		$("div.currentDataDiv_tit").hide();
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	// 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("ORDER" == $(this).attr("id")){
	    		$("div.currentDataDiv_tit").show();
	    		$("button#order_combine").removeClass("sr-only");
	    		$("div.form_divBox").hide();
	    	}else{
	    		$("div.form_divBox").show();
	    		$("div.currentDataDiv_tit").hide();
	    		$("button#order_combine").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("button#order_print").addClass("sr-only");
	    	$("button#order_deliver").addClass("sr-only");
	    	$("select[name=subStatus]").val("");
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	        
	        var idVal=$(this).attr('id');
  			$('#grid-table').GridUnload();//重绘
	    	if(idVal=='ORDER'){
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
								return '未发货';
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
						} 
					} 
				});	    	
	    	}else{
	    		var mc = '';
		    	if(idVal == 'X'){
		    		idVal = 'D';
		    		mc = 'VNMERGE,WHMERGE';
		    	}else if(idVal == 'P'){
		    		mc = 'VNMERGE,WHMERGE';
		    	}else{
		    		mc = 'WHMERGE';
		    	}
	    		var postData={orderby:'CREATE_DATE',statusFlg:idVal,masCode:mc};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/sumorderlist.jhtml',
 					colNames:['','汇总单号','汇总单类型','发货方','收货方','状态','操作'],
 					width:999,
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'MAS_CODE',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='VNMERGE'){
								return '供应商汇总单';
							}else if(data=='WHMERGE'){
								return '仓库汇总单';
							}else {
								return '';
							}
	   					}},
				   		
				   		{name:'ACC_NAME',align:"center",width:180},
				   		{name:'WH_NAME',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已收货';
							}else if(data=='R'){
								return '待发货';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:180,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var detail = '';
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.STATUS_FLG == '已发货'){
								if(mc == 'WHMERGE'){
																	detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/getdelivereddetail.jhtml'>明细 </button>";
								detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/order/cancelmerge.jhtml?type=B'>撤销</button>";
								}else{
									detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/getdelivereddetail.jhtml'>明细 </button>";
									detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/warehouse/receive.jhtml'>收货</button>";
								}
							}else if(rowData.STATUS_FLG == '待发货'){
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/getdelivereddetail.jhtml'>明细 </button>";
								detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/deliver.jhtml'>发货</button>";
							}else if(rowData.STATUS_FLG == '已收货'){
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/order/getfinisheddetail.jhtml'>明细 </button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
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
	    	
	        $("select[name=subStatus]").val($(this).val());
	        $("#warehouse_sumsearch").click(); 
	    });
	});
</script>
</html>