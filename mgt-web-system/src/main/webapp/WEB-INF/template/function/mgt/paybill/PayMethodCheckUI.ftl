<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>财务管理-渠道对账</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
    </head>
    <body>
     <div class="main_heightBox1">
       <div class="control-group sub_status" style="position:relative;">
	       <ul class="nav nav-pills" role="tablist">
			<li role="presentation" id="01" class="sub_status_but active"><a> 汇总查询</a></li>					
			<li role="presentation" id="02" class="sub_status_but"><a> 交易明细</a></li>
		   </ul>
	   </div>
	   <!--浮动文字-->
	   <div class="pos_orderCount_box">
   		<div class="orderCount-IconBtn"></div>
		<div class="pos_orderCount">
   			<div class="form-group"><font>期初金额：</font><span id="beginMoney" style="color:red;">0.00</span> 元<font class="padding_fontl">期间收入：</font><span id="inMoney" style="color:red;">0.00</span> 元<font class="padding_fontl">期间支出：</font><span id="outMoney" style="color:red;">0.00</span> 元<font class="padding_fontl">期末金额</font><span id="endMoney" style="color:red;">0.00</span> 元</div>
		</div>
	   </div>
       <div class="body-container">
			<div id="currentDataDiv">
			   <div class="form_divBox" style="padding-bottom:10px;display:block;">
	            <form class="form form-inline queryForm"  id="query-form" action="${base}/paybill/PayMethodCheck.jhtml"> 
	               	 <div class="form-group" >
	                    <label class="control-label">渠道:</label>
	                    <select class="form-control" name="channelId" id="channelId" style="width:95px;">
	                        [#list payChannel as type]
	                        [#if type.channelId = channelId]
	                        	<option value="${type.channelId}" selected>${type.channelBankType}</option>
	                        [#else]
	                        	<option value="${type.channelId}" >${type.channelBankType}</option>
	                        [/#if]
	                        [/#list]
	                    </select>
	                 </div>
	                 <div class="form-group">
						<label class="control-label">交易日期:</label>
						<input type="text" class="form-control" id="startDate" name="startDate" value="${startDate}" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
					 </div>
					 <div class="form-group">
						<span class="control-label" style="padding:10px 10px 0 0;vertical-align:middle;">至:</span>
						<input type="text" class="form-control" id="endDate" name="endDate" value="${endDate}" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
					 </div>
					 <div class="search_cBox" style="bottom:20px;">
						 <div class="search form-group">
		                 	<button type="submit" class="search_cBox_btn search" id="order_search">搜 索 </button>
		                 </div>
	                 </div>
					 <div class="form-group moreBtn sr-only">
						<label for="tranType" class="control-label">
							交易类型:
						</label>
	                    <select class="form-control" name="tranType" id="tranType" style="width:120px;">
	                    </select>
					 </div>
					 <div class="form-group moreBtn sr-only">
						<label class="control-label">交易说明:</label>
						<input type="text" class="form-control" id="tranNote" name="tranNote" style="width:150px;>
					 </div>
					 
		                 <div class="form-group">
		                 <div class="search_cBox">
		                 	<button type="button" class="search_cBox_btn" id="pay_check" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                 </div>
	                 </div>
	            </form>
	           </div>
	        </div>
		   
		      [#list map as map]
		     <table>
		     	<tr>
		     	<td>
		     		<table border="0" cellpadding="3" cellspacing="0.1" style="width:300px;" class="ffff">
						  <tr>
						    <th>渠道账户余额：</th>
						    <th id="cb">${map.CB}</th>
						  </tr>
						  <tr>
						    <th>待收入金额：</th>
						    <th id="wcr">${map.WCR}</th>
						  </tr>
						  <tr>
						    <th>待支出金额：</th>
						    <th id="wdr">${map.WDR}</th>
						  </tr>
						  <tr>
						    <th>未分账金额：</th>
						    <th id="nd">${map.ND}</th>
						  </tr>
						  <tr>
						    <th>客户账户金额：</th>
						    <th id="account">${map.ACCOUNT}</th>
						  </tr>
						</table>
		     	</td>
		     	<td>
		     		<table border="0" cellpadding="3" style="width:300px;" class="ffff">
						  <tr>
						    <th>期间累计收入：</th>
						    <th id="cr">${map.CR}</th>
						    <tr>
						    </tr>
						    <th>期间累计支出：</th>
						    <th id="dr">${map.DR}</th>
						  </tr>
						</table>
						<table cellspacing="0.1" width="60%" style="width:300px;" class="ffff" id="tt">
						<tr>
						<th colspan="3" style="text-align:center;">期间费用分类统计</th>
						</tr>
						<tr>
						<th style="width:100px;">分类</th>
						<th style="width:100px;">收入</th>
						<th style="width:100px;">支出</th>
						</tr>
						[#list list as list]
						<tr>
						<th>${list.TRAN_SUBTYPE}</th>
						<th>${list.CR}</th>
						<th>${list.DR}</th>
						</tr>
						[/#list]
						</table>
		     	</td>
		     	</tr>
		     </table>
			<div class="form-group balance"  style="float:left;color:red;">
				<span style="font-size:20px;">渠道帐户试算平衡：<br></span>(<span style="color:red;">平衡条件为：
				渠道帐户余额-未分帐金额+待收金额-待支金额-客户帐户余额=0</span>)
				<br/>
				<span style="color:red;font-size:20px;">${map.CB}-${map.ND}+${map.WCR}-${map.WDR}-${map.ACCOUNT}=${map.BALANCE}</span>
			</div>
			[/#list]
		</div>
		</div>
		<table id="grid-table" ></table>
		<div id="grid-pager"></div>
    </body>

<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
		var type=$("#tranNote").val();
		var note=$("#tranType").val();
	    $("li.sub_status_but").on("click",function(){
	    	$('#grid-table').GridUnload();//重绘
	    	if("01" == $(this).attr("id")){
	    		// 设置表格高度
	    		$("#query-form").css("height","100px");
	    		$(".moreBtn").addClass("sr-only");
	    		$(".search").removeClass("sr-only");
	    		$(".balance").removeClass("sr-only");
	    		$(".ffff").removeClass("sr-only");
	    		$("#startDate").val("");
	    		$("#endDate").val("");
	    		$("#channelId").val("");
	    		window.location.href='${base}/paybill/PayMethodCheck.jhtml';
	    	}else{
	    		// 设置表格高度
	    		//$("#query-form").css("height","150px");
	    		$(".moreBtn").removeClass("sr-only");
	    		$(".search").addClass("sr-only");
	    		$(".balance").addClass("sr-only");
	    		$(".ffff").addClass("sr-only");
	    		$("#startDate").val("");
	    		$("#endDate").val("");
	    		$("#channelId").val("");
	    		$("#tranNote").val("");
	    		//获取交易类型options AJAX
	    		$.ajax({
					url: "${base}/paybill/selectOptions.jhtml",
					type: "GET",
					dataType: "json",
					cache: false,
					async: false,
					success: function(data) {
					$("#tranType").empty();
					$("#tranType").append("<option value='0'>全部（默认）</option>");
					//循环添加类型options
					$.each(data, function(value, name) {
						$('#tranType').append("<option value='"+value+"'>"+name+"</option>"); 
					});	
				  }				
				});
	    		var postData={tranType:type,tranNote:type};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/paybill/tranDetails.jhtml',
 					colNames:['','交易日期','交易类型','描述','收入','支出','交易流水',''],
 					multiselect:false,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'TRAN_DATE',align:"center",width:130},
				   		{name:'TRAN_TYPE',align:"center",width:140},				   		
				   		{name:'TRAN_NOTE',align:"center",width:200},				   		
				   		{name:'CR',align:"center",width:130},
				   		{name:'DR',align:"center",width:130},
				   		{name:'SN',align:"center",width:190},
				   		{name:'BEGIN_MONEY',align:"center",width:180,hidden:true},
				   	],
				   	//查询计算总金额、初始金额
				   	gridComplete:function(){
						$.ajax({
						url:'${base}/paybill/getAjaxTransDetail.jhtml',
						sync:false,
						type : 'post',
            			data: {
            				tranType:$('#tranType').val(),
            				tranNote:$('#tranNote').val(),  
            				channelId:$('#channelId').val(),  
            				startDate:$('#startDate').val(),  
            				endDate:$('#endDate').val()
            			},  
           				dataType: 'json', 
						error : function(data) {
							alert("系统数据异常");
							return false;
						},
						success : function(data) {
							if(data.message.type == "success"){
								$("#inMoney").html(formatCurrency(data.beginMoney.SUM_CR));
								$("#outMoney").html(formatCurrency(data.beginMoney.SUM_DR));
								$("#beginMoney").html(formatCurrency(data.beginMoney.SUM_BEGIN));
								$("#endMoney").html(formatCurrency(data.beginMoney.SUM_BEGIN+data.beginMoney.SUM_CR-data.beginMoney.SUM_DR));
							}else{
								top.$.jBox.tip('获取详情失败！', 'error');
			 						return false;
								}
							}
						});
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());				   	
					},
				});		    		
	    	}
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=checkState]").val($(this).attr("id"));
	        $("#pay_check").click();
	    });
	});
</script>
</html>