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
				$("#check").click(function(){
					$.ajax({
						url:"${base}/impstkmas/check.jhtml?date="+new Date(),
						async:false,
						success: function(data){
							 $("#grid-table").jqGrid('setGridParam',{  
					            postData:{} //发送数据  
					        }).trigger("reloadGrid"); //重新载入  
					        top.$.jBox.tip('检查完成！', 'success');
						}
					});
				});
				
				$("#exportStk").click(function(){
					$.ajax({
						url:"${base}/impstkmas/exportStk.jhtml?date="+new Date(),
						async:false,
						success: function(data){
							 $("#grid-table").jqGrid('setGridParam',{  
					            postData:{} //发送数据  
					        }).trigger("reloadGrid"); //重新载入  
					        //top.$.jBox.tip('导入完成！', 'success');
					        alert(data.msg);
						}
					});
				});
			
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/impstkmas/stkmaslist.jhtml?date='+new Date(),
 					colNames:['','条形码','商户编码','商品名称','规格','单位','平台分类','品牌','商户分类','图片张数','描述','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'PLU_C',align:"center",width:'6%'},
				   		{name:'VENDOR_STK_C',align:"center",width:'4%'},
				   		{name:'NAME',align:"center",width:'9%'},
				   		{name:'MODLE',align:"center",width:'5%'},
				   		{name:'UOM',align:"center",width:'3%'},
				   		{name:'STK_CAT_NAME',align:"center",width:'4%'},
				   		{name:'BRAND_NAME',align:"center",width:'4%'},
				   		{name:'CAT_NAME',align:"center",width:'4%'},
				   		{name:'PIC_QTY',align:"center",width:'3%'},
				   		{name:'REMARK',align:"center",width:'9%'},
				   		{name:'detail',index:'PK_NO',width:'4%',align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							var detail = "&nbsp;<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show'  href='${base}/impstkmas/editimpstkmasUI.jhtml'>修改</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
				   	
				});
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
					
					var checkFlg;
					if(id == 'getAll'){
						checkFlg = "";
					}else if(id == 'getWithoutPic'){
						checkFlg = "E";
					}else if(id == 'getWithoutRote'){
						checkFlg = "X";
					}else if(id == 'getStop'){
						checkFlg = "P";
					}
					$("#grid-table").jqGrid('setGridParam',{
		            	postData:{"checkFlg":checkFlg},
		        	}).trigger('reloadGrid'); 
				});
				
				$("#custLocation").click(function(){
					var postData = {custCode:$("#custCode").val(),areaId:$("#areaId").val(),allSeachTex:$("#allSeachTex").val(),withoutPic:$("#withoutPic").val(),custType:$("#custType").val(),startDate:$("#startDate").val(),endDate:$("#endDate").val(),custName:$("#custName").val(),spUserName:$("#spUserName").val(),showFlg:$("#showFlg").val()};
					var ss = JSON.stringify(postData); 
					var url = '${base}/vendorCust/vendorcustlocationUI.jhtml?postData='+ss+"&date="+new Date();
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
						top.$.jBox.tip('请选择至少一条记录！');
						return;
					}
					var url = $(this).attr("url");
					window.location.href=url+'?ids='+ids;
				});
			});
			
			//停用
			function shutdown(custCode){
			alert(custCode);
			 $.jBox.confirm("确认停用吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				url:'${base}/vendorCust/vendorCustFlg.jhtml?date='+new Date(),
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
		    		url:"${base}/common/area.jhtml?date="+new Date()
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
					   url:'${base}/vendorCust/updateSortNo.jhtml?date='+new Date(),
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
					<form class="form form-inline "  id="query-form1">
						<div class="btn-group">
						   <button type="button" class="btn btn-default dropdown-toggle btn_divBtn" 
						      data-toggle="dropdown">
						                   导入导出 <span class="caret"></span>
						   </button>
						   <ul class="dropdown-menu" role="menu">
						      <li><a href="${base}/impstkmas/exprotstkmasUI.jhtml" data-toggle="jBox-win">导入excel</a></li>
						      <li class="divider"></li>
						      <li><a href="${base}/impstkmas/exprotimgUI.jhtml" data-toggle="jBox-win">导入图片</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/impstkmas/exportExcel.jhtml" class="toRemove">导出excel</a></li>
						   </ul>
						</div>
		           <button type="button" id="check" class="btn_divBtn del float_btn"  href="#">检查</button>
		            <button type="button" id="exportStk" class="btn_divBtn del float_btn"  href="#">导入系统</button>
		            <div class="btn-group">
						   <button type="button" class="btn btn-default dropdown-toggle btn_divBtn" 
						      data-toggle="dropdown">
						     批量修改<span class="caret"></span>
						   </button>
						   <ul class="dropdown-menu" role="menu">
						      <li><a href="#" url="${base}/impstkmas/updatecatUI.jhtml" class="toUrl">平台分类</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/impstkmas/updatevendorcatUI.jhtml" class="toUrl">自有分类</a></li>
						      <li class="divider"></li>
						      <li><a href="#" url="${base}/impstkmas/updatebrandUI.jhtml" class="toUrl">品牌</a></li>
						   </ul>
						</div>
		            
		            <button type="button" class="btn_divBtn edit float_btn"  id="role_modifyScopeToPublic" data-toggle="jBox-remove" 
		            href="${base}/impstkmas/removes.jhtml">删除 </button>
		            
		            <button type="button" class="btn_divBtn edit float_btn"  id="role_modifyScopeToPublic"
		            onclick="window.location.href='${base}/impstkmas/exportExcelTemplate.jhtml'" >下载模板</button>
		            
		            </form>
		            <div style="width:100%;overflow:hidden;">
	           			<ul class="change-ul" style="list-style:none;padding:4px 15px 0 0;float:left;">
    						<li class="selectli cur" style="margin-right:10px;" id="getAll">全部</li>
    						<li class="selectli " id="getWithoutPic">异常商品</li>
    						<li class="selectli" id="getWithoutRote">未导入商品</li>
    						<li class="selectli" id="getStop">已导入商品</li>
  						</ul>
	               	 </div>
	            </div>
	        </div>
	      </div>   
		    <table id="grid-table" >
		    </table>
		    <div id="grid-pager"></div>
   		</div>
    </body>
    
</html>