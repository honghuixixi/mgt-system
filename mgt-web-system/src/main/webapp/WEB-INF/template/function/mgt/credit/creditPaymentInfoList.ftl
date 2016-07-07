<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>信用支付</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
	
		 	function findPayOrderUI(obj){
				mgt_util.showjBox({
							width : 960,
							height : 500,
							title : '配送人员详情',
							url : '${base}/credit/editCreditPayment.jhtml?id='+obj,
							grid : $('#grid-table')
						});
	   			}
	
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/credit/list.jhtml',
 					colNames:['','配送员登录名字','手机号码','工资收入','担保人','押金','当前信用额度','最高信用额度','最长期限','操作'],
				   	colModel:[	 
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'USER_NAME',width:100},
				   		{name:'DELIVER_MOBILE',width:100},
				   		{name:'MONTHLY_INCOME',width:80},
				   		{name:'GUARANTEE',width:80},
				 		{name:'DEPOSIT',width:80},
				 		{name:'CREDIT_CURRENT',width:100},
				 		{name:'CREDIT_MAXIMUM',width:100},
				   		{name:'CREDIT_TERM',width:50},
				   		{name:'', width:50,formatter:function(value,row,index){
	   		            var str =  '<button type="button" class="btn btn-info edit"     onClick=findPayOrderUI("'+index.ID+'") >修改 </button>';
	   		            
						return  str;
	   		            }
						}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
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
			//onclick=editStatusFlg("'+index.PK_NO+'","A","撤销") >撤销</button>
			function editStatusFlg(pkNo,statusFlg,message){
				//alert(pkNo);
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
					
							 $.ajax({
								 url:'${base}/prom/editStatus.jhtml',
								 sync:false,
								type : 'post',
								dataType : "json",
								data :{
									'pkNo':pkNo,
									'statusFlg':statusFlg
								},
								error : function(data) {
									alert("网络异常");
									return false;
								},
								success : function(data) {
									if(data.code==001){
									top.$.jBox.tip('保存成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
									}
									else if(data.code==002){
									top.$.jBox.tip('修改失败！该活动正在进行中或已解释...', 'error');
									}
									else if(data.code==003){
									top.$.jBox.tip('修改失败！请先添加商品...', 'error');
									}
									else if(data.code==004){
										top.$.jBox.tip('修改失败！未添加赠品', 'error');
										}
									else{
									top.$.jBox.tip('保存失败！', 'error');
							 			return false;
									}
								}
				});	
			}});
			}
			
			
			
		</script>
    </head>
    <body>
       <div class="body-container">
		  <div class="main_heightBox1">
            <!-- 面包屑导航 -->
			<div id="currentDataDiv" action="resource">
			<div class="currentDataDiv_tit">
             	<button type="button" class="btn_divBtn add"  id='member_add' data-toggle="jBox-win"  href="${base}/credit/addCreditPaymentInfo.jhtml">添加</button>
			
			</div>
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">单据号码</label>
		                    <input type="text" class="form-control" name="masNo" id="masNo" style="width:120px;" >
		                	<input style="vertical-align: middle;margin-right:5px;" class="radi_input" name="statusFlg" type="radio" value="AP" checked="checked"/><span class="radi_span">启用</span> 
							<input style="vertical-align: middle;margin-right:5px;" name="statusFlg" type="radio" value="C" /><span class="radi_span">取消</span> 
		                </div>
		          		<div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id='prom_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
			                </div>
		                </div>
		            </form>
	        	</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/editPromItemUI.jhtml" method="post" id="editPromForm">
   		<input type="hidden" name="id" id="promId" value="">
   		
   		</form>
   			<form action="${base}/prom/itemListUI.jhtml" method="post" id="itemListForm">
   		</form>
    </body>
</html>
<script  >
function editPromItem(pkNo,statusFlg){
		if(statusFlg=='取消'){
			top.$.jBox.tip('该活动已取消！');
			return;
		}else{
		$.ajax({
			url : "${base}/prom/findPromStatFlag.jhtml",
			type :'post',
			dataType : 'json',
			data : 'pkNo=' + pkNo,
			success : function(data, status, jqXHR) { 
				if(data.code==001){
					$("#promId").val(pkNo);
					$("#editPromForm").submit();
					}else if(data.code==002){
					top.$.jBox.tip('该活动正在进行中或已经结束...', 'error');
					}
			}
		});
		}
		

	}

function  itemListUI(){
	$("#itemListForm").submit();
	
}
</script> 



