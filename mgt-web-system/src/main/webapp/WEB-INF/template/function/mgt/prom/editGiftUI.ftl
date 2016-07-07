<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		var promitemLists={};
		var stkQtyLists={}
		[#list promItem1Freelist as promitem] 
		promitemLists['${promitem.stkC}']='${promitem.pkNo}';
		stkQtyLists['${promitem.stkC}']='${promitem.stkQty}';
		 [/#list] 
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/giftList.jhtml?pkNo=${promItem1.pkNo}&selectType='+$("#selectTypeVal").val(),
					multiselect:false,
 					colNames:['','商品名称','规格','商品编码','商品价格','单位','供应商','赠送数量','操作'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
				   		{name:'NAME',width:'25%',formatter:function(value,row,rowObject){
				   			var str = rowObject.NAME+'&nbsp;';
				   			if(null!=rowObject.STK_NAME_EXT){
				   				str+=rowObject.STK_NAME_EXT;
				   			}
				   			return str;
				   		}},
				   		{name:'MODLE',width:'8%'},
						{name:'STK_C',width:'8%'},
				   		{name:'NET_PRICE',width:'6%'},
				   		{name:'UOM',width:'6%'},
				   		{name:'OLD_CODE',width:'10%'},
				   		{name:'STK_QTY',width:'10%', formatter:function(data,row,rowObject){
					   		if(null!=stkQtyLists[rowObject.STK_C]&stkQtyLists[rowObject.STK_C]!=undefined){
							return '<input type="text" id="stkQty'+rowObject.STK_C+'"   onkeyup=digitalVerification(this)     value="'+stkQtyLists[rowObject.STK_C]+'">';
					   		}else{
							return '<input type="text" id="stkQty'+rowObject.STK_C+'"   onkeyup=digitalVerification(this) value="1" >';
					   		}
						}}
						,
						{name:'',width:'10%',align:"center",editable:true,formatter:function(value,row,rowObject){
							 var str = '';
							var stv = $("#selectTypeVal").val();
							if(stv=='1'){
								str += '<button type="button" class="btn btn-info edit"   onClick=addPromItemGift("'+rowObject.STK_C+'","false")  >删除</button>';
							}
							else{
								str += '<button type="button" class="btn btn-info edit"   onClick=addPromItemGift("'+rowObject.STK_C+'","true")  >添加</button>';
							}
									return str;
						 }}
				   	]
				});

				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});


			});
			
				function addPromItemGift(obj,addFlags){
					var	stkQty = $("#stkQty"+obj).val();
					if(null==stkQty||''==stkQty){
						top.$.jBox.tip('请输入赠送数量！');
						return;
						} 
					else if(parseInt(stkQty)<1){
						top.$.jBox.tip('赠品数量不能小于1！');
						return;
				}
					$.ajax({
						url:'${base}/prom/editGift.jhtml',
						type : 'post',
						dataType : 'json',
						data : {
							stkC : obj,
							addFlag: addFlags,
							stkQty :stkQty,
							pkNo : '${promItem1.pkNo}'
							},
						success : function(data) { 
								if(addFlags=='true'){
								top.$.jBox.tip('添加赠送商品成功！','success');
								}else{
									top.$.jBox.tip('删除赠送商品成功！','success');
								}
								var promItemArrays=data.data;
								 promitemLists={};
								 stkQtyLists={}
							for(var i=0;i<promItemArrays.length;i++){
								promitemLists[promItemArrays[i].stkC]=promItemArrays[i].pkNo;
								stkQtyLists[promItemArrays[i].stkC]=promItemArrays[i].stkQty;
								}
								
								
								$("#grid-table").jqGrid('setGridParam',{  
							        datatype:'json',  
							        postData:$("#queryForm").serializeObjectForm(), //发送数据  
							        page:1  
							    }).trigger("reloadGrid");
						}
			});
					
					}
					
					function ss(){
// 					$.jBox.confirm("确认要保存该数据?", "提示", function(v){
// 					if(v == 'ok'){
// 						mgt_util.showMask('正在保存数据，请稍等...');
// 						setTimeout(function () { 
//         					mgt_util.hideMask();
//     					}, 1000);
						
// 					}
// 					});
 
					$("#editPromForm").submit();
					}
					
					function digitalVerification(obj){
						if(/\D/.test(obj.value)){
						top.$.jBox.tip('只能输入数字！');
						obj.value=0;
						}
						}
		</script>
    </head>
    <body>
       <div class="body-container">
			<div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <!-- 搜索条 -->
	            <div class="currentDataDiv_tit"><h4>促销商品名称:${promItem1.stkName }</h4></div>
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<input type="text" class="form-control input-sm required" value="请输入条码或编码名称" name="nameOrStkc" onFocus="if(value==defaultValue){value='';}">
	            		<a href="#"   data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()" > 关闭</button>
	                </span>
	            	<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1" >
	                
	                <div class="form-group" style="float:right;">
	                 	<button type="button" class="btn_divBtn" id=''  onclick="editGift()"><i class="icon-search"></i> <span id="sreachFlagSpan">添加赠品</span> </button>
	                 	
	                </div>
	                
	                
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/editPromItemUI.jhtml" method="post" id="editPromForm">
   		<input type="hidden" name="id" id="promId" value="${promItem1.masPkNo }">
   		
   		</form>
    </body>
</html>
<script>
function editGift(){
		 if($("#selectTypeVal").val()=='1'){
			 $("#selectTypeVal").val("2");
			 $("#sreachFlagSpan").text("查看赠品");
			 }else{
			 $("#selectTypeVal").val("1");
			 $("#sreachFlagSpan").text("添加赠品");
			 }
		mgt_util.queryForm('#query-form', '#grid-table');
}
</script>


