<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>编辑首页数据页面"A"</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
		    	//网站前缀
   		    	var strHref= $("#macroUrl").val();
				var lastsel2;
				var seleVal;
				var postData={masPkNo:${masPkNo}}
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/index/editIndexDataById.jhtml',
 					colNames:['ID','类型','关键词','排序','链接'],
 					rowNum:1000,
 					rownumbers:true,
 					rownumWidth:10,
				   	colModel:[	 
						{name:'PK_NO',index:'PK_NO',width:10,hidden:true,key:true},
						{name:'BOX_TYPE',index:'BOX_TYPE', width:10,editable: true, editoptions:{value:"A",size:"20",maxlength:"30"}},
				   		{name:'BOX_DESC',index:'BOX_DESC', width:30,editable: true, editoptions:{size:"20",maxlength:"30"}},
				   		{name:'SORT_NO', index:'SORT_NO', width:10,editable: true, editoptions:{size:"20",maxlength:"30"}},
				   		{name:'HREF', width:150,formatter:function(data,row,rowObject){
						   		if (rowObject.HREF != null){  
									tmp = rowObject.HREF;
						   		}else{
						   			link = '<input type="text" name="href" id="href" style="width:400px;" value="'+strHref+'product/search.jhtml?keyword="/>';
									tmp = link+'&nbsp;&nbsp;&nbsp;<select class="form-control" style="width:70px;" name="linkcate" id="linkcate">'+
										   '<option value="keyWord" selected>关键词</option>'+
										   '<option value="search" >搜索</option></select>&nbsp;&nbsp;&nbsp;'+
										   '<input type="text" name="inword" id="inword" style="width:100px;"/>&nbsp;&nbsp;&nbsp;<a id="born" onclick="bornLink();">生成链接</a>';
						   			tmp+='<a id="save" style="display:none" onclick="checkForm();">保存</a>&nbsp;&nbsp;&nbsp;'+
						   				 '<a id="modify" style="display:none" onclick="modify();">修改</a>';
						   		}
						   		return tmp;
							}
						},
				   	],
				   	//只能添加一行，其它行也可编辑
				 	//onSelectRow: function(id){
      				//	if(id && id!==lastsel2){
      			 	//		jQuery('#grid-table').restoreRow(lastsel2);
        			//		jQuery('#grid-table').editRow(id,true);
         			//		lastsel2=id;
      				//	}
   					//	},
				});

			//创建一条空的记录，待编辑  
			function addRowData(tableId){ 
    			var tableObject = $('#'+tableId);  
    			//获取表格的初始model    
    			var colModel = tableObject.jqGrid().getGridParam("colModel") ;    
   				var newRow = JSON.stringify(colModel);   
    			var ids = tableObject.jqGrid('getDataIDs');    
    			//如果jqgrid中没有数据 定义行号为1 ，否则取当前最大行号+1    
   	 			var rowid = (ids.length ==0 ? 1: Math.max.apply(Math,ids)+1); 
    			//设置grid单元格不可编辑 （防止在添加时，用户修改其他非添加行的数据）    
    			tableObject.setGridParam({cellEdit:false});    
     			//将新行追加到表格底部    
     			tableObject.jqGrid("addRowData", rowid,newRow);    
     			//将新行追加到表格头部    
     			//tableObject.jqGrid("addRowData", rowid,newRow,"first");    
     			//设置grid单元格可编辑（防止追加行后，可编辑列无法编辑）    
    			tableObject.jqGrid('editRow', rowid, false); 
    			//设置新增的行被选中
   	 			$("#grid-table").jqGrid('setSelection',rowid);   
			}
	
			//点击“新增”事件
			$("#addMas").click(function(){
				var selectedIds = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				if(selectedIds.length>=1){
					top.$.jBox.tip('请先保存未完成的记录！');
					return false;
				}else{
					//显示确定按钮
					$("#addStk").removeAttr("style");
					addRowData('grid-table');
				}
			});
				
			//点击“删除”事件
			$("#delItem").click(function(){
				delItem();
			});
		});
			
		//批量删除
		function delItem(){
			var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
			var pkno='';
			for(var i=0; i<ids.length; i++){ 
				var id=ids[i]; 
				var rowData = $('#grid-table').jqGrid('getRowData',id);
				if(i != ids.length-1){
					pkno+=rowData.PK_NO+",";
				}else{
					pkno+=rowData.PK_NO;
				}
			}
			if(ids==""){
				top.$.jBox.tip('未选择数据，不可删除！','error');
				return false;
			}
			$.jBox.confirm("确认执行操作?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : "${base}/index/delMainPageBox.jhtml",
						type :'post',
						dataType : 'json',
						data : 'pkno=' + pkno,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
								data, function(s) {
									if (s) {
										top.$.jBox.tip(data.msg,'success');
										mgt_util.refreshGrid("#grid-table");
									}
								});
							}
						});
					}
				})
			} 	
	
	   		//生成链接按钮事件
			function bornLink() {
				var selectVal = $("#linkcate").val();
				var hrefStr='';
				if(selectVal=='keyWord'){
					hrefStr = $("#macroUrl").val()+'product/search.jhtml?keyword='+$("#inword").val();
				}else{
					hrefStr = $("#macroUrl").val()+'product/product_details/'+$("#inword").val()+'.jhtml';
				}
				$("#href").val('');
				$("#href").val(hrefStr);
				$("#linkcate").hide();
				$("#inword").hide();
				$("#born").hide();
				$("#save").show();
				$("#modify").show();
			}
				
			//点击“修改”事件
			function modify(){
				$("#linkcate").show();
				$("#inword").show();
				$("#born").show();
				$("#save").hide();
				$("#modify").hide();
			}
									
			//检查填写表单是否空	
			function checkForm(){
				//封装表单(pkNo+type+keyWord+sortNo+href)的集合
				var str = "";
				var selectedIds = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
				for(var i=0;i<selectedIds.length;i++){
					var rowData = $("#grid-table").jqGrid("getRowData", selectedIds[i]);
					//主键
					var pkNo = rowData.PK_NO;
					//类型
					var type = $("#"+selectedIds[i]+"_BOX_TYPE").val();
					//关键词
					var keyWord = $("#"+selectedIds[i]+"_BOX_DESC").val();
					//排序
					var sortNo = $("#"+selectedIds[i]+"_SORT_NO").val();
					//链接
					var href = $("#href").val();
					
					if(sortNo== ''||type== ''||keyWord== ''||href== ''){
						top.$.jBox.tip('必填项不能为空！');
						return false;
					}
					if(Number(sortNo) <= 0){
						top.$.jBox.tip('排序参数为正整数！');
						return false;
					}
					if(/\D/.test(sortNo)){
						top.$.jBox.tip('请输入正确数值！');
						return false;
					}
										
					//校验热搜关键字是否重复
		   			 $.ajax({
						url:'${base}/index/checkTypeA.jhtml',
						sync:false,
						type : 'post',
						dataType : "json",
						data :{
							'masPkNo':'${masPkNo}',
							'boxType':'A',
							'keyWord':keyWord,
						},
						error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
							if(data.code==001){
								top.$.jBox.tip('该热搜词已存在！');
								return false;
							}else{
								if(i != selectedIds.length-1){
									str =str +pkNo+","+type+","+keyWord+","+sortNo+","+href+";";
								}else{
									str =str +pkNo+","+type+","+keyWord+","+sortNo+","+href;
								}
							$("#masPkNo").val(${masPkNo});
							$("#items").val(str);
							mgt_util.submitForm('#form');
						}
					}
				});
			 }
		}	
	</script>
    </head>
    <body>
       <div class="body-container">
			<div class="pull-left">
				<div class="btn-group">
					<button class="btn btn-danger" id="addMas">
						新增
					</button>
					<button class="btn btn-danger" id="delItem">
						删除
					</button>
				</div>
			</div>
			<div style="clear:both;"></div>
		    <table id="grid-table" >
		    </table>
		    </br>
		    <div style="display:none">
				[#import "/function/mgt/platformIndex/URLMacro.ftl" as urlBox]
				[@urlBox.urlPrefix url='${prodType}' /]
		 	</div>
       		<form class="form-horizontal" id="form" action="${base}/index/addItemA.jhtml"> 
				<input id="masPkNo" name="masPkNo" type="hidden">
				<input id="items" name="items" type="hidden">
			</form>
   		</div>
    </body>
</html>