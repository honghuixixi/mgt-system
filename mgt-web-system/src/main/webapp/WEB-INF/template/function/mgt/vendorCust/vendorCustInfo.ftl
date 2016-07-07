<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-客户信息维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendorCust/list.jhtml',
 					colNames:['','客户编码','客户名称','类别','业务员','地区','地址','线路','排序','属性','状态','创建时间','操作'],
				   	colModel:[
				   		{name:'CUST_CODE',index:'CUST_CODE',width:0,hidden:true,key:true},
				   		{name:'CUST_CODE',align:"center",width:'6%'},
				   		{name:'CUST_NAME',align:"center",width:'6%'},
				   		{name:'CAT_NAME',align:"center",width:'4%'},
				   		{name:'SP_NAME',align:"center",width:'4%'},
				   		{name:'AREA_NAME',align:"center",width:'9%'},
				   		{name:'CRM_ADDRESS1',align:"center",width:'9%'},
				   		{name:'ROUTE_NAME',align:"center",width:'9%'},
				   		{name:'SORT_NO',align:"center",width:'3%',editable:true,formatter:function(cellvalue, options, rowObject){
				   			
				   			if(cellvalue==null){
				   				  return "<input type='text' id='"+options.rowId+"' onkeyup='validateData(this)'   onBlur=addSortNo('"+options.rowId+"',this)  maxlength=80>";
				   			}else{
				   		  		 return "<input type='text' id='"+options.rowId+"' value='"+cellvalue+"' onkeyup='validateData(this)'  onBlur=addSortNo('"+options.rowId+"',this) maxlength=80>";
				   			}
				   			}
				   		},
				   		{name:'CUST_ATTR',align:"center",width:'3%',
				   		editable:true,formatter:function(data){
							if(data=='O'){
								return '自有';
							}else if(data=='P'){
								return '平台';
							}
	   					}
				   		},
				   		{name:'SHOW_FLG',align:"center",width:'3%',
				   			editable:true,formatter:function(data){
								if(data=='Y'){
									return '正常';
								}else if(data=='N'){
									return '锁定';
								}
	   					}},
	   					{name:'CREATE_DATE',align:"center",width:'7%',formatter : function(data){
	                        if(!isNaN(data) && data){
	                        data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
	                        }
	                        return data;
                        }},
				   		{name:'detail',index:'PK_NO',width:'12%',align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CUST_CODE+"' data-toggle='jBox-show'  href='${base}/vendorCust/detailVendorCustUI.jhtml'>明细</button>";
							if(rowData.SHOW_FLG=='正常'){
							//detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='shutdown("+rowData.CUST_CODE+")'>停用</button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CUST_CODE+"' data-toggle='jBox-change-order' href='${base}/vendorCust/vendorCustFlg.jhtml?showflg=N&custCode="+rowData.CUST_CODE+"'>停用</button>";
							}else if(rowData.SHOW_FLG=='锁定'){
							//detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"'  onclick='activated("+rowData.CUST_CODE+")'>启用</button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.CUST_CODE+"' data-toggle='jBox-change-order' href='${base}/vendorCust/vendorCustFlg.jhtml?showflg=Y&custCode="+rowData.CUST_CODE+"'>启用</button>";
							}
							[#if discountEnabled]
							detail += '<a  class="btn btn-info edit" style="color:#0c589e;line-height:1.428571429;padding:3px;" href="${base}/vendorStkDis/stkPriceDiscount.jhtml?custCode='+rowData.CUST_CODE+'">设置优惠价</a>';
							[/#if]
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
				   	
				});
				
				//table数据高度计算
				tabHeight();
				
			});
			
			$(function($) {
				//加载区域控件
				addAreaSelect($(".area_list"));
				loadArea();
				//隐藏查询条件div
				//$("#currentDataDiv2").hide();
				//展开收起查询条件
 				//$("#advanced_search").click(function (){
 					//if($("#currentDataDiv2").is(":hidden")){
						//$("#currentDataDiv2").show();
 					//}else{
						//$("#currentDataDiv2").hide();
 					//}
				//})
				
				//判断复选框状态
				$("#showFlgCB").click(function(){
					if($("#showFlgCB").attr("checked")){
						$("#showFlg").val("N");
					}else{
						$("#showFlg").val("");
					}
				})
				//清空
				$("#resetAll").click(function(){
					$("#query-form2 :input").not(":button, :submit, :reset, :hidden").val("").removeAttr("checked").remove("selected");
					$("#showFlg").val("");
					// 删除区域下拉列表
    				removeAreaSelect($(".area_list"))
					//加载区域控件
					addAreaSelect($(".area_list"));
					loadArea()
				});
				
				$("#allSeach").click(function(){
					if (mgt_util.validate("#query-form1")){
						$("#grid-table").jqGrid('setGridParam', {
							start : 1,
							datatype:'json',
							type:'post',
							mtype:'post',
							page:1 ,
							postData : {allSeachTex:$("#allSeachTex").val()}
						}).trigger("reloadGrid");
					}
				});
				
				$("#vendorCust_query").click(function(){
					$(".isArea").removeClass("isArea")
					if (mgt_util.validate("#query-form2")){
						return true;
					}else{
						return false;
					}
					
				});
				
				$(".selectli").click(function(){
					$this = $(this);
					$(".cur").removeClass("cur");
					$this.addClass("cur");
					var id = $this.attr("id");
					$("#withoutRote").val("");
					$("#withoutPic").val("");
					$("#showFlg").val("");
					if(id == 'getAll'){
						$("#withoutPic").val("N");
					}else if(id == 'getWithoutPic'){
						$("#withoutPic").val("Y");
					}else if(id == 'getWithoutRote'){
						$("#withoutRote").val("Y");
					}else if(id == 'getStop'){
						$("#showFlg").val("N");
					}
					$("#vendorCust_query").click();
				});
				
				$("#custLocation").click(function(){
					var postData = {custCode:$("#custCode").val(),areaId:$("#areaId").val(),allSeachTex:$("#allSeachTex").val(),withoutPic:$("#withoutPic").val(),custType:$("#custType").val(),startDate:$("#startDate").val(),endDate:$("#endDate").val(),custName:$("#custName").val(),spUserName:$("#spUserName").val(),showFlg:$("#showFlg").val()};
					var ss = JSON.stringify(postData); 
					var url = '${base}/vendorCust/vendorcustlocationUI.jhtml?postData='+ss;
					window.location.href = url;
				});
				$("#custCodes").change(function(){
					if($("#custCodes").val()==""){
						$("#custCodesDiv").removeClass("has-error");
					}
				});
				
				
				$("#custCode").change(function(){
					if($("#custCode").val()==""){
						$("#custCodeDiv").removeClass("has-error");
					}
				});
				
				
				$("#custName").change(function(){
					if($("#custName").val()==""){
						$("#custNameDiv").removeClass("has-error");
					}
				});
				
				$("#spUserName").change(function(){
					if($("#spUserName").val()==""){
						$("#spUserNameDiv").removeClass("has-error");
					}
				});
				
				$(".toUrl").click(function(){
					var grid = $("#grid-table");
	   				var ids = grid.jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请至少选择一条记录！');
						return;
					}
					var url = $(this).attr("url");
					url = url + '?id=' + ids;
					mgt_util.showjBox({
						width : 800,
						height : 500,
						title : $(this).html(),
						url : url,
						grid : grid
					});
				});
				
				$(".toRemove").click(function(){
					var grid = $("#grid-table");
	   				var ids = grid.jqGrid('getGridParam', 'selarrrow');
					if (ids.length <= 0) {
						top.$.jBox.tip('请选择一条记录！');
						return;
					}
					var url = $(this).attr("url");
					$.jBox.confirm("确认要清除业务员吗?", "提示", function(v){
						if(v == 'ok'){
							mgt_util.showMask('正在删除数据，请稍等...');
							$.ajax({
								url : url,
								type :'post',
								dataType : 'json',
								data : 'id=' + ids,
								success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										if(data.code=='function_merchant_error_001'){
											top.$.jBox.tip('当前应用正在使用,不能删除！','error');
										}else{
											top.$.jBox.tip('删除成功！','success');
										}
										mgt_util.refreshGrid(grid);
									}
								});
								}
							});
						}
					});
				});
			});
			
			//停用
			function shutdown(custCode){
			alert(custCode);
			 $.jBox.confirm("确认停用吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				url:'${base}/vendorCust/vendorCustFlg.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'custCode':custCode,
				'showflg':'N'
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==100){
					top.$.jBox.tip('停用成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table').trigger("reloadGrid");
					}
					else{
					top.$.jBox.tip('停用失败！', 'error');
			 			return false;
					}
				}
			});	
			}});
			
			}
			//启用
			function activated(custCode){
			 $.jBox.confirm("确认启用吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				 url:'${base}/vendorCust/vendorCustFlg.jhtml',
				 sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'custCode':custCode,
				'showflg':'Y'
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==100){
					top.$.jBox.tip('启用成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table').trigger("reloadGrid");
					}
					else{
					top.$.jBox.tip('启用失败！', 'error');
			 			return false;
					}
				}
			});	
			}});
			
			}
			
			// 加载区域选项
    		function loadArea(){
	    		$("#areaId").lSelect({
	    			isArea:"on",
		    		url:"${base}/common/area.jhtml"
	    		});
    		}
     		// 显示区域下拉列表
    		function addAreaSelect(v){
        		v.append('<input type="text"  id="areaId" name="areaId"  treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
    		}
    		
    		// 删除区域下拉列表
    		function removeAreaSelect(v){
        		v.empty();
   			}
   			
   			function getAll(){
   				$("#getAll").attr("class","cur");
   				$("#getWithoutPic").attr("class","");
   				$("#withoutPic").val("N");
   				
   				$("#vendorCust_query").click();
   			}
   			function getWithoutPic(){
   				$("#getWithoutPic").attr("class","cur");
   				$("#getAll").attr("class","");
   				$("#withoutPic").val("Y");
   				$("#vendorCust_query").click();
   			}
   			
   			function validateData(obj){
				if (/\D/.test($(obj).val())) {
					$(obj).val(1);
				}
			}
   			
   			
   			function addSortNo(custCode,obj){
   			   
	 			$.ajax({
					   url:'${base}/vendorCust/updateSortNo.jhtml',
					   sync:false,
						type : 'post',
						dataType : "json",
						data :{
							'custCode':custCode,
							'sortNo':$(obj).val()
						},
						error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
							if(data.code==100){
							top.$.jBox.tip('修改成功！', 'success');
							top.$.jBox.refresh = true;
							//$('#grid-table').trigger("reloadGrid");
							}
							else{
							top.$.jBox.tip('修改失败！', 'error');
					 			return false;
							}
						}
				});	
			}
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
				<div class="currentDataDiv_tit" style="height:auto;">
					<span class="open_btn" id="advanced_search" style="top:53px;"></span>
					<input type="hidden" name="searchStrBak" id="searchStrBak" >
					<form class="form form-inline "  id="query-form1">
					<div class="spanSearch_btn" style="top:53px;"><input type="text" id="allSeachTex" name="allSeachTex" /><a href="#" id="allSeach"></a></div>
						<button type="button" class="btn_divBtn" data-toggle="jBox-win" href="${base}/vendorCust/addVendorCustUI.jhtml?id=" jBox-width="1000" jBox-height="500">新 增 </button>
						<button type="button" class="btn_divBtn" data-toggle="jBox-edit" href="${base}/vendorCust/addVendorCustUI.jhtml" jBox-width="1000" jBox-height="500">修改 </button>
						<div class="btn-group">
						   <button type="button" class="btn btn-default dropdown-toggle btn_divBtn" 
						      data-toggle="dropdown">
						      批量修改 <span class="caret"></span>
						   </button>
						   <ul class="dropdown-menu" role="menu">
						      <li><a href="#" url="${base}/vendorCust/updateCustCatUI.jhtml" class="toUrl">客户类别</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/vendorCust/updateCustRoteUI.jhtml" class="toUrl">客户线路</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/vendorCust/deletepic.jhtml" class="toRemove">清除业务员</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/vendorCust/updateCustSalesmanUI.jhtml" class="toUrl">指定业务员</a></li>
						   </ul>
						</div>
						<a href="${base}/impvendorcust/impvendorcustlist.jhtml"><button type="button" class="btn_divBtn"  >导入 </button></a>
						<button type="button" class="btn_divBtn" id="custLocation">查看客户分布 </button>
						<!-- 
						<button type="button" class="btn_divBtn" data-toggle="jBox-remove-role" href="${base}/vendorCust/deletepic.jhtml">删除业务员 </button>
						-->
		            </form>
		            <div style="width:100%;overflow:hidden;">
	           			<ul class="change-ul" style="list-style:none;padding:4px 15px 0 0;float:left;">
    						<li class="selectli cur" style="margin-right:10px;" id="getAll">全部</li>
    						<li class="selectli" id="getWithoutPic">未分配业务员</li>
    						<li class="selectli" id="getWithoutRote">未分配线路</li>
    						<li class="selectli" id="getStop">已停用</li>
  						</ul>
	               	 </div>
	            </div>
	        </div>
	        <div class="form_divBox">
	        	<div id="currentDataDiv2" action="menu" >
		            <form class="form form-inline  " id="query-form2">      
		                <div id="finishSt" class="">
		                	<table class="">
		                		<tr height="50px">
			                		
		              				<td height="30" align="right"><label class="control-label" style="padding:3px 5px 0 0;">客户编码</label></td>
		              				<td height="30" align="left"><input type="text" class="form-control" id="custCode" name="custCode" style="width:120px;" maxlength=16 /></td>
		              				<td height="30" align="right"><label class="control-label" style="padding:3px 5px 0 0;">客户名称</label></td>
		              				<td height="30" align="left"><input type="text" class="form-control isContainsSpecialChar" id="custName" name="custName" style="width:120px;" maxlength=30 /></td>
		              				<td height="30" align="right"><label class="control-label" style="padding:3px 5px 0 0;">业务员</label></td>
		              				<td height="30" align="left"><input type="text" class="form-control isContainsSpecialChar" name="spUserName" id="spUserName" style="width:120px;" maxlength=30 /></td>
		              				<td style="width:105px;" align="right"><label class="control-label" style="padding:3px 5px 0 0;">客户属性</label></td>
		              				<td width="80px" align="left">
		                			<select class="form-control" id="custAttr" name="custAttr" style="width:120px;">
										<option value="">请选择</option>
	    								<option value="O">自有</option>
	    								<option value="P">平台</option>
									</select>
									<input type="hidden" id="withoutPic" name="withoutPic" value="N" >
									<input type="hidden" id="withoutRote" name="withoutRote" value="N" >
									</td>
									<td width="80" align="right"><label class="control-label" style="padding-right:5px;">线路</label></td>
		                			<td>
									<select class="form-control " id="routeCode" name="routeCode" style="width:120px;">
									<option value="">请选择</option>
										[#if routeList?exists] 
  											[#list routeList as route]
    											<option value="${route.ROUTE_CODE}">${route.ROUTE_NAME}</option>
  											[/#list]
										[/#if]
									</select>
		                			</td>
		                		</tr>
		                		<tr>
		                			<td width="80" align="right"><label class="control-label" style="padding-right:5px;">客户类型</label></td>
		                			<td>
		                			<select class="form-control " id="custType" name="custType" style="width:120px;">
										<option value="">请选择</option>
											[#if typeList?exists] 
	  											[#list typeList as type]
	    											<option value="${type.custType}">${type.name}</option>
	  											[/#list]
											[/#if]
									</select>
		                			</td>
		                			<td width="80" align="right"><label class="control-label" style="padding-right:5px;">创建时间从</label></td>
		                			<td colspan="2">
		                			<input type="text" style="width:105px;" class="form-control" name="startDate" id="startDate" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" ><span class="control-label" style="text-align:center;">到</span>
		                			<input type="text" style="width:105px;" class="form-control" name="endDate" id="endDate" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" ></td>
		                			<td height="30px" width="110px" align="right"><label class="control-label" style="padding:3px 5px 0 0;">地区</label></td>
			                		<td colspan="3"> <span class="area_list" style="display: block;float: left;overflow: hidden;line-height:20px;width:350px">
		              					</span>
		              				</td>
		                		</tr>
		                	</table>
		                	<ul class="help_box">
		                		<li style="text-align:right;vertical-align:middle;width:auto;float:right;">
		                			<input type="hidden" name="showFlg" id="showFlg" style="float:left;" />
		                			<button style="float:left;margin-right:5px;" type="button" class="btn_divBtn" id="vendorCust_query" data-form="#query-form2" data-toggle="jBox-query">查 询 </button>
		                			<button style="float:left;" type="button" class="btn_divBtn" id="resetAll">清 空 </button>
		                		</li>
		                	</ul>
		                	<!--
		                	<td height="30px" width="110px" align="right"><label class="control-label" style="padding:3px 5px 0 0;">地区</label></td>
			                		<td colspan="3"> <span class="area_list" style="display: block;float: left;overflow: hidden;line-height:20px;width:350px">
		              					</span>
		              				</td>
		                	<ul class="help_box">
		                		<li>
		                			<div class="form-group vendorCust-help" id="custCodeDiv" >
			                			<label class="control-label">客户编码</label>
			                			<input type="text" class="form-control abc" id="custCode" name="custCode" style="width:120px;" maxlength=16 />
		                			</div>
		                			<div class="form-group vendorCust-help" id="custNameDiv">
			                			<label class="control-label">客户名称</label>
			                			<input type="text" class="form-control isContainsSpecialChar" id="custName" name="custName" style="width:120px;" maxlength=30 />
		                			</div>
		                			<div class="form-group vendorCust-help" id="spUserNameDiv">
			                			<label class="control-label" >业务员</label>
			                			<input type="text" class="form-control isContainsSpecialChar" name="spUserName" id="spUserName" style="width:120px;" maxlength=30 />
		                			</div>
		                		</li>
		                		<li style="text-align:right;vertical-align:middle;width:auto;float:right;">
		                			<input type="checkbox" name="showFlgCB" id="showFlgCB" style="float:left;margin:15px 5px 0 0" />
		                			<input type="hidden" name="showFlg" id="showFlg" style="float:left;" />
		                			<label class="control-label controlAlign"  style="float:left;line-height:24px;">显示已停用</label>
		                			<button style="float:left;margin-right:5px;" type="button" class="btn_divBtn" id="vendorCust_query" data-form="#query-form2" data-toggle="jBox-query">查 询 </button>
		                			<button style="float:left;" type="button" class="btn_divBtn" id="resetAll">清 空 </button>
		                		</li>
		                	</ul>
		                		-->
						</div>
		            </form>
		        </div>
	        </div>
	      </div>   
		    <table id="grid-table" >
		    </table>
		    <div id="grid-pager"></div>
   		</div>
    </body>
    
</html>