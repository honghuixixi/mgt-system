<!DOCTYPE html>
<html>
    <head>
        <title>系统管理-信息配置</title>
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
					url:'${base}/info/infoList.jhtml',
 					colNames:['ID','文章标题1','是否发布','是否置顶','作者','创建时间','操作','ACID'],
				   	colModel:[
				   		{name:'ART_ID',index:'ART_ID',width:30,hidden:true,key:true},
				   		{name:'ART_TITLE',align:"center",width:120},
				   		{name:'IS_PUBLICATION',width:60,align:"center",editable:true,formatter:function(data){
							if(data=='0'){
								return '未发布';
							}else if(data=='1'){
								return '已发布';
							}else{
								return data;
	   					}}},
				   		{name:'IS_TOP',width:50,align:"center",editable:true,formatter:function(data){
							if(data==0){
								return '否';
							}else if(data==1){
								return '是';
							}else{
								return data;
	   					}}},
				   		{name:'AUTHOR',align:"center",width:50},
				   		{name:'SA_CREATE_DATE',align:"center",width:120},
				   		{name:'detail',width:100,align:'center',sortable:false} ,
				   		{name:'AC_ID',hidden:true,key:true,index:'AC_ID'} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							
							if(rowData.IS_PUBLICATION=='未发布'){
								detail="<button type='button' class='btn btn-info '  id='"+rowData.ART_ID+"' onclick='isPublication("+rowData.ART_ID+",1)'>发布 </button>"
							}else if(rowData.IS_PUBLICATION=='已发布'){
								detail="&nbsp;<button type='button' class='btn btn-info '  id='"+rowData.ART_ID+"' onclick='isPublication("+rowData.ART_ID+",0)'>取消发布 </button>"
							}
							
							if(rowData.AC_ID=='23' || rowData.AC_ID=='24' || rowData.AC_ID=='25'){
								if(rowData.IS_TOP=='否'){
									detail+="&nbsp;<button type='button' class='btn btn-info '  id='"+rowData.ART_ID+"' onclick='isTop("+rowData.ART_ID+",1)'>置顶 </button>"
								}else if(rowData.IS_TOP=='是'){
									detail+="&nbsp;<button type='button' class='btn btn-info '  id='"+rowData.ART_ID+"' onclick='isTop("+rowData.ART_ID+",0)'>取消置顶 </button>"
								}
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}				   	
				});

				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
			function isPublication(acid,flg){
				var str = "";
				if(flg==0){
					str="确认取消发布吗?";
				}else if(flg==1){
					str="确认发布吗?";
				}else{
					str="确认此操作吗?"
				}
				$.jBox.confirm(str,"提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/info/isPublicationFlg.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'artId':acid,
								'isPublication':flg
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
								if(data.code==100){
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
			
			function isTop(acid,flg){
				var str = "";
				if(flg==0){
					str="确认取消置顶吗?";
				}else if(flg==1){
					str="确认置顶吗?";
				}else{
					str="确认此操作吗?"
				}
				$.jBox.confirm(str,"提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/info/isTopFlg.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'artId':acid,
								'isTop':flg
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
								if(data.code==100){
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
  <script type="text/javascript">  
  	$().ready(function() {
  		var $acId = $("#acId");
  		// 文章类型选择
		$acId.lSelect({
		url: "${base}/info/artType.jhtml"
		});
	});
  </script> 
    </head>
    <body>
       <div class="body-container">
      	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
    			<div class="currentDataDiv_tit">
        			<div class="form-group">
    		    		<button type="button" class="btn_divBtn add" id="info_add" data-toggle="jBox-win" href="${base}/info/addInfoUI.jhtml">添加 </button>
    		        	<button type="button" class="btn_divBtn edit" id="info_edit" data-toggle="jBox-edit" href="${base}/info/editInfoUI.jhtml">编辑 </button>
    		        	<button type="button" class="btn_divBtn del"  id="info_del" data-toggle="jBox-remove-role" href="${base}/info/delete.jhtml">删除 </button>
    		        </div> 
    			</div>
    			<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
	        			<div class="form-group">
		                    <label class="control-label">文章类型</label>
	           				<input type="hidden" id="acId" name="acId" />
	        			</div>
		                <div class="form-group">
		                    <label class="control-label">文章状态</label>
		                    <select class="form-control" name="isPublication">
		                        <option value="">全部</option>
		                        <option value="1">已发布</option>
		                        <option value='0'>未发布</option>
		                    </select>
		                </div>
		               
		            </form>
            	</div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="info_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	             </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>