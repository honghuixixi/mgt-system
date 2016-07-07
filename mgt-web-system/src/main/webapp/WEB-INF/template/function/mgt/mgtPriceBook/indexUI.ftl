<!DOCTYPE html>
<html>
    <head>
        <title>价格本管理-价格本列表</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/priceBook/list.jhtml',
 					colNames:['PK_NO','编号','价格本名称','开始日期','结束日期','类别','描述','状态','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:30,hidden:true,key:true},
				   		{name:'PB_CODE',align:"center",width:70},
				   		{name:'PB_NAME',align:"center",width:60},
				   		{name:'DATE_FROM',align:"center",width:60},
				   		{name:'DATE_TO',align:"center",width:60},
				   		{name:'MAS_CODE',align:"center",width:50,formatter:function(data){
							if(data=='B2B'){
								return $.trim(data);
							}else if(data=='CHANNEL'){
								return '分销';
							}else{
								return $.trim(data);
	   						}
						}},
				   		{name:'PB_NOTE',align:"center",width:100},
				   		{name:'STATUS_FLG',width:50,align:"center",editable:true,formatter:function(data){
							if(data=='A'){
								return '已停用';
							}else if(data=='P'){
								return '启用中';
							}else if(data=='T'){
								return '已过期';
	   						}else{
	   							return data;
	   						}
						}},
				   		{name:'STATUS_FLG',align:"center",editable:true,width:100,title:false,formatter:function(data,row,index){
				   			if(data == 'P'){
				   				return '<button type="button" class="btn btn-info edit" onClick=editStatus("'+index.PK_NO+'","A")  href="${base}/priceBook/editStatus.jhtml">停用 </button>&nbsp;'+
				   					   '<button type="button" class="btn btn-info edit" onClick=detail("'+index.PK_NO+'") href="${base}/priceBook/priceBookDetailUI.jhtml?mas_pk_no="'+index.PK_NO+'">查看</button>';
				   			}else if(data == 'T'){
				   				return '<button type="button" class="btn btn-info del" onClick=deletePriceBook("'+index.PK_NO+'")  href="${base}/priceBook/delete.jhtml">删除</button>';
				   			}else if(data == 'A'){
				   				return '<button type="button" class="btn btn-info edit"  onClick=editStatus("'+index.PK_NO+'","P")  href="${base}/priceBook/editStatus.jhtml">启用</button>&nbsp;'+
				   					   '<button type="button" class="btn btn-info edit"  onClick=edit("'+index.PK_NO+'") href="${base}/priceBook/addIndexUI.jhtml?mas_pk_no="'+index.PK_NO+'">修改</button>&nbsp;'+
				   					   '<button type="button" class="btn btn-info del"   onClick=deletePriceBook("'+index.PK_NO+'")  href="${base}/priceBook/delete.jhtml">删除</button>';
				   			}
				   		}} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
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
				        	keyword:$("#keyword").val()=='请输入编号或名称'?'':$("#keyword").val(),
				        	dateFrom:$("#dateFrom").val(),
				        	dateTo:$("#dateTo").val(),
				        	statusFlg:$("#statusFlg").val(),
				        },
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
			//启用/停用价格本
			function editStatus(obj,status){
				var tips = "";
				if(status=='P'){
					tips="确认启用该价格本吗?";
				}else if(status=='A'){
					tips="确认停用该价格本吗?";
				}else{
					tips="确认此操作吗?"
				}
		   		$.jBox.confirm(tips, "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在设置数据，请稍等...');
						$.ajax({
							url : '${base}/priceBook/editStatus.jhtml',
							type :'post',
							dataType : 'json',
							data : 'id=' + obj+'&status='+status,
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										top.$.jBox.tip('设置成功！','success');
										mgt_util.refreshGrid($("#grid-table"));
									}
								});
							}
						});
					}
			    });
		   }
			
			//编辑价格本
			function edit(mas_pk_no){
				if(mas_pk_no!=''){
					window.location.href = "${base}/priceBook/addIndexUI.jhtml?mas_pk_no="+mas_pk_no;
				}else{
					window.location.href = "${base}/priceBook/addIndexUI.jhtml";
				}
			}
			
			//详情
			function detail(mas_pk_no){
				window.location.href = "${base}/priceBook/priceBookDetailUI.jhtml?mas_pk_no="+mas_pk_no;
			}
			
		   //删除价格本
		   function deletePriceBook(obj){
			   $.jBox.confirm("确认删除该价格本吗?", "提示", function(v){
					if(v == 'ok'){
						mgt_util.showMask('正在删除数据，请稍等...');
						$.ajax({
							url : '${base}/priceBook/delete.jhtml',
							type :'post',
							dataType : 'json',
							data : 'id=' + obj,
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										top.$.jBox.tip('删除成功！','success');
										mgt_util.refreshGrid($("#grid-table"));
									}
								});
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
			<div id="currentDataDiv" action="menu">
    			<div class="currentDataDiv_tit">
        			<div class="form-group">
    		    		<button type="button" class="btn_divBtn add" id="info_add" onClick="edit('');" href="${base}/priceBook/addIndexUI.jhtml">新增价格本</button>
    		        	<button type="button" class="btn_divBtn del"  id="info_del" data-toggle="jBox-remove-role" href="${base}/priceBook/delete.jhtml">删除 </button>
    		        </div> 
    			</div>
    			<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
		                <label class="control-label" style="width:60px;">关键词：</label>
		                <div class="form-group">
		                	<input type="text" class="form-control" name="keyword" id="keyword" style="width:170px" value="请输入编号或名称" class="form-control" onfocus="if(value=='请输入编号或名称') {value=''}" onblur="if (value=='') {value='请输入编号或名称'}">
                		</div>
                		<div  class="form-group">
                			<label class="control-label" style="padding-right:5px;width:60px;">有效期：</label>
	                		<input type="text" class="form-control" name="dateFrom" id="dateFrom" style="width:120px;" onfocus="WdatePicker({maxDate:$('#dateTo').val(),dateFmt:'yyyy-MM-dd'});" >
	                		<span class="control-label">~</span>
	                		<input type="text" class="form-control" name="dateTo" id="dateTo" style="width:120px;" onfocus="WdatePicker({minDate:$('#dateForm').val(),dateFmt:'yyyy-MM-dd'});" >					
                		</div>
                		<div class="form-group">
		                    <label class="control-label" style="width:60px;">状态:</label>
		                    <select class="form-control" style="width:120px;" name="statusFlg" id="statusFlg">
		                        <option value="">全部</option>
		                        <option value="A">已停用</option>
		                        <option value='P'>启用中</option>
		                        <option value='T'>已过期</option>
		                    </select>
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