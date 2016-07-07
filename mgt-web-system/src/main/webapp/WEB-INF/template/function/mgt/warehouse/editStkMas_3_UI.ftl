<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={pkNo:${pkNo}}
				mgt_util.jqGrid('#grid-table1',{
					postData: postData,
					url:'${base}/warehouse/addedStkMas.jhtml',
					multiselect:false,
 					colNames:['商品编码','条码','商品名称','单位','请求数量','操作'],
 					rowNum:1000,
				   	colModel:[	 
						{name:'STK_C',width:50},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'', width:40,align:"center",formatter:function(value,row,index){
							return '<button type=button class="btn btn-info edit" onclick=deleWhIo("'+index.PK_NO+'")>删除</button>';
							}
						} 
				   	],
				});
				
				//点击添加商品事件
				$("#addMas").click(function(){
				//显示确定按钮
				$("#addStk").removeAttr("style");
				$("#allow_List").removeAttr("style");
				$("#allowStk").removeAttr("style");				
				var postData={pkNo:"${pkNo}",masCode:"${masCode}",whCode:"${whCode}",vendorCode:"${vendorCode}",keyWord:$("#keyWord").val()};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/warehouse/allowStkMas.jhtml',
 					colNames:['','商品编码','条码','商品名称','单位','库存量','预留数量','操作数量','操作'],
 					rowNum:1000,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},	 
						{name:'STK_C',index:'STK_C',width:50,hidden:false,key:true},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:120},
				   		{name:'UOM', width:40},
				   		{name:'STK_QTY', width:40},
				   		{name:'RES_QTY', width:40},
				   		{name:'', width:40,formatter:function(data,row,rowObject){
						   		tmp = 0;
						   		if (!tmp && typeof(tmp)!="undefined" && tmp!=0){  
						   			tmp = '';
						   		}
								return '<input type="text" id="'+rowObject.STK_C+'"  value="'+tmp+'">';
							}
						},
				   		{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
							return '<button type=button class="btn btn-info edit" onclick=addWhIo("'+rowObject.STK_C+'","'+rowObject.STK_QTY+'","'+rowObject.RES_QTY+'")>添加</button>';
							}
						} 						
				   	],
				  });
				});	
			});

			//单条添加商品
			function addWhIo(stkC,stkQty,resQty,message){
				//该商品数量
				var Qty = $("#"+stkC).val();
				if(Qty == 0){
					top.$.jBox.tip('备货数量不能为空');
					return false;
				}
				if(/\D/.test(Qty)){
					top.$.jBox.tip('请输入正确数量！');
					return false;
				}
				if(Number(Qty) > Number(stkQty-resQty)){
					top.$.jBox.tip('数量超过上限！');
					return false;
				}				
			 $.ajax({
				url:'${base}/warehouse/addWhIo.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'pkNo':'${pkNo}',
				'masCode':'${masCode}',
				'stkC':stkC,
				'qty':Qty,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						$('#grid-table1').trigger("reloadGrid");
					}else{
						top.$.jBox.tip('添加失败！', 'error');
			 			return false;
					}
				}
			  });	
			}	
						
			//删除商品
			function deleWhIo(pkNo,message){
			 $.jBox.confirm("确认删除吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				url:'${base}/warehouse/deleWhIo.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'pkNo':pkNo,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
					top.$.jBox.tip('删除成功！', 'success');
					top.$.jBox.refresh = true;
					$('#grid-table1').trigger("reloadGrid");
					}else{
					top.$.jBox.tip('删除失败！', 'error');
			 			return false;
					}
					}
				});	
			   }
			  });
			}	
			
			//检查填写数量是否空	
			function checkForm(){
				//封装这商品(id+数量)的集合
				var str = "";
				var selectedIds = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				for(var i=0;i<selectedIds.length;i++){
					var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
					//商品id
					var stkC = rowData.STK_C;
					//商品库存量
					var whQty = rowData.STK_QTY;	
					//商品预留量
					var resQty = rowData.RES_QTY;									
					//该商品数量
					var Qty = $("#"+rowData.STK_C).val();
					if(Qty == 0){
						top.$.jBox.tip('备货数量不能为空');
						return false;
					}
					if(/\D/.test(Qty)){
						top.$.jBox.tip('请输入正确数量！');
						return false;
					}
					if(Number(Qty) > Number(whQty-resQty)){
						top.$.jBox.tip('数量超过上限！');
						return false;
					}					
					if(i != selectedIds.length-1){
						str =str +stkC+","+Qty+";";
					}else{
						str =str +stkC+","+Qty;
					}
				 }
				$("#pkNo").val(${pkNo});
				$("#items").val(str);
				mgt_util.submitForm('#form');
			}	
		</script>
    </head>
    <body>
       <div class="body-container">
			<div class="pull-left">
				<div class="btn-group">
					<button class="btn btn-danger" id="addMas">
						添加商品
					</button>
				</div>
			</div>
			<div style="clear:both;"></div>
		    <table id="grid-table1" >
		    </table>
		    </br>
       		<form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" >
	            <div class="pull-left">
				<div class="btn-group" id="allowStk" style="float:left;display:none" >
					<input id="keyWord" name="keyWord" type="text" class="form-control" value="" placeholder="商品名/编码/条码" style="width:150px;">
				</div>
					<button type="button" style="display:none" class="btn btn-danger" id="allow_List" data-toggle="jBox-query">搜 索 </button>
				</div>			
			</form>
       		<form class="form-horizontal" id="form" action="${base}/warehouse/addStkItem.jhtml"> 
				<input id="pkNo" name="pkNo" type="hidden">
				<input id="items" name="items" type="hidden">
				<input id="masCode" name="masCode" type="hidden" value=${masCode}>
				<div class="pull-left">
					<div class="btn-group">
						<button style="display:none" id="addStk" class="btn btn-danger" data-toggle="jBox-call"
							data-fn="checkForm">
							保存
						</button>
					</div>
				</div>
			</form>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>