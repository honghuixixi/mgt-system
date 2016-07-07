<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>营销管理-赠品发放</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<style>
		.new_select select{width:auto;display:inline-block;}
		.page-content .form-control{width:auto;}
		.yyzx_xgBox{padding:20px 0;}
		.tjqy_table tr td{vertical-align:middle;}
		.row{margin-top:10px;}
		.a{text-decoration:none;}
		</style>
		
		<script  type="text/javascript">
		$(document).ready(function(){
			
		});
		function addStkMasUI(){
			$.jBox.open("iframe:${base}/donation/addStkMasUI.jhtml", "新增赠品商品", 800, 350, { buttons: { } });
		}
		
		
		</script>
    </head>
    <body>
    <input type="hidden" id="userDate" name="userDate" value="${userDate}"/>
    <input type="hidden" id="flg" name="flg" />
       <div class="body-container">
       <div class="main_heightBox1">
	<div id="currentDataDiv" action="menu" >
		<div class="btn_diva_box"></div>
		<div class="currentDataDiv_tit">
			<button type="button" class="btn btn-info btn_divBtn" onclick="history.back();">返回赠品发放列表页</button>
		</div>
    </div>
  </div> 
         <div id="main_heightBox" class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="CATEGROY" class="sub_status_but active"><a href="#"> 赠券</a></li>					
							<li role="presentation" id="BRAND" class="sub_status_but"><a href="#"> 赠商品</a></li>						
						</ul>
					</div>
					<div class="form_divBox" style="display:block;">
						<div class="form-group">
	                 		<button type="button" class="btn_divBtn add" id="vendorStkCat_add"  onClick="editPack()">新增 </button>
	                 		<button type="button" class="btn_divBtn add" id="vendorStkCat_grant"  onClick="grantTable()">保存 </button>
		                	<div class="" id="btnRadio" hidden="true">
								<button type="button" class="btn_divBtn add" onClick="addStkMasUI()" >新增</button>
								<button type="button" class="btn_divBtn add" onClick="addDonationTask()" >保存</button>
								 有效时间:<input type="text" id="beginDates" name="beginDates" class="form-control " onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width:181px;" value="${beginDates}"/>
							</div>
						</div> 
	                </div>
	            </form>
	        </div>
	      </div>
	      <table id="packTab" class="tjqy_table" width="90%" border="0" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th align="center" width="15%">*面额</th>
						<th align="center" width="15%" >*消费最低金额</th>
						<th align="center" width="15%" >*张数</th>
						<th align="center" width="40%" >*优惠券有效期</th>
						<th align="center" width="15%" >操作</th>
					</tr>
				</thead>
			</table>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
