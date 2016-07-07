<!DOCTYPE html>
<html>
    <head>
        <title>价格本管理-添加客户</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					postData:{
						mas_pk_no:${mas_pk_no}
					},
					url:'${base}/priceBook/vendorCustList.jhtml',
					colNames:['客户编码','客户名称','类型','地区','地址'],
					multiselectWidth:'1',
 					rownumWidth:'12',
					colModel:[	 
						{name:'CUST_CODE',align:"center",index:'CUST_CODE',width:'8',hidden:false,key:true},
						{name:'CUST_NAME',align:"center",index:'CUST_NAME',width:'12',key:true},
						{name:'CAT_NAME',align:"center",index:'CUST_TYPE',width:'8',key:true},
						{name:'AREA_NAME',align:"center",index:'AREA_ID',width:'12',key:true},
						{name:'CRM_ADDRESS1',align:"center",index:'crmAddress1',width:'15',key:true}
					  ],
					  gridComplete:function(){ 
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					  }				   	
				});

				 $("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json', 
				        //发送数据  
				        postData:{
				        	keyword:$("#keyword").val(),
				        	mas_pk_no:${mas_pk_no}
				        },
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				 
				 //添加客户
				 $("#stk_cust_add").click(function(){
					 $("#stk_cust_add").attr("disabled",true);
					 var custCodes = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
					 if(custCodes.length == 0){
						 top.$.jBox.tip("请选择客户!");
						 $("#stk_cust_add").attr("disabled",false);
						 return;
					 }else{
						 mgt_util.showMask('正在添加客户，请稍等...');
						 $.ajax({
								url:'${base}/priceBookCust/add.jhtml',
								sync:false,
								type : 'post',
								dataType : "json",
								data :{custCodes:custCodes.toString(),masPkNo:${mas_pk_no}},
								error : function(data) {
									alert("网络异常");
									$("#stk_cust_add").attr("disabled",false);
									return false;
								},
								success : function(data) {
									if(data.success){
										top.$.jBox.tip("客户添加成功!");
										$("#configureCust",window.top.frames[0].document).click();
										mgt_util.closejBox();
									}else{
										top.$.jBox.tip(data.msg);
									}
									$("#stk_cust_add").attr("disabled",false);
								}
						});
					 }
				 });
				 
				//监听输入框回车
				 $('#keyword').bind('keydown', function(e) {
					 var theEvent = e || window.event;    
				     var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
				     if(code == 13) { 
				    	 $("#keyword").blur();
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
				        //发送数据  
				        postData:{
				        	keyword:$("#keyword").val(),
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
					    <button type="button" class="btn_divBtn del float_btn"   id="stk_cust_add"  data-toggle="jBox-show">添加</button>
				   </div>
				</div>
    			<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
                		<div class="form-group">
		                    <label class="control-label">名称或编码:</label>
	           				<input  class="form-control" id="keyword" style="width:200px;" name="keyword" value="" placeholder="请输入客户编码或名称"/>
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