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
				var postData={orderby:"MAS_NO",statusFlg:"D",masCode:'VNRMERGE'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/returnmergeorder/returnmergeorderlist.jhtml',
 					colNames:['','汇总单号','退货仓库','仓库地址','状态','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'WH_NAME',align:"center",width:180},
				   		{name:'ADDRESS1',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已完成';
							}else if(data=='R'){
								return '已确认';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/returnmergeorder/returnmergeorderdetailUI.jhtml'>明细 </button>";
							detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/returnmergeorder/receive.jhtml'>接收</button>";
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
						<li role="presentation" id="A" class="sub_status_but active"><a> 待接收退单</a></li>					
						<li role="presentation" id="C" class="sub_status_but"><a> 待退货汇总单</a></li>
						<li role="presentation" id="D" class="sub_status_but"><a>已完成退单</a></li>
					</ul>
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
	    	if(idVal=='A'){
	    		$('#grid-table').GridUnload();//重绘
	    		var postData={orderby:"MAS_NO",statusFlg:"D",masCode:'VNRMERGE'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/returnmergeorder/returnmergeorderlist.jhtml',
 					colNames:['','汇总单号','退货仓库','仓库地址','状态','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'WH_NAME',align:"center",width:180},
				   		{name:'ADDRESS1',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已完成';
							}else if(data=='R'){
								return '已确认';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/returnmergeorder/returnmergeorderdetailUI.jhtml'>明细 </button>";
							detail =detail +"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-change-order' href='${base}/returnmergeorder/receive.jhtml'>接收</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
	    	}else if(idVal=='C'){
	    		$('#grid-table').GridUnload();//重绘
	    		var postData={orderby:"MAS_NO",statusFlg:"P",masCode:'VNMERGE',type:'C'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/returnmergeorder/returnmergeorderlist.jhtml',
 					colNames:['','日期','汇总单号','单据类型','发货方编码','发货方名称','收货方编码','收货方名称','状态','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_DATE1',align:"center",width:100},
				   		{name:'MAS_NO',align:"center",width:100},
				   		{name:'MAS_CODE',align:"center",width:80,editable:true,formatter:function(data){
							if(data=='WHRMERGE'){
								return '仓库退货单';
							}else{
								return '供应商退货单';
							}
	   					}},
	   					{name:'DEST_WH_C',align:"center",width:80},
	   					{name:'WH_NAME',align:"center",width:180},
				   		{name:'ACC_CODE',align:"center",width:80},
				   		{name:'ACC_NAME',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已完成';
							}else if(data=='R'){
								return '已确认';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:180,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/returnmergeorder/returnmergeorderinfoUI/Y.jhtml'>查看差异</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});	
	    	}else if(idVal=='D'){
	    		$('#grid-table').GridUnload();//重绘
	    		var postData={orderby:"MAS_NO",statusFlg:"P",masCode:'WHRMERGE,VNRMERGE',type:'D'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/returnmergeorder/returnmergeorderlist.jhtml',
 					colNames:['','日期','汇总单号','单据类型','发货方编码','发货方名称','收货方编码','收货方名称','状态','操作'],
 					rowNum:1000,
 					rowList:[],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'MAS_DATE1',align:"center",width:80},
				   		{name:'MAS_NO',align:"center",width:80},
				   		{name:'MAS_CODE',align:"center",width:80,editable:true,formatter:function(data){
							if(data=='WHRMERGE'){
								return '仓库退货单';
							}else{
								return '供应商退货单';
							}
	   					}},
	   					{name:'DEST_WH_C',align:"center",width:180},
	   					{name:'WH_NAME',align:"center",width:180},
				   		{name:'ACC_CODE',align:"center",width:180},
				   		{name:'ACC_NAME',align:"center",width:180},
				   		{name:'STATUS_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='D'){
								return '已发货';
							}else if(data=='P'){
								return '已完成';
							}else if(data=='R'){
								return '已确认';
							}
	   					}},
				   		{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/returnmergeorder/returnmergeorderdetailUI.jhtml'>明细 </button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
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