$().ready(function() {
	// 状态面包屑事件，改变隐藏域select值并提交表单
    $("li.sub_status_but").on("click",function(){
    	$('#grid-table').GridUnload();//重绘
        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
        //商品分类
    	if("CATEGROY" == $(this).attr("id")){
    		$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		$("#addStock").show();
    		$("#btnRadio").hide();
			$("#query-form").css("height","80px");
			$("#vendorStkCat_add").removeClass("sr-only");
			$("#vendorStkCat_grant").removeClass("sr-only");
			$("#packTab").removeClass("sr-only");
			$("#brand_search").addClass("sr-only");
			
    	}
    	//商品品牌
    	if("BRAND" == $(this).attr("id")){
    		$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		$("#addStock").hide();
    		$("#btnRadio").show();
			$("#query-form").css("height","80px");
    		$("#vendorStkCat_add").addClass("sr-only");
    		$("#vendorStkCat_grant").addClass("sr-only");
    		$("#brand_search").removeClass("sr-only");
    		$("#packTab").addClass("sr-only");
    		//发送异步请求
    		var postData={orderby:"CREATE_DATE"};
    		mgt_util.jqGrid('#grid-table',{
 					colNames:['商品编码','条码','商品名称','价格','单位','规格','数量','操作'],
 					//multiselect : false,
				   	colModel:[	 
						{name:'STK_C',index:'STK_C',width:50,hidden:false,key:true},
						{name:'PLU_C',width:70},
				   		{name:'NAME',width:130},
				   		{name:'NET_PRICE',width:40},
				   		{name:'UOM', width:30},
				   		{name:'MODLE', width:35},
				   		{name:'QTY', width:35},
				   		{name:'detail',width:35}
				   	],
					
				});
    	}
    });
});

		
		//添加一行
		function editPack(){
		    $("#packTab").append(makeThStr());
			var i =packTab.rows.length-1;
			//$("#flg").val("N")
		}
		function grantTable(){
			var url = "${base}/donation/addDonationTaskCoupon.jhtml";
			var data = getTableData("packTab");
			$("#packTab").find("input, select").each(function(){
				if($(this).attr("name")=="cpValue"){
					if($(this).val()!=null && $(this).val()!=""){
						$("#flg").val("Y")
					}else{
						top.$.jBox.tip('面额不能为空 ');
						$("#flg").val("N")
						return false;
					}
				}
				if($(this).attr("name")=="minAmtNeed"){
					if($(this).val()!=null && $(this).val()!=""){
						$("#flg").val("Y")
					}else{
						top.$.jBox.tip('消费最低金额 ');
						$("#flg").val("N")
						return false;
					}
				}
				if($(this).attr("name")=="cpQty"){
					if($(this).val()!=null && $(this).val()!=""){
						$("#flg").val("Y")
					}else{
						top.$.jBox.tip('张数 ');
						$("#flg").val("N")
						return false;
					}
				}
				if($(this).attr("name")=="cpDateFrom"){
					if($(this).val()!=null && $(this).val()!=""){
						$("#flg").val("Y")
					}else{
						top.$.jBox.tip('券开始有效期不能为空 ');
						$("#flg").val("N")
						return false;
					}
				}
				if($(this).attr("name")=="cpDateTo"){
					if($(this).val()!=null && $(this).val()!=""){
					$("#flg").val("Y")
					}else{
						top.$.jBox.tip('券结束有效期不能为空 ');
						$("#flg").val("N")
						return false;
					}
				}
			})
			if($("#flg").val()=="Y"){
				$.jBox.confirm("确认要保存优惠券吗?", "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在发放，请稍等...');
						$.ajax({
            				url:url,
            				type : 'post',
							dataType : 'json',
							data:{userDate:$("#userDate").val(),DateTable:data},
							error : function(data) {
								alert("网络异常");
								mgt_util.hideMask();
								return false;
							},
							success : function(data) { 
								top.$.jBox.tip('操作成功！', 'success');
								$(".trs").remove()
								mgt_util.hideMask();
								window.location.href = "${base}/donation/donationInfo.jhtml";
							}
            			});
					}
				});
			}else{
				top.$.jBox.tip('请输入完整信息 ');
				return false;
			}
			
		}
		

		//拼td字符串
		function makeThStr(){
			var i =packTab.rows.length;
			var th=	"<tr class='trs'>";
				th+="<td height='40' width='15%' align='center'><input id='cpValue"+i+"' leng='"+i+"' onblur='cpValue(this)' name='cpValue' type='text' maxlength='8'/></td>";
				th+="<td align='center' width='15%' ><input type='text' id='minAmtNeed"+i+"' leng='"+i+"' onblur='minAmtNeed(this)' name='minAmtNeed' maxlength='8'/></td>";
				th+="<td align='center' width='15%' ><input type='text' id='cpQty"+i+"' leng='"+i+"' onblur='cpQty(this)' name='cpQty' maxlength='8'/></td>";
				var str ="WdatePicker({minDate:\"%y-%M-%d\",dateFmt:\"yyyy-MM-dd HH:mm:ss\"})";
				th+="<td align='center' width='40%' > <input type='text' id='cpDateFrom' name='cpDateFrom' class='form-control required' onClick='WdatePicker({minDate:\"%y-%M-%d\",dateFmt:\"yyyy-MM-dd\",onpicked:pickedFunc})' style='width:181px;' /> 到<input type='text' id='cpDateTo"+i+"' name='cpDateTo' class='form-control required'   onClick='"+str+"' style='width:181px;' /></th>";
				th+="<td align='center' width='15%'><label class='control-label'><a href='#' stkc='' class='del'>删除</a></label></td>";
				th+="</tr>";
			return th;
		}
		
		function cpValue(obj){
			if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
				top.$.jBox.tip('请输入正确数字');
				return;
			}
			if(Number($("#minAmtNeed"+$("#"+obj.id).attr("leng")).val()) <= Number(obj.value)){
				if($("#minAmtNeed"+$("#"+obj.id).attr("leng")).val()!=""){
					top.$.jBox.tip('消费最低金额不能小于面额!');
					obj.value="";
					return;
				}
            }
		}
		
		function minAmtNeed(obj){
			if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(obj.value)){
				top.$.jBox.tip('请输入正确数字');
				return;
			}
			if(Number($("#cpValue"+$("#"+obj.id).attr("leng")).val()) >= Number(obj.value)){
            		top.$.jBox.tip('消费最低金额不能小于面额!');
            		obj.value="";
					return;
            }
		}
		
		function cpQty(obj){
			var regu = "^[0-9]+$";
			var re = new RegExp(regu);
			
			if (obj.value.search(re) != -1) {
					
			} else {
				top.$.jBox.tip('请输入正确数量');
				obj.value="";
				return false;
			}
			if(Number(obj.value)>Number(9999) || Number(obj.value)==Number(0)){
				top.$.jBox.tip('请输入1到9999的数字');
				obj.value="";
				return false;
			}
		}
		
		function pickedFunc(){
			var i =packTab.rows.length-1;
			var s = $dp.cal.getNewDateStr();
			$('#cpDateTo'+i).attr("onclick", "WdatePicker({dateFmt:\"yyyy-MM-dd\",minDate:'"+s+"'})");
		}
		
		
		function getTableData(tableId){
    		var data = "["; //定义数据变量
    		$("#" + tableId).find("tr").each(function(i,val){
    			if(i!=0){
    				data+="{"
    				$(this).find("input, select").each(function(){
    					if($(this).attr("name")){//如果此标签设置了id，则取出其中数据
            				data += "'"+$(this).attr("name") + "':'" + $(this).val() + "',";  //拼接id和数据
        				}
    				})
    				if(data.length != 1){//如果取出了数据，删除多余的符号
       					data = data.substring(0, data.length-1);//删除多余的符号','
    				}  
        			data+="},"
    			}
    			
    		});
    		if(data.length != 1){//如果取出了数据，删除多余的符号
       					data = data.substring(0, data.length-1);//删除多余的符号','
    		}          
    		data += "]";//添加结束符
    		//data = eval("(" + data + ")");//将数据转换成json对象
    		return data; //返回数据
		}
			
		//删除一行
		$("a.del").live("click",function(){
			var tr = $(this).parent().parent().parent();
			var len = tr.parent().children("tr").length;
			tr.remove();
		});	
		

		function addRowData(stkC,stkName,netPrice,uom,modle,pluC,qty){
			var ids = jQuery("#grid-table").jqGrid('getDataIDs');
 			//获得当前最大行号（数据编号）
 			var rowid;
 			if(ids==""){
 				rowid=0
 			}else{
 				rowid = Math.max.apply(Math,ids);
 			}
 			//获得新添加行的行号（数据编号）
 			newrowid = rowid+1;
 			
 			var detail ="<button type='button' class='btn btn-info edit' onClick='editStk("+newrowid+","+stkC+","+qty+")'>修改</button>";
			detail+="<button type='button' class='btn btn-info edit' onClick='delStk("+newrowid+")' >删除</button>";
    		var dataRow = {  
     			STK_C: stkC,
     			PLU_C:pluC,
     			NAME:stkName,
     			NET_PRICE:netPrice,
     			UOM:uom,
     			MODLE:modle,
     			QTY:qty,
     			detail:detail
    		};
			$("#grid-table").jqGrid("addRowData",newrowid , dataRow, "first"); 
		}
		function editStk(newrowid,stkC,qty){
			$.jBox.open("iframe:${base}/donation/editStkMasUI.jhtml?newrowid="+newrowid+"&stkC="+stkC+"&qty="+qty+"", "修改赠品商品", 800, 350, { buttons: { } });
			//$("#grid-table").jqGrid("setCell",newrowid , "QTY", "3"); 
		}
		
		function setCell(newrowid,qty){
			$("#grid-table").jqGrid("setCell",newrowid , "QTY", qty); 
		}
		
		function addDonationTask(){
			var grid = $("#grid-table");
	   		var ids = grid.jqGrid('getGridParam', 'selarrrow');
	   		var stkCs = "["
	   		for(var i=0; i<ids.length; i++){
	   			var id=ids[i]; 
				var rowData = $('#grid-table').jqGrid('getRowData',id);
				
				var le = ids.length-1;
				if(le==i){
					stkCs+="{stkc:"+rowData.STK_C+",qty:"+rowData.QTY+",uom:'"+rowData.UOM+"'}]" 
				}else{
					stkCs+="{stkc:"+rowData.STK_C+",qty:"+rowData.QTY+",uom:'"+rowData.UOM+"'}," 
				}
	   		}
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			
			var url = "${base}/donation/addDonationTask.jhtml";
			$.jBox.confirm("确认要保存赠品吗?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在发放，请稍等...');
					$.ajax({
            		url:url,
            		type : 'post',
					dataType : 'json',
					data:{userDate:$("#userDate").val(),stkCs:stkCs,beginDates:$("#beginDates").val()},
					error : function(data) {
						alert("网络异常");
						mgt_util.hideMask();
						return false;
					},
					success : function(data) { 
						top.$.jBox.tip('操作成功！', 'success');
						mgt_util.hideMask();
						$("#grid-table").trigger("reloadGrid");
						window.location.href = "${base}/donation/donationInfo.jhtml";
					}
            	});
				}
			});
		}
		function delStk(rowid){
			$.jBox.confirm("确认要删除吗?", "提示", function(v){
				if(v == 'ok'){
					$('#grid-table').jqGrid('delRowData',rowid);
				}
			})
		}

</script>
</html>