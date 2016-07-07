<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>订单回款情况</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/layer/layer.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
		$(document).ready(function(){
			mgt_util.jqGrid('#grid-table',{
					url:'${base}/biOrderMas/selfInfo.jhtml',
					colNames:['ID','日期','配送员','订单编号','客户名称','订单金额','在线支付金额','实际结算金额','费用','预计实际到账时间','状态'],
					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
				   		{name:'',align:"center",width:40},
				   		{name:'MAS_NO',align:"center",width:85},
				   		{name:'CUST_NAME',align:"center",width:90},
				   		{name:'AMOUNT',align:"center",width:50},
				   		{name:'PAY_AMOUNT',align:"center",width:50},
				   		{name:'TRANAMOUNT',align:"center",width:47,formatter:function(data){
							if(data==null){
								return '';
							}else{
								return data;
							}}},
						{name:'TRANFEEAMOUNT',align:"center",width:47,formatter:function(data){
							if(data==null){
								return '';
							}else{
								return data;
							}}},
						{name:'PAY_TIME',align:"center",width:55,formatter:function(data){
							if(data==null){
								return '';
							}else{
								var date=new Date(data);
								return date.format('yyyy-MM-dd')
							}}},
				   		{name:'DISASM_STATE',width:40,align:"center"}
				   	],
			   	gridComplete:function(){ //循环为每一行添加业务事件 
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
				} 				   	
			});
		});
		
		function queryData(abnormal){
			 if($("#styleId").val()!=''){
				 $("#click"+$("#styleId").val()).css("color","blue");
			 }
			 $("#click"+abnormal).css("color","#f39801");
			 $("#styleId").val(abnormal);
			 
			 $("#isAbnormal").val(abnormal);
			 if(abnormal=="4"){
				 $('#grid-table').GridUnload();//重绘
				 if($("#isSelfOrder").val()=="1"){
					 mgt_util.jqGrid('#grid-table',{
							url:'${base}/biOrderMas/selfInfo.jhtml',
							postData:$("#query-form").serializeObjectForm(), //发送数据  
							colNames:['ID','日期','配送员','订单编号','客户名称','订单金额','状态'],
							multiselect:false,
						   	colModel:[
						   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
						   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
								}},
						   		{name:'',align:"center",width:40},
						   		{name:'MAS_NO',align:"center",width:85},
						   		{name:'CUST_NAME',align:"center",width:90},
						   		{name:'AMOUNT',align:"center",width:50},
						   		{name:'DISASM_STATE',width:40,align:"center", formatter:function(data){
									return '系统不结算';
								}}
						   	],
					   	gridComplete:function(){ //循环为每一行添加业务事件 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						} 				   	
					});
				 }else{
					 mgt_util.jqGrid('#grid-table',{
							url:'${base}/biOrderMas/shipForOrder.jhtml',
							postData: $("#query-form").serializeObjectForm(), //发送数据  
							colNames:['ID','日期','配送员','订单编号','卖家名称','订单金额','状态'],
							multiselect:false,
						   	colModel:[
						   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
						   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
								}},
						   		{name:'',align:"center",width:40},
						   		{name:'MAS_NO',align:"center",width:85},
						   		{name:'VENDOR_NAME',align:"center",width:90},
						   		{name:'AMOUNT',align:"center",width:50},
						   		{name:'DISASM_STATE',width:40, formatter:function(data){
									return '系统不结算';
								}}
						   	], 
						autowidth: true,
					   	gridComplete:function(){ //循环为每一行添加业务事件 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						} 				   	
					});
				 }
			 }else{
				 $('#grid-table').GridUnload();//重绘
				 if($("#isSelfOrder").val()=="1"){
					 mgt_util.jqGrid('#grid-table',{
							url:'${base}/biOrderMas/selfInfo.jhtml',
							postData: $("#query-form").serializeObjectForm(), //发送数据 
							colNames:['ID','日期','配送员','订单编号','客户名称','订单金额','在线支付金额','实际结算金额','费用','预计实际到账时间','状态'],
							multiselect:false,
						   	colModel:[
						   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
						   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
								}},
						   		{name:'',align:"center",width:40},
						   		{name:'MAS_NO',align:"center",width:85},
						   		{name:'CUST_NAME',align:"center",width:90},
						   		{name:'AMOUNT',align:"center",width:50},
						   		{name:'PAY_AMOUNT',align:"center",width:50},
						   		{name:'TRANAMOUNT',align:"center",width:47,formatter:function(data){
									if(data==null){
										return '';
									}else{
										return data;
									}}},
								{name:'TRANFEEAMOUNT',align:"center",width:47,formatter:function(data){
									if(data==null){
										return '';
									}else{
										return data;
									}}},
								{name:'PAY_TIME',align:"center",width:55,formatter:function(data){
									if(data==null){
										return '';
									}else{
										var date=new Date(data);
										return date.format('yyyy-MM-dd')
									}}},
						   		{name:'DISASM_STATE',width:40}
						   	],
					   	gridComplete:function(){ //循环为每一行添加业务事件 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						} 				   	
					});
				 }else{
					 mgt_util.jqGrid('#grid-table',{
							postData: $("#query-form").serializeObjectForm(), //发送数据 
							url:'${base}/biOrderMas/shipForOrder.jhtml',
							colNames:['ID','日期','配送员','订单编号','卖家名称','订单金额','结算类型','实际结算金额','预计到账时间','状态'],
							multiselect:false,
						   	colModel:[
						   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
						   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
									if(data==null){return '';}
									var date=new Date(data);
									return date.format('yyyy-MM-dd');
								}},
						   		{name:'',align:"center",width:40},
						   		{name:'MAS_NO',align:"center",width:85},
						   		{name:'VENDOR_NAME',align:"center",width:90},
						   		{name:'AMOUNT',align:"center",width:50},
								{name:'TRAN_SUBTYPE',align:"center",width:50},
								{name:'TRANAMOUNT',align:"center",width:50,formatter:function(data){
									if(data==null){
										return '';
									}else{
										return data;
									}}},
								{name:'PAY_TIME',align:"center",width:50,formatter:function(data){
									if(data==null){
										return '';
									}else{
										var date=new Date(data);
										return date.format('yyyy-MM-dd')
									}}},
						   		{name:'DISASM_STATE',width:40}
						   	], 
						autowidth: true,
					   	gridComplete:function(){ //循环为每一行添加业务事件 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						} 				   	
					});
				 }
			 }
		}
