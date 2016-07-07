<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-商品属性管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"SORT_NO"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendorStk/list.jhtml',
 					colNames:['','编码','名称','排序号','备注','操作'],
				   	colModel:[
				   		{name:'CAT_C',index:'CAT_C',width:0,hidden:true,key:true},
				   		{name:'CAT_C',align:"center",width:180},
				   		{name:'NAME',align:"center",width:180},
				   		{name:'SORT_NO',align:"center",width:180},
				   		{name:'REMARK',align:"center",width:180},
				   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false, title:false} 
				   	],
				   		gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/vendorStk/editStkCatUI.jhtml'>修改 </button>";
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='editStatus("+id+");'>删除</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						} 
					} 
				   	
				});
					$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
						function showDetail(orderID){
				alert(orderID);
			}
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" id="query-form">      
				    <div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="StkCat" class="sub_status_but active"><a href="#"> 商品分类</a></li>					
							<li role="presentation" id="StkBrand" class="sub_status_but"><a href="#"> 商品品牌</a></li>
						</ul>
				    </div>
				    <div class="currentDataDiv_tit">
	                 	<button type="button" class="btn_divBtn add" id="vendorStkCat_add"  data-toggle="jBox-win" href="${base}/vendorStk/addStkCatUI.jhtml">新增 </button>
	                </div>
	            </form>
	        </div>
	      </div>    
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script type="text/javascript">
	$().ready(function() {
		// 状态面包屑事件，改变隐藏域select值并提交表单
	    $("li.sub_status_but").on("click",function(){
	        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
	    	if("StkCat" == $(this).attr("id")){
	    		$(".click_form").removeClass("sr-only");
	    	}else{
	    		$(".click_form").addClass("sr-only");
	    	}
	    	// 重置子状态select
	    	$("li.sub_status_but").removeClass("active");
	    	$(this).addClass("active");
	    	var formID = 'query-form';
	    	$(".form-inline").attr("id","");
	        $(this).parents(".form-inline").attr("id",formID);
	        $("select[name=statusFlg]").val($(this).attr("id"));
	        $("#order_search").click(); 
	    });
	});
		//供应商商品分类------删除
		function editStatus(id){
			 $.jBox.confirm("确认删除吗?", "提示", function(v){
			 if(v == 'ok'){
			 $.ajax({
				 url:'${base}/vendorStk/delete.jhtml',
				 sync:false,
				type : 'post',
				dataType : "json",
				data :{
				'id':id
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==1){
					alert(data.msg);
					}else{
					top.$.jBox.tip(data.msg, 'success');
					top.$.jBox.refresh = true;
					}
					$('#grid-table').trigger("reloadGrid");
				}
			});	
		}
	  });
	}
</script>
</html>