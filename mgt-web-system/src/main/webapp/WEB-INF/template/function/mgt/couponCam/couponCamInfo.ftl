<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>优惠券</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>	
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:14px;color:blue}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
					mgt_util.jqGrid('#grid-table',{
						url:'${base}/couponCam/list.jhtml',
	 					colNames:['','活动状态','过期状态','类型','活动标题','开始时间','截止时间','规则','面额','每人限领','总张数','已发张数','操作'],
					   	colModel:[
					   		{name:'CC_CODE',index:'CC_CODE',width:0,hidden:true,key:true},
					   		{name:'STATUS_FLG', width:80,align:"center",formatter:function(data){
							if(data=='A'){
								return '未启用';
							}else if(data=='P'){
								return '已启用';
							}else if(data=='E'){
								return '已停用';
							}else{
							    return '未启用';
							}}
							},
							{name:'STATUS_FLGS', width:80,align:"center",formatter:function(data){
							if(data=='X'){
								return '已过期';
							}else{
								return '未过期';
							}}
							},
					   		{name:'CP_PROP', width:50,align:"center",formatter:function(data){
							if(data=='P'){
								return '平台券';
							}else if(data=='O'){
								return '自有券';
							}else{
							    return data;
							}}
							},
					   		{name:'CC_NAME',align:"center",width:150},
					   		{name:'DATE_FROM',align:"center",width:180,formatter : function(data){
	                            if(!isNaN(data) && data){
	                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
	                            }
	                            if(data!=null){
	                            return data;
	                            }else{
	                            return "";
	                            }
	                            }
	                        },
					   		{name:'DATE_TO',align:"center",width:180,formatter : function(data){
	                            if(!isNaN(data) && data){
	                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
	                            }
	                            if(data!=null){
	                            return data;
	                            }else{
	                            return "";
	                            }
	                            }
	                        },
					   		{name:'ISSUE_TYPE', width:100,align:"center",formatter:function(data){
							if(data=='U'){
								return '用户领取';
							}else if(data=='O'||data=='R'){
								return '自动发放';
							}else{
							    return data;
							}}
							},
					   		{name:'CP_VALUE',width:75,align:'center'},
					   		{name:'SINGLE_CUST_MAX_QTY',width:75,align:'center'},
					   		{name:'TOTAL_QTY',width:75,align:'center'},
					   		{name:'PROVIDE',width:75,align:'center'},
					   		{name:'detail',index:'CC_CODE',width:180,align:'center',sortable:false} 
					   	],
					   	gridComplete:function(){ 
						   	var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
							for(var i=0; i<ids.length; i++){ 
								var id=ids[i]; 
								var rowData = $('#grid-table').jqGrid('getRowData',id);
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/couponCam/couponCamDetail.jhtml'>详情 </button>";
								if(rowData.STATUS_FLG=='未启用'||(rowData.STATUS_FLG=='已停用'&&rowData.PROVIDE==0)){
								detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CC_CODE+"' data-toggle='jBox-show'  href='${base}/couponCam/edit.jhtml'>修改</button>";
								}
								jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
							};
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						}
					});
						
					$("li[name='statusFlg']").on('click', function(){
					    if($(this).attr("value")=='1'){
					    var postData={statusFlg:"A",statusFlgs:""};
			    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
			    		.trigger("reloadGrid");
					    }else if($(this).attr("value")=='2'){
					    var postData={statusFlg:"P",statusFlgs:""};
			    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
			    		.trigger("reloadGrid");
					    }else if($(this).attr("value")=='3'){
					    var postData={statusFlg:"",statusFlgs:"X"};
			    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
			    		.trigger("reloadGrid");
					    }
					});  
					
					$(".change-ul li").click(function(){
						$(".change-ul li").removeClass("cur");
						$(this).addClass("cur");
					});
					$("#stock_query").click(function(){
						$(".change-ul li").removeClass("cur");
						var postData={statusFlg:"",statusFlgs:""};
			    		$('#grid-table').jqGrid('setGridParam',{postData:postData,gridComplete:butten2})
			    		.trigger("reloadGrid");
					});
				});
				var butten2 = function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
					for(var i=0; i<ids.length; i++){ 
						var id=ids[i]; 
						var rowData = $('#grid-table').jqGrid('getRowData',id);
						detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/couponCam/couponCamDetail.jhtml'>详情 </button>";
						if(rowData.STATUS_FLG=='未启用'||(rowData.STATUS_FLG=='已停用'&&rowData.PROVIDE==0)){
						detail +="&nbsp;&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CC_CODE+"' data-toggle='jBox-show'  href='${base}/couponCam/edit.jhtml'>修改</button>";
						}
						jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
					};
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
				}
		</script>
    </head>
    <body>
    
       <div class="body-container">
         <div class="main_heightBox1">
         	<div style="border-bottom:1px solid #f39801;overflow:hidden;padding-bottom:10px;">
	            <form class="form form-inline queryForm"  id="query-form" name="form1">
	            </br>
					<div class="form-group">
		                 	<button type="button" class="btn_divBtn add" id="couponcam_add"  data-toggle="jBox-win" href="${base}/couponCam/addCouponCamUI.jhtml">新增 </button>
		    		        <button type="button" class="btn_divBtn del" id="couponcam_edit" data-toggle="jBox-change-order" href="${base}/couponCam/editStatusFlgY.jhtml">启用 </button>
		    		        <button type="button" class="btn_divBtn del" id="couponcam_edit_no" data-toggle="jBox-change-order" href="${base}/couponCam/editStatusFlgN.jhtml">停用</button>
		             </div>
	           		<div>
	           			<ul class="change-ul" style="list-style:none;padding-top:14px;float:left;">
    						<li name="statusFlg" value="1">未启用</li>
    						<li name="statusFlg" value="2">已启用</li>
    						<li name="statusFlg" value="3" style="margin-right:10px;">已过期</li>
  						</ul>
	               	 </div>
						<div class="search_cBox" style="bottom:20px;">
							 	<!-- <button class="search_cBox_btn btn btn-info"  id="order_search" data-toggle="jBox-call"  data-fn="checkForm">
							 	搜索<i class="fa-save align-top bigger-125 fa-on-right"></i>
						        </button>-->
						        <button type="button" class="btn_divBtn" id="stock_query" data-toggle="jBox-query"><i class="icon-search"></i> 全 部 </button>
           			    </div>
	            </form>
	            </div>
	      </div>
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>