</script>
<style type="text/css"> 
	.redlink{
		font-size:14px;
		color:blue;
	}
</style>
</head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1 main_controls1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form"> 
	            	<!-- 判断显示是否异常的信息，1为正常即全部，2为异常 -->
	            	<input type="hidden" id="isAbnormal" name="isAbnormal" value="1">
	            	<input type="hidden" id="isSelfOrder" name="isSelfOrder" value="1">
	            	<input type="hidden" id="styleId" value="" />
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist" style="overflow:hidden;position:inherit;">
							<li role="presentation" id="selfOrder" class="sub_status_but active"><a href="#"> 自有订单</a></li>					
							<li role="presentation" id="shipForOrder" class="sub_status_but"><a href="#"> 代送订单</a></li>	
							<li role="presentation" id="exportedFile" class="sub_status_but" style="margin-left:900px;margin-top:0px;">
								<a href="#" style="display:block;width:100px;height:28px;border:1px solid #CCC;background:#F0F0F0;"> 导出到Excel</a>
							</li>		
						</ul>
					</div>
					<div style="height:86px;" class="currentDataDiv_tit">
						<span style="top:72px;" class="open_btn" id="advanced_search"></span>
						<div class="form-group" style="margin-right:5px;">
					</div>
					<div class="control" id="control" style="height:500px;display:">
						<a target="_blank" id="click1" class="redlink" onclick="queryData(1)" >全部</a>
						<a target="_blank" id="click2" class="redlink" onclick="queryData(2)" style="margin-left:10px;">线上已结算订单</a>
						<a target="_blank" id="click3" class="redlink" onclick="queryData(3)" style="margin-left:10px;">线上未结算订单</a>
						<a target="_blank" id="click4" class="redlink" onclick="queryData(4)" style="margin-left:10px;">线下结算订单</a>
						<br/>
						<div class="form-group" style="float:left;margin-left:0px;">
							<label class="control-label">时间：</label>
							<input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'endDate\')}'});" >
							-
							<input type="text" class="form-control" name="endDate" id="endDate" style="width:120px;"    onClick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}'})" >
						</div>
					</div>
					<div id="pickcheck" class="radio"></div>
					</div>
					<div class="search_cBox">
						<div class="form-group">
		                 	<button type="button" class="btn_divBtn sr-only" id="suporder_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
	                </div>
	            	<div class="form_divBox" id="searchTerms" style="display:">
	            		<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">订单编号：</label>
							<input type="text" class="form-control" id="orderNo" name="orderNo" style="width:120px;">
						</div>
						<div class="form-group" id="custName" style="float:left;margin-right:0px;display:;" >
							<label class="control-label">客户名称：</label>
							<input type="text" class="form-control" id="custNameStyle" name="custName" style="width:120px;">
						</div>
						<div class="form-group" id="vendorName" style="float:left;margin-right:0px;display:none;" >
							<label class="control-label">卖家名称：</label>
							<input type="text" class="form-control" id="vendorNameStyle" name="vendorName" style="width:120px;">
						</div>
						<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">配送员：</label>
							<input type="text" class="form-control" id="Diliveryman" name="Diliveryman" style="width:120px;">
						</div><br/>

					</div>
	        		<div class="form_divBox">
		                <div id="finishSt" class="">
		                	</table>
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
		  <table id="grid-table" style="word-break:break-all; word-wrap:break-word;"></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
