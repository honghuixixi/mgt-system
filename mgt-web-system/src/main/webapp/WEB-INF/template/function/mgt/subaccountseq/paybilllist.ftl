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
				var userName='${userName}';
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/paybill/list.jhtml',
 					colNames:['','创建时间','交易分类','名称','批次号','对方','交易身份','交易金额','交易状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CREATE_TIME',align:"center",width:60,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                        },
				   		{name:'TRAN_TYPE',align:"center",width:'50',
				   		editable:true,formatter:function(data){
				   			if(data=='9000'){ return 	'银联信用卡收款';}
				   			if(data=='9001'){ return 	'银联储蓄卡收款';}
				   			if(data=='9002'){ return 	'资金归集';}
				   			if(data=='9003'){ return 	'批量代付';}
				   			if(data=='9010'){ return 	'微信';}
				   			if(data=='9011'){ return 	'支付宝';}
				   			if(data=='9090'){ return 	'中信信用卡';}
				   			if(data=='9091'){ return 	'中信储蓄卡';}
				   			if(data=='9099'){ return 	'中信附属帐户支付';}
				   			if(data=='9100'){ return 	'代付';}
				   			if(data=='9102'){ return 	'跨行支付';}
				   			else{return data;} 

						 
	   					}
				   		},
				   		{name:'TRAN_NOTE',align:"center",width:40},
				   		{name:'BATCHID',align:"center",width:66},
				   		{name:'',align:"center",width:50,formatter:function(value,row,index){
				   		if(userName==index.PAYERCUST_ID){
				   		return index.PAYEECUST_NAME;
				   		}else{
				   		return index.PAYERCUST_NAME;
				   		}
				   		}},
				   		{name:'PAYERCUST_ID',align:"center",width:30,formatter:function(value,row,index){
				   		if(userName==index.PAYERCUST_ID){
				   		return '支出';
				   		}else{
				   		return '收入';
				   		}
				   		}},
				   		{name:'TRANAMOUNT',align:"center",width:36},
				   		{name:'STATE',align:"center",width:30,
				   		editable:true,formatter:function(data){
							if(data=='10'){
								return '未支付';
							}else if(data=='00'){
								return '待支付';
							}else if(data=='01'){
								return '支付中';
							}else if(data=='02'){
								return '支付成功';
							}else if(data=='03'){
								return '支付失败';
							}
	   					}
				   		},
				   		{name:'detail',index:'PK_NO',width:60,align:'center',sortable:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
				   		
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.PAYERCUST_ID=='收入'){
							detail ="<button type='input' name='"+rowData.TRANAMOUNT+"' class='btn btn-info edit shouru' id='"+rowData.BATCHID+"' data-toggle='jBox-show' href='${base}/paybill/paybillDetailUI.jhtml'>详情</button>";
							}else{
							detail ="<button type='input' name='"+rowData.TRANAMOUNT+"' class='btn btn-info edit zhichu' id='"+rowData.BATCHID+"' data-toggle='jBox-show' href='${base}/paybill/paybillDetailUI.jhtml'>详情</button>";
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
				
				$("#paybilllist_search").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#query-form").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
			});
			
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
					<div class="control-group sub_status">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="subaccountlist" class="sub_status_but "><a>我的账户</a></li>
							<li role="presentation" id="paybilllist" class="sub_status_but active"><a>交易记录</a></li>
							<li role="presentation" id="subaccountseqInfo" class="sub_status_but"><a>收支明细</a></li>
						</ul>						 
					 </div>
					 <div style="border-bottom:1px solid #f39801;padding-bottom:10px;position:relative;">
	            <form class="form form-inline queryForm"   >
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
	            <span class="open_btn" style="top:33px;"></span>
	        </div>
	            <div class="form_divBox"  >
	            <form class="form form-inline queryForm"	style="overflow:hidden;" id="query-form"> 
						<div class="form-group">
							<label class="control-label">交易时间:</label>
							<input type="text" class="form-control" id="startDate" name="startDate" style="width:95px;" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
						</div>
						<div class="form-group">
							<span class="control-label" style="color:#6c6c6c;padding-right:10px;vertical-align:middle;">至</span>
							<input type="text" class="form-control" id="endDate" name="endDate" style="width:95px;" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
						</div>
						<div class="form-group" style="margin-left:50px;">
		                    <label class="control-label">交易状态:</label>
		                    <select class="form-control" name="state">
		                        <option value="">全部状态</option>
		                        <option value="10">未支付</option>
		                        <option value="00">待支付</option>
		                        <option value="01">支付中</option>
		                        <option value="02">支付成功</option>
		                        <option value="03">支付失败</option>
		                    </select>
	                    </div>
	                    <div class="form-group" >
		                    <label class="control-label">交易分类:</label>
		                    <select class="form-control" name="tranType" style="width:95px;">
		                        <option value="">全部</option>
		                        [#list tranType as type]
		                        <option value="${type.CODE}">${type.NAME}</option>
		                        [/#list]
		                    </select>
	                    </div>
	                    </br>
	                    <div class="form-group">
							<label class="control-label">金额范围:</label>
							<input type="text" class="form-control" name="minMoney" style="width:95px;"   onBlur="checkPrice(this)" />
						</div>
						<div class="form-group">
							<span class="control-label" style="color:#6c6c6c;padding-right:10px;vertical-align:middle;">至</span>
							<input type="text" class="form-control" name="maxMoney" style="width:95px;"   onBlur="checkPrice(this)"/>
						</div>
						<div class="form-group" style="margin-left:50px;">
	                    	<label class="control-label">资金流向:</label>
		                    <select class="form-control" name="tradeType" style="width:91px;">
		                        <option value="">全部</option>
		                        <option value="1">收入</option>
		                        <option value="2">支出</option>
		                    </select>
	                    </div>
	                    <div class="search_cBox">
		                    <div class="form-group"  >
		                    	<button type="button" class="search_cBox_btn" id="paybilllist_search" data-toggle="jBox-query">搜 索 </button>
		                    </div>
		                    
	                    </div>
		            </form>
				</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
    </body>
    	<form action="" method="post" id="tabFrom"></form>
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
	
	function checkPrice(obj){ 
		if(null==obj.value||''==obj.value){
		return;
		}
		 else if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
		 top.$.jBox.tip('请输入正确的金额');
		obj.value='';
		 } 
		 }
</script> 