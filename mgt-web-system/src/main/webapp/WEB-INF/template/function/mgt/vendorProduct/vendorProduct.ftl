<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>供应商管理-B2B商品管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script  type="text/javascript">
			//chosen插件初始化，绑定元素
			$(function(){
	    		$("#brandC").chosen();
			});	
		
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",bcFlg:"${bcFlg}"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendorPro/proList.jhtml',
	 				colNames:['','','编码','包装条码','名称','零售单位','包装单位','包装数量','价格','供货量','商品品牌','商品分类','状态','操作'],
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:0,hidden:true,key:true},
						{name:'STK_FLG',index:'STK_FLG',width:0,hidden:true,key:true},
				   		{name:'VENDOR_STK_C',align:"center",index:'VENDOR_STK_C',width:'9',key:true},
				   		{name:'PACK_PLU_C',align:"center",index:'PLU_C',width:'12',key:true},
				   		{name:'NAME',align:"center",index:'NAME',width:'15',key:true},
				   		{name:'STD_UOM',align:"center",index:'STD_UOM',width:'6',key:true},
				   		{name:'UOM',align:"center",index:'UOM',width:'7',key:true},
				   		{name:'PACK_QTY',align:"center",index:'PACK_QTY',width:'7',key:true},
				   		{name:'NET_PRICE',align:"center",index:'NET_PRICE',width:'7',key:true},
				   		{name:'SUPPLY_QTY',align:"center",index:'SUPPLY_QTY',width:'5',key:true},
				   		{name:'BRANDNAME',align:"center",index:'BRANDNAME',width:'7',key:true},
				   		{name:'CATCNAME',align:"center",index:'CATCNAME',width:'7',key:true},
				   		//{name:'EP_FLG',index:'EP_FLG',width:50,key:true},
				   		//A新建的/B申请审核/C审核通过/D审核退回/Y已上架/N已下架
				   		[#if bcFlg == 'B']
				   	   {name:'EP_FLG',align:"center",width:'7',
					   		editable:true,formatter:function(data){
								if(data=='A'){
									return '新建';
								}else if(data=='B'){
									return '申请上架';
								}else if(data=='C'){
									return '申请下架';
								}else if(data=='Y'){
									return '已上架';
								}else if(data=='N'){
									return '已下架';
								}else{
									return '未知';
								}
		   					}},
		   					[#elseif bcFlg == 'C']
		   					 {name:'AP_FLG',align:"center",width:'8%',
					   			editable:true,formatter:function(data){
								if(data=='A'){
									return '新建';
								}else if(data=='B'){
									return '申请上架';
								}else if(data=='C'){
									return '申请下架';
								}else if(data=='Y'){
									return '已上架';
								}else if(data=='N'){
									return '已下架';
								}else{
									return '未知';
								}
		   					}},
		   					[/#if]
					    {name:'detail',index:'STK_C',width:'20',align:'center',sortable:false,title:false} 
				   	],
				   	gridComplete:function(){ 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							//定义包装  修改  删除  请求审核
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1000' href='${base}/vendorPro/editpack/${bcFlg}.jhtml'>定义包装</button>";
							
							detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1000' href='${base}/vendorPro/editproduct/${bcFlg}.jhtml'>修改</button>";
							if(rowData.STK_FLG == 'Z'){
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"'  onClick=editStatus('"+id+"','S')>恢复</button>";
							}else{
								detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"'  onClick=editStatus('"+id+"','Z')>删除</button>";
							}
								
			//				if(rowData.EP_FLG=='新建'||rowData.EP_FLG=='审核退回'){
			//					detail +="&nbsp;<button type='button' class='btn btn-info edit' id='"+id+"'  onClick=editStatus('"+id+"','B');>请求审核</button>";
			//				}
							
							CATCNAME="<select type='select' id='"+id+"' class='catcname' onChange=saveCat('"+id+"')>"
							[#if list ??]
							[#list list as cat]
								CATCNAME= CATCNAME+"<option value='${cat.id.catC}'";
								if(rowData.CATCNAME == '${cat.name}'){
									CATCNAME= CATCNAME+ "selected";
								}
								CATCNAME= CATCNAME+">${cat.name}</option>";
							[/#list]
							[/#if]
							CATCNAME= CATCNAME+"<select>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail,CATCNAME:CATCNAME }); 
						} 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
						
						//getCat();
						//resetBrand();
					} 
				   	
				   	
				});
				
				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
				$(".cat").hover(function (){
					$("#batchUp").show();
					$(".cat .btn").addClass("btn-infoOne-hover");					
				},function (){
					
					$("#batchUp").hide();
					$(".cat .btn").removeClass("btn-infoOne-hover");
				})
			});
			
			function resetBrand(){
				$("#brandC").empty();
					$("#brandC").prepend("<option value=''>全部品牌</option>");
					$.ajax({
						url: '${base}/vendorPro/brandlist.jhtml',
						type: 'GET',
						cache: false,
						async: false,
						success: function(data) {
							if ($.isEmptyObject(data)) {
								return false;
							}
							$.each(data, function(value,name) {
							var v = name.id.brandC;
							var n = name.name;
								//var option = $("<option>").val(1).text(1);
								//$(this).append(option);
								$("#brandC").append("<option value='"+v+"'>"+n+"</option>");
							});
						}
					});
			}
		</script>
    </head>
    <body>
     <div class="body-container">
     	<div class="main_heightBox1">
		    <div class="currentDataDiv" action="menu">
		    	<div class="currentDataDiv_tit">
		           <button type="button" class="btn_divBtn del float_btn"   id="${bcFlg}"  data-toggle="jBox-show" jBox-width="1000"  href="${base}/vendorPro/addproduct/${merchantUserName}.jhtml">添加商品</button>
		           <button type="button" class="btn_divBtn edit float_btn"  id="role_modifyScopeToPublic" data-toggle="jBox-modify-scope" 
		            href="${base}/vendorPro/updateStatus.jhtml?status=Y&bcFlg=${bcFlg}" jBox-width="1212" jBox-height="560">上架 </button>
		            <button type="button" class="btn_divBtn edit float_btn"  id="role_modifyScopeToPublic" data-toggle="jBox-modify-scope" 
		            href="${base}/vendorPro/updateStatus.jhtml?status=N&bcFlg=${bcFlg}" jBox-width="1212" jBox-height="560">下架 </button>
		            <!--<span class="open_btn"></span>-->
		         </div>
		         <div class="form_divBox" style="display:block;overflow:inherit;">
		            <form class="form form-inline queryForm" id="query-form"> 
	                   <div class="form-group">
		                   <select class="form-control required" id="brandC" name="brandC" style="width:120px;">
								<option value="">全部品牌</option>
								[#if listbrand ??]
						         [#list listbrand as brand]
			                          <option value='${brand.id.brandC}'>${brand.name}</option>
								[/#list]
							[/#if]
							</select>
		                </div>
		                 <div class="form-group">
		                    <select class="form-control required" id="vendorCatC" name="vendorCatC" style="width:120px;">
								<option value="">全部分类</option>
							[#if list ??]
						         [#list list as cat]
			                          <option value='${cat.id.catC}'>${cat.name}</option>
								[/#list]
							[/#if]
							</select>
		                </div>
		                <div class="form-group">
		                  <select class="form-control required" id="epFlg" name="epFlg" style="width:120px;">
								<option value="">全部上下架商品</option>
								<option value="A">新建商品</option>
								<option value="B">请求上架商品</option>
								<option value="D">请求下架商品</option>
								<option value="Y">已上架商品</option>
								<option value="N">已下架商品</option>
								<option value="C">处理中商品</option>
							</select>
		                </div>
		                <div class="form-group">
		                	<input type="text" class="form-control" name="name" style="width:170px" value="请输入条码或编码或名称" class="form-control" onfocus="if(value=='请输入条码或编码或名称') {value=''}" onblur="if (value=='') {value='请输入条码或编码或名称'}">
                		</div>
                		<div class="form-group">
		                  <select class="form-control required" id="stkFlg" name="stkFlg" style="width:120px;">
								<option value="">全部商品</option>
								<option value="S">库存商品</option>
								<option value="Z">已删除商品</option>
							</select>
		                </div>
		            </form>
		            <div class="search_cBox">
		            	<div class="form-group">
		                 	<button type="button" class="search_cBox_btn" id="order_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
		                </div>
		            </div>
			     </div>
			</div>
        </div>
	    <table id="grid-table" ></table>
        <div id="grid-pager"></div>
    </body>
    
<script type="text/javascript">

function   saveCat(id){
	var vendorCatC=$("#"+id).find("option:selected").val();
	
	$.jBox.confirm("确认修改吗?", "提示", function(v){
	if(v == 'ok'){
		$.ajax({
			url : '${base}/vendorPro/updStkMas.jhtml',
			type :'post',
			dataType : 'json',
			data : 'ids=' + id+'&vendorCatC='+vendorCatC,
			success : function(data) {
		if(data.code==001){		
			top.$.jBox.tip('操作成功！', 'success');
			top.$.jBox.refresh = true;
			$('#grid-table').trigger("reloadGrid");
			}
			else{
			top.$.jBox.tip('操作失败！', 'error');
					return false;
			}
		}
		});
	}else{
		$('#grid-table').trigger("reloadGrid");
	}
	});
		
	
}

function editStatus(id,status){
	var msgtip="";
	if(status=='Z'){
		msgtip="确定删除吗";
	}
	if(status=='S'){
		msgtip="确定恢复吗";
	}
	else if(status=='B'){
		msgtip="确定要请求审核吗？";
	}
	$.jBox.confirm(msgtip, "提示", function(v){
	if(v == 'ok'){
		$.ajax({
			url : '${base}/vendorPro/updateStatus.jhtml',
			type :'post',
			dataType : 'json',
			data : 'ids=' + id+'&status='+status,
			success : function(data) {
		if(data.code==001){		
			top.$.jBox.tip('操作成功！', 'success');
			top.$.jBox.refresh = true;
			$('#grid-table').trigger("reloadGrid");
			}
			else{
			top.$.jBox.tip(data.msg, 'error');
					return false;
			}
		}
		});
	}
});
}
</script>
</html>