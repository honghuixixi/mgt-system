	<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>运维管理-主商品维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
		<script  type="text/javascript">
			//chosen插件初始化，绑定元素
			$(function(){
	    		$("#brandC").chosen();
			});
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/vendorPro/list.jhtml',
 					colNames:['','条码','名称','零售单位','商品品牌','平台分类','状态','创建时间'],
				   	colModel:[	
				   		{name:'PLU_C',index:'PLU_C',width:0,hidden:true,key:true}, 
						{name:'PLU_C',width:150,align:"center"},
				   		{name:'NAME',width:300,align:"center"},
				   		{name:'STD_UOM', width:100,align:"center"},
				   		{name:'BRAND_NAME', width:100,align:"center"},
				   		{name:'CAT_NAME', width:270,align:"center"},
				   		{name:'STATUS_FLG', width:100,align:"center",formatter:function(data){
							if(data=='N'){
								return '未审核';
							}else if(data=='Y'){
								return '已审核';
							}}
							},
						{name:'CREATE_DATE',align:"center",width:180,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            if(data!=null){
                            return data;
                            }else{
                            return "";
                            }
                            }
                        },
				   	]
				});
				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
			function check(pluC){
				   	   $.jBox.confirm("确认审核吗?", "提示", function(v){
							if(v == 'ok'){
								 $.ajax({
								      url:'${base}/globalPluMas/check.jhtml',
								      sync:false,
								      type : 'post',
								      dataType : "json",
								      data :{'pluC': pluC},
								      error : function(data) {
									    alert("网络异常");
								        return false;
								      },
								      success : function(data) {
								        if(data.success==true){
								        top.$.jBox.tip('审核成功');
								        $("#grid-table").trigger("reloadGrid");
								 		}else{ 
										  	top.$.jBox.tip('审核失败');
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
		  		var $catId = $("#catId");
		  		// 菜单类型选择
				$catId.lSelect({
					url: "${base}/stkCategory/catType.jhtml"
				});
			});
  		</script>
    </head>
    <body>
       <div>
   		<div class="main_heightBox1">
	   		<div id="currentDataDiv" action="menu">
		   			       <div class="currentDataDiv_tit">
		   			       <div class="form-group">
							    <button type="button" class="btn_divBtn del float_btn"   id="global_plu_mas_add"  data-toggle="jBox-show" href="${base}/globalPluMas/addGlobalUI.jhtml">添加商品</button>
							    <button type="button" class="btn_divBtn edit" id="global_plu_mas_edit" data-toggle="jBox-edit" href="${base}/globalPluMas/edit.jhtml">修改 </button>
							    <button type="button" class="btn_divBtn del" id="global_plu_mas_check" data-toggle="jBox-audit-userfunction" href="${base}/globalPluMas/check.jhtml">审核</button>
						    </div>
							</div>
					<div class="form_divBox" style="display:block;overflow:inherit;">
			            <form class="form form-inline queryForm" style="width:1000px" name="query" id="query-form"> 
			            <div class="form-group">
			            <label class="control-label">商品品牌:</label>
                			<select class="form-control" style="width:120px;" name="brandC" id="brandC">
        						<option value=''>全部品牌</option>
		                        [#list brandList as brand]
									 	<option value='${brand.brandC}'>${brand.name}</option>
								[/#list]
		                    </select>
		                    </div>
		        			<div class="form-group">
			                    <label class="control-label">商品分类:</label>
		           				<input type="hidden" id="catId" name="catId" />
		        			</div>
		        			<div class="form-group">
		        			<label class="control-label">状态:</label>
                			<select class="form-control" style="width:120px;" name="statusFlg" id="STATUS_FLG">
                						<option value=''>请选择...</option>
									 	<option value='Y'>已审核</option>
									 	<option value='N'>未审核</option>
		                    </select>
		        			</div>
		        			<div class="form-group">
			                    <label class="control-label">名称或条码:</label>
		           				<input  class="form-control" id="PLU_C" style="width:200px;" name="pluC" value="" placeholder="请输入商品条码/名称进行查询"/>
		        			</div>
				            <div class="search_cBox">
				            <div class="radio">&nbsp;&nbsp;&nbsp;&nbsp;<input class="control_rad" name="bugCheckbox" type="checkbox"/>&nbsp;<span>仅显示信息不完整商品</span></div>
				                 	<button type="button" class="btn_divBtn" id="info_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
				            </div>
			            </form>
		            </div>
		        </div>
   		</div>
	    <table id="grid-table" >
	    </table>
	    <div id="grid-pager"></div>
 		</div>
    </body>
       
    <script type="text/javascript">
		$().ready(function() {
		// 子状态(“仅显示不完整商品”)单选框事件，改变隐藏域select值并提交表单
			    $('input[name=bugCheckbox]').on("click",function(){
			    	var checkVal;
			    	if($('input[name=bugCheckbox]').attr("checked")){
			    		checkVal = 'Y';
			    	}else{
			    		checkVal = '';
			    	}
			    	var postData={orderby:"CREATE_DATE",bugCheckValue:checkVal};
			    		$('#grid-table').jqGrid('setGridParam',{postData:postData})
			    		.trigger("reloadGrid");
	    		});
		});
	</script>
</html>