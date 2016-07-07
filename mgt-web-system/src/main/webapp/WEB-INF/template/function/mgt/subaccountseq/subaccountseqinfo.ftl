<!DOCTYPE html>
<html>
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
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
				<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/subaccountseq/list.jhtml',
 					colNames:['','交易日期','类型','交易号','方向','交易金额','余额','对方银行帐号','对方帐户','备注'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'WORKDATE',width:20},
				   		{name:'CHANGE_TYPE',width:20,formatter:function(data){
							if(data == null){
								return '';
							}
							if(data=='01'){
								return '充值';
							}
					   		if(data=='02'){
								return '支付';
							}
					   		if(data=='03'){
								return '提现';
							}
					   		if(data=='04'){
								return '内部转账';
							}
					   		if(data=='05'){
								return '结息';
							}
					   		if(data=='06'){
								return '利息税';
							}
					   		if(data=='07'){
								return '原交易退款';
							}
					   		if(data=='08'){
								return '原交易撤销';
							}
					   		if(data=='09'){
								return '内部结算';
							}
							 else{
								return data;
							}
	   		            }},
				   		{name:'REFSN', width:40},
				   		{name:'SEQFLAG', width:16,formatter:function(data){
				   			
				   			if(data=='0'){
								return '收入';
							}
					   		if(data=='1'){
								return '支出';
							}
							 else{
								return data;
							}
						 
							}},
				   		{name:'PREAMOUNT',width:20,align:"center",editable:true,formatter:function(data,row,rowObject){
				   			if(rowObject.SEQFLAG=='0'){
								return (parseFloat(rowObject.AMOUNT)-parseFloat(rowObject.PREAMOUNT)).toFixed(2);
							}
					   		if(rowObject.SEQFLAG=='1'){
					   			return (parseFloat(rowObject.PREAMOUNT)-parseFloat(rowObject.AMOUNT)).toFixed(2);
							}
							 else{
								return data;
							}
				   			
				   		}},
				   		{name:'AMOUNT',width:20,align:"center",editable:true},
						{name:'REF_ACCOUNT_CODE', width:40},
						{name:'REF_ACCOUNT_NAME', width:40},
						{name:'NOTE', width:60}
				   	],
				   	gridComplete:function(){ 
				   	    $.ajax({
				   	      url:'${base}/subaccountseq/countTranAmount.jhtml',
				   	      type : 'post',
				   	      dataType : "json",
				   	   	  mtype:'post',
				   	      data :mgt_util.formObjectJson("#query-form"),
				   	      error : function(data) {
				   		    alert("网络异常");
				   	        return false;
				   	      },
				   	      success : function(data) { 
				   	    	$("#incomeCountSpan").text(data.data.INCOME);
				   	    	$("#expenditureCountSpan").text(data.data.EXPENDITURE);
				   	      }
				   	    });
				   	}
				});
				
				//table数据高度计算
				tabHeight();

				$("#subaccountlist_search").click(function(){
					var changeTypes = '';
		                $("input[name='changeTypes']:checked").each(function(){
		                	changeTypes+=$(this).val()+",";
		                })
					var json = $("#query-form").serializeObjectForm();
					json['changeTypes'] = changeTypes;
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:json, //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
			});
		 
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
       	      <!--浮动文字-->
		    <div class="pos_orderCount_box">
		   		<div class="orderCount-IconBtn"></div>
				<div class="pos_orderCount">
		   			<div class="form-group"><font>收入：</font><span id="incomeCountSpan">0.00</span>元<font class="padding_fontl">支出：</font><span id="expenditureCountSpan"  >0.00</span> 元</div>
				</div>
		    </div>
			<div id="currentDataDiv" action="menu" >
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="subaccountlist" class="sub_status_but"><a>我的账户</a></li>
							<li role="presentation" id="paybilllist" class="sub_status_but"><a>交易记录</a></li>
							<li role="presentation" id="subaccountseqInfo" class="sub_status_but active"><a>收支明细</a></li>
						</ul>
					 </div>
					 <div   style="border-bottom:1px solid #f39801;padding-bottom:10px;position:relative;">
					 <form class="form form-inline"   >
	           		<div>
	           			<ul class="change-ul" style="list-style:none;padding-top:14px;float:left;">
    						<li  onClick="findFormTimes(1)">本周</li>
    						<li  onClick="findFormTimes(2)">上个月</li>
    						<li  style="margin-right:10px;"  onClick="findFormTimes(3)">本月</li>
  						</ul>
	               	 </div>
	                 <div class="form-group">
						<label class="control-label" style=" vertical-align: middle;">交易时间:</label>
						<input type="text" class="form-control" id="startDate1" style="width:90px;" name="startDate1" onfocus="WdatePicker({maxDate:$('#endDate1').val(),dateFmt:'yyyy-MM-dd',onpicked: findFormTimes(4)});"  >
						</div>
						<div class="form-group">
						<label class="control-label" style=" vertical-align: middle;">至</label>
						<input type="text" class="form-control" id="endDate1" style="width:90px;" name="endDate1" onfocus="WdatePicker({minDate:$('#startDate1').val(),dateFmt:'yyyy-MM-dd',onpicked: findFormTimes(4)});">
						</div>
						<div class="search_cBox" style="bottom:20px;display: none;">
							 <div class="form-group">
							 	<!-- <button class="search_cBox_btn btn btn-info"  id="order_search" data-toggle="jBox-call"  data-fn="checkForm">
							 	搜索<i class="fa-save align-top bigger-125 fa-on-right"></i>
						        </button>-->
						        <button type="button" class="btn_divBtn" id="stock_query" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	           			    </div>
           			    </div>
	            </form>
					   <span class="open_btn"  style="top:33px;"></span>
					 </div>	
	            
	            <div class="form_divBox" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" method="post" action="${base}/subaccountseq/list.jhtml"> 
					<input type="hidden" name="startDate">
					<input type="hidden" name="endDate">
					<div class="form-group"  >
						<label class="control-label">账户:</label>
				<select class="form-control required" id="subaccountId" name="subaccountId">
				<option value="">请选择</option>
									[#list subaccountList as item]
								    <option value="${item.id}"  >
								[#if item.subaccountType=='9001']
                				${item.custName }(余额账户)
                				[#elseif item.subaccountType=='8001']
                				${item.custName }(中信附属账户)
                				[#else]
                				 未知账户
                				[/#if]
								    </option>
								    [/#list]
							    </select>
					</div>
					<div class="form-group" style="float:left;">
						<label class="control-label">交易时间:</label>
						<select class="form-control required" id="workdate" name="workdate">
									<option value="">请选择</option>
								    <option value="7"  >7天   </option>
								    <option value="30"  >30天   </option>
							    </select>
					</div>
					<div class="form-group" style="float:left;">
						<label class="control-label">资金流向:</label>
						<select class="form-control required" id="seqflag" name="seqflag">
									<option value="">请选择</option>
								    <option value="0"  >收入</option>
								    <option value="1"  >支出   </option>
							    </select>
					</div>
						<div class="form-group" style="float:left;">
						<label class="control-label">金额范围:</label>
	<input type="text" class="form-control input-sm required number" name="minamount" id="minamount"  style="width: 60px;"   onBlur="checkPrice(this)">
	-<input type="text" class="form-control input-sm required number" name="maxamount" id="maxamount"  style="width: 60px;"  onBlur="checkPrice(this)">
					</div>
					     <div class="form-group" style="float:left;">
						<label class="control-label">交易类型:</label>
<!-- 						changeType;       //类型 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销 -->
						<input class="form-control required"  type="checkbox" id="changeType01" name="changeTypes" value="01">
						<label class="control-label" for="changeType01" style="width: 30px;">充值</label>
						
						<input class="form-control required"  type="checkbox" id="changeType02" name="changeTypes" value="02">
						<label class="control-label" for="changeType02" style="width: 30px;">支付</label>
						
						<input class="form-control required"  type="checkbox" id="changeType03" name="changeTypes" value="03">
						<label class="control-label" for="changeType03" style="width: 30px;">提现</label>
						
						<input class="form-control required"  type="checkbox" id="changeType04" name="changeTypes" value="04">
						<label class="control-label" for="changeType04" style="width: 60px;">内部调账</label>
						
						<input class="form-control required"  type="checkbox" id="changeType05" name="changeTypes" value="05">
						<label class="control-label" for="changeType05" style="width: 30px;">结息</label>
						
						<input class="form-control required"  type="checkbox" id="changeType06" name="changeTypes" value="06">
						<label class="control-label" for="changeType06" style="width: 50px;">利息税</label>
						
						<input class="form-control required"  type="checkbox" id="changeType07" name="changeTypes" value="07">
						<label class="control-label" for="changeType07" style="width: 70px;">原交易退款</label>
						
						<input class="form-control required"  type="checkbox" id="changeType08" name="changeTypes" value="08">
						<label class="control-label" for="changeType08" style="width: 70px;">原交易撤销</label>
						<input class="form-control required"  type="checkbox" id="changeType09" name="changeTypes" value="09">
						<label class="control-label" for="changeType09" style="width: 70px;">内部结算</label>
						
						
					</div>
				<div class="search_cBox">
					<button type="button" class="search_cBox_btn" id="subaccountlist_search"  >搜 索 </button>
				</div>
				</form>
				</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
   		<form action="" method="post" id="tabFrom"></form>
    </body>
    
</html>
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    	$("#tabFrom").attr('action','${base}/subaccountseq/'+$(this).attr("id")+'.jhtml');
	    	$("#tabFrom").submit();
	    });
		$(".change-ul li").click(function(){
			$(".change-ul li").removeClass("cur");
			$(this).addClass("cur");
		});
	});
	
	function checkPrice(obj){ 
		if(null==obj.value||''==obj.value){
		return;
		}
		 else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
		 top.$.jBox.tip('请输入正确的金额');
		obj.value='';
		 } 
		 }
	

	function findFormTimes(obj){
		var jsonParams = {};
		if(obj==1){
			var myDate = new Date();
			jsonParams['endDate']  = myDate.format('yyyy-MM-dd');//今天
			myDate.setDate(myDate.getDate() - myDate.getDay() + 1);
			jsonParams['startDate'] = myDate.format('yyyy-MM-dd');//周一
		
		}
		else if(obj==2){
			var date=new Date();//上个月第一天
		    date.setFullYear(date.getFullYear());
		    date.setMonth(date.getMonth()-1);
			date.setDate(1);
			jsonParams['startDate'] = date.format('yyyy-MM-dd');
			var date1=new Date();//上个月最后一天
	        date1.setFullYear(date1.getFullYear());
	        date1.setMonth(date1.getMonth());
			date1.setDate(0);
			jsonParams['endDate'] = date1.format('yyyy-MM-dd');
		}
		else if(obj==3){
			var date=new Date();//今天
			jsonParams['endDate']  = date.format('yyyy-MM-dd');//今天
		 	date.setDate(1);//当前月的第一天
		 	jsonParams['startDate'] = date.format('yyyy-MM-dd');
		}
		else if(obj==4){
			var startDate1 = $('#startDate1').val();
			var endDate1 = $('#endDate1').val();
			if(null!=startDate1&&null!=endDate1&&''!=startDate1&&''!=endDate1){
		 	jsonParams['startDate'] = startDate1;
			jsonParams['endDate']  = endDate1;
			$(".change-ul li").removeClass("cur");
			}else{
				return;
			}
		}else{
			return;
		}
		
		
		$('#startDate1').val(jsonParams['startDate']);
		$('#endDate1').val(jsonParams['endDate']);
	$("#grid-table").jqGrid('setGridParam',{  
        datatype:'json',  
        postData:jsonParams, //发送数据  
        page:1  
    }).trigger("reloadGrid"); //重新载入  
	}
	
</script> 