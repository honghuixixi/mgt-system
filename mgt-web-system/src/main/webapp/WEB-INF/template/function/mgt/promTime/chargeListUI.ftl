<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={masPkNo:${masPkNo},orderby:"CREATE_DATE",statusFlg:"A"};
				mgt_util.jqGrid('#grid-table',{
				postData: postData,
					url:'${base}/prom/chargeList.jhtml',
					multiselect:false,
 					colNames:['','促销起止时间','参与日期','供应商','编码','名称','单位','供应商价格','抢购价','商品正常售价','平台补贴金额','促销总量','客户限购量','操作'],
				   	colModel:[	 
						{name:'STK_C',width:'0%',index:'ID',hidden:true,key:true},
						{name:'TIMELONG',width:'9%'},
						{name:'JOINDATE',width:'4%'},
				   		{name:'NAME',width:'7%'},
				   		{name:'STK_C',width:'3%'},
				   		{name:'STK_NAME',width:'10%'},
				   		{name:'UOM',width:'2%'},
				   		{name:'LIST_PRICE',width:'4%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.LIST_PRICE)).toFixed(2);
						}},
				   		{name:'PROM_PRICE',width:'3%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.PROM_PRICE)).toFixed(2);
						}},
						{name:'NET_PRICE',width:'3%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.NET_PRICE)).toFixed(2);
						}},
						{name:'SUBSIDY_PRICE',width:'3%',formatter:function(data,row,rowObject){
							if(data==null){return '';}
							return (parseFloat(rowObject.SUBSIDY_PRICE)).toFixed(2);
						}},
				   		{name:'MAX_QTY',width:'3%'},
				   		{name:'SINGLE_CUST_QTY',width:'3%'},
	   					{name:'',width:'4%',formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '<button type=button class="btn btn-info edit" onclick=editItemStatus("'+index.PK_NO+'","P","启用")>同意</button>'
											  +'<button type=button class="btn btn-info edit" onclick=editItemStatus("'+index.PK_NO+'","R","启用")>拒绝</button>';
									}
									if(index.STATUS_FLG=='P'){
										var start=new Date(index.JOINDATE.replace("-", "/").replace("-", "/"));
										var sysdate = new Date();
										if(start>sysdate){
											return '<button type=button class="btn btn-info edit" onclick=editItemStatus("'+index.PK_NO+'","R","撤销") >拒绝</button>';
										}else{
											return '--';
										}
									}
									if(index.STATUS_FLG=='R'){
										return '<button type=button class="btn btn-info edit" >--</button>';
									}
									else{
										return '';
									}
								}
						},
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
 
			function ss(){
				$("#promMasForm").submit();
			}
		</script>
		<script type="text/javascript">
			$().ready(function() {
				// 状态面包屑事件，改变隐藏域select值并提交表单
	    		$("li.sub_status_but").on("click",function(){
	    			// 切换table时， 清空搜索框内容
	    				$("input[name=keyWord]").val('');
	    			// 重置子状态select
	    			$("li.sub_status_but").removeClass("active");
	    			$(this).addClass("active");
	    			var formID = 'query-form';
	    			$(".form-inline").attr("id","");
	       		 	$(this).parents(".form-inline").attr("id",formID);
	       		    $("select[name=statusFlg]").val($(this).attr("id"));
	       			$("#Promtime_search").click(); 
	    		});			
	    	});			
	    	
			//审核操作
			function editItemStatus(pkNo,statusFlg,message){
				 if(statusFlg=="P"){
				 	var str = "确认同意此限时抢购方案吗?";
				 }else{
				 	var str = "确认修改吗?";
				 }
				 $.jBox.confirm(str, "提示", function(v){
			 			if(v == 'ok'){
							 $.ajax({
								url:'${base}/prom/editItemStatus.jhtml',
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
										top.$.jBox.tip('操作成功！', 'success');
										top.$.jBox.refresh = true;
										$('#grid-table').trigger("reloadGrid");
									}else{
										top.$.jBox.tip('操作失败！', 'error');
							 			return false;
									}
								}
							});	
						}
				});
			}
		</script>		
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
	            <form class="form form-inline queryForm" style="width:100%" id="query-form">
					<div class="control-group sub_status">
						<div class="form-group sr-only" >
		                    <select class="form-control" name="statusFlg">
		                        <option value="P">有效的</option>
		                        <option value="A">待审批的</option>
		                        <option value='R'>拒绝的</option>
		                    </select>
	                	</div>
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="A" class="sub_status_but active"><a>待审批的</a></li>
							<li role="presentation" id="P" class="sub_status_but"><a>有效的</a></li>
							<li role="presentation" id="R" class="sub_status_but"><a>拒绝的</a></li>
						</ul>
					 </div>
	            <div class="form_divBox" style="display:block;padding-right:10px;">
	            	<div class="ygcxBtn-box" style="margin-top:8px;">
	            		<label class="control-label">商品名称或编码</label>
	            		<input type="text" class="form-control input-sm"  name="keyWord">
	            		<a href="#"  id="Promtime_search" data-toggle="jBox-query" ></a>
	            	</div>
	            	<span class="form-group" style="float:right">
	                 	<button type="button" class="btn_divBtn" id='' onClick="ss()"> 关闭</button>
	                </span>
	            </form>
	            </div>
	          </div>
	        </div>
	        <div style="clear:both"></div>
		    <table id="grid-table" ></table>
		  	<div id="grid-pager"></div>
   		</div>
   		<form action="${base}/prom/promTimeInfo.jhtml" id="promMasForm" method="post">
   		</form>
    </body>
</html>