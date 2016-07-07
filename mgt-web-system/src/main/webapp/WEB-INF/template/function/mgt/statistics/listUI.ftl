<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script  type="text/javascript">
			$(document).ready(function(){
			var t = ${type};
			if(t == 'vendorWaitReceive' || t == 'vendorWaitDeliver'){
				var postData={type:${type},orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/statistics/statistics.jhtml',
 					colNames:['','供应商名称','','类型','订单号','创建日期','支付方式','客户名称','金额','发货仓库'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'VENDOR_NAME',align:"center",width:100},
				   		{name:'MAS_CODE',align:"center",width:40,formatter:function(data,row,rowObject){
				   				var masCode = rowObject.MAS_CODE;
				   				if(masCode == 'RETURN'){
				   					return '退';
				   				}else if(masCode == 'SALES'){
				   					return '订';
				   				}else{
				   					return '';
				   				}
							}},
				   		{name:'ORDER_TYPE',align:"center",width:40},
				   		{name:'MAS_NO',align:"center",width:180},
				   		{name:'OM_CREATE_DAT',align:"center",width:150},
				   		{name:'DM_NAME',align:"center",width:80},
				   		{name:'CUST_NAME',align:"center",width:83},
				   		{name:'AMOUNT',align:"center",width:80},
				   		{name:'WHNAME',align:"center",width:80}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}	
				});
			}else if(t == 'warehouseWaitReceive' || t == 'warehouseWaitDeliver' || t == 'warehouseException'){
				var postData={type:${type},orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/statistics/statistics.jhtml',
 					colNames:['','发货仓库','','类型','订单号','创建日期','支付方式','客户名称','金额','优惠金额','差异金额','供应商名称'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'WHNAME',align:"center",width:80},
				   		{name:'MAS_CODE',align:"center",width:30,formatter:function(data,row,rowObject){
				   				var masCode = rowObject.MAS_CODE;
				   				if(masCode == 'RETURN'){
				   					return '退';
				   				}else if(masCode == 'SALES'){
				   					return '订';
				   				}else{
				   					return '';
				   				}
							}},
				   		{name:'ORDER_TYPE',align:"center",width:40},
				   		{name:'MAS_NO',align:"center",width:170},
				   		{name:'OM_CREATE_DAT',align:"center",width:160},
				   		{name:'DM_NAME',align:"center",width:70},
				   		{name:'CUST_NAME',align:"center",width:80},
				   		{name:'AMOUNT',align:"center",width:40},
				   		{name:'MISC_PAY_AMT',align:"center",width:40},
				   		{name:'DIFF_MISC_AMT',align:"center",width:40},
				   		{name:'VENDOR_NAME',align:"center",width:83}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}	
				});
			}else if(t == 'logisticsWaitDistribution' || t == 'logisticsDistribution'){
				var postData={type:${type},orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/statistics/statistics.jhtml',
 					colNames:['','发货仓库','物流商','配送员','订单号','创建日期','支付方式','客户名称','金额','优惠金额'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'WHNAME',align:"center",width:80},
				   		{name:'LOGISTIC_NAME',align:"center",width:130},
				   		{name:'LOGISTIC_USER_NAME',align:"center",width:60},
				   		{name:'MAS_NO',align:"center",width:170},
				   		{name:'OM_CREATE_DAT',align:"center",width:160},
				   		{name:'DM_NAME',align:"center",width:70},
				   		{name:'CUST_NAME',align:"center",width:80},
				   		{name:'AMOUNT',align:"center",width:40},
				   		{name:'MISC_PAY_AMT',align:"center",width:40},
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}	
				});
			}else if(t == 'waitCollection' || t == 'financeException'){
				var postData={type:${type},orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/statistics/statistics.jhtml',
 					colNames:['','发货仓库','物流商','配送员','订单号','创建日期','支付方式','客户名称','应收金额','金额','优惠金额','差异金额'],
 					shrinkToFit:false,
 					rowList:[10,20,50],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'WHNAME',align:"center",width:80},
				   		{name:'LOGISTIC_NAME',align:"center",width:130},
				   		{name:'LOGISTIC_USER_NAME',align:"center",width:60},
				   		{name:'MAS_NO',align:"center",width:170},
				   		{name:'OM_CREATE_DAT',align:"center",width:80},
				   		{name:'DM_NAME',align:"center",width:70},
				   		{name:'CUST_NAME',align:"center",width:80},
				   		{name:'DAMOUNT',align:"center",width:40,formatter:function(data,row,rowObject){
				   				var AMOUNT = rowObject.AMOUNT;
				   				var MISC_PAY_AMT = rowObject.MISC_PAY_AMT;
				   				var DIFF_MISC_AMT = rowObject.DIFF_MISC_AMT;
				   				return Number(AMOUNT)-Number(DIFF_MISC_AMT)-Number(MISC_PAY_AMT);
							}},
				   		{name:'AMOUNT',align:"center",width:40},
				   		{name:'MISC_PAY_AMT',align:"center",width:40},
				   		{name:'DIFF_MISC_AMT',align:"center",width:40},
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}	
				});
			}
				// 加载区域选项
	    		$("#areaId").lSelect({
		    		url:"${base}/common/area.jhtml"
	    		});
			});
		</script>
		</head>
	    <body>
	        <div class="body-container">
	        <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
				<div class="form_divBox" style="display:block">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	            [#if type == "'vendorWaitDeliver'" || type =="'vendorWaitReceive'"]
	            	 <div class="form-group">
	                    <label class="control-label">供应商:</label>
	                    <select class="form-control" name="vendor" style="width:100px" >
	                    <option value="">请选择...</option>
	                    [#list supplist as supp]
	                    	<option value="${supp.USER_NO}">${supp.NAME}</option>
	                    [/#list]
	                    </select>
	                </div>  
	            [#elseif type =="'warehouseException'" || type =="'warehouseWaitDeliver'" || type=="'warehouseWaitReceive'"]
	            	<div class="form-group">
	            	<label class="control-label">仓库:</label>
	                    <select class="form-control" name="wh" style="margin-right: 4px;width:100px;">
	                    <option value="">请选择...</option>
	                    [#list whlist as wh]
	                    	<option value="${wh.whC}">${wh.name}</option>
	                    [/#list]
						</select>
                    </div>
	            [#elseif type =="'logisticsDistribution'" || type =="'logisticsWaitDistribution'"]
	            	<div class="form-group">
	            	<label class="control-label">物流:</label>
	                    <select class="form-control" name="logistics" style="margin-right: 4px;width:100px;">
	                    <option value="">请选择...</option>
	                    [#list logList as logi]
	                    	<option value="${logi.USER_NO}">${logi.NAME}</option>
	                    [/#list]
	                    </select>
                    </div>
	            [/#if]
	               <div class="form-group">
	                    <label class="control-label">订单编号:</label>
	                    <input type="text" class="form-control" name="masNo" id="masNo" style="width:120px;" >
	                </div>
	                <div class="form-group">
	                    <label class="control-label">地区:</label>
	                    <input type="hidden" class="form-control" id="areaId" name="areaId" />
	                </div>
	                <div class="search_cBox"> 
		                <div class="form-group">
			                <button type="button" class="search_cBox_btn" id="order_control_search"  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
	                </div>
	            </form>
	            </div>
	        </div>
	       </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
   		<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	    </body>
	</html>