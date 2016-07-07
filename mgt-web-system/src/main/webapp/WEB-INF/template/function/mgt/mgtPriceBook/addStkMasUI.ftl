<!DOCTYPE html>
<html>
    <head>
        <title>价格本管理-添加商品</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					postData:{
						mas_pk_no:${mas_pk_no}
					},
					url:'${base}/priceBook/stkMasList.jhtml',
 					colNames:['','','编码','条码','名称','零售单位','商品品牌','商品分类'],
 					multiselect:true,
 					multiselectWidth:'1',
 					rownumWidth:'12',
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:0,hidden:true,key:true},
						{name:'STK_FLG',index:'STK_FLG',width:0,hidden:true,key:true},
						{name:'VENDOR_STK_C',align:"center",index:'VENDOR_STK_C',width:'8',key:true},
						{name:'PLU_C',align:"center",index:'PLU_C',width:'12',key:true},
						{name:'NAME',align:"center",index:'NAME',width:'15',key:true},
						{name:'STD_UOM',align:"center",index:'STD_UOM',width:'6',key:true},
						{name:'BRANDNAME',align:"center",index:'BRANDNAME',width:'7',key:true},
						{name:'CATCNAME',align:"center",index:'CATCNAME',width:'7',key:true},
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}				   	
				});

				 $("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json', 
				        //发送数据  
				        postData:{
				        	name:$("#name").val(),
				        	mas_pk_no:${mas_pk_no}
				        },
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				 
				 //添加商品
				 $("#global_plu_mas_add").click(function(){
					 $("#global_plu_mas_add").attr("disabled",true);
					 var stkCs = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					 if(stkCs.length == 0){
						 top.$.jBox.tip("请选择商品!");
						 $("#global_plu_mas_add").attr("disabled",false);
						 return;
					 }else{
						 mgt_util.showMask('正在添加商品，请稍等...');
						 $.ajax({
								url:'${base}/priceBookItem/add.jhtml',
								sync:false,
								type : 'post',
								dataType : "json",
								data :{stkCs:stkCs.toString(),masPkNo:${mas_pk_no}},
								error : function(data) {
									alert("网络异常");
									$("#global_plu_mas_add").attr("disabled",false);
									return false;
								},
								success : function(data) {
									if(data.success){
										top.$.jBox.tip("商品添加成功!");
										$("#configureMas",window.top.frames[0].document).click();
										mgt_util.closejBox();
									}else{
										top.$.jBox.tip(data.msg);
									}
									$("#global_plu_mas_add").attr("disabled",false);
								}
							});
					 }
				 });
				 
				 //监听输入框回车
				 $('#name').bind('keydown', function(e) {
					 var theEvent = e || window.event;    
				     var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
				     if(code == 13) { 
				    	 $("#name").blur();
				     }
				 });
			});
			
			//监听页面回车键查询数据
			$(document).keydown(function(e){
		        var theEvent = e || window.event;    
		        var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
		        if (code == 13) {    
		            $("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json', 
				        postData:{
				        	name:$("#name").val(),
				        	mas_pk_no:${mas_pk_no}
				        },
				        page:1  
				    }).trigger("reloadGrid"); 
		        }    
			});
		</script>
    </head>
    <body>
       <div class="body-container">
      	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
			 	<div class="currentDataDiv_tit">
   			       <div class="form-group">
					    <button type="button" class="btn_divBtn del float_btn" id="global_plu_mas_add">添加</button>
				   </div>
				</div>
    			<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
                		<div class="form-group">
		                    <label class="control-label">名称或条码:</label>
	           				<input  class="form-control" id="name" style="width:200px;" name="name" value="" placeholder="请输入条码或编码或名称"/>
	        			</div>
		            </form>
            	</div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="searchbtn" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	             </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>