</html>
<script  type="text/javascript">
	$(function(){
		$("#shipForOrder").click(function(){
				$("#isSelfOrder").val("2");
				$('#grid-table').GridUnload();//重绘
				$('#custName').css('display','none')
				$('#vendorName').css('display','')
				if($("#styleId").val()!=''){
					 $("#click"+$("#styleId").val()).css("color","blue");
				 }
				$("li.sub_status_but").removeClass("active");
	    		$(this).addClass("active");
	    		//发送异步请求
	    		var postData={};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/biOrderMas/shipForOrder.jhtml',
					colNames:['ID','日期','配送员','订单编号','卖家名称','订单金额','结算类型','实际结算金额','预计到账时间','状态'],
					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
				   		{name:'',align:"center",width:40},
				   		{name:'MAS_NO',align:"center",width:85},
				   		{name:'VENDOR_NAME',align:"center",width:90},
				   		{name:'AMOUNT',align:"center",width:50},
						{name:'TRAN_SUBTYPE',align:"center",width:50},
						{name:'TRANAMOUNT',align:"center",width:50,formatter:function(data){
							if(data==null){
								return '';
							}else{
								return data;
							}}},
						{name:'PAY_TIME',align:"center",width:50,formatter:function(data){
							if(data==null){
								return '';
							}else{
								var date=new Date(data);
								return date.format('yyyy-MM-dd')
							}}},
				   		{name:'DISASM_STATE',width:40}
				   	], 
				autowidth: true,
			   	gridComplete:function(){ //循环为每一行添加业务事件 
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
				} 				   	
			});
		});
		
		$("#selfOrder").click(function(){
			$("#isSelfOrder").val("1");
			$('#grid-table').GridUnload();//重绘
			$('#vendorName').css('display','none')
			$('#custName').css('display','')
			if($("#styleId").val()!=''){
				 $("#click"+$("#styleId").val()).css("color","blue");
			 }
			$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		mgt_util.jqGrid('#grid-table',{
				url:'${base}/biOrderMas/selfInfo.jhtml',
				colNames:['ID','日期','配送员','订单编号','客户名称','订单金额','在线支付金额','实际结算金额','费用','预计实际到账时间','状态'],
				multiselect:false,
			   	colModel:[
			   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
			   		{name:'ORDER_DATE',align:"center",width:50, formatter:function(data){
						if(data==null){return '';}
						var date=new Date(data);
						return date.format('yyyy-MM-dd');
					}},
			   		{name:'',align:"center",width:40},
			   		{name:'MAS_NO',align:"center",width:85},
			   		{name:'CUST_NAME',align:"center",width:90},
			   		{name:'AMOUNT',align:"center",width:50},
			   		{name:'PAY_AMOUNT',align:"center",width:50},
			   		{name:'TRANAMOUNT',align:"center",width:47,formatter:function(data){
						if(data==null){
							return '';
						}else{
							return data;
						}}},
					{name:'TRANFEEAMOUNT',align:"center",width:47,formatter:function(data){
						if(data==null){
							return '';
						}else{
							return data;
						}}},
					{name:'PAY_TIME',align:"center",width:55,formatter:function(data){
						if(data==null){
							return '';
						}else{
							var date=new Date(data);
							return date.format('yyyy-MM-dd')
						}}},
			   		{name:'DISASM_STATE',width:40}
			   	],
		   	gridComplete:function(){ //循环为每一行添加业务事件 
				//table数据高度计算
				cache=$(".ui-jqgrid-bdivFind").height();
				tabHeight($(".ui-jqgrid-bdiv").height());
			} 				   	
		});
		});
		$("#exportedFile").click(function(){
			//loading层
			var index = layer.load(2,{
				shade: [0.8, '#F0F0F0'],
				time: 3*1000}); 
			window.location.href = 
				"${base}/biOrderMas/returnMoneyExportedFile.jhtml?isSelfOrder="+$("#isSelfOrder").val()
						+"&isAbnormal="+$("#isAbnormal").val()
						+"&startDate="+$("#startDate").val()
						+"&endDate="+$("#endDate").val()
						+"&orderNo="+$("#orderNo").val()
						+"&custName="+$("#custNameStyle").val()
						+"&vendorName="+$("#vendorNameStyle").val()
						+"&Diliveryman="+$("#Diliveryman").val(); 
			//layer.close(index);
		});
	});

</script>