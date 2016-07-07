<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>金融交易对账</title>
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
					url:'${base}/paybillFee/PayCheckList.jhtml',
					colNames:['ID','日期','渠道ID','渠道名称','交易笔数','交易金额','实际到账','渠道费用','调账状态','对账结果','分账状态','创建时间','操作'],
					multiselect:false,
				   	colModel:[
				   		{name:'SN',index:'SN',width:30,hidden:true,key:true},
				   		{name:'CHECK_DATE',align:"center",width:80, formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
				   		{name:'CHANNEL_ID',align:"center",width:60},
				   		{name:'MERCHANT_NO',align:"center",width:60},
				   		{name:'TRAN_NUM',align:"center",width:60},
				   		{name:'TRAN_AMT',align:"center",width:60},
				   		{name:'TRAN_ACTAMT',align:"center",width:60},
				   		{name:'CHANNEL_FEE',align:"center",width:60},
				   		{name:'ADJUST_STATE',width:80,align:"center",formatter:function(data){
							if(data=='0'){
								return '未调账';
							}else if(data=='1'){
								return '已调账';
							}else{
								return '';
							}}},
						{name:'CHECK_RESULT_STATE',width:80,align:"center",formatter:function(data){
							if(data=='1'){
								return '平帐';
							}else if(data=='2'){
								return '不平';
							}else{
								return '';
							}}},
				   		{name:'DISASM_STATE',width:50,align:"center",formatter:function(data){
							if(data=='Y'){
								return '已分';
							}else if(data=='N'){
								return '未分';
							}else{
								return '';
							}}},
						{name:'CHECK_TIME', width:90, formatter:function(data){
							if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
							}},
				   		{name:'', width:140,align:"center",formatter:function(value,row,index){
								if(index.CHECK_RESULT_STATE =='2'){
									var others = '<button type=button class="btn btn-info edit" onclick=CheckAccount("'+index.SN+'")>手工对账</button>';
									return others;
								}else{
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
		
		function queryData(abnormal,styleId){
			 if($("#styleId").val()!=''){
				 $("#click"+$("#styleId").val()).css("color","blue");
			 }
			 $("#click"+styleId).css("color","#f39801");
			 $("#styleId").val(styleId);
			 
			 $("#isAbnormal").val(abnormal);
			 $("#grid-table").jqGrid('setGridParam',{
		        datatype:'json',  
		        postData:$("#query-form").serializeObjectForm(), //发送数据  
		        page:1  
		    }).trigger("reloadGrid"); //重新载入   
		}
		
		function CheckAccount(sn){
			mgt_util.showjBox({
				width : 960,
				height : 500,
				title : '手工对账',
				url : '${base}/paybillFee/checkAccount.jhtml?sn='+sn,
				grid : $('#grid-table')
			});
		}
</script>
<style type="text/css"> 
	.redlink{
		font-size:14px;
		color:blue;
	}
	
	/* .ui-jqgrid tr.jqgrow td {
	   white-space: normal !important;
	   height:auto;
	   vertical-align:text-top;
	   padding-top:2px;
  } */
</style>
</head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1 main_controls1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form"> 
	            	<!-- 判断显示是否异常的信息，1为正常即全部，2为异常 -->
	            	<input type="hidden" id="isAbnormal" name="isAbnormal" value="1">
	            	<input type="hidden" id="isPaystate" name="isPaystate" value="1">
	            	<input type="hidden" id="styleId" value="" />
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist" style="overflow:hidden;position:inherit;">
							<li role="presentation" id="threePayCheck" class="sub_status_but active"><a href="#"> 三方支付渠道对帐</a></li>					
							<li role="presentation" id="tradeLogCheck" class="sub_status_but"><a href="#"> 交易记录对帐</a></li>						
						</ul>
					</div>
					<div class="currentDataDiv_tit">
						<span class="open_btn" id="advanced_search"></span>
						<div class="form-group" style="margin-right:5px;">
					</div>
					<div class="control" id="control" style="display:">
						<a target="_blank" id="click6" class="redlink" onclick="queryData(1,6)" >全部</a>
						<a target="_blank" id="click7" class="redlink" onclick="queryData(2,7)" style="margin-left:10px;">异常交易</a>
					</div>
					<div class="control" id="controlLog" style="display:none">
						<a target="_blank" id="click1" class="redlink" onclick="queryDataByParams(1)" >全部</a>
						<a target="_blank" id="click2" class="redlink" onclick="queryDataByParams(2)" style="margin-left:10px;">未成功交易</a>
						<a target="_blank" id="click3" class="redlink" onclick="queryDataByParams(3)" style="margin-left:10px;">未支付成功交易</a>
						<a target="_blank" id="click4" class="redlink" onclick="queryDataByParams(4)" style="margin-left:10px;">未归集交易</a>
						<a target="_blank" id="click5" class="redlink" onclick="queryDataByParams(5)" style="margin-left:10px;">未分账交易</a>
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
							<label class="control-label">渠道名称：</label> 
							<!-- <input type="text" class="form-control" name="merchantNo" style="width:120px;"> -->
							<select class="form-control" name="merchantNo" style="width:120px;" value="" >
								<option value=""></option>
								[#if payChannels ??]
							        [#list payChannels as payChannel]
				                          <option value='${payChannel.merchantNo}'>${payChannel.merchantNo}</option>
									[/#list]
								[/#if]
							</select>
						</div>
						<div class="form-group" style="float:left;margin-left:0px;">
							<label class="control-label">交易时间</label>
							<input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;" onfocus="WdatePicker();" >
							-
							<input type="text" class="form-control" name="endDate" style="width:120px;"    onClick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}'})" >
						</div>
					</div>
					<div class="form_divBox" id="searchTermsLog" style="display:none">
						<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">渠道名称：</label>
							<select class="form-control" name="merchantName" style="width:120px;" value="" >
								<option value=""></option>
								[#if payChannels ??]
							        [#list payChannels as payChannel]
				                          <option value='${payChannel.merchantNo}'>${payChannel.merchantNo}</option>
									[/#list]
								[/#if]
							</select>
						</div>
						<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">交易类型：</label>
							<select class="form-control" name="payType" style="width:120px;" value="" >
								<option value=""></option>
								[#if tranTypes ??]
							        [#list tranTypes as tranType]
				                          <option value='${tranType.code}'>${tranType.name}</option>
									[/#list]
								[/#if]
							</select>
						</div>
						<div class="form-group" style="float:left;margin-right:0px;">
							<label class="control-label">交易时间</label>
							<input type="text" class="form-control" name="startTime" id="startTime" style="width:120px;" onfocus="WdatePicker();" >
							-
							<input type="text" class="form-control" name="endTime" style="width:120px;"    onClick="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}'})" >
						</div><br/>
						<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">付款方：</label>
							<input type="text" class="form-control" name="payercustName" style="width:120px;">
						</div>
						<div class="form-group" style="float:left;margin-right:0px;" >
							<label class="control-label">收款方：</label>
							<input type="text" class="form-control" name="payeecustName" style="width:120px;">
						</div>
						<div class="form-group" style="float:left;margin-right:0px;">
							<label class="control-label">金额范围</label>
							<input type="text" class="form-control" name="minAmount" id="minAmount" style="width:120px;">
							-
							<input type="text" class="form-control" name="maxAmount" style="width:120px;">
						</div>
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
		$("#tradeLogCheck").click(function(){
				$('#grid-table').GridUnload();//重绘
				$("li.sub_status_but").removeClass("active");
				$('#control').css('display','none');
				$('#controlLog').css('display','');
				$('#searchTerms').css('display','none');
				$('#searchTermsLog').css('display','');
	    		$(this).addClass("active");
	    		//发送异步请求
	    		var postData={};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/paybillFee/queryPaybillList.jhtml',
					colNames:['ID','日期','渠道ID','渠道名称','交易类型','子类型','付款方','收款方','交易金额','交易说明','状态','支付状态','归集状态','分账状态','操作'],
					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'TRAN_DATE',align:"center",width:60, formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
				   		{name:'CHANNEL_ID',align:"center",width:60},
				   		{name:'MERCHANT_NO',align:"center",width:50},
				   		{name:'NAME',align:"center",width:45},
				   		{name:'TRAN_SUBTYPE',align:"center",width:60},
				   		{name:'PAYERCUST_NAME',align:"center",width:90},
				   		{name:'PAYEECUST_NAME',align:"center",width:95},
				   		{name:'TRANAMOUNT',align:"center",width:50},
				   		{name:'TRAN_NOTE',align:"center",width:60},
				   		{name:'STATE',align:"center",width:35,formatter:function(data){
							if(data=='02'){
								return '已交易';
							}else{
								return '未交易';
							}}},
				   		{name:'PAY_STATE',align:"center",width:40,formatter:function(data){
							if(data=='03'){
								return '已支付';
							}else{
								return '未支付';
							}}},
				   		{name:'RECHARGE_STATE',align:"center",width:40,formatter:function(data){
							if(data=='3'){
								return '已归集';
							}else{
								return '未归集';
							}}},
				   		{name:'DISASM_STATE',align:"center",width:40,formatter:function(data){
							if(data=='N'){
								return '未分账';
							}else{
								return '已分账';
							}}},
				   		
				   		{name:'', width:90,align:"center",formatter:function(value,row,index){
									var others = '<button type=button class="btn btn-info edit" onclick=queryDetailById("'+index.PK_NO+'")>详情</button>'
									+'<button type=button class="btn btn-info edit" onclick=partAccountDetail("'+index.PK_NO+'")>分账详情</button><br/>';
									if(index.TRAN_TYPE =='9100'){
										others += '<button type=button class="btn btn-info edit" onclick=queryOrderDetail("'+index.PK_NO+'","'+index.TRAN_TYPE+'","'+index.SN+'")>订单</button>';
									}else if(index.TRAN_TYPE =='9000'||index.TRAN_TYPE =='9001'||index.TRAN_TYPE =='9010'||index.TRAN_TYPE =='9011'||index.TRAN_TYPE =='90014'||index.TRAN_TYPE =='9012'||index.TRAN_TYPE =='9013'||index.TRAN_TYPE =='9099'){
										others += '<button type=button class="btn btn-info edit" onclick=queryOrderDetail("'+index.PK_NO+'","'+index.TRAN_TYPE+'","'+index.BATCHID+'")>订单</button>';
									}
									if(index.PAY_STATE!='03'){
										others += '<button type=button class="btn btn-info edit" onclick=StartPay("'+index.PK_NO+'","'+index.TRAN_TYPE+'")>发起支付</button>';
									}
									return others;
							}
						}
				   	], 
				autowidth: true,
			   	gridComplete:function(){ //循环为每一行添加业务事件 
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
				} 				   	
			});
		});
		
		$("#threePayCheck").click(function(){
			$('#grid-table').GridUnload();//重绘
			$("li.sub_status_but").removeClass("active");
			$('#controlLog').css('display','none');
			$('#control').css('display','');
			$('#searchTermsLog').css('display','none');
			$('#searchTerms').css('display','');
    		$(this).addClass("active");
    		mgt_util.jqGrid('#grid-table',{
				url:'${base}/paybillFee/PayCheckList.jhtml',
				colNames:['ID','日期','渠道ID','渠道名称','交易笔数','交易金额','实际到账','渠道费用','调账状态','对账结果','分账状态','创建时间','操作'],
				multiselect:false,
			   	colModel:[
			   		{name:'SN',index:'SN',width:30,hidden:true,key:true},
			   		{name:'CHECK_DATE',align:"center",width:80, formatter:function(data){
						if(data==null){return '';}
						var date=new Date(data);
						return date.format('yyyy-MM-dd');
					}},
			   		{name:'CHANNEL_ID',align:"center",width:60},
			   		{name:'MERCHANT_NO',align:"center",width:60},
			   		{name:'TRAN_NUM',align:"center",width:60},
			   		{name:'TRAN_AMT',align:"center",width:60},
			   		{name:'TRAN_ACTAMT',align:"center",width:60},
			   		{name:'CHANNEL_FEE',align:"center",width:60},
			   		{name:'ADJUST_STATE',width:80,align:"center",formatter:function(data){
						if(data=='0'){
							return '未调账';
						}else if(data=='1'){
							return '已调账';
						}else{
							return '';
						}}},
					{name:'CHECK_RESULT_STATE',width:80,align:"center",formatter:function(data){
						if(data=='1'){
							return '平帐';
						}else if(data=='2'){
							return '不平';
						}else{
							return '';
						}}},
			   		{name:'DISASM_STATE',width:50,align:"center",formatter:function(data){
						if(data=='Y'){
							return '已分';
						}else if(data=='N'){
							return '未分';
						}else{
							return '';
						}}},
					{name:'CHECK_TIME', width:90, formatter:function(data){
						if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd');
						}},
			   		{name:'', width:140,align:"center",formatter:function(value,row,index){
							if(index.CHECK_RESULT_STATE =='2'){
								var others = '<button type=button class="btn btn-info edit" onclick=CheckAccount("'+index.SN+'")>手工对账</button>';
								return others;
							}else{
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
		
	});
	
	function queryDataByParams(state){
		if($("#styleId").val()!=''){
			 $("#click"+$("#styleId").val()).css("color","blue");
		 }
		 $("#click"+state).css("color","#f39801");
		 $("#styleId").val(state);
		
		 $("#isPaystate").val(state);
		 $("#grid-table").jqGrid('setGridParam',{
	        datatype:'json',  
	        postData:$("#query-form").serializeObjectForm(), //发送数据  
	        page:1  
	    }).trigger("reloadGrid"); //重新载入   
	}
	//交易记录对账详情 
	function queryDetailById(id){
		mgt_util.showjBox({
			width : 960,
			height : 500,
			title : '详情',
			url : '${base}/paybillFee/queryDetailById.jhtml?PK_NO='+id,
			grid : $('#grid-table')
		});
	}
	
	//交易记录对账-订单详情
	function queryOrderDetail(pkNo,tranType,AccountCode){
		mgt_util.showjBox({
			width : 960,
			height : 500,
			title : '订单详情',
			url : '${base}/paybillFee/queryOrderDetail.jhtml?tranType='+tranType+'&AccountCode='+AccountCode+'&pkNo='+pkNo,
			grid : $('#grid-table')
		});
	}
	
	//交易记录对账-分账详情
	function partAccountDetail(pkNo){
		mgt_util.showjBox({
			width : 960,
			height : 500,
			title : '订单详情',
			url : '${base}/paybillFee/partAccountDetail.jhtml?pkNo='+pkNo,
			grid : $('#grid-table')
		});
	}
	
	function StartPay(pkNo,tranType){
		 $.ajax({
			url:'${base}/paybillFee/StartPay.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{PK_NO:pkNo,TRAN_TYPE:tranType},
			success : function(data) {
				if(data){
					layer.alert('支付成功！', {icon: 6});
				}else{
					layer.alert('支付失败！', {icon: 5});
				}
			},
			error : function(data) {
				layer.alert('网络异常', {icon: 2}); 
				return false;
			}
		 }); 
	}
</script>