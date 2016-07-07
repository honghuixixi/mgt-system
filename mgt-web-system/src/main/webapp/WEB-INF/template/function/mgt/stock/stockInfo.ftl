<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品属性管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
		$(document).ready(function(){
			var postData={};
			mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/vendorStk/list.jhtml',
					colNames:['','编码','名称','排序号','备注','操作'],
					multiselect : false,
			   	colModel:[
			   		{name:'CAT_C',index:'CAT_C',width:0,hidden:true,key:true},
			   		{name:'CAT_C',align:"center",width:180},
			   		{name:'NAME',align:"center",width:180},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'REMARK',align:"center",width:180},
			   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false,title:false} 
			   	],
			   		gridComplete:function(){ //循环为每一行添加业务事件 
				var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
					for(var i=0; i<ids.length; i++){ 
						var id=ids[i]; 
						var rowData = $('#grid-table').jqGrid('getRowData',id);
						detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/vendorStk/editStkCatUI.jhtml'>修改 </button>";
						detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' onclick='editStatus("+id+");'>删除</button>";
						jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
					};
					//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height()); 
				} 
			   	
			});
		});
		</script>
    </head>
    <body>
       <div class="body-container">
         <div id="main_heightBox" class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="CATEGROY" class="sub_status_but active"><a href="#"> 商品分类</a></li>					
							<li role="presentation" id="BRAND" class="sub_status_but"><a href="#"> 商品品牌</a></li>						
						</ul>
					</div>
					<div class="form_divBox" style="display:block;">
						<div class="form-group">
	                 		<button type="button" class="btn btn-info btn_divBtn add" id="vendorStkCat_add"  data-toggle="jBox-win" href="${base}/vendorStk/addStkCatUI.jhtml">新增 </button>
		                	<div class="" id="btnRadio" hidden="true">
								<label style="width:auto;float:left;"><input type="radio" name="brand" value="PLATFORMBRAND" checked> 平台品牌 </label/>&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;
								<label style="width:auto;float:left;padding-left:10px;"><input type="radio" name="brand" value="MYBRAND" > 我经营的品牌</label/>
							</div>
						</div>
						<div class="search_cBox">
							<div class="form-group sr-only" id="brand_search">
			                    <input type="text" class="form-control" name="brandName" id="brandName" style="width:120px;"  placeholder="请输入品牌名">
			                 	<button type="button" class="btn btn-info btn_divBtn" id="suporder_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
			                </div>
		                </div>
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
    	$('#grid-table').GridUnload();//重绘
        // 如果点击的是处理中，显示子状态单选框区域否则隐藏
        //商品分类
    	if("CATEGROY" == $(this).attr("id")){
    		$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		$("#addStock").show();
    		$("#btnRadio").hide();
			$("#query-form").css("height","80px");
			$("#vendorStkCat_add").removeClass("sr-only");
			$("#brand_search").addClass("sr-only");
			//发送异步请求
    		var postData={};
			mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/vendorStk/list.jhtml',
					colNames:['','编码','名称','排序号','备注','操作'],
					multiselect : false,
			   	colModel:[
			   		{name:'CAT_C',index:'CAT_C',width:0,hidden:true,key:true},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'NAME',align:"center",width:180},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'REMARK',align:"center",width:180},
			   		{name:'detail',index:'PK_NO',width:190,align:'center',sortable:false,title:false} 
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
    	}
    	//商品品牌
    	if("BRAND" == $(this).attr("id")){
    		$("li.sub_status_but").removeClass("active");
    		$(this).addClass("active");
    		$("#addStock").hide();
    		$("#btnRadio").show();
			$("#query-form").css("height","80px");
    		$("#vendorStkCat_add").addClass("sr-only");
    		$("#brand_search").removeClass("sr-only");
    		//发送异步请求
    		var postData={orderby:"CREATE_DATE"};
    		mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/stock/list.jhtml',
				colNames:['编码','名称','排序号','操作'],
				multiselect : false,
			   	colModel:[
			   		{name:'BRAND_C',index:'BRAND_C',align:"center",width:180,key:true},
			   		{name:'NAME',align:"center",width:180},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'', width:100,title:false,formatter:function(value,row,index){
								return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.BRAND_C+'","选择") >选择</button>';
						   }
					}
			   	],
			});	
    	}

    });
	//radio
    $('input[name=brand]').on("click",function(){
    	$("#brandName").attr("value","");
    	var stkBrandName = $("#brandName").val();
    	$('#grid-table').GridUnload();//重绘
		if($(this).val() == "PLATFORMBRAND"){
			//发送异步请求
    		var postData={orderby:"CREATE_DATE",brandName:stkBrandName};
    		mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/stock/list.jhtml',
				colNames:['编码','名称','排序号','操作'],
				multiselect : false,
			   	colModel:[
			   		{name:'BRAND_C',index:'BRAND_C',align:"center",width:180,key:true},
			   		{name:'NAME',align:"center",width:180},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'', width:120,title:false,formatter:function(value,row,index){
								return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=editStatusFlg("'+index.BRAND_C+'","选择") >选择</button>';
						   }
					}
			   	],
			});	
		}
		if($(this).val() == "MYBRAND"){
			//发送异步请求
    		var postData={orderby:"CREATE_DATE",statusFlg:"INPROCESS",brandName:stkBrandName};
    		mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/stock/myBrandList.jhtml',
				colNames:['编码','名称','排序号','备注','操作'],
				multiselect : false,
			   	colModel:[
			   		{name:'BRAND_C',align:"center",width:180,key:true},
			   		{name:'NAME',align:"center",width:180},
			   		{name:'SORT_NO',align:"center",width:180},
			   		{name:'REMARK',align:"center",width:180},
			   		{name:'', width:100,title:false,formatter:function(value,row,index){
						return '&nbsp;&nbsp;<button type=button class="btn btn-info edit" onclick=deleteMyRunBrand("'+index.BRAND_C+'","删除")>删除</button>&nbsp;&nbsp;<button type=button class="btn btn-info edit" data-toggle="jBox-show" id="'+index.BRAND_C+'" href="${base}/stock/editMyRunBrand.jhtml">修改 </button>;';
				   }
			}
			   	]
			});
		}
		
    });

});

function deleteMyRunBrand(BRAND_C,message){
	 $.jBox.confirm("确认删除么?", "提示", function(v){
 			if(v == 'ok'){
				 $.ajax({
					url:'${base}/stock/deleteMyRunBrand.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					data :{
						'brandC':BRAND_C,
					},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						if(data.code==001){
							top.$.jBox.tip('删除成功！', 'success');
							top.$.jBox.refresh = true;
							$('#grid-table').trigger("reloadGrid");
						}
						if(data.code==002){
							top.$.jBox.tip('该品牌包含未下架商品，请先下架！', 'success');
							top.$.jBox.refresh = true;
							$('#grid-table').trigger("reloadGrid");
						}
					}
	});	
}});
}

function editStatusFlg(BRAND_C,message){
	 $.jBox.confirm("确认选择么?", "提示", function(v){
			if(v == 'ok'){
				 $.ajax({
					url:'${base}/stock/stockAdd.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					data :{
						'brandC':BRAND_C,
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
						}else{
						   top.$.jBox.tip(data.msg, 'error');
				 			return false;
						}
					}
	});	
}});
}

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
				top.$.jBox.tip(data.msg);
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