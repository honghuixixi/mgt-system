<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>在线对账</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0" style="display:none;"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object>	
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={checkState:"01"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/paybillDtl/list.jhtml',
 					colNames:['','订单日期','订单编号','付款方账号','交易分类','订单金额','交易金额','费用金额','金融费用','对账状态','支付状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CREATE_TIME',align:"center",width:90,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }
                        },
				   		{name:'SUB_ORDERID',align:"center",width:190},
				   		{name:'PAYERCUST_ID',width:90,align:"center"},
				   		{name:'TRAN_SUBTYPE',width:85,align:"center",
				   		editable:true,formatter:function(data){
							if(data=='10'){
								return '货款';
							}else if(data=='11'){
								return '物流费';
							}else if(data=='12'){
								return '广告费';
							}else{
							return data;
							}}
				   		},
				   		{name:'ORDER_AMOUNT',align:"center",width:70},
				   		{name:'TRANAMOUNT',align:"center",width:70}, 
				   		{name:'TRANFEEAMOUNT',align:"center",width:70},
				   		{name:'CHANNELFEEAMOUNT',align:"center",width:70},
				   		{name:'CHECK_STATE',align:"center",width:70,
				   		editable:true,formatter:function(data){
							if(data=='00'){
								return '不可对账';
							}else if(data=='01'){
								return '可对账';
							}else if(data=='02'){
								return '对账成功';
							}else{
							return data;
							}}
				   		},
				   		{name:'PAY_STATE',align:"center",width:'80',
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
							}else{
							return "";
							}
							
							}
				   		},
				   		{name:'',index:'PK_NO', width:160,align:"center",formatter:function(value,row,index){
	   		            var detail ="<button type='button' class='btn btn-info edit' id='"+index.SUB_ORDERID+"' data-toggle='jBox-show' href='${base}/paybillDtl/paybillDtlDetailUI.jhtml'>详情 </button><button type='button' class='btn btn-info edit' id='"+index.SUB_ORDERID+"' data-toggle='jBox-show' href='${base}/paybillDtl/tranfeeDetailUI.jhtml'>费用明细</button>";
	   		            if(index.CHECK_STATE=='01'){
							detail +="</br><button type='button' class='btn btn-info edit float_btn'  id='role_modifyScopeToPublic'   onClick=accountCheck('"+index.PK_NO+"','02') href='${base}/paybillDtl/accountCheck.jhtml?flg=02'>对账 </button>";						
							}else{
							detail +="</br><button type='button' class='btn btn-info edit float_btn'  id='role_modifyScopeToPublic' onClick=accountCheck('"+index.PK_NO+"','01') href='${base}/paybillDtl/accountCheck.jhtml?flg=01'>撤销 </button>";
							}
						return  detail;
	   		            }}
				   	],
					onSelectAll:function(aRowids,status){
					setTimeout(function(){
				   	var orderAmountSpan = 0.00;
				   	var selectedIds = $("#grid-table").jqGrid("getGridParam", "selarrrow");
				   	for(var i=0;i<selectedIds.length;i++){
				   	var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
				   	orderAmountSpan=orderAmountSpan+parseFloat(rowData.TRANAMOUNT);
				   	}
				   	$("#orderAmountSpan").html(formatCurrency(orderAmountSpan));
				   	$("#orderCountSpan").html(selectedIds.length);
				   	},600);
				   	},
				   	onCellSelect:function(rowid,iCol,cellcontent,e){
					setTimeout(function(){
				   	var orderAmountSpan = 0.00;
				   	var selectedIds = $("#grid-table").jqGrid("getGridParam", "selarrrow");
				   	for(var i=0;i<selectedIds.length;i++){
				   	var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
				   	orderAmountSpan=orderAmountSpan+parseFloat(rowData.TRANAMOUNT);
				   	}
				   	$("#orderAmountSpan").html(formatCurrency(orderAmountSpan));
				   	$("#orderCountSpan").html(selectedIds.length);
				   	},600);
				   	},
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				});
				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});

			function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
       	    <!--浮动文字-->
		    <div class="pos_orderCount_box">
		   		<div class="orderCount-IconBtn"></div>
				<div class="pos_orderCount">
		   			<div class="form-group"><font>总订单数：</font><span id="orderCountSpan">0</span>张<font class="padding_fontl">总金额：</font><span id="orderAmountSpan" style="color:red;">0.00</span> 元</div>
				</div>
		    </div>
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" id="query-form"> 
	            <div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="01" class="sub_status_but active"><a href="#"> 未对账</a></li>					
							<li role="presentation" id="02" class="sub_status_but"><a href="#"> 对账成功</a></li>
						</ul>
				    </div>			
				    <div class="form-group sr-only" >
	                    <label class="control-label">对账状态</label>
	                    <select class="form-control" name="checkState">
	                        <option value="">全部</option>
	                        <option value="01">未对账</option>
	                        <option value="02">对账成功</option>
	                    </select>
	                </div>
	                <div id="onFinishSt">
	                	<div class="currentDataDiv_tit">
		                	<div class="form-group" >
						       <button type="button" class="btn_divBtn edit "  id="role_modifyScopeToPublic"  
						            href="${base}/paybillDtl/accountCheck.jhtml" onClick="accountCheck(null,'02')" >批量对账 </button>
		           			</div>
	           			</div>
	           			<div class="form_divBox" style="display:block;">
		           		 	<div class="form-group">
		                    	<input type="text" class="form-control" name="orderID" style="width:180px;"  placeholder="输入订单号(支持模糊查询)">
		               	 	</div>
		                 	<div class="form-group">
								<label class="control-label">交易时间:</label>
								<input type="text" class="form-control" id="startDate" name="startDate" onfocus="WdatePicker({maxDate:$('#endDate').val(),dateFmt:'yyyy-MM-dd'});" >
								</div>
								<div class="form-group">
								<label class="control-label">至</label>
								<input type="text" class="form-control" id="endDate" name="endDate" onfocus="WdatePicker({minDate:$('#startDate').val(),dateFmt:'yyyy-MM-dd'});" >
							</div>
						</div>
						<div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="btn_divBtn" id="order_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
			                </div>
		                </div>
           			</div>
	            </form>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>

<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	    
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("01" == $(this).attr("id")){
	    		$(".click_form").removeClass("sr-only");
	    		$("#onFinishSt").removeClass("sr-only");
	    	}else{
	        document.getElementById("query-form").reset();
	    		$(".click_form").addClass("sr-only");
	    		$("#onFinishSt").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=checkState]").val($(this).attr("id"));
	        $("#order_search").click(); 
	    });
	});
	function accountCheck(obj,flg){
	if(null==obj){
	   obj= $("#grid-table").jqGrid("getGridParam", "selarrrow");
	   	if (obj.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
	}
	   	   $.jBox.confirm("确认对账?", "提示", function(v){
				if(v == 'ok'){
		var objVal=(obj+'');
		
		 $.ajax({
      url:'${base}/paybillDtl/accountCheck.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{'ids': objVal,
      		 'flg':flg
      },
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
        if(data.success==true){
        top.$.jBox.tip('对账成功');
        $("#grid-table").trigger("reloadGrid");
 		}else{ 
		  	top.$.jBox.tip('对账失败');
		 	return false;
		}
      }
    });
		
		
		}});
	
	
	}
</script>
</html>